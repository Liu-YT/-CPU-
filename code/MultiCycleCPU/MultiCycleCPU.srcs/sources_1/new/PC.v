`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/22 19:13:14
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
       input CLK,               //ʱ��
       input RST,             //�Ƿ����õ�ַ��0-��ʼ��PC����������µ�ַ
       input PCWre,             //�Ƿ�����µĵ�ַ��0-�����ģ�1-���Ը���
       input [31:0] nextPC,  //��ָ���ַ
       output reg[31:0] curPC //��ǰָ��ĵ�ַ
    );
    
    initial begin
        curPC <= 0;
    end

    always@(posedge CLK or negedge RST)
    begin
        if(!RST) // Reset == 0, PC = 0
            begin
                curPC <= 0;
            end
        else 
            begin
                if(PCWre) // PCWre == 1
                    begin 
                        curPC <= nextPC;
                    end
                else    // PCWre == 0, halt
                    begin
                        curPC <= curPC;
                    end
            end
    end
endmodule
