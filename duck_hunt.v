//x
// x
//  x
//xxxxxx
//  x  x
// x
//x
// a duck

module duck_hunt(CLOCK_50, KEY, LEDR,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B);
	input CLOCK_50;
	input [1:0] KEY;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]	
	
	wire [7:0] x, new_x;
	wire [6:0] y, new_y;
	wire enable;

	assign x = 8'b0000010;
	assign y = 7'b0001010;
	
	/*
	INSTANTIATE MULTIPLE BIRDS.
	*/
	
	//FSM Stuff
	localparam	ERASE_BIRDS = 3'b000,
				UPDATE_POSITIONS = 3'b001,
				DRAW_BIRDS = 3'b010,
				
				
				

	frame_counter fram (.num(4'b1111), .clock(CLOCK_50), .reset(KEY[1]), .q(1'b1));
	
	vga_adapter VGA(
			.resetn(KEY[0]),
			.clock(CLOCK_50),
			.colour(3'b111),
			.x(new_x),
			.y(new_y),
			.plot(1'b1),
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

module bird(clock, reset, count_en, draw_en);
	input clock, reset, count_en, draw_en;
	
	wire [7:0] x_out;

	bird_counter bcount(
			.clock(clock), 
			.reset(reset), 
			.enable(count_en), 
			.new_x(x_out)
	);
	
	draw d1(
		.clock(clock),
		.x(x_out),
		.y(y_out), 
		.reset(reset),
		.draw_en(draw_en),
		.new_x(x_out), 
		.new_y(y_out)
	);
			
	//assign y_out = random number
endmodule
   
module bird_counter(clock, reset, enable, new_x);
	input clock;
	input reset;
	input enable;
	output [7:0] new_x;
  
	reg [7:0] counter = 0;

	assign new_x = counter;
	always @(posedge clock) begin
	if (reset)
		counter <= 0;
    else if (enable)
		counter <= counter + 1'b1;
	end
endmodule


module draw_bird(clock, x, y, reset, draw_en, new_x, new_y, done);
	input clock;
	input [7:0] x;
	input [6:0] y;
	input reset, draw_en;
	output [7:0] new_x;
	output [6:0] new_y;
	output done;
	
	reg [3:0] current_state, next_state;
	reg [7:0] temp_x;
	reg [6:0] temp_y;
	
	assign new_x = temp_x;
	assign new_y = temp_y;
	
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
			BIRD_0: next_state = BIRD_1;
			BIRD_1: next_state = BIRD_2;
			BIRD_2: next_state = BIRD_3;
			BIRD_3: next_state = BIRD_4;
			BIRD_4: next_state = BIRD_5;
			BIRD_5: next_state = BIRD_6;
			BIRD_6: next_state = BIRD_7;
			BIRD_7: next_state = BIRD_8;
			BIRD_8: next_state = BIRD_9;
			BIRD_9: next_state = BIRD_10;
			BIRD_10: next_state = BIRD_11;
			BIRD_11: next_state = BIRD_12;
			BIRD_12: next_state = END;
			END: next_state = reset ? BIRD_0 : END;
         default:     next_state = END;
      endcase
   end
	
	always @(*)
	begin // set x
		case (current_state)
			BIRD_0: temp_x = draw_en ? x : -1;
			BIRD_1: temp_x = draw_en ? x : -1;
			BIRD_2: temp_x = draw_en ? x - 1 : -1;
			BIRD_3: temp_x = draw_en ? x - 2 : -1;
			BIRD_4: temp_x = draw_en ? x - 3 : -1;
			BIRD_5: temp_x = draw_en ? x - 4 : -1; 
			BIRD_6: temp_x = draw_en ? x - 5 : -1;
			BIRD_7: temp_x = draw_en ? x - 3 : -1;
			BIRD_8: temp_x = draw_en ? x - 3 : -1;
			BIRD_9: temp_x = draw_en ? x - 4 : -1;
			BIRD_10: temp_x = draw_en ? x - 4 : -1;
			BIRD_11: temp_x = draw_en ? x - 5 : -1;
			BIRD_12: temp_x = draw_en ? x - 5 : -1;
      endcase
	end
	
	always @(*)
	begin // set y
		case (current_state)
			BIRD_0: temp_y = draw_en ? y : -1;
			BIRD_1: temp_y = draw_en ? y + 1 : -1;
			BIRD_2: temp_y = draw_en ? y : -1;
			BIRD_3: temp_y = draw_en ? y : -1;
			BIRD_4: temp_y = draw_en ? y : -1;
			BIRD_5: temp_y = draw_en ? y : -1;
			BIRD_6: temp_y = draw_en ? y : -1;
			BIRD_7: temp_y = draw_en ? y + 1 : -1;
			BIRD_8: temp_y = draw_en ? y - 1 : -1;
			BIRD_9: temp_y = draw_en ? y + 2 : -1;
			BIRD_10: temp_y = draw_en ? y - 2 : -1;
			BIRD_11: temp_y = draw_en ? y + 3 : -1;
			BIRD_12: temp_y = draw_en ? y - 3 : -1;
      endcase
	end
   
	always @(posedge clock)
	begin
		if (reset)
			current_state <= BIRD_0;
		else
			current_state <= next_state;
	end
   
	assign done = (current_state == END) ? 1 : 0;
	
endmodule

//module random(num);// output a starting position
//	output [7:0] num;
//	
//	reg [6:0] temp;
//	wire [3:0] layers;
//	wire [4:0] height;
//	
//	assign layers = 3'b111;
//	
//	initial begin
//		temp <= $random$ layers;
//	end
//	
//	assign height = temp*8 + 3'b100;// 8x+4
//	assign num = {4'b000, temp[3:0]};
//	
//endmodule

module frame_counter(num, clock, reset, q); // output 1 if desinated fram number reached.
	input [3:0] num;
	input clock;
	input reset;
	output reg q = 0;
	
	wire count;
	
	reg [3:0] temp = 0;
	
	
	delay_counter delay(
		.clock(clock),
		.reset(reset),
		.q(count)
	);
	
	always @(posedge clock)
	begin
		if (count == 20'b00000000000000000000)
			temp <= temp - 1;
		else if (temp == 0) begin
			temp <= num;
			q <= 1'b1;
		end
		else
			q <= 1'b0;
	end
	
endmodule
	
module delay_counter(clock, reset, q);
	input clock;
	input reset;
	output reg [19:0] q = 0;
	
	always @(posedge clock)
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
