
module FORWARD
(
input[4:0] ID_EXRs1, ID_EXRs2, EX_MEMRegRd, MEM_WBRegRd;
input EX_MEMRegWrite, MEM_WBRegWrite;
output reg[1:0] Fwd_A, Fwd_B;
)
always @(ID_EXRs1, EX_MEMRegRd, EX_MEMRegWrite, MEM_WBRegWrite, MEM_WBRegRd)
    begin
        if(EX_MEMRegWrite &&(EX_MEMRegRd != 0)&&(EX_MEMRegRd == ID_EXRs1))
            begin
                Fwd_A = 2'b10;
            end
        else if(MEM_WBRegWrite &&(MEM_WBRegRd != 0)&&(MEM_WBRegRd == ID_EXRs1))
            begin
                Fwd_A = 2'b01;
            end
        else 
            begin
                Fwd_A = 2'b00;
            end
	end

always @(ID_EXRs2, EX_MEMRegRd, EX_MEMRegWrite, MEM_WBRegWrite, MEM_WBRegRd)
    begin
        if(EX_MEMRegWrite &&(EX_MEMRegRd != 0)&&(EX_MEMRegRd == ID_EXRs2))
            begin
                Fwd_B = 2'b10;
            end
        else if(MEM_WBRegWrite &&(MEM_WBRegRd != 0)&&(MEM_WBRegRd == ID_EXRs2))
            begin
                Fwd_B = 2'b01;
            end
        else 
            begin
                Fwd_B = 2'b00;
            end
    end

endmodule