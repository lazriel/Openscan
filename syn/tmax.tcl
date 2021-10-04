set top rv_top
set mode sa
set_messages -log ${top}_${mode}_atpg.log -replace
read_netlist rv_top.g.v
#read_netlist /tools/kits/tower/PDK_TS18SL/FS120_STD_Cells_0_18um_2005_12/DW_TOWER_tsl18fs120/2005.12/verilog/zero/all.v
read_netlist NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/verilog/NanGate_15nm_OCL_functional.v
run_build_model $top
set_drc rv_top.spf
set_faults -model stuck
run_drc
run_atpg -auto
write_patterns    ${top}_$mode.stil -replace -internal -format stil
write_testbench -input ${top}_$mode.stil -out ${top}_${mode}_tb -replace
quit
