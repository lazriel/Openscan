DESIGN = "rv_top"
numcopies = 10
numchanges = 5

import sys, os
# some necessary configuration:
HAL_BASE = "/home/leonida/HAL/hal2/hal/build/"
os.environ["HAL_BASE_PATH"] = HAL_BASE
sys.path.append(HAL_BASE+"lib/")  # this is where your hal python lib is located

hdl_file_path = "/home/leonida/openscan/"+DESIGN+".g.v"
gate_library_path = "/home/leonida/openscan/NanGate_15nm_OCL_v0.1_2014_06_Apache.A/front_end/timing_power_noise/NanGate_15nm_OCL_functional.lib"


import hal_py
from hal_py import GateLibraryManager
from hal_plugins import boolean_influence
import random
hal_py.plugin_manager.load_all_plugins()

from api.circuits import Circuit
from api.components import NetlistReader
from graphProcessing import HALNetlistQueriesService
from graphProcessing import FullNetlistNoiseGenerator


circuit = Circuit()
circuit.hdl_file = hdl_file_path
circuit.netlist = HALNetlistQueriesService.gerenate_netlist(hdl_file_path, gate_library_path)

for j in range(numcopies):
    new_netlist = FullNetlistNoiseGenerator.generate_full_netlist_noise(circuit.netlist, gate_library_path, numchanges)
    new_netlist.set_design_name(DESIGN+str(j))
    new_netlist.get_top_module().set_type(DESIGN+str(j))
    hal_py.NetlistWriterManager.write(new_netlist, DESIGN+"."+str(j)+".g.v")

