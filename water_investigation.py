import numpy as np
import seaborn as sns
from matplotlib import pyplot as plt
from scipy.stats import skew
import pylab as p
from matplotlib.colors import ListedColormap

filename = open('count_water_aligned.out', 'r')
filename_lines= filename.readlines()

out = open('DENEME_count_by_frame.out', 'w')
out_count = open('DENEME_count_by_molecule.out', 'w')
out_percentage = open('DENEME_percentage_by_molecule.out', 'w')
out_eliminated = open('DENEME_eliminated.out', 'w')
out_heatmap = open('DENEME_heatmap.out', 'w')

# out.write('Frame\tCount of Water Molecules\n')
# out_count.write('Molecule\tCount of Water Molecules\n')
# out_percentage.write('Molecule\tCount of Water Molecules (%)\n')

water_all_frame = []
count = []
frame_num = []

first_resid_of_water = 47
last_resid_of_water = 6526

all_water_molecule_number = last_resid_of_water-first_resid_of_water  #Water molecules finished with this residue and starts this residue
frame_number_last = 24999
frame_number_initial = 0
#frame_number_initial = 24499
#raw_matrix = np.zeros((all_water_molecule_number+1,frame_number_last-frame_number_initial+1), dtype='int')

raw_matrix = []
for z in range(0, all_water_molecule_number+1):
    raw_matrix_row = []
    for k in range(0,frame_number_last-frame_number_initial+1):
        raw_matrix_row.append(0)
    raw_matrix.append(raw_matrix_row)


for i in range(frame_number_initial,frame_number_last+1):
    frame_num.append(i)
    splitted_line = filename_lines[i].split()
    water_one_frame = []
    for j in range(1,len(splitted_line)):
        if splitted_line[j] != splitted_line[j-1]:
            water_one_frame.append(int(splitted_line[j]))
    for z in range(0,len(water_one_frame)):
        #print(water_one_frame[z],i)
        raw_matrix[int(water_one_frame[z]-first_resid_of_water)][i-frame_number_initial] = 1
    water_one_frame_to_str = str(water_one_frame).replace(',','')
    water_one_frame_to_str = water_one_frame_to_str[1: len(water_one_frame_to_str)-1]
    count.append(len(water_one_frame))
    out_eliminated.write('Water_molecules_resid: '+ water_one_frame_to_str + '\n')
    out.write(str(i) + '\t' + str(count[i-frame_number_initial]) + '\n')
    water_all_frame.append(water_one_frame)

all_molecules = []
percentage_for_heatmap = []
percentage = []
molecule = []
for i in range(0,len(raw_matrix)):
    count_num = 0
    heatmap_str = str(raw_matrix[i]).replace(',','')
    heatmap_str = heatmap_str[1: len(heatmap_str)-1]
    out_heatmap.write(str(heatmap_str) + '\n')
    for j in range(0,len(raw_matrix[i])):
        #print(raw_matrix[i][j])
        count_num = count_num + raw_matrix[i][j]
    all_molecules_percentage = []
    all_molecules.append(count_num)
    all_molecules_percentage.append(float(count_num/(frame_number_last-frame_number_initial+1)*100))
    if float(count_num/(frame_number_last-frame_number_initial+1)*100) > 30:
        print(i+first_resid_of_water,(count_num/(frame_number_last-frame_number_initial+1)*100))
    out_count.write(str(i+first_resid_of_water) + '\t' + str(count_num) + '\n')
    out_percentage.write(str(i+first_resid_of_water) + '\t' + str('%.2f' % (count_num/(frame_number_last-frame_number_initial+1)*100)) + '\n')
    percentage.append(count_num/(frame_number_last-frame_number_initial+1)*100)
    molecule.append(i+first_resid_of_water)
    percentage_for_heatmap.append(all_molecules_percentage)

#print(raw_matrix)

# print(max(percentage_for_heatmap))
#
# # p.plot(molecule, percentage, '*')
# print( '\nSkewness for data : ', skew(percentage))
#
# #plt.plot(frame_num, count, 'o',markersize=0.5, color='blue')
# font = {'size': 20,}
# plt.figure(figsize=(16,6))
# plt.ylabel('Number of Water Molecules',fontdict=font)
# plt.xlabel('time (ns)',fontdict=font)
# plt.axis([0, 25000, 0, 500])
# plt.grid()
# plt.plot(frame_num,count, linewidth=0.75)
# plt.show()


#ax = sns.heatmap(raw_matrix[:500], cmap='Blues_r', cbar= False)
#ax.set(xlabel = "Frame")
# plt.xticks([0, frame_number_last-frame_number_initial+1],[str(frame_number_initial), str(frame_number_last)],rotation=0)
# plt.yticks([0, last_resid_of_water-first_resid_of_water+1],[str(first_resid_of_water), str(last_resid_of_water)])
#plt.xticks([0, frame_number_last-frame_number_initial+1],[str(frame_number_initial), str(frame_number_last)],rotation=0)

#plt.show()
# sns.heatmap(percentage_for_heatmap, cmap="Blues", vmin=0)
# plt.yticks([0, last_resid_of_water-first_resid_of_water+1],[str(first_resid_of_water), str(last_resid_of_water)])
# plt.show()
#plt.savefig('M3_bsc1_HC_hbonds.png')

out.close()
out_count.close()
out_percentage.close()
out_eliminated.close()
out_heatmap.close()