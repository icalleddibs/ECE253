//Part 2 (ALU and Register)

module part2(input logic Clock, Reset_b, input logic [3:0] Data, input logic [1:0] Function, output logic [7:0] ALUout);

	logic [7:0] D; //input to the register
	logic [3:0] A, B;
	assign A = Data;			//A is the input data
	assign B = ALUout[3:0];		//B is 4 LSB of ALUout

	always_ff @(posedge Clock)
	begin
		if(Reset_b == 1)
			ALUout <= 8'b00000000;
		else
			ALUout <= D;
	end

	always_comb
	begin
		case (Function)
			0: D = A+B;		//A plus B
			1: D = A*B;		//A mult B
			2: D = B << A; 	//shift B A bits over
			3: D = D; 		//store previous ALUoutput value
			default: D = 8'b00000000;
		endcase
	end
endmodule




