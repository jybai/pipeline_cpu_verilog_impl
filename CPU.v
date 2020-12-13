module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire          [31:0] pc_next;
wire          [31:0] pc_now;
wire          [2:0] ALUCtrl;
wire          [1:0] ALUOp;
wire                ALUSrc;
wire                RegWrite;
wire          [31:0] sign_extended;
wire          [31:0] ALU_data;
wire          [31:0] mux_data;
wire           [31:0] instr;
wire           [31:0] read_data_1;
wire           [31:0] read_data_2;

Control Control(
    .Op_i       (instr[6:0]),
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite)
);

Adder Add_PC(
    .data1_in   (pc_now),
    .data2_in   (4),
    .data_o     (pc_next)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_next),
    .pc_o       (pc_now)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_now),
    .instr_o    (instr)
);


Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (instr[19:15]),
    .RS2addr_i   (instr[24:20]),
    .RDaddr_i   (instr[11:7]), 
    .RDdata_i   (ALU_data),
    .RegWrite_i (RegWrite), 
    .RS1data_o   (read_data_1), 
    .RS2data_o   (read_data_2) 
);

MUX32 MUX_ALUSrc(
    .data1_i    (read_data_2),
    .data2_i    (sign_extended),
    .select_i   (ALUSrc),
    .data_o     (mux_data)
);

Sign_Extend Sign_Extend(
    .data_i     (instr[31:20]),
    .data_o     (sign_extended)
);
  
ALU ALU(
    .data1_i    (read_data_1),
    .data2_i    (mux_data),
    .ALUCtrl_i  (ALUCtrl),
    .data_o     (ALU_data),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

endmodule

