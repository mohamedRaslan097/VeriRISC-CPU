module alu #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 3
)

(
    input wire [DATA_WIDTH-1:0] in_a,in_b,
    input wire [OPCODE_WIDTH-1:0] opcode,
    output reg [DATA_WIDTH-1:0] alu_out,
    output wire a_is_zero
    
);
    
    assign a_is_zero = in_a? 1'b0:1'b1;  

    always @(*) begin
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