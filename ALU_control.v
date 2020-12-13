module ALU_Control(
  funct_i,
  ALUOp_i,
  ALUCtrl_o
);

input          [9:0] funct_i;
input          [1:0] ALUOp_i;
output reg     [2:0] ALUCtrl_o;

`define AND 3'b000
`define XOR 3'b001
`define SLL 3'b010
`define ADD 3'b011
`define SUB 3'b100
`define MUL 3'b101
`define ADDI 3'b110
`define SRAI 3'b111

always @ (*) begin
  if (ALUOp_i[0] == 1) begin
    if (funct_i[2:0] == 3'b000)
      ALUCtrl_o = `ADDI;
    else
      ALUCtrl_o = `SRAI;
  end
  else begin
    if (funct_i == 10'b0000000_111)
      ALUCtrl_o = `AND;
    else if (funct_i == 10'b0000000_100)
      ALUCtrl_o = `XOR;
    else if (funct_i == 10'b0000000_001)
      ALUCtrl_o = `SLL;
    else if (funct_i == 10'b0000000_000)
      ALUCtrl_o = `ADD;
    else if (funct_i == 10'b0100000_000)
      ALUCtrl_o = `SUB;
    else
      ALUCtrl_o = `MUL;
  end
end

endmodule
