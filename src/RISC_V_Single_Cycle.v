/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 128
)

(
	// Inputs
	input clk,
	input reset,
	output [31:0]forclkrate
);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire jalsignal_w;
wire JalRsignal_w;
wire Branch_w;
wire alu_src_w;
wire reg_write_w;
wire mem_to_reg_w;
wire mem_write_w;
wire mem_read_w;
wire [2:0] alu_op_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;


/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;

/**Inmmediate Unit**/
wire [31:0] inmmediate_data_w;

/**ALU**/
wire [31:0] alu_result_w;
wire Zero_O_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;
//******************************************************************/
//**************cables agregados**************/
//******************************************************************/
/**andWire**/
wire AND_OUT_w;
/**ORWire**/
wire OR_OUT_w;
/**DataMemory**/
wire [31:0] Read_data_mem_w;
/**Multiplexer MUX_data_OR_mem_FOR_Wregister**/
wire [31:0] Wirte_data_Rdat_or_Datmem_w;
/**Multiplexer MUX_PCplus4_OR_brancheJal**/
wire [31:0] Wirte_PCplus4_OR_brancheJal_w;
/**ADDER_PC_PLUS_INMM**/
wire [31:0] ADDER_PC_PLUS_INMM_w;
/**Multiplexer MUX_Pcplus4toRegis_OR_dataAluOrMem**/
wire [31:0] Wirte_Pcplus4toRegis_OR_dataAluOrMem_w;
/**Multiplexer MUX_JALR_OR_brancheJalORPCplus4_w**/
wire [31:0]Wirte_JALR_OR_brancheJalORPCplus4_w;
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputus**/
	.JalR_o(JalRsignal_w),
	.Jal_o(jalsignal_w),
	.Branch_o(Branch_w),
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w)
);


PC_Register
PROGRAM_COUNTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(Wirte_JALR_OR_brancheJalORPCplus4_w),
	.PC_Value(pc_w)
);


Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_w),
	.Instruction_o(instruction_bus_w)
);


Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	
	.Result(pc_plus_4_w)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/



Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(instruction_bus_w[11:7]),
	.Read_Register_1_i(instruction_bus_w[19:15]),
	.Read_Register_2_i(instruction_bus_w[24:20]),
	.Write_Data_i(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);



Immediate_Unit
IMM_UNIT
(  .op_i(instruction_bus_w[6:0]),
   .Instruction_bus_i(instruction_bus_w),
   .Immediate_o(inmmediate_data_w)
);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(inmmediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)

);


ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(instruction_bus_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(instruction_bus_w[14:12]),
	.ALU_Operation_o(alu_operation_w)

);



ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(read_data_1_w),
	.B_i(read_data_2_or_imm_w),
	.ALU_Result_o(alu_result_w),
	.Zero_o(Zero_O_w)
);



//******************************************************************/
             //*********AGREGADO*****************/
//******************************************************************/

Data_Memory 
#(	
   .DATA_WIDTH(32)
)
Data_memory
(
	.clk(clk),
	.Mem_Write_i(mem_write_w),
	.Mem_Read_i(mem_read_w),
	.Write_Data_i(read_data_2_w),
	.Address_i(alu_result_w),

	.Read_Data_o(Read_data_mem_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_data_OR_mem_FOR_Wregister
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(Read_data_mem_w),
	
	.Mux_Output_o(Wirte_data_Rdat_or_Datmem_w)

);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_Pcplus4toRegis_OR_dataAluOrMem
(
	.Selector_i(jalsignal_w),
	.Mux_Data_0_i(Wirte_data_Rdat_or_Datmem_w),
	.Mux_Data_1_i(pc_plus_4_w),
	
	.Mux_Output_o(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w)
);



Adder_32_Bits
#(
	.NBits(32)
)
Adder_PC_PLUS_INMM
(
	.Data0(pc_w),
	.Data1(inmmediate_data_w),
	
	.Result(ADDER_PC_PLUS_INMM_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PCplus4_OR_BRANCHJal
(
	.Selector_i(AND_OUT_w),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(ADDER_PC_PLUS_INMM_w),
	
	.Mux_Output_o(Wirte_PCplus4_OR_brancheJal_w)

);

ANDGate
BranchJAL
(
	.A(OR_OUT_w),
	.B(Zero_O_w),
	.C(AND_OUT_w)
);


ORGate
Branch_or_Jal
(
	.A(Branch_w),
	.B(jalsignal_w),
	.C(OR_OUT_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_JALR_OR_BRANCHJalORPCplus4
(
	.Selector_i(JalRsignal_w),
	.Mux_Data_0_i(Wirte_PCplus4_OR_brancheJal_w),
	.Mux_Data_1_i(alu_result_w),
	
	.Mux_Output_o(Wirte_JALR_OR_brancheJalORPCplus4_w)

);


assign forclkrate= Wirte_JALR_OR_brancheJalORPCplus4_w;

endmodule

