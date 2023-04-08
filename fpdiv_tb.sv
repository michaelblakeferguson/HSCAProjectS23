`timescale 1ns / 1ps
module tb ();

   logic   d;
   logic   x;
   logic   sel_muxa;
   logic   sel_muxb;
   logic   loada;
   logic   loadb; 
   logic   loada;
   
  // instantiate device under test
   fpdiv dut (d,x,sel_muxa,sel_muxb,loada,loadb,loadc);

   // 2 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #10 clk = ~clk;
     end


    initial
    begin
    
		#0   d = 1'b0;	
		#0   x = 1'b1;	
		#0   sel_muxa = 1'b0;
		#0   sel_muxb = 2'b0;
		#0   loada = 1'b0;
		#0   loadb = 1'b0;
		#0   loadc = 1'b0;

		#20   d = 1'b0;	
		#0   x = 1'b1;	
		#0   sel_muxa = 1'b0;
		#0   sel_muxb = 2'b0;
		#0   loada = 1'b0;
		#0   loadb = 1'b0;
		#0   loadc = 1'b0;
	
    end

   
endmodule