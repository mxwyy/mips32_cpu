`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:22:30
// Design Name: 
// Module Name: PCNext
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


module PCNext(
        input Reset,
        //input CLK,
        input [1:0] PCSel,
        input [31:0] immediate,
        input [25:0] addr,
        input [31:0] curPC,
        input [31:0] alPC,
        output reg[31:0] nextPC
    );
    
    initial begin
        nextPC <= 0;
    end
    
    reg [31:0] pc;
    
    //always@(negedge CLK or negedge Reset)
    always@(*)
    begin
        if(!Reset) begin
            nextPC <= 0;
        end
        else begin
            pc <= curPC + 4;
            case(PCSel)
                2'b00: nextPC <= curPC + 4;
                2'b01: nextPC <= {pc[31:28],addr,2'b00};
                2'b10: nextPC <= curPC + 4 + immediate * 4;
                2'b11: nextPC <= alPC;
            endcase
        end
    end
endmodule
