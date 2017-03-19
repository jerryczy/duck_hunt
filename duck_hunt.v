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
	
module delay_counter(clock, reset, q);
	input clock;
	input reset;
	output reg q;
	
	always @(posedge clock, negedge reset)
	begin
		if (reset == 1'b0)
			q <= 0;
		else if (clock == 1'b1)
			begin
				if (q == 0)
					q <= 20'b11001011011100110110;//(1/60s)
				else
					q <= q - 1'b1;
			end
	end
endmodule

module frame_counter(num, clock, reset, q); // output 1 if desinated fram number reached.
	input num;
	input clock;
	input reset;
	output reg q;
	
	wire count;
	reg temp;
	
	assign temp = num;
	assign q = 1'b0;
	
	delay_counter(
		.clock(clock),
		.reset(reset),
		.q(count)
	);
	
	always @(*)
	begin
		if (count == 20'b00000000000000000000)
			temp <= temp - 1;
		else if (temp == 0)
			temp <= num;
			q <= 1'b1;
		else
			q <= 1'b0;
	end
	
endmodule
