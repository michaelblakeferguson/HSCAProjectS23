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
		if (reset)   q <= 0;
		else if (en) q <= D_f;
		
endmodule

module mult_cs (input logic [27:0] a,
				input logic [27:0] b,
				output logic [55:0] sum,
				output logic [55:0] carry);

   // PP array
   logic [55:0] 	      pp_array [0:27];
   logic [55:0] 	      next_pp_array [0:27];   
   logic [55:0] 	      tmp_sum, tmp_carry;
   logic [55:0] 	      temp_pp;
   logic [55:0] 	      tmp_pp_carry;
   logic [27:0] 	      temp_b;
   logic 		      temp_bitgroup;	
   integer 		      bit_pair, height, i;      

   always_comb
     begin 
	// For each multiplicand PP generation
	for (bit_pair=0; bit_pair < 28; bit_pair=bit_pair+1)
	  begin
	     // Shift to the right via P&H
	     temp_b = (b >> (bit_pair));	     	     
	     temp_bitgroup = temp_b[0];
	     // PP generation
	     case (temp_bitgroup)
               1'b0 : temp_pp = {55{1'b0}};
               1'b1 : temp_pp = a;
               default : temp_pp = {55{1'b0}};
	     endcase
	     // Shift to the left via P&H
	     temp_pp = temp_pp << (bit_pair);
	     pp_array[bit_pair] = temp_pp;
	  end 

	// Height is multiplier
	height = 28;

	// Wallace Tree PP reduction
	while (height > 2)
	  begin
	     for (i=0; i < (height/3); i=i+1)
	       begin
		  next_pp_array[i*2] = pp_array[i*3]^pp_array[i*3+1]^pp_array[i*3+2];		  
		  tmp_pp_carry = (pp_array[i*3] & pp_array[i*3+1]) |
				 (pp_array[i*3+1] & pp_array[i*3+2]) |
				 (pp_array[i*3] & pp_array[i*3+2]);
		  next_pp_array[i*2+1] = tmp_pp_carry << 1;
	       end
	     // Reasssign not divisible by 3 rows to next_pp_array
	     if ((height % 3) > 0)
	       begin
		  for (i=0; i < (height % 3); i=i+1)
		    next_pp_array[2 * (height/3) + i] = pp_array[3 * (height/3) + i];
	       end
	     // Put back values in pp_array to start again
	     for (i=0; i < 28; i=i+1) 
               pp_array[i] = next_pp_array[i];
	     // Reduce height
	     height = height - (height/3);
	  end
	// Sum is first row in reduced array
	tmp_sum = pp_array[0];
	// Carry is second row in reduced array
	tmp_carry = pp_array[1];
     end 

   assign sum = tmp_sum;
   assign carry = tmp_carry;

endmodule

module fpdiv (input [27:0] d,
			  input [27:0] x,
			  input [7:0] d_exp,
			  input [7:0] x_exp,
			  input d_sign,
			  input x_sign,
			  input [1:0] sel_muxa,
			  input [1:0] sel_muxb,
			  input enA,
			  input enB,
			  input enC,
			  input enR,
			  input rMode,
			  input clock,
			  input reset);
			  
	reg [55:0] mul_out;
	reg [55:0] carry_out;
	reg [55:0] sum_out;
	reg [55:0] ones_comp;
	reg [27:0] rega_out;
	reg [27:0] regb_out;
	reg [27:0] regc_out;
	reg [27:0] regr_out;
	reg [27:0] muxa_out;
	reg [27:0] muxb_out;
	reg [27:0] muxr_out;
	reg [27:0] ia;
	reg [27:0] rem;
	reg [27:0] Q_out1;
	reg [27:0] Qp1_out1;
	reg [27:0] Qm1_out1;
	reg [27:0] Q_out0;
	reg [27:0] Qp1_out0;
	reg [27:0] Qm1_out0;
	reg [27:0] Q;
	reg [27:0] Qp1;
	reg [27:0] Qm1;
	reg [1:0] sel_muxr;
	reg [27:0] k_q;
	reg [27:0] k_qp;
	reg [27:0] k_qm;
	reg [22:0] man_out;
	reg [22:0] mantissa;
	reg [7:0] exp_out;
	reg [7:0] exp_out1;
	reg [7:0] exponent;
	reg sign;
	reg [31:0] resultOut;
	
	reg c1;
	reg c2;
	reg c3;
	reg c4;
	reg c5;
	reg c6;

	assign ia = 28'b0110_0000_0000_0000_0000_0000_0000;
	
	mux3 muxa(rega_out,d,ia,sel_muxa,muxa_out);
	mux4 muxb(d,x,regb_out,regc_out,sel_muxb,muxb_out);
	
	mult_cs wallace(muxa_out,muxb_out,sum_out,carry_out);
	
	assign mul_out = sum_out + carry_out;
	assign ones_comp = ~mul_out;
	
	flopenr rega(clock,reset,enA,(ones_comp[54:27]),rega_out);
	flopenr regb(clock,reset,enB,(mul_out[54:27]),regb_out);
	flopenr regc(clock,reset,enC,(mul_out[54:27]),regc_out);
	
	////////////////////////////////////////////////////////
	
	flopenr regr(clock,reset,enR,(mul_out[54:27]),regr_out);
	
	assign k_q  = 28'b0000_0000_0000_0000_0000_0000_0100;
	assign k_qp = 28'b0000_0000_0000_0000_0000_0001_0100;
	assign k_qm = 28'b1111_1111_1111_1111_1111_1111_0011;
	
	assign rem = x - regr_out;
	
	always @(*)
	begin
		//[1,2) q1
		assign {c1,Q_out1}   = regb_out + k_q;         //trunc
		assign {c2,Qp1_out1} = regb_out + k_qp;        //inc
		assign {c3,Qm1_out1} = regb_out + k_qm + 1'b1; //dec
		
		//[0.5,1) q0
		assign {c4,Q_out0}   = {regb_out[26:0],1'b0} + k_q;            //trunc
		assign {c5,Qp1_out0} = {regb_out[26:0],1'b0} + k_qp;           //inc
		assign {c6,Qm1_out0} = {regb_out[26:0],1'b0} + k_qm + 1'b1;    //dec
	
		if (Q_out1[27] == 1)
		begin
			assign Q = Q_out1;
			assign Qp1 = Qp1_out1;
			assign Qm1 = Qm1_out1;
		end else
		begin
			assign Q = Q_out0;
			assign Qp1 = Qp1_out0;
			assign Qm1 = Qm1_out0;
		end
	
	end
		
	always_comb
	begin
		case(rMode)
			1'b0:
				//RZ logic
				case(rem[4]) //guard bit
					1'b0:
						case (rem)
							28'b0: assign sel_muxr = 2'b00;
							default:
								case(rem[27])
									1'b0: assign sel_muxr = 2'b00;
									1'b1: assign sel_muxr = 2'b01;
									default: assign sel_muxr = 2'bXX;
								endcase
						endcase
					1'b1:
						assign sel_muxr = 2'b00;
					default: assign sel_muxr = 2'bXX;   
				endcase
			1'b1:
				//RNE logic
				case(rem[4]) //guard bit
					1'b0:
						assign sel_muxr = 2'b00;
					1'b1:
						case(rem[27])
							1'b0: assign sel_muxr = 2'b01;
							1'b1: assign sel_muxr = 2'b00;
							default: assign sel_muxr = 2'bXX;
						endcase
					default: assign sel_muxr = 2'bXX;   
				endcase
		endcase
	end
	
	mux3 muxr(Q,Qm1,Qp1,sel_muxr,muxr_out);
	assign man_out = muxr_out[26:4];
	
	//add 1 for RNE
	always_comb
	begin
		if (rMode == 1'b1)
		begin
			assign mantissa = man_out + 1'b1;
		end
		if (rMode == 1'b0)
		begin
			assign mantissa = man_out;
		end
	end
	
	//exponent bit calculation
	always_comb
	begin
		assign exp_out = d_exp - x_exp;
		assign exp_out1 = ~(exp_out - 127);
		if (Q_out1[27] == 1)
		begin
			assign exponent = exp_out1 + 1;
		end else
		begin
			assign exponent = exp_out1;
		end
	end
	
	//sign bit calculation
	always_comb
	begin
		if ((d_sign == 1'b0) && (x_sign == 1'b0))
		begin
			assign sign = 1'b0;
		end else if ((d_sign == 1'b1) && (x_sign == 1'b1))
		begin
			assign sign = 1'b0;
		end else
		begin
			assign sign = 1'b1;
		end
	end
	
	always_comb
	begin
		assign resultOut = {sign,exponent,mantissa};
	end
	
endmodule
