`timescale 1ns / 1ps

module fpga_top_tb;

  logic SYS_CLK = 0;
  logic BTN0;
  logic LD0;

  fpga_top fpga_top_i (
      .SYS_CLK(SYS_CLK),
      .BTN0(BTN0),
      .LD0(LD0)
  );

  always #4 SYS_CLK = ~SYS_CLK;  // 125MHz


  initial begin
    BTN0 = 1'b0;
    for (int i = 0; i < 100; i++) begin
        @(posedge SYS_CLK);
    end
    BTN0 = 1'b1;
  end

endmodule
