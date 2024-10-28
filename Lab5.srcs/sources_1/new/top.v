`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 12:29:40 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(clk, btnU, btnR, btnL, btnD, sw, led, seg, an);
input clk;
input btnU, btnR, btnL, btnD;
input[7:0] sw;
output[7:0] led;

output[6:0] seg;
output[3:0] an;
//might need to change some of these from wires to regs
wire cs;
wire we;
wire[6:0] addr;
wire[7:0] data_out_mem;
wire[7:0] data_out_ctrl;
wire[7:0] data_bus;

// Us defined
wire mem_buf;
wire cntrl_buf;
wire [3:0] CODE;
wire [7:0] dsw;

wire [7:0] exposed_DVR;
wire [3:0] thou;
wire [3:0] hundreds;
wire [3:0] tens;
wire [3:0] ones;

//CHANGE THESE TWO LINES
//assign data_bus = 1; // 1st driver of the data bus -- tri state switches
//// function of we and data_out_ctrl
//assign data_bus = 1; // 2nd driver of the data bus -- tri state switches
//// function of we and data_out_mem
wire slow_clk;
// clk div --> 50mhz
clkdiv div(clk,slow_clk);


assign data_bus = mem_buf ? data_out_mem :
                 cntrl_buf ? data_out_ctrl : 8'hZZ;
                 
Input_Handler in(slow_clk, btnU, btnR, btnL, btnD, sw, CODE, dsw); 


controller ctrl(slow_clk, cs, we, addr, data_bus, data_out_ctrl,
    CODE, sw, led, exposed_DVR, mem_buf, cntrl_buf);

memory mem(slow_clk, cs, we, addr, data_bus, data_out_mem);
//add any other functions you need
//(e.g. debouncing, multiplexing, clock-division, etc)

Display_Controller(slow_clk, exposed_DVR, seg, an);

endmodule
