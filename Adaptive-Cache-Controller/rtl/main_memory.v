`timescale 1ns / 1ps
module main_memory(

    input wire read_en,
    input wire [7:0] addr,

    output reg [7:0] data_out

);

reg [7:0] memory [0:255];

integer i;

initial
begin

    for(i=0;i<256;i=i+1)
        memory[i] = i;

end

always @(*)
begin

    if(read_en)
        data_out = memory[addr];
    else
        data_out = 8'd0;

end

endmodule