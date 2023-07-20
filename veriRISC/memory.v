module memory #(
    parameter ADDR_WIDTH = 5,
    parameter DATA_WIDTH = 8
) 
(
    input wire [ADDR_WIDTH-1:0] addr,
    input wire clk,wr,rd,
    inout wire [DATA_WIDTH-1:0] data   
);

    reg [DATA_WIDTH-1:0] array [2**ADDR_WIDTH-1:0];

    always @(posedge clk ) begin
        if( wr)
            array[addr] <= data;
    end

    assign data = rd ? array[addr]:'bz;
        
endmodule