# to use: vmd -dispdev text -e cellsize_system.tcl

set boundaryFile "Mo2C_centered.bound"
set system "system"

mol load psf ${system}_solvate.psf pdb ${system}_solvate.pdb
set all [atomselect 0 "all"] 

set min_max_all [measure minmax $all]
set all_max_z [lindex $min_max_all 1 2]
set all_min_z [lindex $min_max_all 0 2]
set lz [expr $all_max_z - $all_min_z]

set center [measure center $all]

# Get the cellBasisVector1_x from the boundary file.
proc readLx {boundaryFile} {
	set in [open $boundaryFile r]
	foreach line [split [read $in] \n] {
    		if {[string match "cellBasisVector1 *" $line]} {
			set lx [lindex $line 1]
			break
		}
	}
	puts "cellBasisVector1:		$lx"
	close $in
	return $lx
}

# Get the cellBasisVector2_y from the boundary file.
proc readLy {boundaryFile} {
	set in [open $boundaryFile r]
	foreach line [split [read $in] \n] {
    		if {[string match "cellBasisVector2 *" $line]} {
			set ly [lindex $line 2]
			break
		}
	}
	puts "cellBasisVector2:		$ly"
	close $in
	return $ly
}

set lx [readLx $boundaryFile]
set ly [readLy $boundaryFile]


set periodicFile_name "system_cellsize.xsc"
set periodicFile [open $periodicFile_name w]
puts $periodicFile "# NAMD extended system configuration input file"
puts $periodicFile "#\$LABELS step a_x a_y a_z b_x b_y b_z c_x c_y c_z o_x o_y o_z"
puts $periodicFile "0 $lx 0.0 0.0 0.0 $ly 0.0 0.0 0.0 $lz $center"
close $periodicFile

exit