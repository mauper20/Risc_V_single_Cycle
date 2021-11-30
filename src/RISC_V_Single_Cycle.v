module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 128
)

(
	// Inputs
	input clk,
	input reset
	//output [31:0]forclkrate
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
          //*********cables agregados PARA PIPELINE*****************/
//******************************************************************/
/** PCout_IF/ID Bus**/	
wire [31:0] PC_out_IFID_W;
/** IF/ID Bus**/	
wire [127:0] Nw_instruction_bus_w;
/** ID/EX Bus**/
wire [221:0]OutIDEX_w;
/** EX/MEM Bus**/
wire [140:0]OutEXMEM_w;
/** MEM/WB Bus**/
wire [72:0]OutMEMWB_w;
//******************************************************************/
   //*********cables agregados PARA PIPELINE*****************/
			 //*********FORWARD UNIT*****************/
//******************************************************************/
/** Forward_A**/	
wire [1:0] W_ForwardUnit_A_salida;
wire [31:0] W_Forward_A_salida_MUX;
/** Forward_B**/	
wire [1:0] W_ForwardUnit_B_salida;
wire [31:0] W_Forward_B_salida_MUX;
//******************************************************************/
   //*********cables agregados PARA PIPELINE*****************/
			 //*********HAZARD UNIT*****************/
//******************************************************************/
wire [1:0] stall_to_PC_w;
wire [10:0] control_hazard_w;
wire Flush_w;
wire [31:0]topcb_w;
wire OR2_OUT_w;
wire [4:0]toWriteReg_W;
wire toRegWrite_w;
wire [31:0] PCplus4toIFID_w;
wire toRegWrite_2_w;
wire fin_w;
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(Nw_instruction_bus_w[6:0]),
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
	.Next_PC(topcb_w),
	.PC_Value(pc_w),
	.stall(stall_to_PC_w)
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
	.Reg_Write_i(toRegWrite_2_w),//reg_write_w//toRegWrite_w//OutIDEX_w[104]//OutEXMEM_w[72]//toRegWrite_2_w//OutMEMWB_w[70]
	.Write_Register_i(toWriteReg_W),//toWriteReg_W//OutMEMWB_w[68:64]
	.Read_Register_1_i(Nw_instruction_bus_w[19:15]),
	.Read_Register_2_i(Nw_instruction_bus_w[24:20]),
	.Write_Data_i(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);



Immediate_Unit
IMM_UNIT
(  .op_i(Nw_instruction_bus_w[6:0]),
   .Instruction_bus_i(Nw_instruction_bus_w),
   .Immediate_o(inmmediate_data_w)
);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(OutIDEX_w[111]),//Alusrc
	.Mux_Data_0_i(W_Forward_B_salida_MUX),//D2//W_Forward_B_salida_MUX//OutIDEX_w[95:64]
	.Mux_Data_1_i(OutIDEX_w[31:0]),//inm
	
	.Mux_Output_o(read_data_2_or_imm_w)

);


ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(OutIDEX_w[115]),
	.ALU_Op_i(OutIDEX_w[103:101]),
	.funct3_i(OutIDEX_w[114:112]),
	.ALU_Operation_o(alu_operation_w)

);



ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(W_Forward_A_salida_MUX),
	.B_i(read_data_2_or_imm_w),//read_data_2_or_imm_w//W_Forward_B_salida_MUX
	.ALU_Result_o(alu_result_w),//alu_result_w
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
	.Mem_Write_i(OutEXMEM_w[70]),//OutIDEX_w[106]//OutEXMEM_w[70]
	.Mem_Read_i(OutEXMEM_w[71]),
	.Write_Data_i(OutEXMEM_w[63:32]),//OutEXMEM_w[63:32]
	.Address_i(OutEXMEM_w[31:0]), //OutEXMEM_w[31:0]

	.Read_Data_o(Read_data_mem_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_data_OR_mem_FOR_Wregister
(
	.Selector_i(OutMEMWB_w[69]),
	.Mux_Data_0_i(OutMEMWB_w[31:0]),//OutMEMWB_w[31:0]
	.Mux_Data_1_i(OutMEMWB_w[63:32]),//OutMEMWB_w[63:32]
	
	.Mux_Output_o(Wirte_data_Rdat_or_Datmem_w)

);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_Pcplus4toRegis_OR_dataAluOrMem
(
	.Selector_i(OutIDEX_w[108]),//jal IDEX
	.Mux_Data_0_i(Wirte_data_Rdat_or_Datmem_w),
	.Mux_Data_1_i(OutIDEX_w[221:190]),//IDEX PC+4
	
	.Mux_Output_o(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w)
);



Adder_32_Bits
#(
	.NBits(32)
)
Adder_PC_PLUS_INMM
(
	.Data0(Nw_instruction_bus_w[95:64]),
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
	.Mux_Data_0_i(Nw_instruction_bus_w[95:64]),//dontcareiguess
	.Mux_Data_1_i(OutIDEX_w[189:158]),
	
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
	.A(OutIDEX_w[108]),//jal idex
	.B(OutIDEX_w[110]),//branch id ex
	.C(OR_OUT_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_JALR_OR_BRANCHJalORPCplus4
(
	.Selector_i(OutIDEX_w[109]),//Jalr
	.Mux_Data_0_i(Wirte_PCplus4_OR_brancheJal_w),
	.Mux_Data_1_i(alu_result_w),//alu_result_w//OutEXMEM_w
	
	.Mux_Output_o(Wirte_JALR_OR_brancheJalORPCplus4_w)

);

//******************************************************************/
          //*********AGREGADO PARA PIPELINE*****************/
//******************************************************************/

RegisterIF_ID
IF_ID
(
	.clk(clk),
	.reset(reset),
	.enable(stall_to_PC_w),
	.DataOutput(Nw_instruction_bus_w),
	.DataInput(instruction_bus_w),
	.pc_in(pc_w),
	.pc_out(PC_out_IFID_W),
	.PC(pc_w),
	.PCplusI(ADDER_PC_PLUS_INMM_w),
	.PCplus4(pc_plus_4_w),
	.Flush(Flush_w)

);

RegisterID_EX
ID_EX
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.ID_EXRs1_in(Nw_instruction_bus_w[19:15]),
	.ID_EXRs2_in(Nw_instruction_bus_w[24:20]),
	.pc_in(PC_out_IFID_W),
	.RegWrite_in(reg_write_w),//control_hazard_w[4]//reg_write_w
	.Jalr_in(JalRsignal_w),//control_hazard_w[8]JalRsignal_w
	.Jal_in(jalsignal_w),//control_hazard_w[9]//jalsignal_w
	.func3_in(Nw_instruction_bus_w[14:12]),
	.func7_in(Nw_instruction_bus_w[30]),
	.Branch_in(Branch_w),
	.MemRead_in(control_hazard_w[7]),
	.MemWrite_in(control_hazard_w[6]),//control_hazard_w[6]
	.MemToReg_in(control_hazard_w[5]),//mem_to_reg_w//control_hazard_w[5]
	.AluSrc_in(control_hazard_w[3]),
	.ALUOp_in(control_hazard_w[2:0]),
	.Rd1_in(read_data_1_w),
	.Rd2_in(read_data_2_w),
	.RD_in(Nw_instruction_bus_w[11:7]),
	.mm_Unit_in(inmmediate_data_w),
	.Flush(Flush_w),
	.PCplus4(Nw_instruction_bus_w[127:96]),
	.PC(ADDER_PC_PLUS_INMM_w),
	
	.DataOut_ID_EX(OutIDEX_w)
	
);


RegisterEX_MEM
EX_MEM
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.ALU_result_in(alu_result_w),
	.Rd2_in(W_Forward_B_salida_MUX),
	.RD_in(OutIDEX_w[100:96]),
	.MemRead_in(OutIDEX_w[107]),
	.MemWrite_in(OutIDEX_w[106]),
	.MemToReg_in(OutIDEX_w[105]),
	.RegWrite_in(OutIDEX_w[104]),
	.ADDER_PC_PLUS_INMM_in(ADDER_PC_PLUS_INMM_w),
	.Orgate_in(OR_OUT_w),
	.Jalr_in(OutIDEX_w[109]),
	.jal_in(OutIDEX_w[108]),
	.Zero_in(Zero_O_w),
	.Flush(Flush_w),
	
	.DataOutEX_MEM(OutEXMEM_w)
	
);


