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

//module flopr (input clk,
//			  input [23:0] in,
//			  output [23:0] out);
//			  
//	always @(posedge clk)
//	begin
//		out = in;
//	end
//
//endmodule

module flopenr (input  logic clk,
				input  logic reset,
				input  logic en,
				input  logic [27:0] d, 
				output logic [270] q);

    always_ff @(posedge clk)
		if (reset)   q <= #1 0;
		else if (en) q <= #1 d;
		
endmodule

//Is WIDTH here supposed to be 28 bits due to precision required? -- The output ACCURACY must be 24 bits of precision!
//module mult_cs #(parameter WIDTH = 8) 
//  (a, b, sum, carry);
//
//   input logic [WIDTH-1:0]    a;
//   input logic [WIDTH-1:0]    b;
//   //input logic 		      tc; //removed from input parameters since it is unused
//   
//   output logic [2*WIDTH-1:0] sum;
//   //output logic [2*WIDTH-1:0] carry;
//
//   // PP array
//   logic [2*WIDTH-1:0] 	      pp_array [0:WIDTH-1];
//   logic [2*WIDTH-1:0] 	      next_pp_array [0:WIDTH-1];   
//   logic [2*WIDTH-1:0] 	      tmp_sum, tmp_carry;
//   logic [2*WIDTH-1:0] 	      temp_pp;
//   logic [2*WIDTH-1:0] 	      tmp_pp_carry;
//   logic [WIDTH-1:0] 	      temp_b;
//   logic 		      temp_bitgroup;	
//   integer 		      bit_pair, height, i;      
//
//   always_comb 
//     begin 
//	// For each multiplicand PP generation
//	for (bit_pair=0; bit_pair < WIDTH; bit_pair=bit_pair+1)
//	  begin
//	     // Shift to the right via P&H
//	     temp_b = (b >> (bit_pair));	     	     
//	     temp_bitgroup = temp_b[0];
//	     // PP generation
//	     case (temp_bitgroup)
//              1'b0 : temp_pp = {2*WIDTH-1{1'b0}};
//               1'b1 : temp_pp = a;
//               default : temp_pp = {2*WIDTH-1{1'b0}};
//	     endcase
//	     // Shift to the left via P&H
//	     temp_pp = temp_pp << (bit_pair);d
//	     pp_array[bit_pair] = temp_pp;
//	  end 
//
//	// Height is multiplier
//	height = WIDTH;
//
//	// Wallace Tree PP reduction
//	while (height > 2)
//	  begin
//	     for (i=0; i < (height/3); i=i+1)
//	       begin
//		  next_pp_array[i*2] = pp_array[i*3]^pp_array[i*3+1]^pp_array[i*3+2];		  
//		  tmp_pp_carry = (pp_array[i*3] & pp_array[i*3+1]) |
//				 (pp_array[i*3+1] & pp_array[i*3+2]) |
//				 (pp_array[i*3] & pp_array[i*3+2]);
//		  next_pp_array[i*2+1] = tmp_pp_carry << 1;
//	       end
//	     // Reasssign not divisible by 3 rows to next_pp_array
//	     if ((height % 3) > 0)
//	       begin
//		  for (i=0; i < (height % 3); i=i+1)
//		    next_pp_array[2 * (height/3) + i] = pp_array[3 * (height/3) + i];
//	       end
//	     // Put back values in pp_array to start again
//	     for (i=0; i < WIDTH; i=i+1) 
//               pp_array[i] = next_pp_array[i];
//	     // Reduce height
//	     height = height - (height/3);
//	  end
//	// Sum is first row in reduced array
//	tmp_sum = pp_array[0];
//	// Carry is second row in reduced array
//	tmp_carry = pp_array[1];
//     end 
//
//   assign sum = tmp_sum;
//   //assign carry = tmp_carry; //Is carry necessary for the multiplication?
//                               //Is this related to the sticky bit?
//
//endmodule


module fpdiv (d, x, sel_muxa, sel_muxb, loada, loadb, loadc);

	//IA
	//this should be a case statement?
	assign ia_out = 24'h60_0000;
	
	//muxa
	mux3 muxa(rega_out,d,ia_out,sel_muxa,muxa_out);
	
	//muxb
	mux4 muxb(d,x,regb_out,regc_out,sel_muxb,muxb_out);
	
	//multiplier
	//mult_cs #(28) mult(muxa_out,muxb_out,rne_out)
	mul_out = muxa_out * muxb*out;
	
	assign ones_comp = ~mul_out[27:0];
	
	//rega
	flopr rega(loada&clk,rne_out[27:0],rega_out);
	
	//regb
	flopr regb(loadb&clk,rne_out[23:0],regb_out);
	
	//regc
	flopr regc(loadc&clk,rne_out[23:0],regc_out);
	
endmodule

//Q's:
//where is q generated? inside the wallace multiplier?
//what is the carry used for, is this related to the sticky bit?
//     ^why is the carry not a single bit?
//are the register contents output back to the control logic each iteration?
//     ^(see parameters for the given division HDL algorithm)
//load_reg variables are control logic for which register is stored each iteration?
//the wallace multiplier code given needs to be modified to insert the RNE logic?
//still need to set up testbench for simulation
//     ^simplest test case to understand the algorithm & control logic?

