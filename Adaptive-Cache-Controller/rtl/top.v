`timescale 1ns / 1ps
module top(

    input wire clk,
    input wire read_en,
    input wire [7:0] addr,

    output wire hit,
    output wire miss,
    output wire [7:0] data_out,
    output wire [31:0] hit_count,
output wire [31:0] miss_count,
output wire [31:0] total_access

);
wire adaptive_mode;
wire [7:0] mem_data;
wire [7:0] mem_addr;
wire mem_read;

main_memory MEM (

    .read_en(mem_read),
    .addr(mem_addr),
    .data_out(mem_data)

);

adaptive_selector ADAPT (

    .clk(clk),
    .read_en(read_en),
    .addr(addr),

    .mode(adaptive_mode)

);

cache_controller CACHE (

    .clk(clk),
    .read_en(read_en),
    .mode(adaptive_mode),
    .addr(addr),

    .hit(hit),
    .miss(miss),
    .data_out(data_out),

    .mem_data(mem_data),
    .mem_addr(mem_addr),
    .mem_read(mem_read)

);
cache_statistics STATS(

    .clk(clk),
    .hit(hit),
    .miss(miss),

    .hit_count(hit_count),
    .miss_count(miss_count),
    .total_access(total_access)

);
endmodule