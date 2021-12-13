`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/21 08:21:12
// Design Name: 
// Module Name: mux4
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


module mux4(
    input [1:0]DBSel,
    input [31:0]result,
    input [31:0]DataOut,
    input [31:0]PC,
    output reg[31:0]DB
    );
    
    //always@(DBsel or result or DataOut or PC)
    always @(*) 
    begin
        case(DBSel)  
            2'b00:DB = result;
            2'b01:begin
                DB = DataOut;
                //$display("Dataout is %h, PC is %h\n",DataOut,PC);
                end
            2'b10:DB = PC + 8;
       endcase
    end
endmodule
