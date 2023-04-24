`timescale 1ns / 1ps
module tb ();

    logic [27:0] d;
    logic [27:0] x;
	logic [7:0] d_exp;
	logic [7:0] x_exp;
	logic d_sign;
	logic x_sign;
    logic [1:0]  sel_muxa;
    logic [1:0]  sel_muxb;
    logic        enA;
    logic        enB; 
    logic        enC;
	logic        enR;
	logic        rMode;
	logic        clk;
	logic        reset;
	
	//////////////////////////////////////////////////////////
	
	logic [103:0] testvectors[50000:0]; // array of testvectors
	
	integer 	file;
	
	logic [31:0] xBits;
	logic [31:0] dBits;
	logic [31:0] outExp;
	logic [7:0]  flags;
	
	logic [27:0] manX;
	logic [27:0] manD;
	logic [7:0] expX;
	logic [7:0] expD;
	logic signX;
	logic signD;
	
	logic [14:0] test;
	logic [14:0] errors;
	logic [14:0] passes;
	logic [31:0] result;
	
	/////////////////////////////////////////////////////////////
	
    // instantiate device under test
    fpdiv dut (d,x,d_exp,x_exp,d_sign,x_sign,sel_muxa,sel_muxb,enA,enB,enC,enR,rMode,clk,reset);

    // 2 ns clock
    initial 
    begin	
		clk = 1'b1;
		forever #10 clk = ~clk;
    end
	
	initial
    begin
		file = $fopen("f32_div_rz.out");
		$readmemh("f32_div_rz.tv", testvectors);
		test = 0;
		errors = 0;
		passes = 0;
    end
	
	always
    begin
		#0 reset = 1'b1;
		
		#1 {xBits, dBits, outExp, flags} = testvectors[test];
		#0 signX = xBits[31];
		#0 signD = dBits[31];
		#0 expX = xBits[30:23];
		#0 expD = dBits[30:23];
		#0 manX = {1'b1,xBits[22:0],4'b0};
		#0 manD = {1'b1,dBits[22:0],4'b0};
		
		#0 x = manX;
		#0 d = manD;
		#0 x_exp = expX;
		#0 d_exp = expD;
		#0 x_sign = signX;
		#0 d_sign = signD;
		
		#0 sel_muxa = 2'b10;
		#0 sel_muxb = 2'b01;
		#0 enA = 1'b0;
		#0 enB = 1'b0;
		#0 enC = 1'b0;
		#0 enR = 1'b0;
		#0 rMode = 1'b0;
	
		#20  reset = 1'b0;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b10;
		#0   sel_muxb = 2'b00;
		
		#10  enA = 1'b1;
		#0   enB = 1'b0;
		#0   enC = 1'b1;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b10;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b11;
		
		#10  enA = 1'b1;
		#0   enB = 1'b0;
		#0   enC = 1'b1;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b10;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b11;
		
		#10  enA = 1'b1;
		#0   enB = 1'b0;
		#0   enC = 1'b1;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b10;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b11;
		
		#10  enA = 1'b1;
		#0   enB = 1'b0;
		#0   enC = 1'b1;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b10;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b11;
		
		#10  enA = 1'b1;
		#0   enB = 1'b0;
		#0   enC = 1'b1;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#10  sel_muxa = 2'b00;
		#0   sel_muxb = 2'b10;
		
		#10  enA = 1'b0;
		#0   enB = 1'b1;
		#0   enC = 1'b0;
		
		#20  enA = 1'b0;
		#0   enB = 1'b0;
		#0   enC = 1'b0;
		
		#0 result = {dut.sign,dut.exponent,dut.mantissa};
		
		if (result != outExp)
		begin
			#0  $fdisplay(file, "Test %d:                       ERROR!", test);
			errors = errors + 1;
		end else
		begin
			#0  $fdisplay(file, "Test %d:   PASS", test);
		end
		
		#0  $fdisplay(file, "              x: %h\n              d: %h\n         result: %h\n       expected: %h\n\n", xBits, dBits, result, outExp);

		test = test + 1;
	
		if (test == 30976)
		begin
			passes = test - errors;
			#0  $fdisplay(file,"Total Tests: %d\nPASS: %d\nERRORS: %d", test, passes, errors);
			$finish;
		end
	
    end
	
endmodule