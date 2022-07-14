DESIGN = "rv_top"
numcopies = 10
numchanges = 1
use_infl = True

import sys, os
os.getcwd()
# some necessary configuration:
HAL_BASE = "hal/build/"
os.environ["HAL_BASE_PATH"] = HAL_BASE
sys.path.append(HAL_BASE+"lib/")  # this is where your hal python lib is located
sys.path.append("../Subcircuit_recognition/src")

hdl_file_path = DESIGN+".g.v"
# Doesn't work with the original .lib, need the internal one.
gate_library_path = "hal/build/share/hal/gate_libraries/NanGate_15nm_OCL.hgl"
#gate_library_path = "NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NanGate_15nm_OCL_functional.lib"


import hal_py
from hal_py import GateLibraryManager
from hal_plugins import boolean_influence
import random
hal_py.plugin_manager.load_all_plugins()
inflpl = hal_py.plugin_manager.get_plugin_instance("boolean_influence")

from api.circuits import Circuit
from api.components import NetlistReader
from graphProcessing import HALNetlistQueriesService
from graphProcessing import FullNetlistNoiseGenerator
from graphProcessing import DependencyFrameGenerator


circuit = Circuit()
circuit.hdl_file = hdl_file_path
circuit.netlist = HALNetlistQueriesService.gerenate_netlist(hdl_file_path, gate_library_path)
matrix_id_to_gate, matrix = inflpl.get_ff_dependency_matrix(circuit.netlist, False)
#matrix_id_to_gate, matrix = hal_py.NetlistUtils.get_ff_dependency_matrix(circuit.netlist)
if use_infl:
    matrix_id_to_gate, inflmatrix = inflpl.get_ff_dependency_matrix(circuit.netlist, True)
    tinflmatrix = [[int(inflmatrix[i][j] > 0) for j in range(len(inflmatrix[i]))]
            for i in range(len(inflmatrix))]

hal_py.NetlistWriterManager.write(circuit.netlist, DESIGN+".orig.g.v")

for cpy in range(numcopies):
    new_netlist = FullNetlistNoiseGenerator.generate_full_netlist_noise(circuit.netlist,
            gate_library_path, numchanges, False)
    new_netlist.set_design_name(DESIGN+str(cpy))
    new_netlist.get_top_module().set_type(DESIGN+str(cpy))
    newmatrix_id_to_gate, newmatrix = inflpl.get_ff_dependency_matrix(new_netlist, False)
    GED = sum([sum([matrix[i][j]!=newmatrix[i][j] for j in range(len(matrix[i]))])
            for i in range(len(newmatrix))])
    print(str(cpy) + ": GED=" + str(GED))
    if use_infl:
        matrix_id_to_gate, newinflmatrix = inflpl.get_ff_dependency_matrix(new_netlist, True)
        newtinflmatrix = [[int(newinflmatrix[i][j] > 0) for j in range(len(newinflmatrix[i]))]
                for i in range(len(newinflmatrix))]
        GED = sum([sum([matrix[i][j]!=newtinflmatrix[i][j] for j in
                    range(len(matrix[i]))]) for i in range(len(matrix))])
        GED_Excl = sum([sum([matrix[i][j]<newtinflmatrix[i][j] for j in
                    range(len(matrix[i]))]) for i in range(len(matrix))])
        print(str(cpy) + ": Infl GED=" + str(GED))
        print(str(cpy) + ": Infl GED exclusive=" + str(GED_Excl))
    hal_py.NetlistWriterManager.write(new_netlist, DESIGN+"."+str(cpy)+".g.v")

