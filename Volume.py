import numpy as np
import matplotlib.pyplot as plt
import glob
import os
import statistics

column_value = 11

pressure = ["0.001", "1", "1.01325", "1.5", "2", "3", "4"]
for pres in pressure:
	os.chdir("Pressure_" + pres + "_Volume_Measurement")
	if column_value == 9:
		X = []
		Y = []
		charge_value = []
		Title_name = "Box Volume"
		mean_file = open( str(Title_name) +"_mean.txt", "w")
		for file_name in glob.glob("*_Volume.dat"):
			charge_value.append(file_name.replace('_Volume.dat', '').replace('2_1_','Charge: ').replace('_3_6','').replace('_','.').replace(pres,''))
			x = []
			y = []
			for line in open(file_name,'r'):
				values = [s for s in line.split( )]
				x.append(float(values[1]))
				y.append(float(values[column_value]))
			file_name_splitted = file_name.replace('_', '\t')
			file_name_splitted = file_name_splitted.replace('_Volume.dat', '\t')
			mean_file.write(str(file_name_splitted) + '\t' + str(statistics.mean(y)) + "\n")
			X.append(x)
			Y.append(y)

		font = {'size': 20,}
		plt.figure(figsize=(16,10))
		plt.ylabel( str(Title_name) + ' ($\AA$)',fontdict=font)
		plt.xlabel('Frame',fontdict=font)
		for i in range(0,len(X)):
			plt.plot(X[i], Y[i])
		plt.title('Pressure:' + str(pres))
		plt.axis([-1, 400, 150000, 190000])
		plt.legend(charge_value)
		plt.grid()
		plt.savefig(str(Title_name) + '_all.png')
		plt.show()
		os.chdir("..")

	if column_value == 11:
		X = []
		Y = []
		charge_value = []
		Title_name = "Surface Volume"
		mean_file = open( str(Title_name) +"_mean.txt", "w")
		for file_name in glob.glob("*_Volume.dat"):
			charge_value.append(file_name.replace('_Volume.dat', '').replace('2_1_','Charge: ').replace('_3_6','').replace('_','.').replace(pres,''))
			x = []
			y = []
			for line in open(file_name,'r'):
				values = [s for s in line.split( )]
				x.append(float(values[1]))
				y.append(float(values[column_value]))
			file_name_splitted = file_name.replace('_', '\t')
			file_name_splitted = file_name_splitted.replace('_Volume.dat', '\t')
			mean_file.write(str(file_name_splitted) + '\t' + str(statistics.mean(y)) + "\n")
			X.append(x)
			Y.append(y)

		font = {'size': 20,}
		plt.figure(figsize=(16,10))
		plt.ylabel( str(Title_name) + ' ($\AA$)',fontdict=font)
		plt.xlabel('Frame',fontdict=font)
		for i in range(0,len(X)):
			plt.plot(X[i], Y[i])
		plt.title('Pressure:' + str(pres))
		plt.axis([-2, 400, 40000, 70000])
		plt.legend(charge_value)
		plt.grid()
		plt.savefig(str(Title_name) + '_all.png')
		plt.show()
		os.chdir("..")