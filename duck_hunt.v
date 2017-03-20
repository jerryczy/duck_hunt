x
 x
  x
xxxxxx
  x  x
 x
x
// a bird

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

//Determines where bird should be drawn based on the bird_shifter value. (Grid based, we will figure out the grid size later).
module bird_pos(shifter, x_out, y_out);
	input [19:0] shifter;
	output reg x_out, y_out;
	
	localparam GRID_SIZE = 20;
	
	always @(*) begin
		if (shifter[19])
			x_out <= 0*GRID_SIZE;
		else if (shifter[18])
			x_out <= 1*GRID_SIZE;
		else if (shifter[17])
			x_out <= 2*GRID_SIZE;
		else if (shifter[16])
			x_out <= 3*GRID_SIZE;
		else if (shifter[15])
			x_out <= 4*GRID_SIZE;
		else if (shifter[14])
			x_out <= 5*GRID_SIZE;
		else if (shifter[13])
			x_out <= 6*GRID_SIZE;
		else if (shifter[12])
			x_out <= 7*GRID_SIZE;
		else if (shifter[11])
			x_out <= 8*GRID_SIZE;
		else if (shifter[10])
			x_out <= 9*GRID_SIZE;
		else if (shifter[9])
			x_out <= 10*GRID_SIZE;
		else if (shifter[8])
			x_out <= 11*GRID_SIZE;
		else if (shifter[7])
			x_out <= 12*GRID_SIZE;
		else if (shifter[6])
			x_out <= 13*GRID_SIZE;
		else if (shifter[5])
			x_out <= 14*GRID_SIZE;
		else if (shifter[4])
			x_out <= 15*GRID_SIZE;
		else if (shifter[3])
			x_out <= 16*GRID_SIZE;
		else if (shifter[2])
			x_out <= 17*GRID_SIZE;
		else if (shifter[1])
			x_out <= 18*GRID_SIZE;
		else if (shifter[0])
			x_out <= 19*GRID_SIZE;	
	end
endmodule

module draw(CLOCK_50, x, y, reset, new_x, new_y);
	input CLOCK_50;
	input [7:0] x;
	input [6:0] y;
	input reset;
	output [7:0] x;
	output [6:0] y;
	
	reg [3:0] current_state, next_state;
	
	localparam  BIRD_0  = 4'b0000,//body 1
					BIRD_1  = 4'b0001,//head
					BIRD_2  = 4'b0010,//body 2
					BIRD_3  = 4'b0011,//body 3
					BIRD_4  = 4'b0100,//body 4
					BIRD_5  = 4'b0101,//body 5
					BIRD_6  = 4'b0110,//body 6
					BIRD_7  = 4'b0111,//up wing 1
					BIRD_8  = 4'b1000,//down wing 1
					BIRD_9  = 4'b1001,//up wing 2
					BIRD_10 = 4'b1010,//down wing 2
					BIRD_11 = 4'b1011,//up wing 3
					BIRD_12 = 4'b1100,//down wing 3
					END     = 4'b1111;
	
	always@(*)
   begin
		case (current_state)
			BIRD_0: nest_state = BIRD_1;
			BIRD_1: nest_state = BIRD_2;
			BIRD_2: nest_state = BIRD_3;
			BIRD_3: nest_state = BIRD_4;
			BIRD_4: nest_state = BIRD_5;
			BIRD_5: nest_state = BIRD_6;
			BIRD_6: nest_state = BIRD_7;
			BIRD_7: nest_state = BIRD_8;
			BIRD_8: nest_state = BIRD_9;
			BIRD_9: nest_state = BIRD_10;
			BIRD_10: nest_state = BIRD_11;
			BIRD_11: nest_state = BIRD_12;
			BIRD_12: nest_state = END;
			END: next_statae = reset ? BIRD_0 : END;
         default:     next_state = END;
      endcase
   end
	
	always @(*)
   begin // set x
		case (current_state)
			BIRD_0: new_x = x;
			BIRD_1: new_x = x;
			BIRD_2: new_x = x - 1;
			BIRD_3: new_x = x - 2;
			BIRD_4: new_x = x - 3;
			BIRD_5: new_x = x - 4;
			BIRD_6: new_x = x - 5;
			BIRD_7: new_x = x - 3;
			BIRD_8: new_x = x - 3;
			BIRD_9: new_x = x - 4;
			BIRD_10: new_x = x - 4;
			BIRD_11: new_x = x - 5;
			BIRD_12: new_x = x - 5;
      endcase
	end
	
	always @(*)
   begin // set y
		case (current_state)
			BIRD_0: new_y = y;
			BIRD_1: new_y = y + 1;
			BIRD_2: new_y = y;
			BIRD_3: new_y = y;
			BIRD_4: new_y = y;
			BIRD_5: new_y = y;
			BIRD_6: new_y = y;
			BIRD_7: new_y = y + 1;
			BIRD_8: new_y = y - 1;
			BIRD_9: new_y = y + 1;
			BIRD_10: new_y = y - 1;
			BIRD_11: new_y = y + 1;
			BIRD_12: new_y = y - 1;
      endcase
	end
   
   always @(posedge CLOCK_50)
	begin:
		if(reset)
			current_state <= BIRD_0;
      else
			current_state <= next_state;
   end
	
endmodule

module random(num);// output a starting position
	output [7:0] num;
	
	reg [6:0] temp;
	wire [3:0] layers;
	wire [4:0] height;
	
	assign layers = 3'b111;
	
	initial begin
		temp <= $urandom$layers;
	end
	
	assign height = temp*8 + 3'b100;// 8x+4
	assign num = {4'b000, temp[3:0]}
	
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
