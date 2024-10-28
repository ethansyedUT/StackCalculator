`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 07:41:01 PM
// Design Name: 
// Module Name: input_handler
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

module Input_Handler(
    input wire clk, btnU, btnR, btnL, btnD,
    input wire [7:0] sw,
    output reg [3:0] CODE,
    output reg [7:0] dsw
);
    // Debounce instances for each button
    debounce u_debounce_U(btnU, clk, dbtnU);
    debounce u_debounce_R(btnR, clk, dbtnR);
    debounce u_debounce_L(btnL, clk, dbtnL);
    debounce u_debounce_D(btnD, clk, dbtnD);

    wire [3:0] concat;
    assign concat = {dbtnU, dbtnL, dbtnD, dbtnR};
    
    initial begin
        CODE <= 4'b1000;
    end

    // Switch handling
    always @(posedge clk) begin
        dsw <= sw;
        case (concat) 
            4'b0001 : begin // Push
                CODE <= 4'b0000;
            end
            4'b0010 : begin // Pop
                CODE <= 4'b0001;
            end
            4'b0101 : begin // Add
                CODE <= 4'b0010;
            end
            4'b0110 : begin // Sub
                CODE <= 4'b0011;
            end
            4'b1001 : begin // Top
                CODE <= 4'b0100;
            end
            4'b1010 : begin // CLR
                CODE <= 4'b0101;
            end
            4'b1101 : begin // INC
                CODE <= 4'b0110;
            end
            4'b1110 : begin // DEC
                CODE <= 4'b0111;
            end
            default : begin
                CODE <= 4'b1000; // INVALID STATE
            end
        endcase 

    end

endmodule

// Debounce module
module debounce(
    input wire pb_1, clk,
    output wire pb_out
);
    wire Q1, Q2, Q2_bar, Q0;

    my_dff d0(clk, pb_1, Q0);
    my_dff d1(clk, Q0, Q1);
    my_dff d2(clk, Q1, Q2);

    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;
endmodule

// D-flip-flop for debouncing module 
module my_dff(
    input wire DFF_CLOCK, D,
    output reg Q
);
    always @(posedge DFF_CLOCK) begin
        Q <= D;
    end
endmodule