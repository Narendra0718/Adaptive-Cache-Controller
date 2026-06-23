`timescale 1ns / 1ps

module fifo_controller(

    input wire clk,
    input wire update,

    input wire [1:0] set_index,

    output wire [1:0] victim_way

);

reg [1:0] fifo_ptr [0:3];

integer i;

initial
begin

    for(i=0;i<4;i=i+1)
        fifo_ptr[i] = 2'd0;

end

assign victim_way = fifo_ptr[set_index];

always @(posedge clk)
begin

    if(update)
        fifo_ptr[set_index] <= fifo_ptr[set_index] + 1'b1;

end

endmodule