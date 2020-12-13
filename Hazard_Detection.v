module Hazard_Detection
(
    IDRs1_i,
    IDRs2_i,
    EXRd_i,
    EXMemRead_i,
    PCWrite_o,
    Stall_o,
    NoOp_o
);

// Ports
input   [4:0]   IDRs1_i;
input   [4:0]   IDRs2_i;
input   [4:0]   EXRd_i;
input           EXMemRead_i;
output reg      PCWrite_o;
output reg      Stall_o;
output reg      NoOp_o;

always @(*) begin
    if (EXMemRead_i
        && ((EXRd_i == IDRs1_i) || (EXRd_i == IDRs2_i))) begin
        PCWrite_o = 0;
        Stall_o = 1;
        NoOp_o = 1;
    end
    else begin
        PCWrite_o = 1;
        Stall_o = 0;
        NoOp_o = 0;
    end
end

endmodule
