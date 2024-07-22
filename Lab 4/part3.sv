module block_reg(input logic clock, reset_b, loadleft, loadn, data_in, right, left, 
                output logic Q);
    always_ff@(posedge clock)
    begin
        if (reset_b) Q<=4'b0000;
        else Q <= ((~loadn & data_in) | loadn&((~loadleft&right) | (loadleft&left)));
    end
endmodule

module part3(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, 
                        input logic [3:0] Data_IN, 
                        output logic [3:0]Q);
	logic left_3;
    assign left_3 = (~ASRight & Q[0]) | (ASRight & Q[3]);
    block_reg u3(clock, reset, RotateRight, ParallelLoadn, Data_IN[3], Q[2], left_3, Q[3]);
    block_reg u2(clock, reset, RotateRight, ParallelLoadn, Data_IN[2], Q[1], Q[3], Q[2]);
    block_reg u1(clock, reset, RotateRight, ParallelLoadn, Data_IN[1], Q[0], Q[2], Q[1]);
    block_reg u0(clock, reset, RotateRight, ParallelLoadn, Data_IN[0], Q[3], Q[1], Q[0]);
endmodule 