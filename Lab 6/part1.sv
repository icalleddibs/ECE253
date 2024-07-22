//lab 6 part 1

module part1(input logic Clock, Reset, w, output logic [3:0] CurState, output logic z);
	typedef enum logic [3:0] {A = 4'd0, B = 4'd1, C = 4'd2, D = 4'd3, E = 4'd4, F = 4'd5, G = 4'd6} statetype;
	statetype y_Q, Y_D; //current state and next state
	
	//state table, only state transitions
	always_comb
	begin
		case(y_Q)
			A: begin
					if (!w) Y_D = A;
					else Y_D = B;
				end
			B: begin
					if (!w) Y_D = A;
					else Y_D = C;
				end
			C: begin
					if (!w) Y_D = E;
					else Y_D = D;
				end
			D: begin
					if (!w) Y_D = E;
					else Y_D = F;
				end
			E: begin
					if (!w) Y_D = A;
					else Y_D = G;
				end
			F: begin
					if (!w) Y_D = E;
					else Y_D = F;
				end
			G: begin
					if (!w) Y_D = A;
					else Y_D = C;
				end
		endcase
	end
	
	//state registers
	always_ff @(posedge Clock)
	begin
		if (Reset == 1'b1)
			y_Q <= A;
		else
			y_Q <= Y_D;
	end
	
	//output logic
	assign z = ((y_Q == F) | (y_Q == G));
	assign CurState = y_Q;
endmodule