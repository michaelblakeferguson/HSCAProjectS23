`timescale 1ns / 1ps
module tb ();

   logic   [27:0] in1;
   logic   [27:0] in2;
   logic   [27:0] in3;
   logic   [27:0] in4;
   logic   [1:0]  sel;
   logic   [27:0] mux_out;
   logic          clk;   
   
  // instantiate device under test
   mux4 dut (in1, in2, in3, in4, sel, mux_out);

   // 2 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #10 clk = ~clk;
     end


    initial
    begin
    
		#0   in1 = 28'b0010101010101;	
		#0   in2 = 28'b11111111111111111111;	
		#0   in3 = 28'b0100000010000;
		#0   in4 = 28'b11001100110011001100;
		#0   sel = 2'b01;

		#20   in1 = 28'b0010101010101;	
		#0   in2 = 28'b11111111111111111111;	
		#0   in3 = 28'b0100000010000;
		#0   in4 = 28'b11001100110011001100;
		#0   sel = 2'b00;
	
		#20   in1 = 28'b0010101010101;	
		#0   in2 = 28'b11111111111111111111;	
		#0   in3 = 28'b0100000010000;
		#0   in4 = 28'b11001100110011001100;
		#0   sel = 2'b11;
		
		#20   in1 = 28'b0010101010101;	
		#0   in2 = 28'b11111111111111111111;	
		#0   in3 = 28'b0100000010000;
		#0   in4 = 28'b11001100110011001100;
		#0   sel = 2'b10;
	
    end

   
endmodule