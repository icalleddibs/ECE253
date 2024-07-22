// Lab 5 Part 2 Rate Divider and Display Counter

//parameter supposed to be 500
module part2 #(parameter CLOCK_FREQUENCY = 500)(input logic ClockIn, input logic Reset, input logic [1:0] Speed, output logic [3:0] CounterValue);
	logic enable;
	RateDivider u0(ClockIn, Reset, Speed, enable);
	DisplayCounter u1(ClockIn, Reset, enable, CounterValue);
endmodule




module RateDivider #(parameter CLOCK_FREQUENCY = 500) (input logic ClockIn, input logic Reset, input logic [1:0] Speed, output logic Enable);

	logic [$clog2(CLOCK_FREQUENCY * 4):0] Q; //counter
	logic [1:0] new_speed;
	logic [$clog2(CLOCK_FREQUENCY * 4):0] rate_amt; //change based on frequency

	always_ff @(posedge ClockIn)
	begin
		if (Reset == 1) 
			Q <= 0;
			new_speed <= Speed;
		if (Reset == 0)
			Q <= (Q == 0) ? (rate_amt) : (Q-1);
			new_speed <= (Q == 0) ? Speed : new_speed;
	end
	
	always_ff @ (posedge Enable)
		new_speed <= Speed;
	
	always_comb
	begin
		case(new_speed) 
			0: rate_amt <= 0; //if i set it to 1 it counts every periods but if i set it to 1 it just dies and only sets to 0
			1: rate_amt <= ((CLOCK_FREQUENCY)-1);
			2: rate_amt <= ((CLOCK_FREQUENCY * 2)-1);
			3: rate_amt <= ((CLOCK_FREQUENCY * 4)-1);
			default: rate_amt <= 0;
		endcase
	end

	assign Enable = (Q == 1'b0)? 1'b1: 1'b0; //once Q is 0, set it to 1, if it's not 0 set it to 0 (this is NOR thing)

endmodule 



module DisplayCounter(input logic Clock, Reset, EnableDC, output logic [3:0] CounterValue);
        always_ff @ (posedge Clock)
        begin
            if (Reset == 1)
                CounterValue <= 4'h0; 
            else if (EnableDC == 1)  
                CounterValue <= CounterValue + 1'h1; 
        end
endmodule






