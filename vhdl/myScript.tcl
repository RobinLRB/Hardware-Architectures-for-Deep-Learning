
source synopsys_dc.setup

analyze -format vhdl -lib WORK { "./SOURCE/system_definition.vhd"}
analyze -format vhdl -lib WORK { "./SOURCE/ReLU_function.vhd"}
analyze -format vhdl -lib WORK { "./SOURCE/MAC_unit.vhd"}
analyze -format vhdl -lib WORK { "./SOURCE/neuron_fully_serial.vhd"}

elaborate neuron_fully_serial -architecture Behavioral -library DEFAULT



set_operating_conditions "NCCOM"
set_wire_load_mode top
set_wire_load_model -name "ZeroWireload"

create_clock -name "clk" -period 4 -waveform { 0 2 } { clk }

compile -map_effort medium 



report_constraints > ./REPORTS/constraints_1_MAC.rep 

report_cell > ./REPORTS/cell_1_MAC.rep 

report_area > ./REPORTS/area_1_MAC.rep 

report_timing > ./REPORTS/timing_1_MAC.rep
 
report_power -analysis_effort low > ./REPORTS/power_1_MAC.rep 