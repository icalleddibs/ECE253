module part1(input logic Clock, Enable, Reset,  
             output logic [7:0] CounterValue);
//The CounterValue is the value of the counter comprised of the Q outputs of all of the T
//flip-flops where CounterValue[7] is the most significant bit and CounterValue[0] is the
//least significant bit of the counter output

// NEED TO FIGURE OUT WHAT T IS FOR EACH ONE! - see notes 

T_flipflop u0(Clock, Enable, Reset, 1, CounterValue[0]);
T_flipflop u1(Clock, Enable, Reset, CounterValue[0], CounterValue[1]);
T_flipflop u2(Clock, Enable, Reset, &CounterValue[1:0], CounterValue[2]);
T_flipflop u3(Clock, Enable, Reset, &CounterValue[2:0], CounterValue[3]);
T_flipflop u4(Clock, Enable, Reset, &CounterValue[3:0], CounterValue[4]);
T_flipflop u5(Clock, Enable, Reset, &CounterValue[4:0], CounterValue[5]);
T_flipflop u6(Clock, Enable, Reset, &CounterValue[5:0], CounterValue[6]);
T_flipflop u7(Clock, Enable, Reset, &CounterValue[6:0], CounterValue[7]);

endmodule 

module T_flipflop(input logic Clock, Enable, Reset, T,
                output logic Q);
//I need to remember how T flipflops work 
    always_ff @(posedge Clock)
    begin 
        if (Reset)
            Q <= 0; 
        else if (Enable)
            Q <= T^Q;  
        
    end
endmodule 