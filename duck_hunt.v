module duck_hunt();
	
	
	
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x_out),
			.y(y_out),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
		
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
	
module devider(num, clock, reset, clk);
	input num;
	input clock;
	input reset;
	output clk;
	
	wire num;
	reg q;
	
	always @(posedge clock, negedge reset)
	begin
		if (reset == 1'b0)
			clk <= 0;
		else if (clock == 1'b1)
			begin
				if (clk == 0)
					clk <= num;// use 26'b10111110101111000010000000 for now (1/s)
				else
					clk <= clk - 1'b1;
			end
	end
endmodule
