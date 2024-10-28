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


module controller(clk, cs, we, address, data_in, data_out, CODE, sw, led, DVR, mem_buf, cntrl_buf);
input clk;
output cs;
output we;
output reg [6:0] address;
input[7:0] data_in;
output reg [7:0] data_out;
input[3:0] CODE;
input[7:0] sw;
output[7:0] led;
output [7:0] DVR;
output mem_buf;
output cntrl_buf;
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
localparam IN_AND_OUT = 4'b0001;
localparam PUSH = 4'b0010;
localparam POP = 4'b0011;
localparam ADD_1 = 4'b0100;
localparam ADD_2 = 4'b0101;
localparam ADD_3 = 4'b0110;
localparam SUB_1 = 4'b0111;
localparam SUB_2 = 4'b1000;
localparam SUB_3 = 4'b1001;
localparam TOP = 4'b1010;
localparam CLR = 4'b1011;
localparam INC = 4'b1100;
localparam DEC = 4'b1101;
localparam DVR_WRITE = 4'b1110; // State 8?
///////Internal Registers/////////////////////
reg [3:0] cur_state = WAIT_S;
reg [3:0] next_state = WAIT_S;
reg [6:0] SPR = 7'h7F;  // Stack Pointer Register
reg [6:0] DAR = 7'h00;  // Display Address Register
reg [7:0] DVR = 8'h00;  // Display Value Register
reg [7:0] op1;          // Operand 1
reg [7:0] op2;          // Operand 2

reg [3:0] ret_n;        // Return address register

///////Internal Control Signals///////////////
reg sub_r;
reg cntrl_buf; // Maybe not
reg mem_buf; // Maybe not 
reg we_reg; 
reg cs_reg;



//////////////////////////////////////////////

initial begin
    cur_state = WAIT_S;
    next_state = WAIT_S;
    SPR = 7'h7F;  // Stack Pointer Register
    DAR = 7'h00;  // Display Address Register
    DVR = 8'h00;  // Display Value Register
end



assign led[7] = (SPR == 7'h7F);
assign led[6:0] = DAR;
assign cs = cs_reg;
assign we = we_reg;

always @(posedge clk)begin
    // Next State Assignment
    case(cur_state)
        WAIT_S : begin
            sub_r <= 0;
            we_reg <= 0;
            cs_reg <= 0;
            cntrl_buf <= 0;
            mem_buf <= 0;
            ret_n <= 0;
        
            // NS 
            case(CODE)
                INVALID_CMD : 
                    next_state <= WAIT_S;
                PUSH_CMD:
                    next_state <= PUSH;
                POP_CMD:
                    next_state <= POP;
                ADD_CMD :
                    next_state <= ADD_1;
                SUB_CMD :
                    next_state <= SUB_1;
                TOP_CMD : 
                    next_state <= TOP;
                CLR_CMD :
                    next_state <= CLR;
                INC_CMD :
                    next_state <= INC;
                DEC_CMD :
                    next_state <= DEC;
                default : 
                    next_state <= WAIT_S;
            endcase
        end
        PUSH : begin
            we_reg <= 1;
            cs_reg <= 1;
            mem_buf <= 0;
            cntrl_buf <= 1;
        
            address <= SPR - 1;
            SPR <= SPR - 1;
            DAR <= SPR - 1;
            
            DVR <= sub_r ? data_out : sw;
            data_out <= sub_r ? data_out : sw;
            
            // NS
            next_state <= WAIT_S;
        end
        POP : begin
            we_reg <= 0;
            cs_reg <= 0;
            mem_buf <= 1;
            cntrl_buf <= 0;
            
            address <= sub_r ? SPR : SPR + 1;
            SPR <= SPR + 1;
            DAR <= SPR + 1;
            
            
            // NS
            next_state <= sub_r ? ret_n : DVR_WRITE;
            
        end
        ADD_1 : begin
            sub_r <= 1;
            
            // NS
            next_state <= POP;
            ret_n <= ADD_2;
        end
        ADD_2 : begin
            sub_r <= 1;
            op1 <= data_in;
            
            // NS
            next_state <= POP;
            ret_n <= ADD_3;
        end
        ADD_3 : begin
            sub_r <= 1;
            op2 <= data_in;
            data_out <= op1 + data_in;
            
            
            //NS
            next_state <= PUSH;
            ret_n <= WAIT_S;
        end
        SUB_1 : begin
            sub_r <= 1;
            
            //NS
            next_state <= POP;
            ret_n <= SUB_2;
        end
        SUB_2 : begin
            sub_r <= 1;
            op1 <= data_in;
            
            //NS
            next_state <= POP;
            ret_n <= SUB_3;
        end
        SUB_3 : begin
            sub_r <= 1;
            op2 <= data_in;
            data_out <= op1 - data_in;
            
            // NS
            next_state <= PUSH;
            ret_n <= WAIT_S;
        end
        TOP : begin
        //TODO
            DAR <= SPR;
            address <= SPR;
            mem_buf <= 1;
            cntrl_buf <= 0;
            // NS
            next_state <= DVR_WRITE;
        end
        CLR : begin
            SPR <= 8'h7F;
            DAR <= 8'h00;
            DVR <= 8'h00;
            
            next_state <= WAIT_S;
        end
        INC : begin
            DAR <= DAR - 1;
            address <= DAR - 1;
            mem_buf <= 1;
            cntrl_buf <= 0;
            // NS
            next_state <= DVR_WRITE;
        end
        DEC : begin
            DAR <= DAR + 1;
            address <= DAR + 1;
            mem_buf <= 1;
            cntrl_buf <= 0;
            // NS
            next_state <= DVR_WRITE;
        end
        DVR_WRITE : begin
            DVR <= data_in;
            sub_r <= 0;
            mem_buf <= 0;
            cntrl_buf <= 0;
            // NS
            next_state <= WAIT_S;    // Return to specifed state
        end
        
        default : begin
            next_state <= WAIT_S;
        end
        
        endcase
        
        
    // State Control Signal Modification
end


always @(negedge clk)begin
    cur_state <= next_state;
end

endmodule
