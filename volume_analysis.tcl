set volume_file [open "BNT_Volume.dat" "w"]
set volume_changes_file [open "BNT_Volume_changes.dat" "w"]

mol load psf system_solvate.psf pdb system_solvate.pdb

set system "system"
mol new ${system}_solvate.psf
mol addfile eq0.dcd waitfor all
mol addfile eq1.dcd waitfor all
mol addfile eq2.dcd waitfor all
mol addfile eq3.dcd waitfor all

set x_periodic_initial [molinfo 0 get a frame 0]
set y_periodic_initial [molinfo 0 get b frame 0]
set z_periodic_initial [molinfo 1 get c frame 0]

set surface_initial [atomselect 0 "resname MOC"]
set min_max_surface_initial [measure minmax $surface_initial]
set length_z_initial [format "%.6f" [expr [lindex $min_max_surface_initial 1 2] - [lindex $min_max_surface_initial 0 2]]]

set volume_periodic_initial [format "%.6f" [expr $x_periodic_initial * $y_periodic_initial * $z_periodic_initial]]
set volume_initial_surface [format "%.6f" [expr $x_periodic_initial * $y_periodic_initial * $length_z_initial]]


puts $volume_file "Frame: -1 \t X: \t $x_periodic_initial \t Y: \t $y_periodic_initial \t Z: \t $z_periodic_initial \t Volume_Box: $volume_periodic_initial \t Volume_Surface: \t $volume_initial_surface \t MOC_length_z: \t $length_z_initial"

set x_changes_percentage_initial [format "%.6f" [expr (${x_periodic_initial} - ${x_periodic_initial})*100/${x_periodic_initial}]]
set y_changes_percentage_initial [format "%.6f" [expr (${y_periodic_initial} - ${y_periodic_initial})*100/${y_periodic_initial}]]
set z_changes_percentage_initial [format "%.6f" [expr (${z_periodic_initial} - ${z_periodic_initial})*100/${z_periodic_initial}]]

set volume_changes_initial [format "%.6f" [expr (${volume_periodic_initial} - ${volume_periodic_initial})*100/${volume_periodic_initial} ]]

set volume_surface_changes_initial [format "%.6f" [expr (${volume_initial_surface} - ${volume_initial_surface})*100/${volume_initial_surface} ]]

set length_z_changes_initial [format "%.6f" [expr (${length_z_initial} - ${length_z_initial})*100/${length_z_initial}]]

puts $volume_changes_file "Frame: \t -1 \t X_changes: \t $x_changes_percentage_initial \t Y_changes: \t $y_changes_percentage_initial \t Z_changes: \t $z_changes_percentage_initial \t Volume_Box_changes: \t $volume_changes_initial \t Volume_surface_changes: \t $volume_surface_changes_initial \t MOC_length_z: \t $length_z_changes_initial"
	

set num_steps [molinfo 1 get numframes]


for {set frame 0} {$frame < $num_steps} {incr frame} {
	
	set x [molinfo 1 get a frame $frame]
	set y [molinfo 1 get b frame $frame]
	set z [molinfo 1 get c frame $frame]
	
	set volume [format "%.6f" [expr ${x} * ${y} * ${z} ]]

	set surface [atomselect 1 "resname MOC" frame $frame ]
	set min_max_surface [measure minmax $surface]
	set length_z [format "%.6f" [expr [lindex $min_max_surface 1 2] - [lindex $min_max_surface 0 2]]]
	
	set volume_surface [format "%.6f" [expr $x * $y * $length_z]]

	puts $volume_file "Frame: $frame \t X: \t $x \t Y: \t $y \t Z: \t $z \t Volume_Box: $volume \t Volume_Surface: \t $volume_surface \t MOC_length_z: \t $length_z "

	
	set x_changes_percentage [format "%.6f" [expr (${x} - ${x_periodic_initial})*100/${x_periodic_initial}]]
	set y_changes_percentage [format "%.6f" [expr (${y} - ${y_periodic_initial})*100/${y_periodic_initial}]]
	set z_changes_percentage [format "%.6f" [expr (${z} - ${z_periodic_initial})*100/${z_periodic_initial}]]
	
	set volume_changes [format "%.6f" [expr (${volume} - ${volume_periodic_initial})*100/${volume_periodic_initial} ]]
	
	set volume_surface_changes [format "%.6f" [expr (${volume_surface} - ${volume_initial_surface})*100/${volume_initial_surface} ]]
	
	set length_z_changes [format "%.6f" [expr (${length_z} - ${length_z_initial})*100/${length_z_initial}]]
	
	puts $volume_changes_file "Frame: \t $frame \t X_changes: \t $x_changes_percentage \t Y_changes: \t $y_changes_percentage \t Z_changes: \t $z_changes_percentage \t Volume_Box_changes: \t $volume_changes \t Volume_surface_changes: \t $volume_surface_changes \t MOC_length_z: \t $length_z_changes"
	
}


close $volume_file
close $volume_changes_file


exit





