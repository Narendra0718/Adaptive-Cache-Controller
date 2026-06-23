`timescale 1ns / 1ps
module tb_top;

reg clk;
reg read_en;
reg [7:0] addr;

wire hit;
wire miss;
wire [7:0] data_out;
wire [31:0] hit_count;
wire [31:0] miss_count;
wire [31:0] total_access;

top DUT(
    .clk(clk),
    .read_en(read_en),
    .addr(addr),

    .hit(hit),
    .miss(miss),
    .data_out(data_out),

    .hit_count(hit_count),
    .miss_count(miss_count),
    .total_access(total_access)
);

//-------------------------------------
// Clock Generation
//-------------------------------------

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


//-------------------------------------
// Stimulus
//-------------------------------------

initial
begin


    read_en = 0;
    addr    = 8'd0;

    #20;

    read_en = 1;

addr = 8'd20; #20;
addr = 8'd24; #20;
addr = 8'd20; #20;
addr = 8'd24; #20;

// Reuse some blocks
addr = 8'd20; #20;
addr = 8'd24; #20;

// Force replacement
addr = 8'd36; #20;

// Check which block was evicted
addr = 8'd20; #20;

    read_en = 0;

    #20;
$display("--------------------------------");
$display("HITS         = %0d", hit_count);
$display("MISSES       = %0d", miss_count);
$display("TOTAL ACCESS = %0d", total_access);
$display("--------------------------------");
    $finish;

end
endmodule