import os

file = open('BNT_away_energy.txt', 'r')
file_w = open('binding_energy.txt', 'a')
file_lines = file.readlines()
count = 0
for line in file_lines:
	aa_name = line[0:3]
	line_splitted = line.split()
	energy_value_cs1 = line_splitted[-1]
	repositioned_file = open('found_bbc1.txt', 'r')
	reposition_line = repositioned_file.readlines()
	energy_value_rep = reposition_line[0].split()[-1]
	binding_energy = float(energy_value_rep) - float(energy_value_cs1)
	if count == 0:
		cs1_numsteps = line_splitted[-2]
		rep_numsteps = reposition_line[0].split()[-2]
		file_w.write('-Binding Energy Calculation-' + '\n' + 'CS1 Minimization Steps: ' + cs1_numsteps + '\t' +'Reposition Minimization Steps: ' + rep_numsteps + '\n' )
	file_w.write(aa_name + '\t' + str(binding_energy) + '\n')
	repositioned_file.close()
	count += 1
file.close()
file_w.close()
