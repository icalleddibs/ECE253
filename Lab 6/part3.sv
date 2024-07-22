// lab 6 part 3

module part3(
    input logic Clock,
    input logic Reset,
    input logic Go,
    input logic [3:0] Divisor,
    input logic [3:0] Dividend,
	output logic [3:0] Quotient,
	output logic [3:0] Remainder,
    output logic ResultValid
);

    // lots of wires to connect our datapath and control
    logic ld_a, ld_r, shift;
	
	// so "shift" is the indicator that calculations should start
	// called shift because the first operation is a left shift
	// but it triggers all the add/sub and replacing for division

    control C0(
        .clk(Clock),
        .reset(Reset),

        .go(Go),

        .ld_a(ld_a),
        .ld_r(ld_r),
		.shift(shift), 
		.result_valid(ResultValid)

    );

    datapath D0(
        .clk(Clock),
        .reset(Reset),
        
        .ld_a(ld_a),
        .ld_r(ld_r),
		.shift(shift),

		.dividend(Dividend), .divisor(Divisor), //like data in
		.quotient(Quotient), .remainder(Remainder)
    );

 endmodule


module control(
    input logic clk,
    input logic reset,
    input logic go,

    output logic ld_a, ld_r, shift,
    output logic result_valid
    );

    typedef enum logic [3:0]  { S_LOAD_RST  	= 'd0,
                                S_LOAD       	= 'd1,
                                S_LOAD_WAIT  	= 'd2,
                                S_CYCLE_0       = 'd3,
                                S_CYCLE_1       = 'd4, 
								S_CYCLE_2 		= 'd5,
								S_CYCLE_3 		= 'd6} statetype;
                                
    statetype current_state, next_state;                            

    // Next state logic aka our state table
    always_comb begin
        case (current_state)
            S_LOAD_RST: next_state = go ? S_LOAD_WAIT : S_LOAD_RST; // Loop in current state until value is input
            S_LOAD: next_state = go ? S_LOAD_WAIT : S_LOAD; // Loop in current state until value is input
            S_LOAD_WAIT: next_state = go ? S_LOAD_WAIT : S_CYCLE_0; 
            S_CYCLE_0: next_state = S_CYCLE_1; //start of bit calculations
            S_CYCLE_1: next_state = S_CYCLE_2;
			S_CYCLE_2: next_state = S_CYCLE_3;
			S_CYCLE_3: next_state = S_LOAD; // we will be done our operations, start over after
            default:   next_state = S_LOAD_RST;
        endcase
    end // state_table

    // output logic logic aka all of our datapath control signals
    always_comb begin
        // By default make all our signals 0 even before the case starts, so no need to reset things to 0
        ld_a = 1'b0;
        ld_r = 1'b0;
		shift = 1'b0;
        result_valid = 1'b0;

        case (current_state) 
            S_LOAD_RST: begin
                ld_a = 1'b1;
                end
            S_LOAD: begin //reset to this state
				ld_a = 1'b1; //a is just to set register to 0 (not super necessary)
                result_valid = 1'b1;
                end
            S_CYCLE_0: begin // Do bit 0
                shift = 1'b1;
				end
			S_CYCLE_1: begin // do bit 1
                shift = 1'b1;
				end
			S_CYCLE_2: begin // do bit 2
                shift = 1'b1;
				end
			S_CYCLE_3: begin // do bit 3 and set
                ld_r = 1'b1;
				shift = 1'b1;
				end
        // We don't need a default case since we already made sure all of our outputs were assigned a value at the start of the always block.
        endcase
    end // enable_signals

    // current_state logicisters
    always_ff@(posedge clk) begin
        if(reset)
            current_state <= S_LOAD_RST;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input logic clk,
    input logic reset,
    input logic [3:0] divisor, dividend,
    input logic ld_a, ld_r,
    input logic shift,
	
    output logic [3:0] quotient, remainder
    );

    logic [3:0] a, next_q, temp_q;
	logic [4:0] next_a, temp_a;
	logic [8:0] concat;

    // giant ff block!
    always_ff @(posedge clk) begin
        if(reset) begin //reset conditions
            a <= 4'b0;
			quotient <= 4'b0;
			remainder <= 4'b0;
        end
        else begin //getting in the information
			if(ld_a) begin
				temp_a <= a;
				temp_q <= dividend;
				end
			
			if(shift) begin
				concat = {temp_a, temp_q} << 1; //shift left
				
				//separate the values
				next_a = concat[8:4]; //5 bits since we need the sign
				next_q = concat[3:0];
				
				//perform subtraction
				next_a = next_a - divisor;
				
				//set new q[0]
				next_q[0] = ~next_a[4];
				
				//if it is a 1, it's negative, so add back
				if(next_a[4]) begin
					next_a = next_a + divisor;
				end
				
				//reset new values in temp for the next cycle
				temp_a = next_a;
				temp_q = next_q;
				
				//once reset starts since we set it to the end of cycle 4
				if(ld_r) begin
					quotient <= next_q;
					remainder <= next_a; //only stores first 4 bits
				end
			end
		end
    end

endmodule
