`timescale 1ns / 1ps

module cache_controller(

    input  wire        clk,
    input  wire        read_en,
    input  wire        mode,
    input  wire [7:0]  addr,

    output reg         hit,
    output reg         miss,
    output reg [7:0]   data_out,

    input  wire [7:0]  mem_data,

    output reg [7:0]   mem_addr,
    output reg         mem_read

);

reg        valid    [0:3][0:3];
reg [5:0]  tag_mem  [0:3][0:3];
reg [7:0]  data_mem [0:3][0:3];

wire [5:0] tag;
wire [1:0] index;

assign tag   = addr[7:2];
assign index = addr[1:0];

integer i,j;

wire [1:0] fifo_victim;
wire [1:0] lru_victim;

reg fifo_update;

reg lru_access_update;
reg [1:0] lru_accessed_way;

fifo_controller FIFO(

    .clk(clk),
    .update(fifo_update),
    .set_index(index),
    .victim_way(fifo_victim)

);

lru_controller LRU(

    .clk(clk),

    .access_update(lru_access_update),
    .set_index(index),
    .accessed_way(lru_accessed_way),

    .victim_way(lru_victim)

);

initial
begin

    for(i=0;i<4;i=i+1)
    begin
        for(j=0;j<4;j=j+1)
        begin
            valid[i][j]    = 1'b0;
            tag_mem[i][j]  = 6'd0;
            data_mem[i][j] = 8'd0;
        end
    end

end

always @(posedge clk)
begin

    hit      <= 1'b0;
    miss     <= 1'b0;
    data_out <= 8'd0;

    mem_addr <= 8'd0;
    mem_read <= 1'b0;

    fifo_update <= 1'b0;

    lru_access_update <= 1'b0;
    lru_accessed_way  <= 2'd0;

    if(read_en)
    begin

        //----------------------------------
        // WAY0 HIT
        //----------------------------------

        if(valid[index][0] &&
           tag_mem[index][0] == tag)
        begin

            hit <= 1'b1;
            data_out <= data_mem[index][0];

            if(mode)
            begin
                lru_access_update <= 1'b1;
                lru_accessed_way  <= 2'd0;
            end

        end

        //----------------------------------
        // WAY1 HIT
        //----------------------------------

        else if(valid[index][1] &&
                tag_mem[index][1] == tag)
        begin

            hit <= 1'b1;
            data_out <= data_mem[index][1];

            if(mode)
            begin
                lru_access_update <= 1'b1;
                lru_accessed_way  <= 2'd1;
            end

        end

        //----------------------------------
        // WAY2 HIT
        //----------------------------------

        else if(valid[index][2] &&
                tag_mem[index][2] == tag)
        begin

            hit <= 1'b1;
            data_out <= data_mem[index][2];

            if(mode)
            begin
                lru_access_update <= 1'b1;
                lru_accessed_way  <= 2'd2;
            end

        end

        //----------------------------------
        // WAY3 HIT
        //----------------------------------

        else if(valid[index][3] &&
                tag_mem[index][3] == tag)
        begin

            hit <= 1'b1;
            data_out <= data_mem[index][3];

            if(mode)
            begin
                lru_access_update <= 1'b1;
                lru_accessed_way  <= 2'd3;
            end

        end

        //----------------------------------
        // MISS
        //----------------------------------

        else
        begin

            miss <= 1'b1;

            mem_addr <= addr;
            mem_read <= 1'b1;

            if(!valid[index][0])
            begin

                valid[index][0]    <= 1'b1;
                tag_mem[index][0]  <= tag;
                data_mem[index][0] <= mem_data;

                if(mode)
                begin
                    lru_access_update <= 1'b1;
                    lru_accessed_way  <= 2'd0;
                end

            end

            else if(!valid[index][1])
            begin

                valid[index][1]    <= 1'b1;
                tag_mem[index][1]  <= tag;
                data_mem[index][1] <= mem_data;

                if(mode)
                begin
                    lru_access_update <= 1'b1;
                    lru_accessed_way  <= 2'd1;
                end

            end

            else if(!valid[index][2])
            begin

                valid[index][2]    <= 1'b1;
                tag_mem[index][2]  <= tag;
                data_mem[index][2] <= mem_data;

                if(mode)
                begin
                    lru_access_update <= 1'b1;
                    lru_accessed_way  <= 2'd2;
                end

            end

            else if(!valid[index][3])
            begin

                valid[index][3]    <= 1'b1;
                tag_mem[index][3]  <= tag;
                data_mem[index][3] <= mem_data;

                if(mode)
                begin
                    lru_access_update <= 1'b1;
                    lru_accessed_way  <= 2'd3;
                end

            end

            else
            begin

                //----------------------------------
                // FIFO
                //----------------------------------

                if(mode == 1'b0)
                begin

                    valid[index][fifo_victim]    <= 1'b1;
                    tag_mem[index][fifo_victim]  <= tag;
                    data_mem[index][fifo_victim] <= mem_data;

                    fifo_update <= 1'b1;

                end

                //----------------------------------
                // LRU
                //----------------------------------

                else
                begin

                    valid[index][lru_victim]    <= 1'b1;
                    tag_mem[index][lru_victim]  <= tag;
                    data_mem[index][lru_victim] <= mem_data;

                    lru_access_update <= 1'b1;
                    lru_accessed_way  <= lru_victim;

                end

            end

        end

    end

end

endmodule