RegisterMEM_WB
MEM_WB
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.Flush(Flush_w),
	.MemWrite_in(OutEXMEM_w[70]),
	.MemRead_in(OutEXMEM_w[71]),
	.MemToReg_in(OutEXMEM_w[69]),
	.RD_in(OutEXMEM_w[68:64]),
	.ReadData_in(Read_data_mem_w),
	.ALU_result_in(OutEXMEM_w[31:0]),
	.RegWrite_in(OutEXMEM_w[72]),
	.jal_in(OutEXMEM_w[140]),
	.DataOutMEM_WB(OutMEMWB_w)
		
);
//******************************************************************/
          //*********AGREGADO PARA PIPELINE(FORWARD UNIT)*****************/
//******************************************************************/

Multiplexer_3_to_1
FORWARD_A
(   
	.Selector_i(W_ForwardUnit_A_salida),
	.Mux_Data_0_i(OutIDEX_w[63:32]),//OutIDEX_w[63:32]//read_data_1_w
	.Mux_Data_1_i(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w),
	.Mux_Data_2_i(OutEXMEM_w[31:0]),//OutEXMEM_w[31:0]

	.Mux_Output_o(W_Forward_A_salida_MUX)

);

Multiplexer_3_to_1
FORWARD_B
(   
	.Selector_i(W_ForwardUnit_B_salida),
	.Mux_Data_0_i(OutIDEX_w[95:64]),//read_data_2_or_imm_w//OutIDEX_w[95:64] rd2 
	.Mux_Data_1_i(Wirte_Pcplus4toRegis_OR_dataAluOrMem_w),//Wirte_Pcplus4toRegis_OR_dataAluOrMem_w//OutEXMEM_w[68:64]
	.Mux_Data_2_i(OutEXMEM_w[31:0]), //OutEXMEM_w[31:0]//OutMEMWB_w[68:64]
	
	.Mux_Output_o(W_Forward_B_salida_MUX)

);

