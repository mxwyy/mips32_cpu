`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 09:40:35
// Design Name: 
// Module Name: PCnext_tb
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


module PCnext_tb();
    reg Reset;
    reg CLK;
    reg [1:0] PCSel;
    wire [31:0] immediate;
    reg [25:0] addr;
    reg [31:0] curPC;
    wire [31:0] alPC;
    wire [31:0] nextPC;
    
    PCNext PCNext(.Reset(Reset),
                    .CLK(CLK),
                    .PCSel(PCSel),
                    .immediate(immediate),
                    .addr(addr),
                    .curPC(curPC),
                    .alPC(alPC),
                    .nextPC(nextPC));
    initial begin
        // Initialize Inputs
        PCSel = 2'b10;
        curPC = 0;
        addr = 26'b0000000000111110;
        CLK = 1;
        Reset = 0;

        CLK = !CLK;
        Reset = 1;
        forever #5
        begin
             CLK = !CLK;
        end
    end
endmodule
