`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/20 15:31:19
// Design Name: 
// Module Name: HILO
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


module HILO(
    input CLK,
    input [1:0]HILOWre,
    input [31:0]inHIData,
    input [31:0]inLOData,
    output reg[31:0]outHIData,
    output reg[31:0]outLOData
    );
    
    initial begin
            outHIData <= 0;
            outLOData <= 0;
    end
        
    /*reg [31:0] HI;
    reg [31:0] LO;*/
            
    /*always@(inHIData or inLOData)
    begin
        outHIData = HI;
        outLOData = LO;
    end*/
    
    //always@(inLOData or HILOWre)
    always@(negedge CLK)
    begin
    if(HILOWre[1])
    begin
        outHIData = inHIData;
    end
    if(HILOWre[0])
    begin
        outLOData = inLOData;
    end
        /*if(HILOWre)
        begin
            HI = inHIData;
            LO = inLOData;
        end */
    end
endmodule
