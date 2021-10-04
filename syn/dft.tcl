set TOP rv_top
set FILE "rv_top.v"
set CLK clk
set RST rst

source init_nangate_lib.tcl

define_name_rules mainrule -replacement_char "_" -restricted "/\[\]" \
    -equal_ports_nets

#read_verilog -netlist $FILE
analyze -format verilog ~/Scandid/benchmarks/rv/src/rv_top.v
analyze -format verilog ~/Scandid/benchmarks/rv/src/rv_dp.v
analyze -format verilog ~/Scandid/benchmarks/rv/src/rv_ctl.v
elaborate $TOP
current_design $TOP
link

create_port -direction in si
create_port -direction out so
create_port -direction in se

set test_default_period 100
set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port $CLK
set_dft_signal -view existing -type Reset -active_state 1 -port $RST
set_scan_configuration -style multiplexed_flip_flop

compile -scan -ungroup
#ungroup -all -flatten
change_names -rules mainrule -hierarchy

create_test_protocol
dft_drc

write_test_protocol -output [current_design_name].spf


set_scan_configuration -chain_count 1
set_scan_configuration -clock_mixing no_mix
set_dft_signal -view spec -type ScanDataIn -port si
set_dft_signal -view spec -type ScanDataOut -port so
set_dft_signal -view spec -type ScanEnable -port se -active_state 1
set_scan_path chain1 -scan_data_in si -scan_data_out so

preview_dft -show all
preview_dft -test_points all

insert_dft

set_scan_state scan_existing
dft_drc -coverage_estimate

report_scan_path -view existing_dft -chain all > [current_design_name].scanpath.rpt
report_scan_path -view existing_dft -cell all >> [current_design_name].scanpath.rpt

change_names -rules mainrule -hierarchy
write -format verilog -out $TOP.g.v -hierarchy
write -format ddc -out $TOP.ddc -hierarchy
write_scan_def -output $TOP.scan.def
set test_stil_netlist_format verilog
write_test_protocol -output $TOP.spf
quit
