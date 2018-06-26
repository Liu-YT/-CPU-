`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/22 19:21:34
// Design Name: 
// Module Name: MultiCycleCPU
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


module MultiCycleCPU(
       input CLK,
        input RST,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] instruction,
        output [31:0] IRInstruction,
        output [5:0] op,
        output [4:0] rs,
        output [4:0] rt,
        output [4:0] rd,
        output [31:0] DB,
        output [31:0] dataDB,
        output [31:0] A,
        output [31:0] dataA,
        output [31:0] B,
        output [31:0] dataB,
        output [31:0] result,
        output [31:0] dataResult,
        output [1:0] PCSrc
    );
    wire zero;
    wire PCWre;       //PC�Ƿ���ĵ��ź�����Ϊ0ʱ�򲻸��ģ�������Ը���
    wire ExtSel;      //��������չ���ź�����Ϊ0ʱ��Ϊ0��չ������Ϊ������չ
    wire InsMemRW;    //ָ��Ĵ�����״̬��������Ϊ0��ʱ��дָ��Ĵ���������Ϊ��ָ��Ĵ���
    wire [1:0] RegDst;      //д�Ĵ�����Ĵ����ĵ�ַ��Ϊ0��ʱ���ַ����rt��Ϊ1��ʱ���ַ����rd
    wire RegWre;     //�Ĵ�����дʹ�ܣ�Ϊ1��ʱ���д
    wire ALUSrcA;    //����ALU����A��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data1�����Ϊ1��ʱ��������λ��sa
    wire ALUSrcB;    //����ALU����B��ѡ��˵����룬Ϊ0��ʱ�����ԼĴ�����data2�����Ϊ1ʱ��������չ����������
    wire [2:0]ALUOp; //ALU 8�����㹦��ѡ��(000-111)
    wire mRD;        //���ݴ洢���������źţ�Ϊ0��
    wire mWR;         //���ݴ洢��д�����źţ�Ϊ0д
    wire DBDataSrc;   //���ݱ����ѡ��ˣ�Ϊ0����ALU�������������Ϊ1�������ݼĴ�����Data MEM�������  
    wire WrRegDSrc;    //д��Ĵ�����Ĵ���������ѡ���ź�
    wire WriteReg;     //д�ؼĴ�����ַ
    wire [31:0] extend;
    wire [31:0] DataOut;
    wire[4:0] sa;
    wire[15:0] immediate;
    wire[25:0] addr;
    
    ControlUnit ControlUnit(.CLK(CLK),
                            .RST(RST),
                            .zero(zero),
                            .op(op),
                            .IRWre(IRWre),
                            .PCWre(PCWre),
                            .ExtSel(ExtSel),
                            .InsMemRW(InsMemRW),
                            .WrRegDSrc(WrRegDSrc),
                            .RegDst(RegDst),
                            .RegWre(RegWre),
                            .ALUSrcA(ALUSrcA),
                            .ALUSrcB(ALUSrcB),
                            .PCSrc(PCSrc),
                            .ALUOp(ALUOp),
                            .mRD(mRD),
                            .mWR(mWR),
                            .DBDataSrc(DBDataSrc));
    
    pcAdd pcAdd(.RST(RST),
                .PCSrc(PCSrc),
                .immediate(extend),
                .addr(addr),
                .curPC(curPC),
                .rs(A),
                .nextPC(nextPC));
                    
    PC PC(.CLK(CLK),
          .RST(RST),
          .PCWre(PCWre),
          .nextPC(nextPC),
          .curPC(curPC));
                              
    InsMEM InsMEM(.IAddr(curPC), 
                  .InsMemRW(InsMemRW), 
                  .IDataOut(instruction));

    IR IR(.instruction(instruction),
          .CLK(CLK),
          .IRWre(IRWre),
          .IRInstruction(IRInstruction));
          
    InstructionCut InstructionCut(.instruction(IRInstruction),
                                  .op(op),
                                  .rs(rs),
                                  .rt(rt),
                                  .rd(rd),
                                  .sa(sa),
                                  .immediate(immediate),
                                  .addr(addr));
    
    SignZeroExtend SignZeroExtend(.immediate(immediate),
                                  .ExtSel(ExtSel),
                                  .extendImmediate(extend));
                                  
    RegisterFile RegisterFile(.CLK(CLK),
                              .ReadReg1(rs),
                              .ReadReg2(rt),
                              .rd(rd),
                              .WriteData(WrRegDSrc ? dataDB : curPC + 4),
                              .RegDst(RegDst),
                              .RegWre(RegWre),
                              .ReadData1(A),
                              .ReadData2(B),
                              .WriteReg(WriteReg));
                              
    TempReg ADR(.CLK(CLK),
                .IData(A),
                .OData(dataA));
                
    TempReg BDR(.CLK(CLK),
                .IData(B),
                .OData(dataB));
                
    ALU alu(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(dataA),
            .ReadData2(dataB),
            .sa(sa),
            .extend(extend),
            .ALUOp(ALUOp),
            .zero(zero),
            .result(result));
                            
    TempReg ALUoutDR(.CLK(CLK),
                     .IData(result),
                     .OData(dataResult));
    
    DataMEM DataMEM(.mRD(mRD),
                    .mWR(mWR),
                    .DBDataSrc(DBDataSrc),
                    .DAddr(result),
                    .DataIn(dataB),
                    .DataOut(DataOut),
                    .DB(DB));
                    
    TempReg DBDR(.CLK(CLK),
                 .IData(DB),
                 .OData(dataDB));
                 
endmodule
