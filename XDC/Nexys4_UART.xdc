#General properties
set_property IOSTANDARD LVCMOS33 [get_ports]
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

#Clock signal
set_property PACKAGE_PIN E3 [get_ports CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]

# USB-RS232 Interface
set_property PACKAGE_PIN C4 [get_ports RX]
set_property PACKAGE_PIN D4 [get_ports TX]