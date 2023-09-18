
# Create forcefield parameter file for NAMD.
# Updated 27.Haziran.2023
# Each parameters changed for fourth times.

import os

bonds_epsilon = ["0.100", "0.200", "0.300", "0.400"]
bonds_sigma = ["1.777", "0.700", "2.000", "3.000"]

angles_Mo_first = ["0.001", "0.002", "0.003", "0.004"]
angles_Mo_second = ["109.47", "90.00", "110.00", "120.00"]

angles_C_first = ["0.001", "0.002", "0.003", "0.004"]
angles_C_second = ["120.00", "90.00", "110.00", "130.00"]

c_vdw_first = ["-0.1900", "-0.1000", "-0.3000", "-0.5000"]
c_vdw_second = ["1.9975", "0.5000", "1.5000", "2.5000"]

mo_vdw_first = ["-0.3100", "-0.1000", "-0.2000", "-0.5000"]
mo_vdw_second = ["2.135", "0.500", "1.5000", "3.5000"]
matrix = [bonds_epsilon, bonds_sigma, angles_Mo_first, angles_Mo_second, angles_C_first, angles_C_second, c_vdw_first, c_vdw_second, mo_vdw_first, mo_vdw_second]
par_File = ["0.100", "1.777", "0.001", "109.47", "0.001", "120.0", "-0.1900", "1.9975", "-0.3100", "2.135"]
tmp_par_file = par_File[:]
note = "Si3N4 parameters"


for m in range(0, 10):
    for n in range(0, 4):
        if(not (n == 0 and m > 0)):
            par_File[m] = matrix[m][n]
            dir_name = "z".join(par_File)
            dir_name = dir_name.replace(".", "_")
            os.mkdir(dir_name)
            os.system('cp -a Surface_main/. '+dir_name)
            os.chdir(dir_name)
            psf_file = open("par_Mo2C_bonds_angles_vdw.inp", "w")

            psf_file.write("!" + str(note) + "\n")

            psf_file.write("BONDS\n")

            for i in range(0,10):
                for j in range(0,10):
                    psf_file.write("C_" + str(i) + " \t" + "MO_" + str(j) + "\t\t" + str("%.3f" % float(par_File[0])) + "\t\t" + str("%.3f" % float(par_File[1])) + "\t" + "\n")

            psf_file.write("\nANGLES\n")

            for i in range(0,10):
                for j in range(0,10):
                    for k in range(0,10):
                        psf_file.write("C_" + str(i) + " \t" + "MO_" + str(j) + "\t" + "C_" + str(k) + " \t" + str("%.3f" % float(par_File[2])) + "\t" + str("%.3f" % float(par_File[3])) + "\t" + "\n")

            psf_file.write("\n")

            for i in range(0,10):
                for j in range(0,10):
                    for k in range(0,10):
                        psf_file.write("MO_" + str(i) + "\t" + "C_" + str(j) + " \t" + "MO_" + str(k) + "\t" + str("%.3f" % float(par_File[4])) + "\t" + str("%.3f" % float(par_File[5])) + "\t" + "\n")



            psf_file.write("\nNONBONDED nbxmod  5 atom cdiel shift vatom vdistance vswitch -\n")
            psf_file.write("cutnb 14.0 ctofnb 12.0 ctonnb 10.0 eps 1.0 e14fac 1.0 wmin 1.5 \n")
            psf_file.write("\nSOD      0.0       -0.0469    1.36375\nPOT      0.0       -0.0870    1.76375\nCLA      0.0       -0.150      2.27\nCAL      0.0       -0.120      1.367\nMG       0.0       -0.0150    1.18500\nCES      0.0       -0.1900    2.100\n\n")

            for i in range(0,10):
                psf_file.write("C_" + str(i) + " \t\t" + "0.0\t\t" + str("%.4f" % float(par_File[6])) + "\t\t" + str("%.4f" % float(par_File[7])) + "\t\t" + "0.000000" + "\t\t" + str("%.4f" % float(par_File[6])) + "\t\t" + str("%.3f" % float(par_File[7])) + "\n")
                psf_file.write("MO_" + str(i) + "\t\t" + "0.0\t\t" + str("%.4f" % float(par_File[8])) + "\t\t" + str("%.4f" % float(par_File[9])) + "\t\t" + "0.000000" + "\t\t" + str("%.4f" % float(par_File[8])) + "\t\t" + str("%.3f" % float(par_File[9])) + "\n")

            psf_file.write("\nHBOND CUTHB 0.5\n\n")
            psf_file.write("END\n")

            psf_file.close()
            par_File = tmp_par_file[:]
            os.system('bash only_surface_current_directory.sh')
            os.chdir("..")

main_root = os.getcwd()
os.mkdir('RMSD_File')
os.system('find . -type f -name *_RMSD.dat -exec cp {} ' + main_root + '/RMSD_File \;')

os.mkdir('Within_5_water_File')
os.system('find . -type f -name *_water.dat -exec cp {} ' + main_root + '/Within_5_water_File \;')


