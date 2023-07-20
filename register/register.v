module register #(
    parameter WIDTH = 8
) (
    input wire [WIDTH-1:0] data_in,
    input wire load,clk,rst,
    output reg [WIDTH-1:0] data_out
);
    
    always @(posedge clk ) begin
        if(rst)
            data_out = 'b0;
        else begin
            if(load)
                data_out = data_in;      
        end
    end

endmodule