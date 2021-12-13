`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 08:28:26
// Design Name: 
// Module Name: ALU
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


module ALU(
        input SrcA,
        input SrcB,
        input [31:0] HI,
        input [31:0] LO,
        input sign,
        input mul,
        input [31:0] inData1,
        input [31:0] inData2,
        input [4:0] sa,
        input [31:0] extend,
        input [4:0] Op,
        output reg zero,
        output reg[1:0] neg,
        output reg[31:0] ALUA,
        output reg[31:0] ALUB,
        output reg[31:0] result,
        output reg[31:0] result2,
        output reg ALURegWre
    );
    
    reg [31:0] A;
    reg [31:0] B;
    reg signed [63:0] ABs;
    reg [63:0] AB;
    initial begin
        result = 4'h0000;
        result2 = 4'h0000;
        A = 4'h0000;
        B = 4'h0000;
        AB = 0;
        end
    //always@(CLK or inData1 or inData2 or SrcA or SrcB or Op) 
    always@(inData1 or sa or SrcA) 
    begin
        case(SrcA)
            0: A=inData1;
            1: A=sa;
        endcase
        ALUA <= A;
    end
    always@(inData2 or extend or SrcB)
    begin
        case(SrcB)
            0: B=inData2;
            1: B=extend;
        endcase
        ALUB <= B;
    end
    always@(A or B or Op or sign or mul) 
    begin
        ALURegWre = 1;
        //$display("ALUOp is %b\n",Op);
        case(Op)
            5'b00000: begin//add addi addu addiu sw sh sb madd maddu
                case (sign)
                    0:case(mul)
                        0:result = A + B;   //addu addiu sw
                        1:begin //maddu
                            AB = {HI,LO} + A * B;
                            result = AB[31:0];
                            result2 = AB[63:32];
                        end
                    endcase
                    1:case(mul)
                        0:result = $signed(A) + $signed(B);     // add addi
                        1:begin //madd
                            ABs = $signed(A) * $signed(B);
                            ABs = ABs + $signed({HI,LO});
                            result = ABs[31:0];
                            result2 = ABs[63:32];
                        end
                    endcase
                endcase
                end
            5'b00001: begin //sub subu msub msubu
                case (sign)
                    0:case(mul)
                        0:result = A - B; //subu
                        1:begin //msubu
                            AB = {HI,LO} - A * B;
                            result = AB[31:0];
                            result2 = AB[63:32];
                        end
                    endcase
                    1:case(mul)
                        0:result = $signed(A) - $signed(B);    //sub
                        1:begin //msub
                            ABs = $signed(A) * $signed(B);
                            ABs = $signed({HI,LO}) - ABs;
                            result = ABs[31:0];
                            result2 = ABs[63:32];
                        end
                    endcase
                endcase
                end
            5'b00010: result = A & B;  //and andi
            5'b00011: result = A | B;  //or ori
            5'b00100: result = A ^ B;  //xor xori
            5'b00101: result = ~(A | B); //nor
            5'b00111: result = B << A;  //sll sllv
            5'b01000: result = B >> A;  //srl srlv
            5'b01001: result = $signed(B) >>> A; //sra srav
            5'b01010: result = B; // lw
            5'b01011: result ={ B[15:0],16'b0000000000000000 }; //lui 
            5'b01100: begin//slt sltu slti sltu
                case(sign)
                    0:result = ( A < B ) ? 1:0;//sltu sltiu
                    1:result = $signed(A) < $signed(B) ? 1:0; //slt slti
                endcase
                end
            5'b01101:begin //movn movz
                result = A;
                ALURegWre = B == 0 ? ~sign:sign;
                end
            5'b01110:begin //clz clo
                casez(sign ? ~A:A)
                    32'b0???????????????????????????????: result = 0;
                    32'b10??????????????????????????????: result = 1;
                    32'b110?????????????????????????????: result = 2;
                    32'b1110????????????????????????????: result = 3;
                    32'b11110???????????????????????????: result = 4;
                    32'b111110??????????????????????????: result = 5;
                    32'b1111110?????????????????????????: result = 6;
                    32'b11111110????????????????????????: result = 7;
                    32'b111111110???????????????????????: result = 8;
                    32'b1111111110??????????????????????: result = 9;
                    32'b11111111110?????????????????????: result = 10;
                    32'b111111111110????????????????????: result = 11;
                    32'b1111111111110???????????????????: result = 12;
                    32'b11111111111110??????????????????: result = 13;
                    32'b111111111111110?????????????????: result = 14;
                    32'b1111111111111110????????????????: result = 15;
                    32'b11111111111111110???????????????: result = 16;
                    32'b111111111111111110??????????????: result = 17;
                    32'b1111111111111111110?????????????: result = 18;
                    32'b11111111111111111110????????????: result = 19;
                    32'b111111111111111111110???????????: result = 20;
                    32'b1111111111111111111110??????????: result = 21;
                    32'b11111111111111111111110?????????: result = 22;
                    32'b111111111111111111111110????????: result = 23;
                    32'b1111111111111111111111110???????: result = 24;
                    32'b11111111111111111111111110??????: result = 25;
                    32'b111111111111111111111111110?????: result = 26;
                    32'b1111111111111111111111111110????: result = 27;
                    32'b11111111111111111111111111110???: result = 28;
                    32'b111111111111111111111111111110??: result = 29;
                    32'b1111111111111111111111111111110?: result = 30;
                    32'b11111111111111111111111111111110: result = 31;
                    32'b11111111111111111111111111111111: result = 32;
                endcase
                end
            5'b01111: begin//mul mult multu
                    case(sign)
                        0:begin //multu
                            AB = A * B; 
                            result = AB[31:0];
                             result2 = AB[63:32];
                         end
                        1:begin //mul mult
                            ABs = $signed(A) * $signed(B); 
                            $display("abs=%0d abs=%0d\n",ABs,$signed(ABs));
                            result = ABs[31:0];
                             result2 = ABs[63:32];
                            end                                                            
                    endcase
                end
            5'b10000: begin //div divu
                case(sign)
                    0:begin //divu
                        result = A / B;
                        result2 = A % B;
                    end
                    1:begin //div
                        result = $signed(A) / $signed(B);
                        result2 = $signed(A) % $signed(B);
                    end
                endcase
            end
            5'b10001: begin //mfhi mflo
                result = HI;
                result2 = LO;
            end
            5'b10010: begin //mthi mtlo
               result = A;
               result2 = A;
           end
            default: 
                begin
                    result = 4'h0000;
                    //result2 = 4'h0000;
                end
        endcase
        zero = (result == 0) ? 1 : 0;
        neg = (A[31] == 1) ? 2'b11 : (A == 0) ? 2'b10: 2'b00;
        //$display("SrcA: %b SrcB: %b inData1: %h inData2: %h sa: %b extend: %b A: %h, B: %h result is %h\n",SrcA,SrcB,inData1,inData2,sa,extend,A,B,result);
    end 
endmodule
