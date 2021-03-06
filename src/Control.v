/******************************************************************
* Description
*	This is control unit for the RISC-V Microprocessor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction bus.
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Control
(
	input [6:0]OP_i,
	
	
	output Branch_o,
   output Jal_o,
	output JalR_o,
	output Mem_Read_o,
	output Mem_to_Reg_o,
	output Mem_Write_o,
	output ALU_Src_o,
	output Reg_Write_o,
	output [2:0]ALU_Op_o
);
// se agregaron los opcode de cada tipo de instruccion correspondiente
localparam R_Type           =7'h33;
localparam I_Type_LOGIC     =7'h13;
localparam U_Type_LUI       =7'h37;
localparam S_Type_SW        =7'h23;
localparam I_Mem_Type_LW    =7'h03;
localparam J_Type_JAL       =7'h6F;
localparam I_Type_JALR      =7'h67;
localparam B_Type           =7'h63;


reg [10:0] control_values;

always@(OP_i) begin
	case(OP_i)//                         11 10 876_54_3_210
	
		R_Type:         control_values= 11'b0_0_001_00_0_000;
		I_Type_LOGIC:   control_values= 11'b0_0_001_00_1_001;
		U_Type_LUI:   	 control_values= 11'b0_0_001_00_1_010;	
		S_Type_SW:   	 control_values= 11'b0_0_001_01_1_011;
	   I_Mem_Type_LW:  control_values= 11'b0_0_011_10_1_100;
		J_Type_JAL:		 control_values= 11'b0_1_001_00_0_101;
		I_Type_JALR:	 control_values= 11'b1_0_000_00_1_110;
		B_Type:         control_values= 11'b0_0_100_00_0_111;
		//se ajustaron las señales necesarias correspondeintes a lo que cada intruccion o tipo de intstruccion hace

		default:
			             control_values= 11'b0_0_000_00_0_000;
		endcase
end	
//se agregaron 2 señales mas, jalr y jal

assign JalR_o        = control_values[10];

assign Jal_o        = control_values[9];

assign Branch_o     = control_values[8];

assign Mem_to_Reg_o = control_values[7];

assign Reg_Write_o  = control_values[6];

assign Mem_Read_o   = control_values[5];
 
assign Mem_Write_o  = control_values[4];

assign ALU_Src_o    = control_values[3];

assign ALU_Op_o     = control_values[2:0];	

endmodule


