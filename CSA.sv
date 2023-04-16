module CSA (input  logic [7:0] a, [7:0] b, [0:0] c_0,
            output logic [7:0] s);
	
	reg p_0;
	reg p_1;
	reg p_2;
	reg p_3;
	reg p_4;
	reg p_5;
	reg p_6;
	reg p_7;
	
	reg c_1;
	reg c_2;
	reg c_3;
	reg c_4;
	reg c_5;
	reg c_6;
	reg c_7;
	
	reg sel_1;
	reg sel_2;
	reg c4_s; //this is the output of Block 1 mux2
	
	reg s_0;
	reg s_1;
	reg s_2;
	reg s_3;
	reg s_4;
	reg s_5;
	reg s_6;
	reg s_7;
	
	//Find carry and sum bits for Block 1
	assign {c_1,s_0} = c_0 + a[0] + b[0];
	assign {c_2,s_1} = c_1 + a[1] + b[1];
	assign {c_3,s_2} = c_2 + a[2] + b[2];
	assign {c_4,s_3} = c_3 + a[3] + b[3];
	
	assign p_0 = a[0] || b[0];
	assign p_1 = a[1] || b[1];
	assign p_2 = a[2] || b[2];
	assign p_3 = a[3] || b[3];
	assign p_4 = a[4] || b[4];
	assign p_5 = a[5] || b[5];
	assign p_6 = a[6] || b[6];
	assign p_7 = a[7] || b[7];
	
	assign sel_1 = p_0 && p_1 && p_2 && p_3;
	assign c_4s  = sel_1 ? c_0 : c_4;
	
	//Find carry and sum bits for Block 2
	assign {c_5,s_4} = c_4s + a[4] + b[4];
	assign {c_6,s_5} = c_5  + a[5] + b[5];
	assign {c_7,s_6} = c_6  + a[6] + b[6];
	assign {c_8,s_7} = c_7  + a[7] + b[7];
	
  //assign sel_2 = p_4 && p_5 && p_6 && p_7;
  //assign c_8s  = sel_2 ? c_4s : c_8;
  
	assign s = {s_7, s_6, s_5, s_4, s_3, s_2, s_1, s_0};

endmodule