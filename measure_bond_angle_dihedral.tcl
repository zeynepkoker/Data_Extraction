set outfile [open "bond_angle_dihedral.txt" w]

mol load pdb Mo2C_centered.pdb

set surface [atomselect top all]

set nameC "C.*"
set selTextC "name \"${nameC}\""
set surface_C [atomselect top $selTextC]
set C_name [lsort -unique [$surface_C get name]]
set C_num [$surface_C num]

set nameMo "MO.*"
set selTextMo "name \"${nameMo}\""
set surface_MO [atomselect top $selTextMo]
set MO_name [lsort -unique [$surface_MO get name]]
set MO_num [$surface_MO num]

set all_name [lsort -unique [$surface get name]]

puts $outfile "Bonds"

set count 0

foreach C_x $C_name {
	foreach MO_x $MO_name {	
	set C_temp [atomselect top "resid 25 and name \"${C_x}\""]
	set MO_temp [atomselect top "resid 25 and name \"${MO_x}\""]
	set C_index [$C_temp get index]
	set MO_index [$MO_temp get index]
	set bond_temp [measure bond [list $C_index $MO_index ]]
	# puts "$C_x $MO_x : $bond_temp"
	incr count 1
	puts $outfile "$C_x $MO_x: $bond_temp"
	}
}

puts $outfile "Angles"

foreach first $all_name {
	foreach second $all_name {	
		if { "$first" != "$second" } {
			foreach third $all_name {
				if { "$second" != "$third" && "$first" != "$third" } {
					set first_temp [atomselect top "resid 25 and name \"${first}\""]
					set second_temp [atomselect top "resid 25 and name \"${second}\""]
					set third_temp [atomselect top "resid 25 and name \"${third}\""]
					set first_index [$first_temp get index]
					set second_index [$second_temp get index]
					set third_index [$third_temp get index]
					set angle_temp [measure angle [list $first_index $second_index $third_index]]
					# puts "$first $second $third : $angle_temp"
					incr count 1
					puts $outfile "$first $second $third: $angle_temp"
				}
			}
		}
	}
}

# puts $outfile "Dihedrals"

foreach first $all_name {
	foreach second $all_name {	
		if { "$first" != "$second" } {
			foreach third $all_name {
				if { "$second" != "$third" && "$first" != "$third" } {
					foreach fourth $all_name {
						if { "$second" != "$fourth" && "$first" != "$fourth" && "$third" != "$fourth" } {
							set first_temp [atomselect top "resid 25 and name \"${first}\""]
							set second_temp [atomselect top "resid 25 and name \"${second}\""]
							set third_temp [atomselect top "resid 25 and name \"${third}\""]
							set fourth_temp [atomselect top "resid 25 and name \"${fourth}\""]
							set first_index [$first_temp get index]
							set second_index [$second_temp get index]
							set third_index [$third_temp get index]
							set fourth_index [$fourth_temp get index]
							set dihed_temp [measure dihed [list $first_index $second_index $third_index $fourth_index]]
							# puts "$first $second $third $fourth : $dihed_temp"
							# incr count 1
							# puts $outfile "$first $second $third $fourth: $dihed_temp"
						}
					}			
				}
			}
		}
	}
}

puts $outfile "Finished"
puts "$count"
puts "Finished"





