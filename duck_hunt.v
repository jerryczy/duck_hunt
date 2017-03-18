module duck_hunt();

endmodule

module bird_shifter(clock, load_en, loadnumber, shift_en, s);
  input clock, load_en;
  input [19:0] loadnumber;
  output s;
  
  assign s = shifter;
  
  reg [19:0] shifter; //Figure out length later.
  always @(posedge clock) begin
    if (load)
      shifter <= loadnumber;
    else if (shift_en)
      shifter <= shifter >> 1;
  end
   
    
endmodule

module random(range, num);
	input [6:0] range;
	output [7:0] num;
	
	reg [6:0] temp;
	
	initial begin
		temp <= $urandom$range;
	end
	
	assign num = {1'b0, temp[6:0]}
	
endmodule
