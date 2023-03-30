module fpdiv (q, rega_out, regb_out, regc_out, d, x, sel_muxa, sel_muxb, reset, clk, load_rega, load_regb, load_regc);

	assign ia_out = 24'h60_0000;
	mux4 #(24) mux2 (d, x, regb_out, regc_out, sel_muxb, muxb_out);
	mux3 #(24) mux3 (rega_out, d, ia_out, sel_muxa, muxa_out);
	
	//multiply
	assign mul_out = muxa_out * muxb_out;
	
	//determine ulp for rne (G * (L + R + sticky))
	assign sticky = |mul_out[20:0];
	assign ulp = mul_out[22] & (mul_out[23] | mul_out[21] | sticky);
	
	//rne
	adder #(24) add1 (mul_out[46:23], {23'h0, ulp}, rne_out);
	
	//two's complement
	adder #(24) add2 (~rne_out[23:0], {23'h0,vdd}, twocmp_out);
	
	//regs
	flopr #(24) rega (load_rega & clk, reset, twocmp_out, rega_out);
	flopr #(24) regb (load_regb & clk, reset, rne_out, regb_out);
	flopr #(24) regc (load_regc & clk, reset, rne_out, regc_out);
	assign q = regb_out;
endmodule