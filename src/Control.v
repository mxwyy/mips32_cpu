`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:41:05
// Design Name: 
// Module Name: Control
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


module Control(
        input zero,
        input [1:0] neg,
        input [5:0] Opcode,
        input [5:0] func,
        input [4:0] brt,
        output reg PCWre,
        output reg ExtSel,
        output reg InsMemR,
        output reg sign,
        output reg mul,
        output reg RegDst,
        output reg RegWre,
        output reg SrcA,
        output reg SrcB,
        output reg [1:0]HILOWre,
        output reg [1:0]PCSel,
        output reg [4:0]Op,
        output reg mRD,
        output reg mWR,
        output reg [1:0]DBSel,
        output reg [1:0]bitWid        
    );
    
    initial begin
        InsMemR = 1;
        PCWre = 1;
        mRD = 0;
        mWR = 0;
        RegDst = 0;
        RegWre = 0;
        SrcA = 0;
        SrcB = 0;
        Op = 5'b00000;
        ExtSel = 0;
        PCSel = 2'b00;
        DBSel = 2'b00;
    end
    
    always@(Opcode or func or brt or zero or neg) 
    begin   
        mWR = (Opcode[5:2] == 4'b1010) ? 1 : 0;
        mRD = (Opcode == 6'b100011) ? 1 : 0;
        DBSel = 2'b00;
        PCSel = 2'b00;
        sign = 0;
        mul = 0;
		HILOWre = 2'b00;
		bitWid = 2'b00;
        
        case(Opcode)
            6'b000000: // R-type instruction
                case(func)
                    6'b100100: //and
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00010;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100101: //or
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00011;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100110: //xor
                        begin
                           RegDst = 1;
                           RegWre = 1;
                           SrcA = 0;
                           SrcB = 0;
                           Op = 5'b00100;
                           ExtSel = 0;
                           PCSel = 2'b00;
                       end 
                    6'b100111: //nor
                        begin
                          RegDst = 1;
                          RegWre = 1;
                          SrcA = 0;
                          SrcB = 0;
                          Op = 5'b00101;
                          ExtSel = 0;
                          PCSel = 2'b00;
                      end
                    6'b000000: //sll
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 1;
                            SrcB = 0;
                            Op = 5'b00111;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000010: //srl
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 1;
                            SrcB = 0;
                            Op = 5'b01000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000011: //sra
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 1;
                            SrcB = 0;
                            Op = 5'b01001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000100: //sllv
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00111;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000110: //srlv
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000111: //srav
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b001011://movn
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01101;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b001010://movz
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01101;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b010000://mfhi
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b010010://mflo
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b010001://mthi
                        begin
                            HILOWre = 2'b10;
                            RegDst = 1;
                            RegWre = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10010;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b010011://mtlo
                        begin
                            HILOWre = 2'b01;
                            RegDst = 1;
                            RegWre = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10010;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100000: //add
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100001: //addu
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100010: //sub
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b100011: //subu
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b101010: //slt
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01100;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b101011: //sltu
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01100;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    /*555555555555555555555*/
                    6'b011000: //mult
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 1;
                            mul = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01111;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b011001: //multu
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 0;
                            mul = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01111;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b011010: //div
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 1;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b011011: //divu
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10000;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b001000: //jr
                        begin
                            RegDst = 1;
                            RegWre = 0;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10010;
                            ExtSel = 0;
                            PCSel = 2'b11;
                        end
                    6'b001001: //jalr
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b10010;  //any opcode which could make result = A is Ok
                            ExtSel = 0;
                            DBSel = 2'b10;
                            PCSel = 2'b11;
                        end
                endcase
            6'b001100: //andi
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b00010;
                    ExtSel = 0;
                    PCSel = 2'b00;
                end
            6'b001101: //ori
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b00011;
                    ExtSel = 0;
                    PCSel = 2'b00;
                end
            6'b001110: //xori
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b00100;
                    ExtSel = 0;
                    PCSel = 2'b00;
                end
                /*55555555555555555*/
            6'b001111: //lui
               begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b01011;
                    ExtSel = 0;
                    PCSel = 2'b00;
                end
            6'b001000: //addi
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 1;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b00000;
                    ExtSel = 1;
                    PCSel = 2'b00;
                end
            6'b001001: //addiu
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 1;
                    Op = 5'b00000;
                    ExtSel = 1;
                    PCSel = 2'b00;
                end
             6'b001010: //slti
               begin
                  RegDst = 0;
                  RegWre = 1;
                  sign = 1;
                  SrcA = 0;
                  SrcB = 1;
                  Op = 5'b01100;
                  ExtSel = 1;
                  PCSel = 2'b00;
               end
           6'b001011: //sltiu
               begin
                  RegDst = 0;
                  RegWre = 1;
                  sign = 0;
                  SrcA = 0;
                  SrcB = 1;
                  Op = 5'b01100;
                  ExtSel = 1;
                  PCSel = 2'b00;
               end    
                /*5555555555555555555555*/
            6'b011100:
                case(func)
                    6'b100000: //clz
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01110;
                            ExtSel = 1;
                            PCSel = 2'b00;
                        end    
                    6'b100001: //clo
                        begin
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01110;
                            ExtSel = 1;
                            PCSel = 2'b00;
                        end
                    6'b000010: //mul
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 1;
                            sign = 1;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b01111;
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000000: //madd
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 1;
                            mul = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00000; //add
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000001: //maddu
                         begin
                               HILOWre = 2'b11;
                               RegDst = 1;
                               RegWre = 0;
                               sign = 0;
                               mul = 1;
                               SrcA = 0;
                               SrcB = 0;
                               Op = 5'b00000; //add
                               ExtSel = 0;
                               PCSel = 2'b00;
                           end
                    6'b000100: //msub
                        begin
                            HILOWre = 2'b11;
                            RegDst = 1;
                            RegWre = 0;
                            sign = 1;
                            mul = 1;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001; //sub
                            ExtSel = 0;
                            PCSel = 2'b00;
                        end
                    6'b000101: //msub
                        begin
                           HILOWre = 2'b11;
                           RegDst = 1;
                           RegWre = 0;
                           sign = 0;
                           mul = 1;
                           SrcA = 0;
                           SrcB = 0;
                           Op = 5'b00001; //sub
                           ExtSel = 0;
                           PCSel = 2'b00;
                       end
                endcase
            6'b000010: //j
                begin
                    RegDst = 0;
                    RegWre = 0;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00000;
                    ExtSel = 0;
                    PCSel = 2'b01;
                end
            6'b000011: //jal
                begin
                    RegDst = 0;
                    RegWre = 1;
                    sign = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00000;  // any opcode is ok
                    ExtSel = 0;
                    PCSel = 2'b01;
                    DBSel = 2'b10;
                end
            6'b000100: //b & beq
                begin
                    RegDst = 1;
                    RegWre = 0;
                    sign = 0;
                    mul = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00001;
                    ExtSel = 0;
                    PCSel = zero ? 2'b10:2'b00;
                end
            6'b000101: //bne
                begin
                    RegDst = 1;
                    RegWre = 0;
                    sign = 0;
                    mul = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00001;
                    ExtSel = 0;
                    PCSel = zero ? 2'b00:2'b10;
                end
            6'b000110: //blez
                begin
                    RegDst = 1;
                    RegWre = 0;
                    sign = 0;
                    mul = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00001; // any opcode is ok
                    ExtSel = 0;
                    PCSel = neg[1] ? 2'b10:2'b00;
                end
            6'b000111: //bgtz
                begin
                    RegDst = 1;
                    RegWre = 0;
                    sign = 0;
                    mul = 0;
                    SrcA = 0;
                    SrcB = 0;
                    Op = 5'b00001; // any opcode is ok
                    ExtSel = 0;
                    PCSel = neg[1] ? 2'b00:2'b10;
                end
            6'b000001:
                case(brt)
                    5'b00000: //bltz
                        begin
                            RegDst = 1;
                            RegWre = 0;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001; // any opcode is ok
                            ExtSel = 0;
                            PCSel = neg[0] ? 2'b10:2'b00;
                        end
                    5'b00001: //bgez
                        begin
                            RegDst = 1;
                            RegWre = 0;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001; // any opcode is ok
                            ExtSel = 0;
                            PCSel = neg[0] ? 2'b00:2'b10;
                        end
                    5'b10000: //bltzal
                        begin
                            RegDst = 1;
                            RegWre = neg[0] ? 1 : 0;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001; // any opcode is ok
                            ExtSel = 0;
                            PCSel = neg[0] ? 2'b10:2'b00;
                            DBSel = neg[0] ? 2'b10:2'b00;
                        end
                    5'b10001: //bal & bgezal
                        begin
                            RegDst = 1;
                            RegWre = neg[0] ? 0 : 1;
                            sign = 0;
                            mul = 0;
                            SrcA = 0;
                            SrcB = 0;
                            Op = 5'b00001; // any opcode is ok
                            ExtSel = 0;
                            PCSel = neg[0] ? 2'b00:2'b10;
                            DBSel = neg[0] ? 2'b00:2'b10;
                        end
                endcase
            6'b100000: //lb
                begin
                   DBSel=2'b01;
                   RegDst = 0;
                   RegWre = 1;
                   sign = 1;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b01010;
                   ExtSel = 1;
                   PCSel = 2'b00;
                   bitWid = 2'b10;
                   mRD = 1;
                end
            6'b100001: //lh
                begin
                   DBSel=2'b01;
                   RegDst = 0;
                   RegWre = 1;
                   sign = 1;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b01010;
                   ExtSel = 1;
                   PCSel = 2'b00;
                   bitWid = 2'b01;
                   mRD = 1;
                end
            6'b100011: //lw
                begin
                   DBSel=2'b01;
                   RegDst = 0;
                   RegWre = 1;
                   sign = 0;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b01010;
                   ExtSel = 0;
                   PCSel = 2'b00;
                   bitWid = 2'b00;
                   mRD = 1;
                end
            6'b100100: //lbu
                begin
                   DBSel=2'b01;
                   RegDst = 0;
                   RegWre = 1;
                   sign = 0;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b01010;
                   ExtSel = 1;
                   PCSel = 2'b00;
                   bitWid = 2'b10;
                   mRD = 1;
                end
            6'b100101: //lhu
                begin
                   DBSel=2'b01;
                   RegDst = 0;
                   RegWre = 1;
                   sign = 0;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b01010;
                   ExtSel = 1;
                   PCSel = 2'b00;
                   bitWid = 2'b01;
                   mRD = 1;
                end
            6'b101000: //sb
                 begin
                      RegDst = 0;
                      RegWre = 0;
                      sign = 0;
                      SrcA = 0;
                      SrcB = 1;
                      Op = 5'b00000;
                      ExtSel = 1;
                      PCSel = 2'b00;
                      bitWid = 2'b10;
                      mRD = 0;
                      mWR = 1;
                   end
            6'b101001: //sh
                begin
                  RegDst = 0;
                  RegWre = 0;
                  sign = 0;
                  SrcA = 0;
                  SrcB = 1;
                  Op = 5'b00000;
                  ExtSel = 1;
                  PCSel = 2'b00;
                  bitWid = 2'b01;
                   mRD = 0;
                  mWR = 1;
               end
            6'b101011: //sw
                begin
                   RegDst = 0;
                   RegWre = 0;
                   sign = 0;
                   SrcA = 0;
                   SrcB = 1;
                   Op = 5'b00000;
                   ExtSel = 1;
                   PCSel = 2'b00;
                   bitWid = 2'b00;
                    mRD = 0;
                    mWR = 1;                   
                end
        endcase
    end
endmodule
