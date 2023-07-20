module tri_state_buffer 
#(
    parameter WIDTH = 8
)
 (
    input wire [WIDTH-1:0]data_in,
    input wire data_en,
    output reg [WIDTH-1:0]data_out
);

always @(*)begin

    if(data_en)
        data_out = data_in;
    else
        data_out = 'b z;

end
    
endmodule