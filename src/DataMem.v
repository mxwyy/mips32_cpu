`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:31:12
// Design Name: 
// Module Name: DataMem
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


module DataMem(
        input mRD,
        input mWR,
        input CLK,
        input sign,
        input [1:0] bitWid,
        input [31:0] DAddr,
        input [31:0] DataIn,
        output reg[31:0] DataOut
    );
    
    reg [7:0] ram [0:127];
    initial begin 
        DataOut <= 32'b0;
        begin
           $readmemb("ram.mem", ram,0);
        end
    end
    
    always@(mRD or DAddr or bitWid or sign)
    begin
       if(mRD)  
       begin
         if(bitWid == 2'b00) //word
            begin
               // $display("DAddr is %b\n",DAddr);
                DataOut[7:0] = ram[DAddr + 3];
                DataOut[15:8] = ram[DAddr + 2];     
                DataOut[23:16] = ram[DAddr + 1];     
                DataOut[31:24] = ram[DAddr];
            end
        else if(bitWid == 2'b01) //half word
            begin
                DataOut[7:0] = ram[DAddr + 1];
                DataOut[15:8] = ram[DAddr];   
                DataOut[31:16] = (sign & ram[DAddr][7]) ? 16'b1111111111111111 : 16'b0000000000000000;
            end
        else if(bitWid == 2'b10) // byte
            begin
                DataOut[7:0] = ram[DAddr];
                DataOut[31:8] = (sign & ram[DAddr][7]) ? 24'b1111111111111111111111111 : 24'b000000000000000000000000;
            end
        end
        //$display("DAtaout is  %h\n",DataOut);
    end
     
    always@(negedge CLK)
    begin   
        if(mWR)
            begin
                if(bitWid == 2'b00) //word write
                    begin
                        ram[DAddr] = DataIn[31:24];    
                        ram[DAddr + 1] = DataIn[23:16];
                        ram[DAddr + 2] = DataIn[15:8];     
                        ram[DAddr + 3] = DataIn[7:0];
                    end
                else if(bitWid == 2'b01) //half word write
                    begin
                        ram[DAddr] = DataIn[15:8];
                        ram[DAddr + 1] = DataIn[7:0];
                    end
                else if(bitWid == 2'b10) //byte write
                    begin
                        ram[DAddr] = DataIn[7:0];
                    end
            end
    end
endmodule
