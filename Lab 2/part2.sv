//Lab 2 Part 2
//Diba Alam & Mikayla Banman

module mux2to1(input logic x, y, s, output logic m);

	logic Connection1;
	logic Connection2; 
	logic Connection3; 
	

	v7404 u0(
		.pin1(s), 
		.pin2(Connection1)
		
	);
	
	v7408 u1(
		.pin1(x),
		.pin2(Connection1), 
		.pin3(Connection2),
		.pin4(s), 
		.pin5(y), 
		.pin6(Connection3)
	);
	
	v7432 u2(
		.pin1(Connection2),
		.pin2(Connection3),
		.pin3(m)
	);
	
endmodule

module v7404 (input logic pin1, pin3, pin5, pin9, pin11, pin13, output logic pin2, pin4, pin6, pin8, pin10, pin12);
	assign pin2 = ~pin1;
	assign pin4 = ~pin3;
	assign pin6 = ~pin5;
	assign pin8 = ~pin9;
	assign pin10 = ~pin11;
	assign pin12 = ~pin13;
endmodule



module v7408 (input logic pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, output logic pin3, pin6, pin8, pin11);
	assign pin3 = pin1 & pin2;
	assign pin6 = pin4 & pin5;
	assign pin8 = pin9 & pin10;
	assign pin11 = pin12 & pin13;
endmodule



module v7432 (input logic pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13, output logic pin3, pin6, pin8, pin11);
	assign pin3 = pin1 | pin2;
	assign pin6 = pin4 | pin5;
	assign pin8 = pin9 | pin10;
	assign pin11 = pin12 | pin13;
endmodule