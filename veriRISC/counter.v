module counter #(
    parameter WIDTH = 5
) 
(
    input wire [WIDTH-1:0]cnt_in,
    input wire clk,load,enab,rst,
    output reg [WIDTH-1:0]cnt_out
);
    
always @(posedge clk ) begin
    if(rst)
        cnt_out = 0;
    else if (load)
        cnt_out = cnt_in;
    else if (enab)
        cnt_out=cnt_out+1;
end

endmodule