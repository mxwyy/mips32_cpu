`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:15:44
// Design Name: 
// Module Name: PC
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


module PC(
       input CLK,
       input Reset,
       input PCWre,
       input [31:0] nextPC,
       output reg[31:0] curPC
    );
    
    initial begin
        curPC <= 0;
    end

    always@(posedge CLK)
    begin
        if(!Reset)
            begin
                curPC <= 0;
            end
        else 
            /*begin
                if(PCWre)*/
                    begin
                        curPC <= nextPC;
                    end
               /* else
                    begin
                        curPC <= curPC;
                    end*
            end*/
        $display("curPC is\n",curPC);
    end
endmodule
