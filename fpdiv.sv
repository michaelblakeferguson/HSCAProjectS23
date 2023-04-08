module mux4 (input [27:0] in1,
             input [27:0] in2,
			 input [27:0] in3,
			 input [27:0] in4,
			 input [1:0]  sel,
			 output [27:0] mux_out);
	
	assign mux_out = sel[1] ? (sel[0] ? in4 : in3) : (sel[0] ? in2 : in1);
	
endmodule

module mux3 (input [27:0] in1,
             input [27:0] in2,
			 input [27:0] in3,
			 input [1:0]  sel,
			 output [27:0] mux_out);
	
	//if sel_muxa = 11 it is dont care since there is only 3 inputs
	assign mux_out = sel[1] ? (sel[0] ? 24'bX : in3) : (sel[0] ? in2 : in1);
	
endmodule

module flopenr (input  logic clk,
				input  logic reset,
				input  logic en,
				input  logic [27:0] d, 
				output logic [270] q);

    always_ff @(posedge clk)
		if (reset)   q <= #1 0;
		else if (en) q <= #1 d;
		
endmodule

module fpdiv (d, x, sel_muxa, sel_muxb, loada, loadb, loadc);

	assign ia_out = 24'h60_0000;
	
	mux3 muxa(rega_out,d,ia_out,sel_muxa,muxa_out);
	mux4 muxb(d,x,regb_out,regc_out,sel_muxb,muxb_out);
	mul_out = muxa_out * muxb*out;
	
	assign ones_comp = ~mul_out[27:0];
	
	//rega
	flopenr rega(loada&clk,rne_out[27:0],rega_out);
	
	//regb
	flopenr regb(loadb&clk,rne_out[23:0],regb_out);
	
	//regc
	flopenr regc(loadc&clk,rne_out[23:0],regc_out);
	
endmodule

