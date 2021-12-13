`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:20:29
// Design Name: 
// Module Name: InsMem
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


module InsMem(
        input [31:0] IAddr,
        input InsMemR,
        output reg[31:0] IDataOut
    );
    
    reg [7:0] rom[1024:0];
    initial 
    begin
       $readmemb("rom.mem", rom);
    end
    always@(IAddr or InsMemR)
    begin
        if(InsMemR)
            begin
                IDataOut[7:0] = rom[IAddr + 3];
                IDataOut[15:8] = rom[IAddr + 2];
                IDataOut[23:16] = rom[IAddr + 1];
                IDataOut[31:24] = rom[IAddr];
            end 
    end 
endmodule
