# Openscan
Framework for running benchmark for the Openscan concept

This project includes submodules. Don't forget to fetch them after cloning:
- `git submodule init && git submodule update`

Includes several stages:
1. Synthesis and scan inserton with Synopsys DC
2. ATPG with Synopsys TetraMax
3. Deviated netlists creation with HAL
4. Applying scan vector simulation to the deviated netlists

At the beginning, create the work directory
- `mkdir work && cd work`

## Prerequisites
* Obtain the free for academic use 15nm Nangate gate library (or modify the scripts to use your own)
    - To work with the given scripts, put/link the root dir of the library in work/
* Synopsys DC and TetraMax licenses
* HAL installation (see below)


## Synthesis and scan insertion
Modify the scripts for the specific benchmark
- `dc_shell -f ../syn/dft.tcl`

## ATPG
Modify the scripts for the specific benchmark
- `tmax -shell ../syn/tmax.tcl`

## Deviated netlists creation
**Note: this stage can run on Ubuntu or MacOS only** If your Synopsys tools require another OS, need to move interim files around between the OS's.
The deviations are created by random gate insertions/deletions and wire rerouting.
Done using the HAL framework: https://github.com/emsec/hal/
- `git clone git@github.com:emsec/hal.git`
Use the instructions in the repository to build HAL. Use the `-DPL_BOOLEAN_INFLUENCE=1` flag in cmake.
- `python ../hal/random_netlist_noise.py`

HAL outputs slighly different netlist format. To return to the original format, use the following script after making the relevant modifications for your neltist
- `../hal/importfromhal.pl <TOP>.<NUM>.g.v > <NEWNAME>`

## Simulation
(Using Xcellium for example)
- `xrun -timescale 1ns/10ps <TOP>_sa_tb.v -v NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/verilog/NanGate_15nm_OCL_functional.v <TOP>.g.v`

