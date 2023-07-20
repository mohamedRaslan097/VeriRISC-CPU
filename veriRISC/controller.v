

module controller
#(
    parameter OPCODE_WIDTH = 3
)
(
  input  wire [OPCODE_WIDTH-1:0] opcode ,
  input  wire [OPCODE_WIDTH-1:0] phase  ,
  input  wire       zero   , // accumulator is zero
  output reg        sel    , // select instruction address to memory
  output reg        rd     , // enable memory output onto data bus
  output reg        ld_ir  , // load instruction register
  output reg        inc_pc , // increment program counter
  output reg        halt   , // halt machine
  output reg        ld_pc  , // load program counter
  output reg        data_e , // enable accumulator output onto data bus
  output reg        ld_ac  , // load accumulator from data bus
  output reg        wr       // write data bus to memory
);

reg ALUOP,HALT,SKZ,ZERO,JMP,STO;

reg [8:0] cntrl_word;

always @(*) begin 

  

  HALT  = 0;
  SKZ   = 0;
  STO   = 0;
  JMP   = 0;
  ZERO  = zero;
  ALUOP = 0;

  case (opcode)
    'b000: HALT = 1;
    'b001: SKZ  = 1;
    'b010,'b011,'b100,'b101: ALUOP = 1;
    'b110: STO =  1;
    'b111: JMP =  1;
  endcase

  case (phase)
      0:cntrl_word = 9'b1000_00000;  //INST_ADDR
      1:cntrl_word = 9'b1100_00000;  //INST_FETCH  
      2:cntrl_word = 9'b1110_00000;  //INST_LOAD
      3:cntrl_word = 9'b1110_00000;  //IDLE

      4:cntrl_word = {3'b000,HALT,5'b1_0000};                           //OP_ADDR
      5:cntrl_word = {1'b0,ALUOP,7'b000_0000};                          //OP_FETCH 
      6:cntrl_word = {1'b0,ALUOP,2'b00,SKZ && ZERO,1'b0,JMP,1'b0,STO};  //ALU_OP
      7:cntrl_word = {1'b0,ALUOP,3'b000,ALUOP,JMP,STO,STO};             //STORE
  endcase

  {sel,rd,ld_ir,halt,inc_pc,ld_ac,ld_pc,wr,data_e} = cntrl_word;
end 
    
endmodule