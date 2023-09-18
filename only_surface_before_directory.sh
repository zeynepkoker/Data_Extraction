#!/bin/bash
# You need rotated_basis.pdb

# 27.Haziran.2023 Updated


bondDistance=( "2.1" )
chargeMo=( "-0.5000" "0.0000" "0.1000" "0.2000" "0.3000" "0.4000" "0.5000" "0.6000" "0.7000" )

bondDistance_name=( "2_1" )
chargeMo_name=( "-0_5000" "0_0000" "0_1000" "0_2000" "0_3000" "0_4000" "0_5000" "0_6000" "0_7000" )

numBondsMo=( "3" )
numBondsC=( "6" )
for bond in "${!bondDistance[@]}"
do
	for charge in "${!chargeMo[@]}"
	do
		for index in "${!numBondsMo[@]}"
		do
			start_time=$(date +%s)
			mkdir "../${bondDistance_name[$bond]}_${chargeMo_name[$charge]}_${numBondsMo[$index]}_${numBondsC[$index]}"
			cp -a $(pwd)/. ../${bondDistance_name[$bond]}_${chargeMo_name[$charge]}_${numBondsMo[$index]}_${numBondsC[$index]}
			cd ../${bondDistance_name[$bond]}_${chargeMo_name[$charge]}_${numBondsMo[$index]}_${numBondsC[$index]}
			vmd -dispdev text -e replicateCrystal_Mo2C.tcl
			echo "replicated"
			vmd -dispdev text -e boundFile.tcl
			echo "bound"
			vmd -dispdev text -e molybdenum_carbidePsf.tcl -args ${bondDistance[$bond]} ${chargeMo[$charge]} ${numBondsMo[$index]} ${numBondsC[$index]}
			echo "psf created"
			
			Initial_PATH=$(pwd)
			Initial_PATH=$(echo "$Initial_PATH" | sed 's/\//\\\//g')
			num_steps=10000
			name=$(basename "`pwd`")

			vmd -dispdev text -e create_only_water.tcl
			vmd -dispdev text -e cellsize_system.tcl
			vmd -dispdev text -e constrainMolybdenum.tcl -args ${numBondsMo[$index]} ${numBondsC[$index]}
			echo "constrain"
			sed -i 's/BNT/'${Initial_PATH}'/g' eq0.namd
			sed -i 's/ZEYNEP/'${num_steps}'/g' eq0.namd
			namd2 +p 12 eq0.namd > eq0.log
			sed -i 's/ZEYNEP/'${num_steps}'/g' eq1.namd
			sed -i 's/BNT/'${Initial_PATH}'/g' eq1.namd
			namd2 +p 12 eq1.namd > eq1.log
			sed -i 's/ZEYNEP/'${num_steps}'/g' eq2.namd
			sed -i 's/BNT/'${Initial_PATH}'/g' eq2.namd
			namd2 +p 12 eq2.namd > eq2.log
			sed -i 's/ZEYNEP/'${num_steps}'/g' eq3.namd
			sed -i 's/BNT/'${Initial_PATH}'/g' eq3.namd
			namd2 +p 12 eq3.namd > eq3.log
			catdcd -o all.dcd eq0.dcd eq1.dcd eq2.dcd eq3.dcd
			sed -i 's/BNT/'${name}'/g' RMSD.tcl
			vmd -dispdev text -e RMSD.tcl
			sed -i 's/BNT/'${name}'/g' RMSD.py
			python RMSD.py
			sed -i 's/BNT/'${name}'/g' system_info_visualization.tcl
			vmd -dispdev text -e system_info_visualization.tcl
			sed -i 's/BNT/'${name}'/g' volume_analysis.tcl
			vmd -dispdev text -e volume_analysis.tcl
			cd ../
			cd Surface_main
		done
	done
done

cd ../
main_root=$(pwd)
mkdir RMSD_File
find . -type f -name *_RMSD.dat -exec cp {} ${main_root}/RMSD_File \;

mkdir Within_5_water_File
find . -type f -name *_water.dat -exec cp {} ${main_root}/Within_5_water_File \;

mkdir Volume_Measurement
find . -type f -name *_Volume.dat -exec cp {} ${main_root}/Volume_Measurement \;

mkdir Volume_Surface_Changes_Measurement
find . -type f -name *_Volume_changes.dat -exec cp {} ${main_root}/Volume_Surface_Changes_Measurement \;



