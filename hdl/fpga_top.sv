///////////////////////////////////////////////////////////////////////////////
//     Copyright (c) 2025 Siliscale Consulting, LLC
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
///////////////////////////////////////////////////////////////////////////////
//           _____          
//          /\    \         
//         /::\    \        
//        /::::\    \       
//       /::::::\    \      
//      /:::/\:::\    \     
//     /:::/__\:::\    \            Vendor      : Siliscale
//     \:::\   \:::\    \           Version     : 2025.1
//   ___\:::\   \:::\    \          Description : FPGA Top for External Signal Synchronization Lab
//  /\   \:::\   \:::\    \ 
// /::\   \:::\   \:::\____\
// \:::\   \:::\   \::/    /
//  \:::\   \:::\   \/____/ 
//   \:::\   \:::\    \     
//    \:::\   \:::\____\    
//     \:::\  /:::/    /    
//      \:::\/:::/    /     
//       \::::::/    /      
//        \::::/    /       
//         \::/    /        
//          \/____/         
///////////////////////////////////////////////////////////////////////////////


module fpga_top (
    input logic SYS_CLK,

    input  logic BTN0,
    output logic LD0

);

  logic clk_100mhz;
  logic rstn_100mhz;

  logic btn0_sync;

  clk_rst_subsys clk_rst_subsys_i (
      .SYS_CLK    (SYS_CLK),
      .clk_100mhz (clk_100mhz),
      .rstn_100mhz(rstn_100mhz)
  );

  logic ld0_i;

  /* Syncronyzer */

  cdc_sync #(
      .N(3),  /* Setting to 3 increases Mean-Time-Between-Failures (MTBF) */
      .WIDTH(1)
  ) cdc_sync_btn0_i (
      .clk (clk_100mhz),
      .din (BTN0),
      .dout(btn0_sync)
  );

  /* Debouncer */
  localparam DEBOUNCE_FLOPS = 100;

  logic [DEBOUNCE_FLOPS-1:0] btn0_debounced;

  genvar i;
  for (i = 0; i < DEBOUNCE_FLOPS; i++) begin : gen_debounce_flops
    if (i == 0) begin
      register_sync_rstn #(
          .WIDTH(1)
      ) register_sync_rstn_i (
          .clk (clk_100mhz),
          .rstn(rstn_100mhz),
          .din (btn0_sync),
          .dout(btn0_debounced[i])
      );
    end else begin
      register_sync_rstn #(
          .WIDTH(1)
      ) register_sync_rstn_i (
          .clk (clk_100mhz),
          .rstn(rstn_100mhz),
          .din (btn0_debounced[i-1]),
          .dout(btn0_debounced[i])
      );
    end
  end

  assign ld0_i = &btn0_debounced;

  OBUF obuf_ld0_i (
      .I(ld0_i),
      .O(LD0)
  );

endmodule
