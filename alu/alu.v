module alu #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 3
)

(
    input wire [DATA_WIDTH-1:0] in_a,in_b,
    input wire [OPCODE_WIDTH-1:0] opcode,
    output reg [DATA_WIDTH-1:0] alu_out,
    output reg a_is_zero
    
);
      

    always @(*) begin
     
     a_is_zero = (in_a == 0);
     case (opcode)
          'b000:
               alu_out = in_a;
          'b001:
               alu_out = in_a;
          'b010:
               alu_out = in_a+in_b;
          'b011:
               alu_out = in_a&in_b;
          'b100:
               alu_out = in_a^in_b;
          'b101:
               alu_out = in_b;
          'b110:
               alu_out = in_a;
          'b111:
               alu_out = in_a;
          default:
               alu_out = in_a; 
     endcase
    end

endmodule