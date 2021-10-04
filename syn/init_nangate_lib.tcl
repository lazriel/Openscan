set syn_home NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NLDM
set search_path [concat $syn_home    $search_path ]
set target_library $syn_home/NanGate_15nm_OCL_typical_conditional_nldm.db
append link_library " $syn_home/NanGate_15nm_OCL_typical_conditional_nldm.db"
set hdlin_auto_save_templates false
define_design_lib WORK -path .template
set verilogout_single_bit false
set hdlout_internal_busses true
set bus_naming_style {%s[%d]}
set bus_inference_style $bus_naming_style

 define_name_rules simple_cell_names -allowed "A-Za-z0-9_" \
  -first_restricted "_0-9" \
  -map [list {{"*-return","RET"}}] \
  -max_length 96 \
  -type cell
define_name_rules verilog -add_dummy_nets
set hdlin_auto_save_templates true
set hdlin_vrlg_std 2001
set change_names_dont_change_bus_members true
set verilogout_no_tri true
  set bus_naming_style {%s[%d]}
  set bus_extraction_style {%s[%d:%d]}
  set bus_dimension_separator_style {][}
  set bus_inference_style {%s[%d]}
