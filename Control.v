module Control(
  Op_i,
  NoOp_i,
  RegWrite_o,
  MemToReg_o,
  MemRead_o,
  MemWrite_o,
  Branch_o,
  ALUOp_o,
  ALUSrc_o,
);

input      [6:0] Op_i;
input            NoOp_i;
output           RegWrite_o;
output           MemToReg_o;
output           MemRead_o;
output           MemWrite_o;
output           Branch_o;
output     [1:0] ALUOp_o;
output           ALUSrc_o;

`define OP_RTYPE 7'b0110011
`define    OP_SW 7'b0100011
`define    OP_LW 7'b0000011
`define   OP_BEQ 7'b1100011

`define ALUOP_RTYPE 2'b00
`define ALUOP_IMM 2'b01

assign RegWrite_o = NoOp_i ? 0 : Op_i[5:0] != 6'b100011;
assign MemToReg_o = NoOp_i ? 0 : Op_i == `OP_LW; // only when lw
assign MemRead_o = NoOp_i ? 0 : Op_i == `OP_LW; // https://stackoverflow.com/questions/54726371/mips-single-cycle-why-are-memread-and-memtoreg-separate
assign MemWrite_o = NoOp_i ? 0 : Op_i == `OP_SW; // only when sw
assign Branch_o = NoOp_i ? 0 : Op_i == `OP_BEQ; // only when beq
assign ALUOp_o = NoOp_i ? 0 : Op_i == `OP_RTYPE ? `ALUOP_RTYPE : `ALUOP_IMM;
assign ALUSrc_o = NoOp_i ? 0 : !Op_i[5];

endmodule
