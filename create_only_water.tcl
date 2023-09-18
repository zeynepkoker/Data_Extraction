# to use: vmd -dispdev text -e create_system.tcl
# Creating only water surface within 15 A min max

set fileName "Mo2C_centered"
set boundaryFile "Mo2C_centered.xsc"
set system "system"
set in [open $boundaryFile r]
set count 0
foreach line [split [read $in] \n] {
incr count
puts "$line"
		if { $count == 3 } {
		set lx [lindex $line 1]
		set ly [lindex $line 5]
	}
}
puts "$lx	$ly"

set x_value [expr $lx / 2]
set y_value [expr $ly / 2]
puts "$x_value $y_value"


mol load psf ${fileName}.psf pdb ${fileName}.pdb


package require solvate
solvate ${fileName}.psf ${fileName}.pdb -minmax  [list [list -${x_value} -${y_value} -30]  [list ${x_value} ${y_value} 30] ] -o ${system}_solvate
mol delete top
resetpsf

exit