forwarding_unit
FORWARDUNIT
(
	.EX_MEMRegWrite(OutEXMEM_w[72]),
	.MEM_WBRegWrite(OutMEMWB_w[70]),
	.ID_EXRs1(OutIDEX_w[152:148]), 
	.ID_EXRs2(OutIDEX_w[157:153]), 
	.EX_MEMRegRd(OutEXMEM_w[68:64]), 
	.MEM_WBRegRd(OutMEMWB_w[68:64]),
	
	.Forward_A(W_ForwardUnit_A_salida), 
	.Forward_B(W_ForwardUnit_B_salida)

);
//******************************************************************/
          //*********AGREGADO PARA PIPELINE(Hazard UNIT)*****************/
//******************************************************************/

hazard_detection_unit
hazard_detection_unit
(
	.stall(stall_to_PC_w),
	.Flush(Flush_w),
	.clk(clk),
	.Branch(OR2_OUT_w),//OutEXMEM_w[106]//OutIDEX_w[109]//OR_OUT_w//OutIDEX_w[110]//OR2_OUT_w//OR_OUT_w
	.ID_EXMemRead(OutIDEX_w[107]),
	.IF_IDRs1(Nw_instruction_bus_w[19:15]),
	.IF_IDRs2(Nw_instruction_bus_w[24:20]),
	.ID_EXRd(OutIDEX_w[100:96])
);
Multiplexer_2_to_1_Control
Multiplexer_2_to_1_Control
(
	.Selector_i(stall_to_PC_w),
	.MemRead_in(mem_read_w),
	.MemWrite_in(mem_write_w),
	.MemToReg_in(mem_to_reg_w),
	.RegWrite_in(reg_write_w),
	.AluSrc_in(alu_src_w),
	.ALUOp_in(alu_op_w),
	.Jalr(JalRsignal_w),
	
	.Mux_Output_o(control_hazard_w)

);
Multiplexer_2_to_1
#(
	.NBits(32)
)
MuxtoPc
(
	.Selector_i(OR2_OUT_w),//OR_OUT_w  OutIDEX_w[110]
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(Wirte_JALR_OR_brancheJalORPCplus4_w),//alu_result_w//OutEXMEM_w
	
	.Mux_Output_o(topcb_w)

);
ORGate
Branch_or_Jal_or_Jalr
(
	.A(OR_OUT_w),//or idex
	.B(OutIDEX_w[109]),//jalr id ex
	.C(OR2_OUT_w)
);
Multiplexer_2_to_1_RD
Multiplexer_2_to_1_RD
(
	.Selector_i(OutIDEX_w[108]),//JAL que viene de IDEX
	.Mux_Data_0_i(OutMEMWB_w[68:64]),//RD EX/WB
	.Mux_Data_1_i(OutIDEX_w[100:96]),//RD ID/EX
	
	.Mux_Output_o(toWriteReg_W)
	
);
Multiplexer_2_to_1_RegW
Multiplexer_2_to_1_RegW
(
	.Selector_i(OutIDEX_w[108]),//JAL que viene de IDEX
	.Mux_Data_0_i(OutEXMEM_w[72]),//Regw MEM/WB//OutMEMWB_w[70]
	.Mux_Data_1_i(OutIDEX_w[104]),// Regw ID/EX
	
	.Mux_Output_o(toRegWrite_w)
);
Multiplexer_2_to_1_RegW_Jalr_or_SW
Multiplexer_2_to_1_RegW_Jalr_or_SW
(
	.Selector_i(fin2_w),//MEMWrite////OutMEMWB_w[71]//OutEXMEM_w[140]//OutIDEX_w[108]
	.Mux_Data_0_i(toRegWrite_w),//Jalr//toRegWrite_w
	.Mux_Data_1_i(OutMEMWB_w[70]),// SW//OutMEMWB_w[70]
	
	.Mux_Output_o(toRegWrite_2_w)
);
RegisterFIN
RegisterFIN
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.memwrite(OutMEMWB_w[71]),
	.DataOutMEM_WB(fin_w)
	
	);
RegisterFIN
RegisterFIN2
(
	.clk(clk),
	.reset(reset),
	.enable(1),
	.memwrite(fin_w),
	.DataOutMEM_WB(fin2_w)
	
	);
//assign forclkrate= Wirte_JALR_OR_brancheJalORPCplus4_w;

endmodule

