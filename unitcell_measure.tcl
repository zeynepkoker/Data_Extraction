# Unit cell changes

set system "system"
mol new ${system}_solvate.psf
mol addfile eq0.dcd waitfor all
mol addfile eq1.dcd waitfor all
mol addfile eq2.dcd waitfor all
mol addfile eq3.dcd waitfor all

set f [open "BNT_surface.dat" "w"]
set f_changes [open "BNT_surface_changes.dat" "w"]

set num_steps [molinfo 0 get numframes]

set x_initial [molinfo 0 get a frame 0]
set y_initial [molinfo 0 get b frame 0]
set z_initial [molinfo 0 get c frame 0]
set volume_initial [expr $x_initial * $y_initial * $z_initial]

set surface_initial [atomselect top "resname MOC" frame 0]
set min_max_surface_initial [measure minmax $surface_initial]
set length_z_initial [expr [lindex $min_max_surface_initial 1 2] - [lindex $min_max_surface_initial 0 2]]
set volume_initial_surface [expr $x_initial * $y_initial * $length_z_initial]


for {set frame 0} {$frame < $num_steps} {incr frame} {
	
	set x [molinfo 0 get a frame $frame]
	set y [molinfo 0 get b frame $frame]
	set z [molinfo 0 get c frame $frame]
	
	set x_changes_percentage [format "%.6f" [expr (${x} - ${x_initial})*100/${x}]]
	set y_changes_percentage [format "%.6f" [expr (${y} - ${y_initial})*100/${y}]]
	set z_changes_percentage [format "%.6f" [expr (${z} - ${z_initial})*100/${z}]]
	
	set volume [format "%.6f" [expr (${x} * ${y} * ${z})]]
	set volume_changes [format "%.6f" [expr (${volume} - ${volume_initial})*100/${volume} ]]
	
	
	set surface [atomselect top "resname MOC" frame $frame]
	set min_max_surface [measure minmax $surface]
	set length_z [format "%.6f" [expr [lindex $min_max_surface 1 2] - [lindex $min_max_surface 0 2]]]
	set volume_surface [format "%.6f" [expr $x * $y * $length_z_initial]]
	set volume_surface_changes [format "%.6f" [expr (${volume_surface} - ${volume_initial_surface})*100/${volume_surface} ]]

	
	puts $f "Frame: $frame \t X: \t $x \t Y: \t $y \t Z: \t $z \t Volume_Box: $volume \t Volume_Surface: \t $volume_surface "
	puts $f_changes "Frame: \t $frame \t X_changes: \t $x_changes_percentage \t Y_changes: \t $y_changes_percentage \t Z_changes: \t $z_changes_percentage \t Volume_Box_changes: \t $volume_changes \t Volume_surface_changes: \t $volume_surface_changes"
	
	
}
close $f
close $f_changes

exit
