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
//   ___\:::\   \:::\    \          Description : FPGA Top Testbench for External Signal Synchronization Lab
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
