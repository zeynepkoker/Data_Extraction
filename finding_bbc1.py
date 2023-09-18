def zeynep(array):
    return array[3]
energy_file = open('ZEYNEP.txt', 'r')
file = open('found_bbc1.txt', 'a')
lines = energy_file.readlines()
file_lines = reversed(energy_file.readlines())
energy = []
for line in lines:
    if len(line) > 1:
        energy.append(line.split())
energy.sort(key=zeynep)
file.write('BNT_repositioned' + '\t' + (energy[len(energy)-1][0]) + '\t' + 'ENERGY:' + '\t' +'TNB' + '\t' +(energy[len(energy)-1][3]))

energy_file.close()
file.close()

