module mux4 (input [27:0] in1,
             input [27:0] in2,
			 input [27:0] in3,
			 input [27:0] in4,
			 input [1:0]  sel,
			 output [27:0] mux_out);
	
	assign mux_out = sel[1] ? (sel[0] ? in4 : in3) : (sel[0] ? in2 : in1);
	
endmodule