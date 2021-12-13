`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:27:00
// Design Name: 
// Module Name: RegGroup
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


module RegGroup(
        input CLK,
        input [4:0] inReg1,
        input [4:0] inReg2,
        input [31:0] WriteData,
        input [4:0] WriteReg,
        input RegWre,
        input ALURegWre,
        output reg[31:0] outData1,
        output reg[31:0] outData2
    );
    initial begin
        outData1 <= 0;
        outData2 <= 0;
    end
    reg [31:0] regGroup[0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i+ 1) regGroup[i] <= 0;  
    end
    always@(WriteReg or WriteData or inReg1 or inReg2) 
    begin
        outData1 = regGroup[inReg1];
        outData2 = regGroup[inReg2];
        if(inReg2 == 5'b10111)
                begin
                    $display("reg is %h, Regdata is %h\n",inReg2,outData2);
                end
    end
    always@(negedge CLK)
    begin
        if(RegWre & ALURegWre)
            begin
                regGroup[WriteReg] = WriteData;
                if(WriteReg == 5'b10111)
                    begin
                        $display("WriteData is %h, WriteReg is %h\n",WriteData,WriteReg);
                    end
            end
    end
endmodule
