`timescale 1ns / 1ps
module tb ();

    logic [27:0] d;
    logic [27:0] x;
    logic [1:0]  sel_muxa;
    logic [1:0]  sel_muxb;
    logic        enA;
    logic        enB; 
    logic        enC;
	logic        enR;
	//logic        clock;
	logic        clk;
	logic        reset;
   
    // instantiate device under test
    fpdiv dut (d,x,sel_muxa,sel_muxb,enA,enB,enC,enR,clk,reset);

    // 2 ns clock
    initial 
    begin	
		clk = 1'b1;
		forever #10 clk = ~clk;
    end


    initial
    begin
		#0 reset = 1'b1;
		#0 d = 28'b1100000000000000000000000000;	
		#0 x = 28'b1110000000000000000000000000;
		#0 sel_muxa = 2'b10;
		#0 sel_muxb = 2'b01;
		#0 enA = 1'b0;
		#0 enB = 1'b0;
		#0 enC = 1'b0;
		#0 enR = 1'b0;
    
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
		
		////////////////////////////////////////
		
		//find remainder
		
		#10 sel_muxa = 2'b01;
		#0  sel_muxb = 2'b10;
		
		#10 enR = 1'b1;
		
		#20 enR = 1'b0;
	
    end

endmodule