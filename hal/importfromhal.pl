#!/usr/bin/env perl
use List::MoreUtils qw(uniq);
my $modulebase = shift or die "Usage: $0 modulebase\n";
my @files = <$modulebase*.g.v>;
foreach my $file (@files) {
  open(IN,'<', $file) or die "Can't open $file for reading\n";
  while(<IN>){
    next if (/^\s*$/);
    next if (/^\s*(input|output|inout)/);
    s/\\'1'/1'b1/;
    s/\\'0'/1'b0/;
    if (/^\s*module/){
        s/module\s+(\w+)\s*\(//;
        $modulename = $1;
        open(OUT,'>', "netlists/$modulename.g.v") or die "Can't open netlists/$modulename.g.v for writing\n";
        s/\)\s*;\s*$//;
        s/\\|(\(\d+\))//g;
        s/,/ /g;
        @ports = split(/\s+/);
        @ports = uniq(@ports);
        if ($modulename =~ "rv_top.*"){
            print OUT "module $modulename (".join(',',@ports).", so);\n";
            print OUT "  output [31:0] imem_addr;\n";
            print OUT "  output [31:0] dmem_addr;\n";
            print OUT "  output [31:0] dmem_dataout;\n";
            print OUT "  input [31:0] dmem_datain;\n";
            print OUT "  input [31:0] imem_datain;\n";
            print OUT "  input clk, rst, si, se;\n";
            print OUT "  output memrw, so;\n";
        }
        elsif ($modulename =~ "aes_128.*"){
            print OUT "module $modulename ( clk, state, key, out, si, so, se );
  input [127:0] state;
  input [127:0] key;
  output [127:0] out;
  input clk, si, se;
  output so;
  assign so = out[127];\n";
        } else { # ibex_top
            print OUT "module $modulename 
            ( clk_i, rst_ni, test_en_i, hart_id_i, boot_addr_i, 
        instr_req_o, instr_gnt_i, instr_rvalid_i, instr_addr_o, instr_rdata_i, 
        instr_rdata_intg_i, instr_err_i, data_req_o, data_gnt_i, data_rvalid_i, 
        data_we_o, data_be_o, data_addr_o, data_wdata_o, data_wdata_intg_o, 
        data_rdata_i, data_rdata_intg_i, data_err_i, irq_software_i, 
        irq_timer_i, irq_external_i, irq_fast_i, irq_nm_i, debug_req_i, 
        fetch_enable_i, alert_minor_o, alert_major_o, core_sleep_o, 
        scan_rst_ni, si, so, se, ram_cfg_i_ram_cfg__cfg_en_, 
        ram_cfg_i_ram_cfg__cfg__3_, ram_cfg_i_ram_cfg__cfg__2_, 
        ram_cfg_i_ram_cfg__cfg__1_, ram_cfg_i_ram_cfg__cfg__0_, 
        ram_cfg_i_rf_cfg__cfg_en_, ram_cfg_i_rf_cfg__cfg__3_, 
        ram_cfg_i_rf_cfg__cfg__2_, ram_cfg_i_rf_cfg__cfg__1_, 
        ram_cfg_i_rf_cfg__cfg__0_, crash_dump_o_current_pc__31_, 
        crash_dump_o_current_pc__30_, crash_dump_o_current_pc__29_, 
        crash_dump_o_current_pc__28_, crash_dump_o_current_pc__27_, 
        crash_dump_o_current_pc__26_, crash_dump_o_current_pc__25_, 
        crash_dump_o_current_pc__24_, crash_dump_o_current_pc__23_, 
        crash_dump_o_current_pc__22_, crash_dump_o_current_pc__21_, 
        crash_dump_o_current_pc__20_, crash_dump_o_current_pc__19_, 
        crash_dump_o_current_pc__18_, crash_dump_o_current_pc__17_, 
        crash_dump_o_current_pc__16_, crash_dump_o_current_pc__15_, 
        crash_dump_o_current_pc__14_, crash_dump_o_current_pc__13_, 
        crash_dump_o_current_pc__12_, crash_dump_o_current_pc__11_, 
        crash_dump_o_current_pc__10_, crash_dump_o_current_pc__9_, 
        crash_dump_o_current_pc__8_, crash_dump_o_current_pc__7_, 
        crash_dump_o_current_pc__6_, crash_dump_o_current_pc__5_, 
        crash_dump_o_current_pc__4_, crash_dump_o_current_pc__3_, 
        crash_dump_o_current_pc__2_, crash_dump_o_current_pc__1_, 
        crash_dump_o_current_pc__0_, crash_dump_o_next_pc__31_, 
        crash_dump_o_next_pc__30_, crash_dump_o_next_pc__29_, 
        crash_dump_o_next_pc__28_, crash_dump_o_next_pc__27_, 
        crash_dump_o_next_pc__26_, crash_dump_o_next_pc__25_, 
        crash_dump_o_next_pc__24_, crash_dump_o_next_pc__23_, 
        crash_dump_o_next_pc__22_, crash_dump_o_next_pc__21_, 
        crash_dump_o_next_pc__20_, crash_dump_o_next_pc__19_, 
        crash_dump_o_next_pc__18_, crash_dump_o_next_pc__17_, 
        crash_dump_o_next_pc__16_, crash_dump_o_next_pc__15_, 
        crash_dump_o_next_pc__14_, crash_dump_o_next_pc__13_, 
        crash_dump_o_next_pc__12_, crash_dump_o_next_pc__11_, 
        crash_dump_o_next_pc__10_, crash_dump_o_next_pc__9_, 
        crash_dump_o_next_pc__8_, crash_dump_o_next_pc__7_, 
        crash_dump_o_next_pc__6_, crash_dump_o_next_pc__5_, 
        crash_dump_o_next_pc__4_, crash_dump_o_next_pc__3_, 
        crash_dump_o_next_pc__2_, crash_dump_o_next_pc__1_, 
        crash_dump_o_next_pc__0_, crash_dump_o_last_data_addr__31_, 
        crash_dump_o_last_data_addr__30_, crash_dump_o_last_data_addr__29_, 
        crash_dump_o_last_data_addr__28_, crash_dump_o_last_data_addr__27_, 
        crash_dump_o_last_data_addr__26_, crash_dump_o_last_data_addr__25_, 
        crash_dump_o_last_data_addr__24_, crash_dump_o_last_data_addr__23_, 
        crash_dump_o_last_data_addr__22_, crash_dump_o_last_data_addr__21_, 
        crash_dump_o_last_data_addr__20_, crash_dump_o_last_data_addr__19_, 
        crash_dump_o_last_data_addr__18_, crash_dump_o_last_data_addr__17_, 
        crash_dump_o_last_data_addr__16_, crash_dump_o_last_data_addr__15_, 
        crash_dump_o_last_data_addr__14_, crash_dump_o_last_data_addr__13_, 
        crash_dump_o_last_data_addr__12_, crash_dump_o_last_data_addr__11_, 
        crash_dump_o_last_data_addr__10_, crash_dump_o_last_data_addr__9_, 
        crash_dump_o_last_data_addr__8_, crash_dump_o_last_data_addr__7_, 
        crash_dump_o_last_data_addr__6_, crash_dump_o_last_data_addr__5_, 
        crash_dump_o_last_data_addr__4_, crash_dump_o_last_data_addr__3_, 
        crash_dump_o_last_data_addr__2_, crash_dump_o_last_data_addr__1_, 
        crash_dump_o_last_data_addr__0_, crash_dump_o_exception_addr__31_, 
        crash_dump_o_exception_addr__30_, crash_dump_o_exception_addr__29_, 
        crash_dump_o_exception_addr__28_, crash_dump_o_exception_addr__27_, 
        crash_dump_o_exception_addr__26_, crash_dump_o_exception_addr__25_, 
        crash_dump_o_exception_addr__24_, crash_dump_o_exception_addr__23_, 
        crash_dump_o_exception_addr__22_, crash_dump_o_exception_addr__21_, 
        crash_dump_o_exception_addr__20_, crash_dump_o_exception_addr__19_, 
        crash_dump_o_exception_addr__18_, crash_dump_o_exception_addr__17_, 
        crash_dump_o_exception_addr__16_, crash_dump_o_exception_addr__15_, 
        crash_dump_o_exception_addr__14_, crash_dump_o_exception_addr__13_, 
        crash_dump_o_exception_addr__12_, crash_dump_o_exception_addr__11_, 
        crash_dump_o_exception_addr__10_, crash_dump_o_exception_addr__9_, 
        crash_dump_o_exception_addr__8_, crash_dump_o_exception_addr__7_, 
        crash_dump_o_exception_addr__6_, crash_dump_o_exception_addr__5_, 
        crash_dump_o_exception_addr__4_, crash_dump_o_exception_addr__3_, 
        crash_dump_o_exception_addr__2_, crash_dump_o_exception_addr__1_, 
        crash_dump_o_exception_addr__0_ );
  input [31:0] hart_id_i;
  input [31:0] boot_addr_i;
  output [31:0] instr_addr_o;
  input [31:0] instr_rdata_i;
  input [6:0] instr_rdata_intg_i;
  output [3:0] data_be_o;
  output [31:0] data_addr_o;
  output [31:0] data_wdata_o;
  output [6:0] data_wdata_intg_o;
  input [31:0] data_rdata_i;
  input [6:0] data_rdata_intg_i;
  input [14:0] irq_fast_i;
  input clk_i, rst_ni, test_en_i, instr_gnt_i, instr_rvalid_i, instr_err_i,
         data_gnt_i, data_rvalid_i, data_err_i, irq_software_i, irq_timer_i,
         irq_external_i, irq_nm_i, debug_req_i, fetch_enable_i, scan_rst_ni,
         si, se, ram_cfg_i_ram_cfg__cfg_en_, ram_cfg_i_ram_cfg__cfg__3_,
         ram_cfg_i_ram_cfg__cfg__2_, ram_cfg_i_ram_cfg__cfg__1_,
         ram_cfg_i_ram_cfg__cfg__0_, ram_cfg_i_rf_cfg__cfg_en_,
         ram_cfg_i_rf_cfg__cfg__3_, ram_cfg_i_rf_cfg__cfg__2_,
         ram_cfg_i_rf_cfg__cfg__1_, ram_cfg_i_rf_cfg__cfg__0_;
  output instr_req_o, data_req_o, data_we_o, alert_minor_o, alert_major_o,
         core_sleep_o, so, crash_dump_o_current_pc__31_,
         crash_dump_o_current_pc__30_, crash_dump_o_current_pc__29_,
         crash_dump_o_current_pc__28_, crash_dump_o_current_pc__27_,
         crash_dump_o_current_pc__26_, crash_dump_o_current_pc__25_,
         crash_dump_o_current_pc__24_, crash_dump_o_current_pc__23_,
         crash_dump_o_current_pc__22_, crash_dump_o_current_pc__21_,
         crash_dump_o_current_pc__20_, crash_dump_o_current_pc__19_,
         crash_dump_o_current_pc__18_, crash_dump_o_current_pc__17_,
         crash_dump_o_current_pc__16_, crash_dump_o_current_pc__15_,
         crash_dump_o_current_pc__14_, crash_dump_o_current_pc__13_,
         crash_dump_o_current_pc__12_, crash_dump_o_current_pc__11_,
         crash_dump_o_current_pc__10_, crash_dump_o_current_pc__9_,
         crash_dump_o_current_pc__8_, crash_dump_o_current_pc__7_,
         crash_dump_o_current_pc__6_, crash_dump_o_current_pc__5_,
         crash_dump_o_current_pc__4_, crash_dump_o_current_pc__3_,
         crash_dump_o_current_pc__2_, crash_dump_o_current_pc__1_,
         crash_dump_o_current_pc__0_, crash_dump_o_next_pc__31_,
         crash_dump_o_next_pc__30_, crash_dump_o_next_pc__29_,
         crash_dump_o_next_pc__28_, crash_dump_o_next_pc__27_,
         crash_dump_o_next_pc__26_, crash_dump_o_next_pc__25_,
         crash_dump_o_next_pc__24_, crash_dump_o_next_pc__23_,
         crash_dump_o_next_pc__22_, crash_dump_o_next_pc__21_,
         crash_dump_o_next_pc__20_, crash_dump_o_next_pc__19_,
         crash_dump_o_next_pc__18_, crash_dump_o_next_pc__17_,
         crash_dump_o_next_pc__16_, crash_dump_o_next_pc__15_,
         crash_dump_o_next_pc__14_, crash_dump_o_next_pc__13_,
         crash_dump_o_next_pc__12_, crash_dump_o_next_pc__11_,
         crash_dump_o_next_pc__10_, crash_dump_o_next_pc__9_,
         crash_dump_o_next_pc__8_, crash_dump_o_next_pc__7_,
         crash_dump_o_next_pc__6_, crash_dump_o_next_pc__5_,
         crash_dump_o_next_pc__4_, crash_dump_o_next_pc__3_,
         crash_dump_o_next_pc__2_, crash_dump_o_next_pc__1_,
         crash_dump_o_next_pc__0_, crash_dump_o_last_data_addr__31_,
         crash_dump_o_last_data_addr__30_, crash_dump_o_last_data_addr__29_,
         crash_dump_o_last_data_addr__28_, crash_dump_o_last_data_addr__27_,
         crash_dump_o_last_data_addr__26_, crash_dump_o_last_data_addr__25_,
         crash_dump_o_last_data_addr__24_, crash_dump_o_last_data_addr__23_,
         crash_dump_o_last_data_addr__22_, crash_dump_o_last_data_addr__21_,
         crash_dump_o_last_data_addr__20_, crash_dump_o_last_data_addr__19_,
         crash_dump_o_last_data_addr__18_, crash_dump_o_last_data_addr__17_,
         crash_dump_o_last_data_addr__16_, crash_dump_o_last_data_addr__15_,
         crash_dump_o_last_data_addr__14_, crash_dump_o_last_data_addr__13_,
         crash_dump_o_last_data_addr__12_, crash_dump_o_last_data_addr__11_,
         crash_dump_o_last_data_addr__10_, crash_dump_o_last_data_addr__9_,
         crash_dump_o_last_data_addr__8_, crash_dump_o_last_data_addr__7_,
         crash_dump_o_last_data_addr__6_, crash_dump_o_last_data_addr__5_,
         crash_dump_o_last_data_addr__4_, crash_dump_o_last_data_addr__3_,
         crash_dump_o_last_data_addr__2_, crash_dump_o_last_data_addr__1_,
         crash_dump_o_last_data_addr__0_, crash_dump_o_exception_addr__31_,
         crash_dump_o_exception_addr__30_, crash_dump_o_exception_addr__29_,
         crash_dump_o_exception_addr__28_, crash_dump_o_exception_addr__27_,
         crash_dump_o_exception_addr__26_, crash_dump_o_exception_addr__25_,
         crash_dump_o_exception_addr__24_, crash_dump_o_exception_addr__23_,
         crash_dump_o_exception_addr__22_, crash_dump_o_exception_addr__21_,
         crash_dump_o_exception_addr__20_, crash_dump_o_exception_addr__19_,
         crash_dump_o_exception_addr__18_, crash_dump_o_exception_addr__17_,
         crash_dump_o_exception_addr__16_, crash_dump_o_exception_addr__15_,
         crash_dump_o_exception_addr__14_, crash_dump_o_exception_addr__13_,
         crash_dump_o_exception_addr__12_, crash_dump_o_exception_addr__11_,
         crash_dump_o_exception_addr__10_, crash_dump_o_exception_addr__9_,
         crash_dump_o_exception_addr__8_, crash_dump_o_exception_addr__7_,
         crash_dump_o_exception_addr__6_, crash_dump_o_exception_addr__5_,
         crash_dump_o_exception_addr__4_, crash_dump_o_exception_addr__3_,
         crash_dump_o_exception_addr__2_, crash_dump_o_exception_addr__1_,
         crash_dump_o_exception_addr__0_;
            assign data_wdata_intg_o[0] = 1'b0;
            assign data_wdata_intg_o[1] = 1'b0;
            assign data_wdata_intg_o[2] = 1'b0;
            assign data_wdata_intg_o[3] = 1'b0;
            assign data_wdata_intg_o[4] = 1'b0;
            assign data_wdata_intg_o[5] = 1'b0;
            assign data_wdata_intg_o[6] = 1'b0;
            assign crash_dump_o_last_data_addr__31_ = so;
            assign alert_minor_o = 1'b0;
            assign data_addr_o[1] = 1'b0;
            assign data_addr_o[0] = 1'b0;
            assign instr_addr_o[1] = 1'b0;
            assign instr_addr_o[0] = 1'b0;
            assign crash_dump_o_next_pc__0_ = 1'b0;
            assign alert_major_o = 1'b0;
            " ;

        }
    } elsif ($inhalgate) {
        $inhalgate = 0 if (/;/)
    } elsif (/HAL_VDD|HAL_VSS/){
        $inhalgate = 1;
    } elsif (/^\s*wire/) {
        next if (/1'b(0|1)\s*;/);
        $inwires = 1;
        s/^\s*wire//;
        s/;\s*$//;
        s/,/ /g;
        @lwires = split(/\s+/);
        die ("Support only single wire declarations") if ((scalar @lwires) == 1);
        $wire =pop(@lwires);
        if ($wire =~ /\\(\w+)\((\d+)\)/){
            $maxind{$1} = $2 if ((not exists $maxind{$1}) or ($2 > $maxind{$1}));
            $minind{$1} = $2 if ((not exists $minind{$1}) or ($2 < $minind{$1}));
        } else {
            print OUT "  wire $wire;\n";
        }
    } else {
        if ($inwires == 1) {
            $inwires = 2;
            foreach $vec (keys %maxind)
            {
	            print OUT "  wire \[$maxind{$vec}:$minind{$vec}\] $vec;\n";
            }
            print OUT "assign so = imem_addr[31];" if ($modulename =~ "rv_top.*"); # HAL bug
        }
        s/\\(\w+)\((\d+)\)/$1\[$2\]/g;
        print OUT;
    }
  }
}
