`default_nettype none

// drivers 
`include "counter.v"
`include "controller.v"
`include "memory.v"
`include "register.v"
`include "alu.v"
`include "multiplexor.v"
`include "Tri_state_Buffer.v"

module veriRISC 
#(
    
) 
(
    input wire clk,rst,
    output wire halt
);

//  parameters 
localparam  CNT_CLK_WIDTH = 3;
localparam  OPCODE_WIDTH = 3;
localparam  ADDR_WIDTH = 5;
localparam  DATA_WIDTH = 8;


//  wires
wire [CNT_CLK_WIDTH-1:0]phase;

wire [OPCODE_WIDTH-1:0] opcode;

wire rd,wr,ld_ir,ld_ac,ld_pc,inc_pc,data_e,sel,zero;

wire [ADDR_WIDTH-1:0]addr;
wire [DATA_WIDTH-1:0]data;

wire [ADDR_WIDTH-1:0]ir_addr,pc_addr;

wire [DATA_WIDTH-1:0]ac_out,alu_out;

//Counter clock (phase generator)
counter #(
    .WIDTH  (CNT_CLK_WIDTH)
)
counter_clk 
(
    .cnt_in (5'b0),
    .clk    (clk),
    .rst    (rst),
    .load   (0),
    .enab   (!halt),
    .cnt_out(phase)
);

//controller
controller #(
    .OPCODE_WIDTH(OPCODE_WIDTH)
)
controller_inst
(
    .opcode (opcode),
    .zero   (zero),
    .phase  (phase),
    .rd     (rd),
    .wr     (wr),
    .ld_ir  (ld_ir),
    .ld_ac  (ld_ac),
    .ld_pc  (ld_pc),
    .inc_pc (inc_pc),
    .halt   (halt),
    .data_e (data_e),
    .sel    (sel)
);

//  memory
memory #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
)
memory_inst
(
    .addr   (addr),
    .clk    (clk),
    .wr     (wr),
    .rd     (rd),
    .data   (data)
);


//multiplexor

multiplexor #(
    .WIDTH(ADDR_WIDTH)
)
address_mux
(
    .sel    (sel),
    .in0    (ir_addr),
    .in1    (pc_addr),
    .mux_out(addr)
);

//PC counter

counter #(
    .WIDTH(ADDR_WIDTH)
)
pc_counter
(
    .cnt_in (ir_addr),
    .clk    (clk),
    .rst    (rst),
    .load   (ld_pc),
    .enab   (inc_pc),
    .cnt_out(pc_addr)
);

//instruction register
register #(
    .WIDTH(DATA_WIDTH)
)
register_ir
(
    .data_in    (data),
    .load       (ld_ir),
    .clk        (clk),
    .rst        (rst),
    .data_out   ({opcode,ir_addr})
);

//ALU
alu #(
    .DATA_WIDTH(DATA_WIDTH),
    .OPCODE_WIDTH(OPCODE_WIDTH)
)
alu_inst
(
    .in_a       (ac_out),
    .in_b       (data),
    .opcode     (opcode),
    .alu_out    (alu_out),
    .a_is_zero  (zero)
);


//accumulator register
register #(
    .WIDTH(DATA_WIDTH)
)
register_ac
(
    .data_in    (alu_out),
    .load       (ld_ac),
    .clk        (clk),
    .rst        (rst),
    .data_out   (ac_out)
);

//tri-state buffer
tri_state_buffer #(
    .WIDTH(DATA_WIDTH)
)
driver_inst
(
    .data_in    (alu_out),
    .data_en    (data_e),
    .data_out   (data)
);

endmodule