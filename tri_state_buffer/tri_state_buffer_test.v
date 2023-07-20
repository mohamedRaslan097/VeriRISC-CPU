module tri_state_buffer_test;

localparam WIDTH = 8;

reg [WIDTH-1:0]data_in;
reg data_en;

wire [WIDTH-1:0]data_out;

tri_state_buffer #(.WIDTH(WIDTH)) tri_state_buffer_inst(.data_en(data_en),.data_in(data_in),.data_out(data_out));


  task expect;
    input [WIDTH-1:0] exp_out;
    if (data_out !== exp_out) begin
      $display("TEST FAILED");
      $display("At time %0d data_en=%b data_in=%b data_out=%b",
               $time, data_en, data_in, data_out);
      $display("data_out should be %b", exp_out);
      $finish;
    end
    else begin
      $display("At time %0d data_en=%b data_in=%b data_out=%b",
               $time, data_en, data_in, data_out);
    end
  endtask

initial begin
    data_en=1'b1; data_in=4'b1001; #1 expect(4'b1001);
    data_en=1'b0; data_in=4'b1001; #1 expect('bz);
    $display("TEST PASSED");
    $finish;
end

endmodule