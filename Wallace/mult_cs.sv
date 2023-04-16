//module mult_cs #(parameter WIDTH = 8)
module mult_cs (input logic [27:0] a,
				input logic [27:0] b,
				input logic tc,
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

endmodule // mult_cs
