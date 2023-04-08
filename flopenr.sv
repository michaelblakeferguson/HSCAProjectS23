`timescale 1ns / 1ps

module flopenr (input  logic clock,
				input  logic reset,
				input  logic en,
				input  logic [27:0] D_in, 
				output logic [27:0] Q_out);

    always_ff @(posedge clock)
		if (reset)   Q_out <= #1 0;
		else if (en) Q_out <= #1 D_in;
		
endmodule