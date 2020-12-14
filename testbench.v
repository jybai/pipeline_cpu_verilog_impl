`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;
parameter          num_cycles = 64;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .start_i(Start),
    .rst_i  (Reset)
);
  
initial begin
    $dumpfile("CPU.vcd");
    $dumpvars;
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end

    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 32'b0;
    end
    CPU.Data_Memory.memory[0] = 5;
    // [D-MemoryInitialization] DO NOT REMOVE THIS FLAG !!!
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    // [RegisterInitialization] DO NOT REMOVE THIS FLAG !!!

    // TODO: initialize your pipeline registers
    // CPU.EX_MEM.RegWrite = 1'b0;
    // CPU.EX_MEM.MemtoReg = 1'b0;
    // CPU.EX_MEM.MemRead = 1'b0;
    // CPU.EX_MEM.MemWrite = 1'b0;
    // CPU.EX_MEM.ALUResult = 32'b0;
    // CPU.EX_MEM.MUX2Result = 32'b0;
    // CPU.EX_MEM.Instruction4 = 4'b0;

    // CPU.ID_EX.RegWrite = 1'b0;
    // CPU.ID_EX.MemtoReg = 1'b0;
    // CPU.ID_EX.MemRead = 1'b0;
    // CPU.ID_EX.MemWrite = 1'b0;
    // CPU.ID_EX.ALUOp = 2'b0;
    // CPU.ID_EX.ALUSrc = 1'b0;
    // CPU.ID_EX.RDdata1 = 32'b0;
    // CPU.ID_EX.RDdata2 = 32'b0;
    // CPU.ID_EX.Imm = 32'b0;
    // CPU.ID_EX.Instruction1 = 10'b0;
    // CPU.ID_EX.Instruction2 = 5'b0;
    // CPU.ID_EX.Instruction3 = 5'b0;
    // CPU.ID_EX.Instruction4 = 5'b0;

    // CPU.IF_ID.pc = 32'b0;
    // CPU.IF_ID.Instruction = 32'b0;

    // CPU.MEM_WB.RegWrite = 1'b0;
    // CPU.MEM_WB.MemtoReg = 1'b0;
    // CPU.MEM_WB.ALUResult = 32'b0;
    // CPU.MEM_WB.RDdata = 32'b0;
    // CPU.MEM_WB.Instruction4 = 5'b0;

    // Load instructions into instruction memory
    // Make sure you change back to "instruction.txt" before submission
    $readmemb("instruction.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    // Make sure you change back to "output.txt" before submission
    outfile = $fopen("output.txt") | 1;
    
    Clk = 1;
    Reset = 1;
    Start = 0;
    
    #(`CYCLE_TIME/4) 

    // $fdisplay(outfile, "ALUResult_i = %d; ALU.data_o = %d; foobar = %d\n", CPU.EX_MEM.ALUResult_i, CPU.ALU.data_o, CPU.foobar);
    // $fdisplay(outfile, "Registers.RS1addr_i = %d; Control.Op_i = %d\n", CPU.Registers.RS1addr_i, CPU.Control.Op_i);
    // $fdisplay(outfile, "IF_ID.Instruction = %d; IF_ID.Instruction_o = %d; ID_PC = %d; instr = %d; imm_extended = %d\n", CPU.IF_ID.Instruction, CPU.IF_ID.Instruction_o, CPU.instr, CPU.ID_pc, CPU.imm_extended);
    // $fdisplay(outfile, "Control.MemRead = %d; Control.Branch_o = %d; read_data_1 = %d; read_data_2 = %d\n", CPU.Control.MemRead_o, CPU.Control.Branch_o, CPU.read_data_1, CPU.read_data_2);
    // $fdisplay(outfile, "ID_EX.MemRead_i = %d; ID_EX.MemRead = %d; ID_EX.RDdata1 = %d; ID_EX.RDdata2 = %d; ID_EX.Instruction4 = %d\n", CPU.ID_EX.MemRead_i, CPU.ID_EX.MemRead, CPU.ID_EX.RDdata1, CPU.ID_EX.RDdata2, CPU.ID_EX.Instruction4);
    // $fdisplay(outfile, "HD.IDRs1_i = %d; HD.IDRs2_i = %d; HD.EXRd_i = %d; HD.EXMemRead = %d; HD.NoOp_o = %d;\n", CPU.Hazard_Detection.IDRs1_i, CPU.Hazard_Detection.IDRs2_i, CPU.Hazard_Detection.EXRd_i, CPU.Hazard_Detection.EXMemRead_i, CPU.Hazard_Detection.NoOp_o);

    Reset = 0;
    Start = 1;
        
end
  
