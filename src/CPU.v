`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 09:19:34
// Design Name: 
// Module Name: CPU
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


module CPU(
        input CLK,
        input Reset,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] instruction,
        output [5:0] Opcode,
        output [4:0] rs,
        output [4:0] rt,
        output [4:0] rd,
        output sign,
        output mul,
        output [31:0] DB,
        output [31:0] ALUA,
        output [31:0] ALUB,
        output [31:0] outData1,
        output [31:0] outData2,
        output [31:0] result,
        output [31:0] result2,
        output [31:0] HI,
        output [31:0] LO,
        output [1:0] HILOWre,
        output [1:0] PCSel,
        output zero,
        output [1:0]neg,
        output PCWre,
        output ExtSel,
        output InsMemR,
        output RegDst,
        output RegWre,
        output ALURW,
        output [25:0]address,
        output SrcA,
        output SrcB,
        output [4:0]Op,
        output mRD,
        output mWR,
        output [1:0] DBSel,
        output [1:0] bitWid
    );

    wire [31:0] extend;
    wire [31:0] DataOut;
    wire[4:0] sa;
    wire[15:0] immediate;
    wire[25:0] addr;
    wire[5:0] func;
    wire Sign;
    wire Mul;
    wire [31:0] A;
    wire [31:0] B;
    wire ALURegWre;
    wire [31:0] HIdata;
    wire [31:0] LOdata;
    wire [1:0]HLWre;

    PCNext PCNext(.Reset(Reset),
                //.CLK(CLK),
                .PCSel(PCSel),
                .immediate(extend),
                .addr(addr),
                .curPC(curPC),
                .nextPC(nextPC),
                .alPC(result));
    
    PC PC(.CLK(CLK),
          .Reset(Reset),
          .PCWre(PCWre),
          .nextPC(nextPC),
          .curPC(curPC));

    InsMem InsMem(.IAddr(curPC), 
                .InsMemR(InsMemR), 
                .IDataOut(instruction));
                    
    InsSub InsSub(.instruction(instruction),
                                  .Opcode(Opcode),
                                  .rs(rs),
                                  .rt(rt),
                                  .rd(rd),
                                  .sa(sa),
                                  .immediate(immediate),
                                  .addr(addr),
                                  .func(func));

    Control Control(.zero(zero),
                            .neg(neg),
                            .Opcode(Opcode),
                            .func(func),
                            .brt(rt),
                            .sign(Sign),
                            .mul(Mul),
                            .PCWre(PCWre),
                            .ExtSel(ExtSel),
                            .InsMemR(InsMemR),
                            .RegDst(RegDst),
                            .RegWre(RegWre),
                            .SrcA(SrcA),
                            .SrcB(SrcB),
                            .HILOWre(HLWre),
                            .PCSel(PCSel),
                            .Op(Op),
                            .mRD(mRD),
                            .mWR(mWR),
                            .DBSel(DBSel),
                            .bitWid(bitWid));

    RegGroup RegGroup(.CLK(CLK),
                              .inReg1(rs),
                              .inReg2(rt),
                              .WriteData(DB),
                              .WriteReg(RegDst ? rd : rt),
                              .RegWre(RegWre),
                              .ALURegWre(ALURegWre),
                              .outData1(A),
                              .outData2(B));

    ALU ALU(.SrcA(SrcA),
            .SrcB(SrcB),
            .HI(HIdata),
            .LO(LOdata),
            .sign(Sign),
            .mul(Mul),
            .inData1(A),
            .inData2(B),
            .ALUA(ALUA),
            .ALUB(ALUB),
            .sa(sa),
            .extend(extend),
            .Op(Op),
            .zero(zero),
            .neg(neg),
            .result(result),
            .result2(result2),
            .ALURegWre(ALURegWre));

    DataMem DataMem(.mRD(mRD),
                    .mWR(mWR),
                    .CLK(CLK),
                    .sign(Sign),
                    .bitWid(bitWid),
                    .DAddr(result),
                    .DataIn(B),
                    .DataOut(DataOut));

    mux4 mux4(.DBSel(DBSel),
                .result(result),
                .DataOut(DataOut),
                .PC(curPC),
                .DB(DB));
    Extend Extend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extend));
                                  
    HILO HILO(.CLK(CLK),
                .HILOWre(HLWre),
                .inHIData(result2),
                .inLOData(DB),
                .outHIData(HIdata),
                .outLOData(LOdata));
     
    assign outData1 = A;
    assign outData2 = B;
    assign ALURW = ALURegWre;
    assign HI = HIdata;
    assign LO = LOdata;
    assign HILOWre = HLWre ;
    assign address = addr;
    assign sign = Sign;
    assign mul = Mul;
     //assign res2 = result2;
    
endmodule
