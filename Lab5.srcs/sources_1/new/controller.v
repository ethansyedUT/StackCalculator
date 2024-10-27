`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/25/2024 12:30:24 AM
// Design Name: 
// Module Name: controller
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


module controller(clk, cs, we, address, data_in, data_out, btns, swtchs, leds, segs, an);
input clk;
output cs;
output we;
output[6:0] address;
input[7:0] data_in;
output[7:0] data_out;
input[3:0] btns;
input[7:0] swtchs;
output[7:0] leds;
output[6:0] segs;
output[3:0] an;
//WRITE THE FUNCTION OF THE CONTROLLER

///////CMD Definitions /////////////////////
localparam PUSH_CMD = 4'b0000;
localparam POP_CMD = 4'b0001;
localparam ADD_CMD = 4'b0010;
localparam SUB_CMD = 4'b0011;
localparam TOP_CMD = 4'b0100;
localparam CLR_CMD = 4'b0101;
localparam INC_CMD = 4'b0110;
localparam DEC_CMD = 4'b0111;

localparam INVALID_CMD = 4'b1000;

///////State Definitions /////////////////////
localparam WAIT_S = 4'b0000;

///////Internal Registers/////////////////////
reg [3:0] cur_state;
reg [3:0] next_state;


///////Internal Control Signals///////////////
reg sub_r;

//////////////////////////////////////////////


always @(*)begin

end


always @(posedge clk)begin

    

end

endmodule
