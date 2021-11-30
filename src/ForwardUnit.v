/******************************************************************
* Description
*	This is a 2 to 1 multiplexer that can be parameterized in its bit-width.
*	1.0
* Author:
*			Peralta Mauricio
* email:
*			mperalta.osorio@iteso.mx
* Date:
*	22/11/2021
******************************************************************/

module forwarding_unit(
input EX_MEMRegWrite, MEM_WBRegWrite,
output reg[1:0] Forward_A, Forward_B,
input[4:0] ID_EXRs1, ID_EXRs2, EX_MEMRegRd, MEM_WBRegRd
);

always @(ID_EXRs1,EX_MEMRegRd, EX_MEMRegWrite, MEM_WBRegWrite, MEM_WBRegRd)
    begin
        if(EX_MEMRegWrite &&(EX_MEMRegRd != 0)&&(EX_MEMRegRd == ID_EXRs1))
                Forward_A = 2'b10;
        else if(MEM_WBRegWrite &&(MEM_WBRegRd != 0)&&(EX_MEMRegRd!= ID_EXRs1)&&(MEM_WBRegRd == ID_EXRs1))//1
                Forward_A  = 2'b01;
        else 
                Forward_A  = 2'b00;
	end

always @(ID_EXRs2, EX_MEMRegRd, EX_MEMRegWrite, MEM_WBRegWrite, MEM_WBRegRd)
    begin
        if(EX_MEMRegWrite &&(EX_MEMRegRd != 0)&&(EX_MEMRegRd == ID_EXRs2))
                Forward_B = 2'b10;//2'b10
        else 
	     if(MEM_WBRegWrite &&(MEM_WBRegRd != 0)&&(EX_MEMRegRd!= ID_EXRs2)&&(MEM_WBRegRd == ID_EXRs2))
                Forward_B = 2'b01;
        else 
                Forward_B = 2'b00;//2'b00
    end

endmodule