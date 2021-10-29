/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	output reg Zero_o,
	output reg [31:0] ALU_Result_o
);

/* se establecieron los valores para que se reconociera el tipo de instrccion que venia de la alucontrol 
y seleccionarl el caso correcto, algunas intrucciones parecen no estar pero hacen lo mismo que otros 
por lo que para ahorrar lineas se vincularon*/
localparam ADD = 4'b00_00;// add y addi
localparam SUB = 4'b00_01;
localparam XOR = 4'b00_10;//xor, xori
localparam OR  = 4'b00_11;
localparam ORI = 4'b10_00;
localparam AND = 4'b01_00;//and y andi
localparam SLL = 4'b01_01;//sll y slli
localparam SRL = 4'b01_11;//srl y srli
localparam LUI = 4'b10_01;
localparam LW  = 4'b11_01;
localparam SW  = 4'b11_00;
localparam JALR= 4'b10_10;
localparam BEQ = 4'b10_11;
localparam BNE = 4'b11_10;
localparam BLT = 4'b11_11;

   
always @ (A_i or B_i or ALU_Operation_i)
     begin
		case (ALU_Operation_i)
		ADD: // add y addi
		   ALU_Result_o= A_i + B_i;

		SUB: // sub 
	      ALU_Result_o = A_i - B_i;
			
		AND: // and y andi
			ALU_Result_o = A_i & B_i;
			
		OR:  // or  
			ALU_Result_o= A_i | B_i;
			
		ORI:  // ori
			ALU_Result_o= A_i | B_i;
			
		XOR: //xor, xori
			ALU_Result_o = (A_i^B_i);
			
		LUI: // lui
			ALU_Result_o = B_i<<12; 
			
		SRL: //srl y srli
		   ALU_Result_o= A_i >> B_i; 
			
		SLL: //sll y slli
		   ALU_Result_o= A_i << B_i;  
			
		SW:  // sw
			ALU_Result_o = (A_i + B_i)-'h10010000;
			
	   LW:  // LW
			ALU_Result_o = (A_i + B_i)-'h10010000;
			
		JALR: //jalr
		   ALU_Result_o= A_i + B_i;
		
		BEQ: //beq
			ALU_Result_o = (A_i == B_i) ? 1'b0 : 1'b1;
			
		BNE: //bne
			ALU_Result_o = (A_i != B_i) ? 1'b0 : 1'b1;
			
		BLT: //blt
			ALU_Result_o = (A_i < B_i) ?  1'b0 : 1'b1;
			
		default:
			ALU_Result_o = 0;	
		endcase // case(control)
		
		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
		
     end // always @ (A or B or control)
endmodule // ALU