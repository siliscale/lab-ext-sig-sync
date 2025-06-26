## Clock Signal
set_property -dict { PACKAGE_PIN H16    IOSTANDARD LVCMOS33 } [get_ports { SYS_CLK }]; #IO_L13P_T2_MRCC_35 Sch=SYSCLK - 125MHz
create_clock -add -name SYS_CLK_PIN -period 8.00 -waveform {0 4} [get_ports { SYS_CLK }];

set_property -dict { PACKAGE_PIN R14    IOSTANDARD LVCMOS33 } [get_ports { LD0 }]; #IO_L6N_T0_VREF_34 Sch=LED0
set_property -dict { PACKAGE_PIN D19    IOSTANDARD LVCMOS33 } [get_ports { BTN0 }]; #IO_L4P_T0_35 Sch=BTN0