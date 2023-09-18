# This code work with visualization_input.tcl Do not change 15 and 21 line from visualizaion_input.tcl
puts "Please enter the desired parameters numbers"
puts "bonds_epsilon		 --> 0"
puts "bonds_sigma		 --> 1"
puts "angles_Mo_first	 --> 2"
puts "angles_Mo_second	 --> 3"
puts "angles_C_first	 --> 4"
puts "angles_C_second	 --> 5"
puts "c_vdw_first		 --> 6"
puts "c_vdw_second		 --> 7"
puts "mo_vdw_first		 --> 8"
puts "mo_vdw_second		 --> 9"

proc visualization { number } {
	set order_index [list "bonds_epsilon_list" "bonds_sigma_list" "angles_Mo_first_list" "angles_Mo_second_list" "angles_C_first_list" "angles_C_second_list" "c_vdw_first_list" "c_vdw_second_list" "mo_vdw_first_list" "mo_vdw_second_list"]
	set list_name [lindex $order_index $number]
	set shell_script "sed -i 's/order_number/${number}/g' visualization_input.tcl"
	exec sh -c $shell_script
	set shell_script "sed -i 's/list_name/${list_name}/g' visualization_input.tcl"
	exec sh -c $shell_script
	source visualization_input.tcl
	set shell_script "sed -i 's/order ${number}/order order_number/g' visualization_input.tcl"
	exec sh -c $shell_script
	set shell_script "sed -i 's/${list_name} \{/list_name \{/g' visualization_input.tcl"
	exec sh -c $shell_script
}

proc rewrite { } {
	set shell_script "sed -i '15d' visualization_input.tcl"
	exec sh -c $shell_script
	set shell_script "sed -i '15 i set order order_number' visualization_input.tcl"
	exec sh -c $shell_script
	
	set shell_script "sed -i '21d' visualization_input.tcl"
	exec sh -c $shell_script
	set shell_script "sed -i '21 i foreach parameters \$list_name \{' visualization_input.tcl"
	exec sh -c $shell_script
}
	
	