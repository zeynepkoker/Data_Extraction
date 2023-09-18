set system "system"
mol new ${system}_solvate.psf
mol addfile eq0.dcd waitfor all
mol addfile eq1.dcd waitfor all
mol addfile eq2.dcd waitfor all
mol addfile eq3.dcd waitfor all

set fileExist [expr {![catch {file lstat "BNT_within_5_water.dat" finfo}]}]
if { 0 == $fileExist } {
	set outfile [open "Structure_info.txt" w]
	set binding_output [open "distance.dat" "w"]
	set binding_results [open "binding_results.dat" "w"]
	set within_5_water [open "BNT_within_5_water.dat" "w"]
}

set all [atomselect top "all"]
set num_all [$all num]
set min_max [measure minmax $all]

set peptide [atomselect top "protein"]
set water [atomselect top "water"]
set ions [atomselect top "segname ION"]
set surface [atomselect top "resname MOC"]

set peptide_resname_resid [$peptide get {resname resid}]
set peptide_resname_resid [lsort -unique [$peptide get {resname resid}]]
set num_peptide [$peptide num]

foreach resname_resid $peptide_resname_resid {
	set sel_resname [lindex $resname_resid 0 0]
	set sel_resid [lindex $resname_resid 1 0]
	set sel [atomselect top "resname $sel_resname and resid $sel_resid"]
	set sel_num [$sel num]
	if { $fileExist == 0} {
		puts $outfile "RESNAME: $sel_resname RESID: $sel_resid NUM_ATOMS: $sel_num"
	}
}

set num_water [$water num]
set ions_name [lsort -unique [$ions get name]]
set num_ions [$ions num]
set num_surface [$surface num]

if { $fileExist == 0} {
	puts $outfile "Peptide Number of Atoms:	$num_peptide"
	puts $outfile "Water Number of Atoms:	$num_water"
	puts $outfile "IONS:	$ions_name"
	puts $outfile "IONS Number of Atoms:	$num_ions"
	puts $outfile "Mo2C Number of Atoms:	$num_surface"
	puts $outfile "Total Number of Atoms:	$num_all"
	close $outfile
	puts $binding_output "# All Distance surface max and all aminoacids center of mass" 
	puts $binding_results "# BINDING within 2A from aminoacids center of mass"
}

set com_peptide [measure center $peptide]
set com_surface [measure center $surface]

set binding_cutoff 2

set binding_list {}
set num_steps [molinfo 0 get numframes]
for {set frame 0} {$frame < $num_steps} {incr frame} {
	set water_within [atomselect top "water within 5 of resname MOC" frame ${frame}]
	set num_water_within [$water_within num]
	puts $within_5_water "$frame	$num_water_within"
	foreach resname_resid $peptide_resname_resid {
		set sel_resname [lindex $resname_resid 0 0]
		set sel_resid [lindex $resname_resid 1 0]
		set sel_peptide [atomselect top "resname $sel_resname and resid $sel_resid" frame ${frame}]
		set sel_surface [atomselect top "resname MOC" frame ${frame}]
		set com_each_aa [measure center $sel_peptide]
		set com_each_aa_z [lindex $com_each_aa 2]
		set surface_minmax [measure minmax $sel_surface]
		set surface_max_z [lindex $surface_minmax 1 2]
		set distance [expr $com_each_aa_z - $surface_max_z]
			if { ${distance} < ${binding_cutoff} } {		
				append binding_list "$sel_resid "
				if { $fileExist == 0} {
					puts $binding_results "$frame	$sel_resid	$sel_resname BINDING within 2"
				}
			}
		if { $fileExist == 0} {
			puts $binding_output "$frame $sel_resid	$sel_resname :	$distance" 
		}
	}
}

if { $fileExist == 0} {
	close $binding_output
	close $binding_results
	close $within_5_water
}


puts $binding_list

mol modselect 0 top "resname MOC"
mol modstyle 0 top VDW
mol addrep top
mol modselect 1 top "protein"
mol modstyle 1 top VDW
mol addrep top 
mol modselect 2 top "segname ION"
mol modstyle 2 top CPK
mol addrep top
mol modselect 3 top "protein"
mol modstyle 3 top VDW

set b_l [lsort -unique $binding_list]

if { [llength $binding_list] > 0 } {
	mol addrep top
	mol modselect 4 top "resid ${b_l} and protein"
	mol modstyle 4 top VDW
	mol modcolor 4 top colorid 1
}


# VISUALIZATION



#global vmd_frame
#
#graphics top delete all
#
#set dist [veclength [vecsub $com_surface $com_peptide ] ]
#set value_1 [expr -$dist*0.01]
#set value_2 [expr $dist*0.01]
#
#mol load graphics grph
#graphics top color red


#text {1 0 10} "$sel_resid $sel_resname" 0.75 6




# proc enabletrace {} {
#     global vmd_frame
#     trace variable vmd_frame([molinfo top]) w changecolor
# }

# draw delete all
# $sel_peptide update
# draw color red
# text {1 0 10} "$sel_resid $sel_resname" 0.75 2 frame $vmd_frame([molinfo top])]

# proc vmd_draw_arrow {mol start end} {
# # an arrow is made of a cylinder and a cone
# set middle [vecadd $start [vecscale 0.9 [vecsub $end $start]]]
# graphics $mol cylinder $start $middle radius 0.15
# graphics $mol cone $middle $end radius 0.25
# }
# 
# draw arrow {0 0 0} {10 10 10} frame $vmd_frame([molinfo top])]


# set sel [atomselect top "protein within 15 of resname MOC" frame $vmd_frame([molinfo top])]
# mol selupdate 4 $sel
# mol colupdate 4 top 5

#mol addrep top frame $vmd_frame([molinfo top])
#mol modselect 5 top "protein within 15 of resname MOC " frame $vmd_frame([molinfo top])]
#mol modstyle 5 top VDW
#mol modcolor 5 top colorid 10
#	mol load graphics grph
# graphics top delete all
# set dist [veclength [vecsub $com_surface $com_peptide ] ]
# set value_1 [expr -$dist*0.01]
# set value_2 [expr $dist*0.01]

# mol load graphics grph
# graphics top color red
# graphics top line [list 0 0 $value_1] [list 0 0 $value_2] style dashed
# graphics top text {0 0 0} "[format %.3f [expr $dist]]" size 0.75 thickness 2 
# axes location Off
# mol addrep top
# mol modselect 3 top "not water"
# mol modstyle 3 top lines 2
# mol modcolor 3 top timestep
# mol drawframes top 3 0:3600
exit