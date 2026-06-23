`timescale 1ns / 1ps

module cache_statistics(

    input wire clk,
    input wire hit,
    input wire miss,

    output reg [31:0] hit_count,
    output reg [31:0] miss_count,
    output reg [31:0] total_access

);

initial
begin

    hit_count    = 0;
    miss_count   = 0;
    total_access = 0;

end

always @(posedge clk)
begin

    if(hit)
    begin
        hit_count    <= hit_count + 1;
        total_access <= total_access + 1;
    end

    if(miss)
    begin
        miss_count   <= miss_count + 1;
        total_access <= total_access + 1;
    end

end

endmodule
