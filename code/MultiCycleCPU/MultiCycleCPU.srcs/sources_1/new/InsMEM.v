`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/22 19:13:53
// Design Name: 
// Module Name: InsMEM
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


module InsMEM(
        input [31:0] IAddr,
        input InsMemRW,             //״̬Ϊ'0'��дָ��Ĵ���������Ϊ��ָ��Ĵ���
        output reg[31:0] IDataOut
    );
    
    reg [7:0] rom[128:0];  // �洢�����������reg���ͣ��洢���洢��Ԫ8λ���ȣ���128���洢��Ԫ�����Դ�32��ָ��
    
    // �������ݵ��洢��rom��ע�⣺����ʹ�þ���·��
    initial 
    begin
        $readmemh("F:\\Vivado\\MultiCycleCPU\\romData.txt", rom);
    end
    
    //���ģʽ
    always@(IAddr or InsMemRW)
    begin
        //ȡָ��
        if(InsMemRW)
            begin
                IDataOut[7:0] = rom[IAddr + 3];
                IDataOut[15:8] = rom[IAddr + 2];
                IDataOut[23:16] = rom[IAddr + 1];
                IDataOut[31:24] = rom[IAddr];
            end 
    end
    
endmodule
