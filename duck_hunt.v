//x
// x
//  x
//xxxxxx
//  x  x
// x
//x
// a duck

module duck_hunt(CLOCK_50, KEY, SW
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
	input [9:7] SW;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]	
	
	wire [7:0] plot_x_1, plot_x_2, plot_x_3, plot_x_4, plot_x_5, plot_x_6, plot_x_h, x_out;
	wire [6:0] plot_y_1, plot_y_2, plot_y_3, plot_y_4, plot_y_5, plot_y_6, plot_y_h, y_out;
	wire draw_en;
	wire frame_reached;
	wire done_draw_1, done_draw_2, done_draw_3, done_draw_4, done_draw_5, done_draw_h;
	wire bird_finish;
	wire [1:0] num;	
	wire [2:0] colour;
	reg [2:0] current_state, next_state;
	
	assign [2:0] num = [9:7] SW;

	/*
	INSTANTIATE MULTIPLE BIRDS.
	*/
	bird b1(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_1), .y_out(plot_y_1), .done(done_draw_1));
	bird b2(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_2), .y_out(plot_y_2), .done(done_draw_2));
	bird b3(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_3), .y_out(plot_y_3), .done(done_draw_3));
	bird b4(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_4), .y_out(plot_y_4), .done(done_draw_4));
	bird b5(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_5), .y_out(plot_y_5), .done(done_draw_5));
	bird b6(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_6), .y_out(plot_y_6), .done(done_draw_6));
	bird b7(.clock(frame_reached), .num(num), .reset(KEY[0]), .count_en(count_en), .draw_en(draw_en), .x_out(plot_x_7), .y_out(plot_y_7), .done(done_draw_7));
	
	/**
	CONTROL BIRD
	*/
	localparam	HOLD = 4'b0,
					ERASE_BIRDS_1 = 4'b1,
					DRAW_BIRDS_1 = 4'b2,
					ERASE_BIRDS_2 = 4'b3,
					DRAW_BIRDS_2 = 4'b4,
					ERASE_BIRDS_3 = 4'b5,
					DRAW_BIRDS_3 = 4'b6,
					ERASE_BIRDS_4 = 4'b7,
					DRAW_BIRDS_4 = 4'b8,
					ERASE_BIRDS_5 = 4'b9,
					DRAW_BIRDS_5 = 4'b10,
					ERASE_BIRDS_6 = 4'b11,
					DRAW_BIRDS_6 = 4'b12,
					ERASE_HUNTER = 4'b13,
					DRAW_HUNTER = 4'b15;
				
	always@(*) 
	begin
		case (current_state) //when frame is reached, we must erase old birds and draw new birds.
			HOLD: next_state = (posedge CLOCK_50) ? ERASE_BIRDS : HOLD;
			ERASE_BIRDS_1: next_state = done_draw_1 ? DRAW_BIRDS_1 : ERASE_BIRDS_1;
			DRAW_BIRDS_1: next_state = done_draw_1 ? ERASE_BIRDS_1 : DRAW_BIRDS_1;
			ERASE_BIRDS_2: next_state = done_draw_2 ? DRAW_BIRDS_2 : ERASE_BIRDS_2;
			DRAW_BIRDS_2: next_state = done_draw_2 ? ERASE_BIRDS_2 : DRAW_BIRDS_2;
			ERASE_BIRDS_3: next_state = done_draw_3 ? DRAW_BIRDS_3 : ERASE_BIRDS_3;
			DRAW_BIRDS_3: next_state = done_draw_3 ? ERASE_BIRDS_3 : DRAW_BIRDS_3;
			ERASE_BIRDS_4: next_state = done_draw_4 ? DRAW_BIRDS_4 : ERASE_BIRDS_4;
			DRAW_BIRDS_4: next_state = done_draw_4 ? ERASE_BIRDS_4 : DRAW_BIRDS_4;
			ERASE_BIRDS_5: next_state = done_draw_5 ? DRAW_BIRDS_5 : ERASE_BIRDS_5;
			DRAW_BIRDS_5: next_state = done_draw_5 ? ERASE_BIRDS_5 : DRAW_BIRDS_5;
			ERASE_BIRDS_6: next_state = done_draw_6 ? DRAW_BIRDS_6 : ERASE_BIRDS_6;
			DRAW_BIRDS_6: next_state = done_draw_6 ? ERASE_HUNTER : DRAW_BIRDS_6;
			ERASE_HUNTER: next_state = done_draw_h ? DRAW_HUNTER : ERASE_HUNTER;
			DRAW_HUNTER: next_state = done_draw_h ? HOLD : DRAW_HUNTER;
			//each bird will have draw_en, and if their draw_en isn't enabled, 
			//and if we reach one bird with draw_en disabled, then we go to next state.
		endcase
	end
		
	always@(posedge CLOCK_50)
	begin
		if (KEY[0])
			current_state <= DRAW_BIRDS_1;
		else
			current_state <= next_state;
	end
	
	/**
	*DATAPATH
	*num indicate the number of birds appears on the screen
	*/
	always@(*) 
	begin // set colour
		case (current_state)
			ERASE_BIRDS_1: colour = 3'b000;
			DRAW_BIRDS_1: colour = 3'b111;
			ERASE_BIRDS_2: erase = 1'b1;
			DRAW_BIRDS_2: begin
				if (num < 4'b3)
					colour = 3'b000;
				else
					colour = 3'b111;
			end
			ERASE_BIRDS_3: colour = 3'b000;
			DRAW_BIRDS_3: begin
				if (num < 4'b4)
					colour = 3'b000;
				else
					colour = 3'b111;
			end
			ERASE_BIRDS_4: colour = 3'b000;
			DRAW_BIRDS_4: begin
				if (num < 4'b5)
					colour = 3'b000;
				else
					colour = 3'b111;
			end
			ERASE_BIRDS_5: colour = 3'b000;
			DRAW_BIRDS_5: begin
				if (num < 4'b6)
					colour = 3'b000;
				else
					colour = 3'b111;
			end
			ERASE_BIRDS_6: colour = 3'b000;
			DRAW_BIRDS_6: begin
				if (num < 4'b7)
					colour = 3'b000;
				else
					colour = 3'b111;
			end
			ERASE_HUNTER: colour = 3'b000;
			DRAW_HUNTER: colour = 3'b001;
		endcase
	end
	
	always@(*) 
	begin // set position x
		case (current_state)
			ERASE_BIRDS_1: x_out = plot_x_1;
			DRAW_BIRDS_1: x_out = plot_x_1;
			ERASE_BIRDS_2: x_out = plot_x_2;
			DRAW_BIRDS_2: x_out = plot_x_2;
			ERASE_BIRDS_3: x_out = plot_x_3;
			DRAW_BIRDS_3: x_out = plot_x_3;
			ERASE_BIRDS_4: x_out = plot_x_4;
			DRAW_BIRDS_4: x_out = plot_x_4;
			ERASE_BIRDS_5: x_out = plot_x_5;
			DRAW_BIRDS_5: x_out = plot_x_5;
			ERASE_BIRDS_6: x_out = plot_x_6;
			DRAW_BIRDS_6: x_out = plot_x_6;
			ERASE_HUNTER: x_out = plot_x_h;
			DRAW_HUNTER: x_out = plot_x_h;
		endcase
	end
	
	always@(*) 
	begin // set position y
		case (current_state)
			ERASE_BIRDS_1: y_out = plot_y_1;
			DRAW_BIRDS_1: y_out = plot_y_1;
			ERASE_BIRDS_2: y_out = plot_y_2;
			DRAW_BIRDS_2: y_out = plot_y_2;
			ERASE_BIRDS_3: y_out = plot_y_3;
			DRAW_BIRDS_3: y_out = plot_y_3;
			ERASE_BIRDS_4: y_out = plot_y_4;
			DRAW_BIRDS_4: y_out = plot_y_4;
			ERASE_BIRDS_5: y_out = plot_y_5;
			DRAW_BIRDS_5: y_out = plot_y_5;
			ERASE_BIRDS_6: y_out = plot_y_6;
			DRAW_BIRDS_6: y_out = plot_y_6;
			ERASE_HUNTER: y_out = plot_y_h;
			DRAW_HUNTER: y_out = plot_y_h;
		endcase
	end

	/**
	MODULE INSTANTIATIONS
	*/
	frame_counter fram (.num(4'b1111), .clock(CLOCK_50), .reset(KEY[1]), .q(frame_reached));
	
	vga_adapter VGA(
		.resetn(KEY[0]),
		.clock(CLOCK_50),
		.colour(colour),
		.x(x_out),
		.y(y_out),
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

module bird(clock, num, reset, draw_en, x_out, y_out, done);
	input clock;
	input [1:0] num;
	input reset, draw_en;
	output [7:0] x_out;
	output [6:0] y_out;
	output done;

	bird_counter bcount(
		.clock(clock), 
		.reset(reset), 
		.enable(draw_en), 
		.new_x(x));
	
	random num1(
		.clock(clock),
		.reset(reset),
		.y(y));
		
	wire [7:0] x;
	wire [6:0] y;
		
	draw_bird d1(
		.clock(clock),
		.x(x),
		.y(y), 
		.reset(reset), 
		.draw_en(draw_en),
		.new_x(x_out), 
		.new_y(y_out),
		.done(done));
		
endmodule
   
module bird_counter(clock, reset, enable, new_x);
	input clock;
	input reset;
	input enable;
	output [7:0] new_x;
  
	reg [7:0] counter = 5;

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
					
	reg [3:0] current_state = BIRD_0;
	reg [3:0] next_state;
	
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

module random(clock, reset, y);
	input clock;
   input reset;
   output [6:0] y;
	
	reg [2:0] num, num_next;
	
	assign y = num * 4'b1000 + 3'b100

	always @* begin
		num_next[2] = num[2]^num[0];
		num_next[1] = num[1]^num_next[2];
		num_next[0] = num[0]^num_next[1];
	end

	always @(posedge clock or negedge reset)
		if(!reset)
			num <= 4'b0110;
		else if ()
			num <= num_next;
endmodule

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