always@(posedge Clk) begin
    if(counter == num_cycles)    // stop after num_cycles cycles
        $finish;

    // put in your own signal to count stall and flush
    if(CPU.Hazard_Detection.Stall_o == 1 && CPU.Control.Branch_o == 0) stall = stall + 1;
    if(CPU.flush == 1) flush = flush + 1;  

    // $fdisplay(outfile, "Branch = %d\n", CPU.Branch);
    // $fdisplay(outfile, "WB_WriteData = %d\n", CPU.WB_WriteData);
    // $fdisplay(outfile, "IF_ID.Instruction = %d; IF_ID.Instruction_o = %d; ID_PC = %d; instr = %d; imm_extended = %d\n", CPU.IF_ID.Instruction, CPU.IF_ID.Instruction_o, CPU.instr, CPU.ID_pc, CPU.imm_extended);
    // $fdisplay(outfile, "Add_PC.data1_in = %d; Add_PC.data2_in = %d; Add_PC.data_o= %d\n", CPU.Add_PC.data1_in, CPU.Add_PC.data2_in, CPU.Add_PC.data_o);
    // $fdisplay(outfile, "pc_now = %d; pc_next = %d; ID_Adder.data_o = %d\n", CPU.pc_now, CPU.pc_next, CPU.ID_Adder.data_o);
    // $fdisplay(outfile, "MUX_PC.data1_i = %d; MUX_PC.data2_i = %d; MUX_PC.data_o = %d\n", CPU.MUX_PC.data1_i, CPU.MUX_PC.data2_i, CPU.MUX_PC.data_o);
    // $fdisplay(outfile, "ID_Adder.data1_in = %d; ID_Adder.data2_in = %d; ID_Adder.data_o = %d\n", CPU.ID_Adder.data1_in, CPU.ID_Adder.data2_in, CPU.ID_Adder.data_o);
    // // $fdisplay(outfile, "PC.pc_i = %d; PC.pc_o = %d\n", CPU.PC.pc_i, CPU.PC.pc_o);
    // $fdisplay(outfile, "NoOp = %d; Stall = %d; PCWrite = %d; flush = %d\n", CPU.Hazard_Detection.NoOp_o, CPU.Hazard_Detection.Stall_o, CPU.Hazard_Detection.PCWrite_o, CPU.flush);
    // $fdisplay(outfile, "Control.MemRead = %d; Control.Branch_o = %d; read_data_1 = %d; read_data_2 = %d\n", CPU.Control.MemRead_o, CPU.Control.Branch_o, CPU.read_data_1, CPU.read_data_2);
    // $fdisplay(outfile, "ID_EX.MemRead_i = %d; ID_EX.MemRead = %d; ID_EX.RDdata1 = %d; ID_EX.RDdata2 = %d\n", CPU.ID_EX.MemRead_i, CPU.ID_EX.MemRead, CPU.ID_EX.RDdata1, CPU.ID_EX.RDdata2);
    // $fdisplay(outfile, "FU.ForwardA_o = %d; FU.ForwardB_o = %d\n", CPU.Forwarding_Unit.ForwardA_o, CPU.Forwarding_Unit.ForwardB_o);
    // $fdisplay(outfile, "ALU.data1_i = %d; ALU.data2_i = %d\n", CPU.ALU.data1_i, CPU.ALU.data2_i);
    // $fdisplay(outfile, "EX_MEM.ALUResult = %d; EX_MEM.MemRead = %d\n", CPU.EX_MEM.ALUResult, CPU.EX_MEM.MemRead);
    // $fdisplay(outfile, "MEM_WB.ALUResult_o = %d; MEM_WB.RDdata_o = %d\n", CPU.MEM_WB.ALUResult_o, CPU.MEM_WB.RDdata_o);
    // $fdisplay(outfile, "Registers.RegWrite_i = %d; Registers.RDaddr_i = %d; Registers.RDdata_i = %d\n", CPU.Registers.RegWrite_i, CPU.Registers.RDaddr_i, CPU.Registers.RDdata_i);
    // $fdisplay(outfile, "HD.IDRs1_i = %d; HD.IDRs2_i = %d; HD.EXRd_i = %d; HD.EXMemRead = %d; PCWrite = %d; HD.NoOp_o = %d;\n", CPU.Hazard_Detection.IDRs1_i, CPU.Hazard_Detection.IDRs2_i, CPU.Hazard_Detection.EXRd_i, CPU.Hazard_Detection.EXMemRead_i, CPU.PCWrite, CPU.Hazard_Detection.NoOp_o);

    // print PC
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "cycle = %d, Start = %0d, Stall = %0d, Flush = %0d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "x0 = %d, x8  = %d, x16 = %d, x24 = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "x1 = %d, x9  = %d, x17 = %d, x25 = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "x2 = %d, x10 = %d, x18 = %d, x26 = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "x3 = %d, x11 = %d, x19 = %d, x27 = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "x4 = %d, x12 = %d, x20 = %d, x28 = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "x5 = %d, x13 = %d, x21 = %d, x29 = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "x6 = %d, x14 = %d, x22 = %d, x30 = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "x7 = %d, x15 = %d, x23 = %d, x31 = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    // DO NOT CHANGE THE OUTPUT FORMAT
    $fdisplay(outfile, "Data Memory: 0x00 = %10d", CPU.Data_Memory.memory[0]);
    $fdisplay(outfile, "Data Memory: 0x04 = %10d", CPU.Data_Memory.memory[1]);
    $fdisplay(outfile, "Data Memory: 0x08 = %10d", CPU.Data_Memory.memory[2]);
    $fdisplay(outfile, "Data Memory: 0x0C = %10d", CPU.Data_Memory.memory[3]);
    $fdisplay(outfile, "Data Memory: 0x10 = %10d", CPU.Data_Memory.memory[4]);
    $fdisplay(outfile, "Data Memory: 0x14 = %10d", CPU.Data_Memory.memory[5]);
    $fdisplay(outfile, "Data Memory: 0x18 = %10d", CPU.Data_Memory.memory[6]);
    $fdisplay(outfile, "Data Memory: 0x1C = %10d", CPU.Data_Memory.memory[7]);

    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
