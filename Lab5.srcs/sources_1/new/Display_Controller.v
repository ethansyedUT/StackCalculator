`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:21:47 PM
// Design Name: 
// Module Name: Display_Controller
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


module Display_Controller(
    input wire clk,
    input wire [7:0] num,    // 8-bit input can represent 00 to FF
    output reg [6:0] seg,
    output reg [3:0] an
    );
    
    reg [1:0] digit_select;
    reg [16:0] refresh_counter;
    wire [3:0] high_digit, low_digit;  // Split input into two 4-bit values
    
    // Split the 8-bit input into two 4-bit values for hex digits
    assign high_digit = num[7:4];  // Most significant digit
    assign low_digit = num[3:0];   // Least significant digit
    
    // Counter for display refresh
    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        if (refresh_counter == 0) begin
            digit_select <= digit_select + 1;
        end
    end
    
    // Display multiplexing logic
    always @(*) begin
        case (digit_select)
            2'b00: begin  // Right digit
                an = 4'b1110;
                seg = seven_segment_encoder(low_digit);
            end
            2'b01: begin  // Left digit
                an = 4'b1101;
                seg = seven_segment_encoder(high_digit);
            end
            2'b10: begin
                an = 4'b1111;
                seg = 7'b1111111;  // All segments off
            end
            2'b11: begin
                an = 4'b1111;
                seg = 7'b1111111;  // All segments off
            end
        endcase
    end
    
    // Extended seven-segment encoder function to support hex values A-F
    function [6:0] seven_segment_encoder;
        input [3:0] hex;
        begin
            case (hex)
                4'h0: seven_segment_encoder = 7'b1000000;  // 0
                4'h1: seven_segment_encoder = 7'b1111001;  // 1
                4'h2: seven_segment_encoder = 7'b0100100;  // 2
                4'h3: seven_segment_encoder = 7'b0110000;  // 3
                4'h4: seven_segment_encoder = 7'b0011001;  // 4
                4'h5: seven_segment_encoder = 7'b0010010;  // 5
                4'h6: seven_segment_encoder = 7'b0000010;  // 6
                4'h7: seven_segment_encoder = 7'b1111000;  // 7
                4'h8: seven_segment_encoder = 7'b0000000;  // 8
                4'h9: seven_segment_encoder = 7'b0010000;  // 9
                4'ha: seven_segment_encoder = 7'b0001000;  // A
                4'hb: seven_segment_encoder = 7'b0000011;  // b
                4'hc: seven_segment_encoder = 7'b1000110;  // C
                4'hd: seven_segment_encoder = 7'b0100001;  // d
                4'he: seven_segment_encoder = 7'b0000110;  // E
                4'hf: seven_segment_encoder = 7'b0001110;  // F
                default: seven_segment_encoder = 7'b1111111; // All segments off
            endcase
        end
    endfunction
    
endmodule
