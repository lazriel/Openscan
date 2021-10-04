#!/bin/perl
use List::MoreUtils qw(uniq);
while(<>){
    next if (/^\s*$/);
    next if (/^\s*(input|output|inout)/);
    s/\\'1'/1'b1/;
    s/\\'0'/1'b0/;
    if (/^\s*module/){
        s/module\s+(\w+)\s*\(//;
        $modulename = $1;
        s/\)\s*;\s*$//;
        s/\\|(\(\d+\))//g;
        s/,/ /g;
        @ports = split(/\s+/);
        @ports = uniq(@ports);
        print "module $modulename (".join(',',@ports).", so);\n";
        print "  output [31:0] imem_addr;\n";
        print "  output [31:0] dmem_addr;\n";
        print "  output [31:0] dmem_dataout;\n";
        print "  input [31:0] dmem_datain;\n";
        print "  input [31:0] imem_datain;\n";
        print "  input clk, rst, si, se;\n";
        print "  output memrw, so;\n";
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
            print "  wire $wire;\n";
        }
    } else {
        if ($inwires == 1) {
            $inwires = 2;
            foreach $vec (keys %maxind)
            {
	            print "  wire $vec\[$maxind{$vec}:$minind{$vec}\];\n";
            }
            print "assign so = imem_addr[31];"; # HAL bug
        }
        s/\\(\w+)\((\d+)\)/$1\[$2\]/g;
        print;
    }
}
