import numpy as np
import matplotlib.pyplot as plt
import glob
import statistics
import os

pressure = ["0.001", "1", "1.01325", "1.5", "2", "3", "4"]
for pres in pressure:
	os.chdir("Pressure_" + pres + "_Within_5_water_File")
	X = []
	Y = []
	charge_value = []

	mean_file = open("Within_water_mean.txt", "w")

	for file_name in glob.glob("*_within_5_water.dat"):
		charge_value.append(file_name.replace('_within_5_water.dat', '').replace('2_1_','Charge: ').replace('_3_6','').replace('_','.').replace(pres,''))
		x = []
		y = []
		for line in open(file_name,'r'):
			values = [float(s) for s in line.split( )]
			x.append(values[0])
			y.append(values[1])
		file_name_splitted = file_name.replace('_', '\t')
		file_name_splitted = file_name_splitted.replace('_within_5_water.dat', '\t')
		mean_file.write(str(file_name_splitted) + '\t' + str(statistics.mean(y)) + "\n")
		X.append(x)
		Y.append(y)

	font = {'size': 20,}
	plt.figure(figsize=(16,10))
	plt.ylabel('Within 5 of water ($\AA$)',fontdict=font)
	plt.xlabel('Frame',fontdict=font)
	for i in range(0,len(X)):
		plt.plot(X[i], Y[i])
	plt.title('Pressure:' + str(pres))
	plt.axis([0, 400, 500, 3500])
	plt.legend(charge_value)
	plt.grid()
	plt.savefig('Within_water_all.png')
	plt.show()
	os.chdir("..")
