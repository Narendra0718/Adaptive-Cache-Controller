`timescale 1ns / 1ps

module lru_controller(

    input wire clk,

    input wire access_update,
    input wire [1:0] set_index,
    input wire [1:0] accessed_way,

    output reg [1:0] victim_way

);

reg [1:0] age [0:3][0:3];

integer i,j,t;

initial
begin

    for(i=0;i<4;i=i+1)
    begin
        for(j=0;j<4;j=j+1)
        begin
            age[i][j] = j;
        end
    end

end

always @(posedge clk)
begin

    if(access_update)
    begin

        for(t=0;t<4;t=t+1)
        begin

            if(t != accessed_way)
            begin
                if(age[set_index][t] < 3)
                    age[set_index][t]
                    <= age[set_index][t] + 1;
            end

        end

        age[set_index][accessed_way] <= 0;

    end

end

always @(*)
begin

    victim_way = 2'd0;

    if(age[set_index][1]
       > age[set_index][victim_way])
        victim_way = 2'd1;

    if(age[set_index][2]
       > age[set_index][victim_way])
        victim_way = 2'd2;

    if(age[set_index][3]
       > age[set_index][victim_way])
        victim_way = 2'd3;

end

endmodule