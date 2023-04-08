`timescale 1ns / 1ps
module tb ();
   
   logic        clock;
   logic        reset;
   logic           en;
   logic [27:0]  D_in; 
   logic [27:0] Q_out;
   logic clk;
   
  // instantiate device under test
   flopenr dut (clock,reset,en,D_in,Q_out);

   // 2 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #10 clk = ~clk;
     end


    initial
    begin
    
		#0   reset = 1'b0;	
		#0   en = 1'b1;	
		#0   D_in = 28'b1000100001000001000000111111;
		#0   clock = 1'b1;
		
		#10  clock = 1'b0;

		#10  reset = 1'b0;	
		#0   en = 1'b1;	
		#0   D_in = 28'b1111100001111111000000110011;
		#0   clock = 1'b1;
		
		#10  clock = 1'b0;
		
		#10  reset = 1'b0;	
		#0   en = 1'b1;	
		#0   D_in = 28'b1100011100000000000011110000;
		#0   clock = 1'b1;
		
		#10  clock = 1'b0;
		
		#10  reset = 1'b0;	
		#0   en = 1'b1;	
		#0   D_in = 28'b1111111111111111111111111111;
		#0   clock = 1'b1;
	
    end

   
endmodule