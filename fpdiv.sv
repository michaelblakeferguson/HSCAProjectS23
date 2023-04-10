`timescale 1ns / 1ps

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

	assign mux_out = sel[1] ? (sel[0] ? 27'bX : in3) : (sel[0] ? in2 : in1);
	
endmodule

module flopenr (input  logic clock,
				input  logic reset,
				input  logic en,
				input  logic [27:0] D_f, 
				output logic [27:0] q);

    always_ff @(posedge clock)
		if (reset)   q <= 0;   //removed #1 delay
		else if (en) q <= D_f; //removed #1 delay
		
endmodule

module fpdiv (input [27:0] d,
			  input [27:0] x,
			  input [1:0] sel_muxa,
			  input [1:0] sel_muxb,
			  input enA,
			  input enB,
			  input enC,
			  input clock,
			  input reset);
			  
	reg [55:0] mul_op;
	reg [27:0] ones_comp;
	reg [27:0] rega_out;
	reg [27:0] regb_out;
	reg [27:0] regc_out;
	reg [27:0] muxa_out;
	reg [27:0] muxb_out;
	reg [27:0] ia;
	reg [27:0] mul_out;

	assign ia = 28'b0110_0000_0000_0000_0000_0000_0000; //0x6000000
	
	mux3 muxa(rega_out,d,ia,sel_muxa,muxa_out);
	mux4 muxb(d,x,regb_out,regc_out,sel_muxb,muxb_out);
	
	assign mul_op = muxa_out * muxb_out;
	assign mul_out = mul_op[55:28];
	assign ones_comp = {mul_out[27],~mul_out[26:0]};
	
	flopenr rega(clock,reset,enA,ones_comp,rega_out);
	flopenr regb(clock,reset,enB,mul_out,regb_out);
	flopenr regc(clock,reset,enC,mul_out,regc_out);
	
endmodule

