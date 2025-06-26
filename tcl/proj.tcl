
if { [info exists ::env(REPO_TOP_DIR)] } {
    set folder              $::env(REPO_TOP_DIR)
} else {
    # Throw an error
    error "REPO_TOP_DIR env variable is not set"
    exit 1
}

puts "Sourcing from: $folder"

set vivado_version      [version -short] 
set project_name        lab-external-signal-synchronization
set part_name           xc7z020clg400-1
set tcl_dir             "$folder/tcl"
set hdl_dir             "$folder/hdl"
set hvl_dir             "$folder/hvl"
set SVLib_dir           "$folder/SVLib"
set constraints_dir     "$folder/xdc"
set vivado_projects_dir "$folder/$project_name.$vivado_version"



file delete -force $vivado_projects_dir/$project_name
create_project $project_name $vivado_projects_dir/$project_name
set_property "part" $part_name [current_project]
set_property target_language verilog [current_project]

# Set the directory path for the new project
set project_dir [get_property directory [current_project]]
cd $project_dir

foreach file [glob -nocomplain $hdl_dir/*] {
    puts "Adding RTL: $file"
    add_files -fileset sources_1 -norecurse $file
}

# Add Files from SVLib
add_files -fileset sources_1 -norecurse $SVLib_dir/src/cdc/cdc_sync.sv
add_files -fileset sources_1 -norecurse $SVLib_dir/src/registers_regfiles/register_sync_rstn.sv

add_files -fileset sim_1 -norecurse $hvl_dir/fpga_top_tb.sv

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Add the constraints file
puts "Adding constraints file"
add_files  -fileset constrs_1 $constraints_dir/constr.xdc

# Report project creation complete
puts "INFO: Project created: $project_name"


# Set Synthesis and Implementation Properties

reset_run synth_1

set_property top fpga_top [get_filesets sources_1]
update_compile_order -fileset sources_1

launch_runs impl_1 -jobs 8
