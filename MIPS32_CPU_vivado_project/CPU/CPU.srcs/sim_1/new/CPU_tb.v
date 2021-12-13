`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 12:13:04
// Design Name: 
// Module Name: CPU_tb
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


module CPU_tb();
    reg CLK;
	reg Reset;

	wire [1:0] PCSel;
	wire [5:0] Opcode;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire sign;
	wire mul;
	wire [31:0] DB;
	wire [31:0] result;
	wire [31:0] result2;
	wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] instruction;
    wire [31:0] ALUA;
    wire [31:0] ALUB;
    wire [31:0] outData1;
    wire [31:0] outData2;
    wire [31:0] HI;
    wire [31:0] LO;
    wire [1:0]HILOWre;
    wire zero;
    wire [1:0]neg;
    wire PCWre;
    wire ExtSel;
    wire InsMemR;
    wire RegDst;
    wire RegWre;
    wire ALURW;
    wire [25:0]address;
    wire SrcA;
    wire SrcB;
    wire [4:0]Op;
    wire mRD;
    wire mWR;
    wire [1:0]DBSel;
    wire [1:0]bitWid;
	CPU CPU (
		.CLK(CLK), 
		.Reset(Reset), 
		.curPC(curPC),
		.nextPC(nextPC),
		.instruction(instruction),
		.Opcode(Opcode), 
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.sign(sign),
		.mul(mul),
		.DB(DB),
		.ALUA(ALUA),
		.ALUB(ALUB),
        .outData1(outData1),
		.outData2(outData2),
		.result(result),
		.result2(result2),
		.HI(HI),
		.LO(LO),
		.HILOWre(HILOWre),
		.PCSel(PCSel),
		.zero(zero),
		.neg(neg),
		.PCWre(PCWre),
		.ExtSel(ExtSel),
		.InsMemR(InsMemR),
		.RegDst(RegDst),
		.RegWre(RegWre),
		.ALURW(ALURW),
		.address(address),
		.SrcA(SrcA),
		.SrcB(SrcB),
		.Op(Op),
		.mRD(mRD),
		.mWR(mWR),
		.DBSel(DBSel),
		.bitWid(bitWid)
	);
	
    initial begin
        // Initialize Inputs
        CLK = 0;
        Reset = 0;

        #20;
        //CLK = !CLK;
        Reset = 1;
        forever #20 CLK = !CLK;
        //begin
             
        //end
    end
endmodule
