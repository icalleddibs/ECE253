//Part 3 (Parametrized ALU)
	

module part3 #(parameter N = 4)(input logic [N-1:0] A, B, input logic [1:0] Function, output logic [(2*N)-1:0] ALUout);
	
	logic [(2*N)-1:0] C2, C3, C4;
	
	//for the or reduction
	assign C2 = | {A[N-1:0], B[N-1:0]};
	
	//for the and reduction
	assign C3 = & {A[N-1:0], B[N-1:0]};
	
	//for the concatenation
	assign C4 = {A[N-1:0], B[N-1:0]};
	
	always_comb
	begin
	case(Function)
		0: ALUout = A+B;
		1: if (C2) ALUout = 1;
		else ALUout = 0;
		2: if (C3) ALUout = 1;
		else ALUout = 0;
		3: ALUout = C4;
		default: ALUout = 0;
	endcase
	end 	
endmodule
	