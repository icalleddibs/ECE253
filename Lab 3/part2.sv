//Part 2 (ALU)

module FA(input logic a, b, cin, output logic s, cout);
	assign s = a ^ b ^ cin;
	assign cout = (a&b) | (b&cin) | (a&cin);
endmodule

module RCA(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
	FA u0(a[0], b[0], c_in, s[0], c_out[0]);
	FA u1(a[1], b[1], c_out[0], s[1], c_out[1]);
	FA u2(a[2], b[2], c_out[1], s[2], c_out[2]);
	FA u3(a[3], b[3], c_out[2], s[3], c_out[3]);
endmodule
	

module part2(input logic [3:0] A, B, input logic [1:0] Function, output logic [7:0] ALUout);
	
	logic [7:0] C1, C2, C3, C4;
	
	//for the RCA connection
	logic [3:0] s, c_out;
	logic cin = 1'b0;
	RCA u5(A, B, cin, s, c_out);
	assign C1 = {3'b000, c_out[3], s[3:0]}; //because C1 and ALUout are 8 bits
	
	//for the or reduction
	assign C2 = | {A[3:0], B[3:0]};
	
	//for the and reduction
	assign C3 = & {A[3:0], B[3:0]};
	
	//for the concatenation
	assign C4 = {A[3:0], B[3:0]};
	
	always_comb
	begin
	case(Function)
		0: ALUout = C1;
		1: if (C2) ALUout = 8'b00000001;
		else ALUout = 8'b00000000;
		2: if (C3) ALUout = 8'b00000001;
		else ALUout = 8'b00000000;
		3: ALUout = C4;
		default: ALUout = 8'b00000000;
	endcase
	end 	
endmodule
	