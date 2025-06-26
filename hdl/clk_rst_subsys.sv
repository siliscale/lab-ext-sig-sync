module clk_rst_subsys (
    input  logic SYS_CLK,
    output logic clk_100mhz,
    output logic rstn_100mhz
);

  logic clk_125mhz_bufg_out;
  logic clkfbout_mmcm;
  logic locked_mmcm;
  logic clk_100mhz_mmcm;

  BUFG clk_125mhz_bufg_in_i (
      .O(clk_125mhz_bufg_out),
      .I(SYS_CLK)
  );

  /* 
    MMCME2_BASE Instance
    https://docs.amd.com/r/en-US/ug953-vivado-7series-libraries/MMCME2_BASE
    https://docs.amd.com/v/u/en-US/ug472_7Series_Clocking

    The following equations apply:
    1) Fvco = Fclk_in * CLKFBOUT_MULT_F/DIVCLK_DIVIDE
    2) Fclk_out = Fvco / CLKOUTx_DIVIDE

    When setting the VCO frequency, should be in the range specified in the datasheet of the part.
    The Maximum Clock Frequency depends on the speed grade of the part as well.

  */

  MMCME2_BASE #(

      .BANDWIDTH("OPTIMIZED"),  // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(8),  // Multiply value for all CLKOUT (2.000-64.000).
      .DIVCLK_DIVIDE(1),  // Master division value (1-106)
      .CLKFBOUT_PHASE(0.0),  // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(8.0),  // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).

      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT0_DIVIDE_F(10),  // 100 MHz
      .CLKOUT1_DIVIDE  (1),  // Unused
      .CLKOUT2_DIVIDE  (1),  // Unused
      .CLKOUT3_DIVIDE  (1),  // Unused
      .CLKOUT4_DIVIDE  (1),  // Unused
      .CLKOUT5_DIVIDE  (1),  // Unused
      .CLKOUT6_DIVIDE  (1),  // Unused

      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),

      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),

      .CLKOUT4_CASCADE("FALSE"),  // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .REF_JITTER1    (0.010),    // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT   ("FALSE")   // Delays DONE until MMCM is locked (FALSE, TRUE)

  ) MMCME2_BASE_i (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0  (clk_100mhz_mmcm),      // 1-bit output: CLKOUT0
      .CLKOUT0B (),                     // 1-bit output: Inverted CLKOUT0
      .CLKOUT1  (),                     // 1-bit output: CLKOUT1
      .CLKOUT1B (),                     // 1-bit output: Inverted CLKOUT1
      .CLKOUT2  (),                     // 1-bit output: CLKOUT2
      .CLKOUT2B (),                     // 1-bit output: Inverted CLKOUT2
      .CLKOUT3  (),                     // 1-bit output: CLKOUT3
      .CLKOUT3B (),                     // 1-bit output: Inverted CLKOUT3
      .CLKOUT4  (),                     // 1-bit output: CLKOUT4
      .CLKOUT5  (),                     // 1-bit output: CLKOUT5
      .CLKOUT6  (),                     // 1-bit output: CLKOUT6
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT (clkfbout_mmcm),        // 1-bit output: Feedback clock
      .CLKFBOUTB(),                     // 1-bit output: Inverted CLKFBOUT
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED   (locked_mmcm),          // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1   (clk_125mhz_bufg_out),  // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN   (1'b0),                 // 1-bit input: Power-down
      .RST      (1'b0),                 // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN  (clkfbout_mmcm)         // 1-bit input: Feedback clock
  );

  BUFG clk_100mhz_bufg_i (
      .O(clk_100mhz),
      .I(clk_100mhz_mmcm)
  );

  cdc_sync #(
      .N(2),
      .WIDTH(1)
  ) cdc_sync_locked_i (
      .clk (clk_100mhz),
      .din (locked_mmcm),
      .dout(rstn_100mhz)
  );




endmodule
