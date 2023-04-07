module mux3 (input [27:0] in1,
             input [27:0] in2,
			 input [27:0] in3,
			 input [1:0]  sel,
			 output [27:0] mux_out);
	
	//if sel_muxa = 11 it is dont care since there is only 3 inputs
	assign mux_out = sel[1] ? (sel[0] ? 24'bX : in3) : (sel[0] ? in2 : in1);
	
endmodule