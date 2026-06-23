`timescale 1ns / 1ps

module adaptive_selector(

    input wire clk,
    input wire read_en,
    input wire [7:0] addr,

    output reg mode

);

reg [7:0] history [0:3];

reg [3:0] stream_count;
reg [3:0] repeat_count;

integer i;

initial
begin

    history[0] = 0;
    history[1] = 0;
    history[2] = 0;
    history[3] = 0;

    stream_count = 0;
    repeat_count = 0;

    mode = 1'b1;

end

always @(posedge clk)
begin

    if(read_en)
    begin

        //--------------------------------
        // Repeat Detection
        //--------------------------------

        if(addr == history[0] ||
           addr == history[1] ||
           addr == history[2] ||
           addr == history[3])
        begin

            repeat_count <= repeat_count + 1;

        end

        //--------------------------------
        // Streaming Detection
        //--------------------------------

        if( (addr == history[0] + 1) ||
            (addr == history[0] + 4) )
        begin

            stream_count <= stream_count + 1;

        end

        //--------------------------------
        // Update History
        //--------------------------------

        history[3] <= history[2];
        history[2] <= history[1];
        history[1] <= history[0];
        history[0] <= addr;

        //--------------------------------
        // Mode Decision
        //--------------------------------

        if(repeat_count >= stream_count)
            mode <= 1'b1;     // LRU
        else
            mode <= 1'b0;     // FIFO

      

        $display(
        "ADDR=%0d H0=%0d H1=%0d H2=%0d H3=%0d STREAM=%0d REPEAT=%0d MODE=%0d",
        addr,
        history[0],
        history[1],
        history[2],
        history[3],
        stream_count,
        repeat_count,
        mode
        );

    end

end

endmodule