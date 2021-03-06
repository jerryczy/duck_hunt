/* FSM template

	always @(*)
	begin
		case (current_state)
			ERASE_BIRDS_1: ;
			DRAW_BIRDS_1: ;
			ERASE_BIRDS_2: ;
			DRAW_BIRDS_2: ;
			ERASE_BIRDS_3: ;
			DRAW_BIRDS_3: ;
			ERASE_BIRDS_4: ;
			DRAW_BIRDS_4: ;
			ERASE_BIRDS_5: ;
			DRAW_BIRDS_5: ;
			ERASE_BIRDS_6: ;
			DRAW_BIRDS_6: ;
			ERASE_HUNTER: ;
			DRAW_HUNTER: ;
			DRAW_LASER: ;
			ERASE_LASER: ;
		endcase
	end
*/

module duck_hunt(CLOCK_50, KEY, LEDR, SW,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,
		PS2_DAT,
		PS2_CLK);
		
	input CLOCK_50;
	input [3:0] KEY;
	input [6:0] SW;
	output [8:0] LEDR;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]	
	input PS2_DAT, PS2_CLK;
	
	wire [7:0] x_out [0:6];
	wire [7:0] test_x, x_out_h, hunter_pos, x_out_l;
	reg [7:0] plot_x;
	wire [6:0] y_out [0:6];
	wire [6:0] test_y, y_out_h, y_out_l;
	reg [6:0] plot_y;
	reg [2:0] colour;
	reg erase;
	
	wire [4:0] current_state;
	wire frame_reached, one_frame;
	wire [4:0] move_freq;
	wire [6:0] bird_on; 
	wire [6:0] collision; //If there is a collision, reset_counter, so a new bird is effectively spawned.

	wire [6:0] done_draw;
	wire [6:0] reset_draw;
	wire done_draw_h, done_draw_l;
	wire reset_draw_h, reset_draw_l, laser_on;
	
	wire move_l, move_r, shoot, valid, makeBreak;
	wire [7:0] data_in;
	//wire q;
	//assign q = ~KEY[0];
	
	//wire reset;
//	assign LEDR = collision;
	
//	assign reset = (collision == bird_on) ? 1 : 0;
	
	localparam 	HOLD = 5'd0,
				ERASE_BIRD_0 = 5'd1,
				DRAW_BIRD_0 = 5'd2,
				ERASE_BIRD_1 = 5'd3,
				DRAW_BIRD_1 = 5'd4,
				ERASE_BIRD_2 = 5'd5,
				DRAW_BIRD_2 = 5'd6,
				ERASE_BIRD_3 = 5'd7,
				DRAW_BIRD_3 = 5'd8,
				ERASE_BIRD_4 = 5'd9,
				DRAW_BIRD_4 = 5'd10,
				ERASE_BIRD_5 = 5'd11,
				DRAW_BIRD_5 = 5'd12,
				ERASE_BIRD_6 = 5'd13,
				DRAW_BIRD_6 = 5'd14,
				ERASE_HUNTER = 5'd15,
				DRAW_HUNTER = 5'd16,
				ERASE_LASER = 5'd17,
				DRAW_LASER = 5'd18;
				
	assign plot = (current_state == HOLD) ? 0 : 1;
	
	/*
	Datapath (Not a separate module because Verilog won't let you pass 2D arrays as input for some reason).
	*/
	always @(*)
	begin
		colour = 3'b000;
		erase = 0;
		case (current_state)
			ERASE_BIRD_0: begin
				plot_x = x_out[0];
				plot_y = y_out[0];
				erase = 1;
			end
			DRAW_BIRD_0: begin
				colour = 3'b111;
				plot_x = x_out[0];
				plot_y = y_out[0];
			end
			ERASE_BIRD_1: begin
				plot_x = x_out[1];
				plot_y = y_out[1];
				erase = 1;
			end
			DRAW_BIRD_1: begin
				colour = 3'b111;
				plot_x = x_out[1];
				plot_y = y_out[1];
			end
			ERASE_BIRD_2: begin
				plot_x = x_out[2];
				plot_y = y_out[2];
				erase = 1;
			end
			DRAW_BIRD_2: begin
				colour = 3'b111;
				plot_x = x_out[2];
				plot_y = y_out[2];
			end
			ERASE_BIRD_3: begin
				plot_x = x_out[3];
				plot_y = y_out[3];
				erase = 1;
			end
			DRAW_BIRD_3: begin
				colour = 3'b111;
				plot_x = x_out[3];
				plot_y = y_out[3];
			end
			ERASE_BIRD_4: begin
				plot_x = x_out[4];
				plot_y = y_out[4];
				erase = 1;
			end
			DRAW_BIRD_4: begin
				colour = 3'b111;
				plot_x = x_out[4];
				plot_y = y_out[4];
			end
			ERASE_BIRD_5: begin
				plot_x = x_out[5];
				plot_y = y_out[5];
				erase = 1;
			end
			DRAW_BIRD_5: begin
				colour = 3'b111;
				plot_x = x_out[5];
				plot_y = y_out[5];
			end
			ERASE_BIRD_6: begin
				plot_x = x_out[6];
				plot_y = y_out[6];
				erase = 1;
			end
			DRAW_BIRD_6: begin
				colour = 3'b111;
				plot_x = x_out[6];
				plot_y = y_out[6];
			end
			ERASE_HUNTER: begin
				plot_x = x_out_h;
				plot_y = y_out_h;
				erase = 1;
			end
			DRAW_HUNTER: begin
				colour = 3'b111;
				plot_x = x_out_h;
				plot_y = y_out_h;
			end
 			DRAW_LASER: begin
				colour = 3'b010;
				plot_x = x_out_l;
				plot_y = y_out_l;
			end
 			ERASE_LASER: begin
				colour = 3'b000;
				plot_x = x_out_l;
				plot_y = y_out_l;
			end
			default: begin
				colour = 3'b000;
				plot_x = 0;
				plot_y = 0;
			end
		endcase
	end
	
	
	/*
	Module Instantiations
	*/
	bird b0(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd10), .bird_on(bird_on[0]), .reset_counter(1'b0), .reset_draw(reset_draw[0]), .erase(erase), .x_out(x_out[0]), .y_out(y_out[0]), .done(done_draw[0]));
	bird b1(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd24), .bird_on(bird_on[1]), .reset_counter(1'b0), .reset_draw(reset_draw[1]), .erase(erase), .x_out(x_out[1]), .y_out(y_out[1]), .done(done_draw[1]));
	bird b2(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd38), .bird_on(bird_on[2]), .reset_counter(1'b0), .reset_draw(reset_draw[2]), .erase(erase), .x_out(x_out[2]), .y_out(y_out[2]), .done(done_draw[2]));
	bird b3(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd52), .bird_on(bird_on[3]), .reset_counter(1'b0), .reset_draw(reset_draw[3]), .erase(erase), .x_out(x_out[3]), .y_out(y_out[3]), .done(done_draw[3]));
	bird b4(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd66), .bird_on(bird_on[4]), .reset_counter(1'b0), .reset_draw(reset_draw[4]), .erase(erase), .x_out(x_out[4]), .y_out(y_out[4]), .done(done_draw[4]));
	bird b5(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd80), .bird_on(bird_on[5]), .reset_counter(1'b0), .reset_draw(reset_draw[5]), .erase(erase), .x_out(x_out[5]), .y_out(y_out[5]), .done(done_draw[5]));
	bird b6(.cclock(frame_reached), .dclock(CLOCK_50), .y(7'd94), .bird_on(bird_on[6]), .reset_counter(1'b0), .reset_draw(reset_draw[6]), .erase(erase), .x_out(x_out[6]), .y_out(y_out[6]), .done(done_draw[6]));
	
	
	collision_check c0(.laser_x(8'd90), .bird_x(x_out[0]), .q(collision[0]));
	collision_check c1(.laser_x(8'd90), .bird_x(x_out[1]), .q(collision[1]));
	collision_check c2(.laser_x(8'd90), .bird_x(x_out[2]), .q(collision[2]));
	collision_check c3(.laser_x(8'd90), .bird_x(x_out[3]), .q(collision[3]));
	collision_check c4(.laser_x(8'd90), .bird_x(x_out[4]), .q(collision[4]));
	collision_check c5(.laser_x(8'd90), .bird_x(x_out[5]), .q(collision[5]));
	collision_check c6(.laser_x(8'd90), .bird_x(x_out[6]), .q(collision[6]));
	
	keyboard_press_driver k1(.CLOCK_50(CLOCK_50), .valid(valid), .makeBreak(makeBreak), .outCode(data_in), .PS2_DAT(PS2_DAT), .reset(1'b0));
	keyboard kb(.clock(CLOCK_50), .valid(valid), .makeBreak(makeBreak), .data_in(data_in), .move_l(move_l), .move_r(move_r), .shoot(shoot));
	
	hunter h0(.clock(CLOCK_50), .move_l(~KEY[2]), .move_r(~KEY[1]), .reset_draw(reset_draw_h), .x_out(x_out_h), .y_out(y_out_h), .hunter_x(hunter_pos), .done(done_draw_h), .erase(erase));
	draw_laser dl(.clock(CLOCK_50), .x(hunter_pos), .reset_draw_l(reset_draw_l), .laser_on(laser_on), .shoot(~KEY[3]), .reloaded(reloaded), .plot_x(x_out_l), .plot_y(y_out_l), .done(done_draw_l));
	laser_reload lr(.clock(CLOCK_50), .shoot(~KEY[3]), .reloaded(reloaded));
	
	draw_control dc(.clock(CLOCK_50), .one_frame(one_frame), .bird_on(bird_on), .done_draw(done_draw), .done_draw_h(done_draw_h), .done_draw_l(done_draw_l), .reset(reset), .reset_draw(reset_draw), .reset_draw_h(reset_draw_h), .reset_draw_l(reset_draw_l), .laser_on(laser_on), .current_state(current_state));
	bird_control bc(.clock(CLOCK_50), .reset(reset), .KEY(~KEY[0]), .bird_on(bird_on), .move_freq(move_freq));
	
	frame_counter fbird(.num(move_freq), .clock(CLOCK_50), .reset(1'b0), .q(frame_reached));
	rate_divider f1(.clock(CLOCK_50), .reset(1'b0), .one_frame(one_frame));


	vga_adapter VGA(
		.resetn(1'b1),
		.clock(CLOCK_50),
		.colour(colour),
		.x(plot_x),
		.y(plot_y),
		.plot(1'b1),
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

module draw_control(clock, one_frame, bird_on, done_draw, done_draw_h, done_draw_l, reset, reset_draw, reset_draw_h, reset_draw_l, laser_on, current_state);
	input clock, reset, one_frame;
	input [6:0] done_draw, bird_on;
	input done_draw_h, done_draw_l;
	output reg [6:0] reset_draw = 7'b0;
	output reg reset_draw_h, reset_draw_l;
	output reg laser_on;
	
	localparam 	HOLD = 5'd0,
				ERASE_BIRD_0 = 5'd1,
				DRAW_BIRD_0 = 5'd2,
				ERASE_BIRD_1 = 5'd3,
				DRAW_BIRD_1 = 5'd4,
				ERASE_BIRD_2 = 5'd5,
				DRAW_BIRD_2 = 5'd6,
				ERASE_BIRD_3 = 5'd7,
				DRAW_BIRD_3 = 5'd8,
				ERASE_BIRD_4 = 5'd9,
				DRAW_BIRD_4 = 5'd10,
				ERASE_BIRD_5 = 5'd11,
				DRAW_BIRD_5 = 5'd12,
				ERASE_BIRD_6 = 5'd13,
				DRAW_BIRD_6 = 5'd14,
				ERASE_HUNTER = 5'd15,
				DRAW_HUNTER = 5'd16,
				ERASE_LASER = 5'd17,
				DRAW_LASER = 5'd18;
				
				
	output reg [4:0] current_state = HOLD;
	reg [4:0] next_state;
	

	always @(*)
	begin
		case(current_state)
			HOLD: 			next_state = one_frame ? ERASE_BIRD_0 : HOLD;
			ERASE_BIRD_0: 	next_state = done_draw[0] ? DRAW_BIRD_0 : ERASE_BIRD_0;
			DRAW_BIRD_0: 	next_state = done_draw[0] ? ERASE_BIRD_1 : DRAW_BIRD_0;
			ERASE_BIRD_1: 	next_state = done_draw[1] ? DRAW_BIRD_1 : ERASE_BIRD_1;
			DRAW_BIRD_1: 	next_state = done_draw[1] ? ERASE_BIRD_2 : DRAW_BIRD_1;
			ERASE_BIRD_2: 	next_state = done_draw[2] ? DRAW_BIRD_2 : ERASE_BIRD_2;
			DRAW_BIRD_2: 	next_state = done_draw[2] ? ERASE_BIRD_3 : DRAW_BIRD_2;
			ERASE_BIRD_3: 	next_state = done_draw[3] ? DRAW_BIRD_3 : ERASE_BIRD_3;
			DRAW_BIRD_3: 	next_state = done_draw[3] ? ERASE_BIRD_4 : DRAW_BIRD_3;
			ERASE_BIRD_4: 	next_state = done_draw[4] ? DRAW_BIRD_4 : ERASE_BIRD_4;
			DRAW_BIRD_4: 	next_state = done_draw[4] ? ERASE_BIRD_5 : DRAW_BIRD_4;
			ERASE_BIRD_5: 	next_state = done_draw[5] ? DRAW_BIRD_5 : ERASE_BIRD_5;
			DRAW_BIRD_5: 	next_state = done_draw[5] ? ERASE_BIRD_6 : DRAW_BIRD_5;
			ERASE_BIRD_6: 	next_state = done_draw[6] ? DRAW_BIRD_6 : ERASE_BIRD_6;
			DRAW_BIRD_6: 	next_state = done_draw[6] ? ERASE_HUNTER : DRAW_BIRD_6;
			ERASE_HUNTER: next_state = done_draw_h ? DRAW_HUNTER : ERASE_HUNTER;
			DRAW_HUNTER: next_state = done_draw_h ? HOLD : DRAW_HUNTER;
 			DRAW_LASER: next_state = done_draw_l ? ERASE_LASER : DRAW_LASER;
 			ERASE_LASER: next_state = done_draw_l ? HOLD : ERASE_LASER;
			default: next_state = HOLD;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (current_state != next_state) begin
			case(next_state)
				ERASE_BIRD_0: 	reset_draw[0] = 1 & bird_on[0];
				DRAW_BIRD_0: 	reset_draw[0] = 1 & bird_on[0];
				ERASE_BIRD_1:	reset_draw[1] = 1 & bird_on[1];
				DRAW_BIRD_1: 	reset_draw[1] = 1 & bird_on[1];
				ERASE_BIRD_2: 	reset_draw[2] = 1 & bird_on[2];
				DRAW_BIRD_2: 	reset_draw[2] = 1 & bird_on[2];
				ERASE_BIRD_3: 	reset_draw[3] = 1 & bird_on[3];
				DRAW_BIRD_3: 	reset_draw[3] = 1 & bird_on[3];
				ERASE_BIRD_4: 	reset_draw[4] = 1 & bird_on[4];
				DRAW_BIRD_4: 	reset_draw[4] = 1 & bird_on[4];
				ERASE_BIRD_5: 	reset_draw[5] = 1 & bird_on[5];
				DRAW_BIRD_5:	reset_draw[5] = 1 & bird_on[5];
				ERASE_BIRD_6:	reset_draw[6] = 1 & bird_on[6];
				DRAW_BIRD_6:	reset_draw[6] = 1 & bird_on[6];
				ERASE_HUNTER:  reset_draw_h = 1;
				DRAW_HUNTER: 	reset_draw_h = 1;
				DRAW_LASER:    reset_draw_l = 1;
				ERASE_LASER:	reset_draw_l = 1;
				default:		begin
					reset_draw = 7'b0;
					reset_draw_h = 0;
					reset_draw_l = 0;
				end
			endcase
		end
		else begin
			reset_draw = 7'b0;
			reset_draw_h = 0;
			reset_draw_l = 0;
		end
		current_state <= next_state;
	end
	
	always @(*)
	begin
		if (current_state == ERASE_HUNTER | current_state == DRAW_HUNTER)
			laser_on = 1'b1;
		else
			laser_on = 1'b0;
	end
endmodule

/*
Control for number of birds/speed.
*/
module bird_control(clock, KEY, reset, bird_on, move_freq);
	input clock, reset;
	input [0:0] KEY;
	output reg [6:0] bird_on = 7'b0000001;
	output reg [4:0] move_freq = 30;
	
	assign q = KEY[0];
	reg [9:0] seconds = 0;
	
	//frame_counter f60(.num(6'd60), .clock(clock), .reset(1'b0), .q(q)); 
	
	always@(posedge q)
	begin
		if (reset)
			seconds <= 0;
		else
			seconds <= seconds + 1;
	end
	
	always@(posedge clock)
	begin
		if (seconds <= 5) begin
			bird_on <= 7'b0000001;
			move_freq <= 30;
		end
		else if (seconds <= 10) begin
			bird_on <= 7'b0000011;
			move_freq <= 24;
		end
		else if (seconds <= 15) begin
			bird_on <= 7'b0000111;
			move_freq <= 18;
		end
		else if (seconds <= 20) begin
			bird_on <= 7'b0001111;
			move_freq <= 12;
		end
		else if (seconds <= 25) begin
			bird_on <= 7'b0011111;
			move_freq <= 6;
		end
		else if (seconds <= 30) begin
			bird_on <= 7'b0111111;
			move_freq <= 3;
		end
		else if (seconds <= 35) begin
			bird_on <= 7'b1111111;
			move_freq <= 3;
		end
	end
endmodule

module bird(cclock, dclock, y, bird_on, reset_counter, reset_draw, erase, x_out, y_out, done/*, test_x, test_y*/);
	//cclock = clock for bird_counter
	//dclock = clock for draw_bird
	input cclock, dclock;
	input [6:0] y;
	input reset_counter, reset_draw;
	input erase, bird_on;
	output [7:0] x_out/*, test_x*/;
	output [6:0] y_out/*, test_y*/;
	output done;

	wire [7:0] x;
	reg [7:0] draw_x;
//	assign test_x = x;
//	assign test_y = y;
	
	bird_counter bcount(
		.clock(cclock), 
		.reset(reset_counter), 
		.enable(bird_on), 
		.new_x(x));

	always @(*)
	begin
		case (erase)
			1'b0: draw_x = x;
			1'b1: draw_x = x - 1;
		endcase
	end
	
	draw_bird d1(
		.clock(dclock),
		.x(draw_x),
		.y(y), 
		.reset(reset_draw),
		.x_out(x_out), 
		.y_out(y_out),
		.done(done));
endmodule

module draw_bird(
		input clock,
		input [7:0] x,
		input	[6:0] y,
		input reset, 
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output done
		);
		
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
					
	reg [3:0] current_state = END;
	reg [3:0] next_state;
		
    /*
	x from right
	y from centre
	
	x
     x
      x
    xxxxxx
      x  x
     x
    x
	
	*/	
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
			END: next_state = END;
			default: next_state = END;
		endcase
	end
		
	always @(*)
	begin // set x
		case (current_state)
			BIRD_0: x_out = x;
			BIRD_1: x_out =  x;
			BIRD_2: x_out = x - 1;
			BIRD_3: x_out = x - 2;
			BIRD_4: x_out =  x - 3;
			BIRD_5: x_out =  x - 4; 
			BIRD_6: x_out =  x - 5;
			BIRD_7: x_out =  x - 3;
			BIRD_8: x_out =  x - 3;
			BIRD_9: x_out = x - 4;
			BIRD_10: x_out = x - 4;
			BIRD_11: x_out = x - 5;
			BIRD_12: x_out = x - 5;
			default: x_out = -1;
      endcase
	end
	
	always @(*)
	begin // set y
		case (current_state)
			BIRD_0: y_out = y;
			BIRD_1: y_out = y + 1;
			BIRD_2: y_out = y;
			BIRD_3: y_out = y;
			BIRD_4: y_out = y;
			BIRD_5: y_out =  y;
			BIRD_6: y_out =  y;
			BIRD_7: y_out =  y + 1;
			BIRD_8: y_out =  y - 1;
			BIRD_9: y_out = y + 2;
			BIRD_10: y_out = y - 2;
			BIRD_11: y_out =  y + 3;
			BIRD_12: y_out =  y - 3;
			default: y_out = -1;
      endcase
	end
	
	always @(posedge clock)
	begin
		if (reset)
			current_state <= BIRD_0;
		else
			current_state <= next_state;
	end
	
	assign done = (current_state == END && ~reset) ? 1 : 0;
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

module keyboard (clock, valid, makeBreak, data_in, move_l, move_r, shoot);
	input clock;
	input valid, makeBreak;
	input [7:0] data_in;
	output reg move_l, move_r, shoot;
	
	always@(*) begin
		if (valid) begin
			if (makeBreak)
				case (data_in)
					8'h75: shoot = 1'b1;
					8'h6B: move_l = 1'b1;
					8'h74: move_r = 1'b1;
				endcase
			else
				case (data_in)
					8'h75: shoot = 1'b0;
					8'h6B: move_l = 1'b0;
					8'h74: move_r = 1'b0;
				endcase
		end
	end
	
endmodule

module hunter(clock, move_l, move_r, reset_draw, x_out, y_out, hunter_x, done, erase);
	input clock;
	input move_l, move_r;
	input reset_draw;
	input erase;
	output [7:0] x_out;
	output [6:0] y_out;
	output [7:0] hunter_x;
	output done;
	
	wire [6:0] y = 7'd115;
	wire one_frame;

	
	reg [7:0] x = 8'd75;
	
	reg [7:0] draw_x, prev_x;
	
	always @(posedge one_frame)
	begin
		if (move_l & x > 4) begin
				prev_x = x;
				x <= x - 1;
		end
		else if (move_r & x < 156) begin
				prev_x = x;
				x <= x + 1;
		end
	end
	
	always@(*) begin
	if(erase)
		draw_x = prev_x;
	else
		draw_x = x;
	end

	assign hunter_x = x;
	rate_divider f1(.clock(clock), .reset(1'b0), .one_frame(one_frame));
	draw_hunter dh(.clock(clock), .reset(reset_draw), .x(draw_x), .y(y), .x_out(x_out), .y_out(y_out), .done(done)); 
endmodule


module draw_hunter(clock, reset, x, y, x_out, y_out, done);
	input clock, reset;
	input [7:0] x; 
	input [6:0] y;
	output reg [7:0] x_out;
	output reg [6:0] y_out;
	output done;

	reg [4:0] next_state;
	
	localparam	DRAW_0 = 5'd0,
				DRAW_1 = 5'd1,
				DRAW_2 = 5'd2,
				DRAW_3 = 5'd3,
				DRAW_4 = 5'd4,
				DRAW_5 = 5'd5,
				DRAW_6 = 5'd6,
				DRAW_7 = 5'd7,
				DRAW_8 = 5'd8,
				DRAW_9 = 5'd9,
				DRAW_10 = 5'd10,
				DRAW_11 = 5'd11,
				DRAW_12 = 5'd12,
				DRAW_13 = 5'd13,
				DRAW_14 = 5'd14,
				DRAW_15 = 5'd15,
				DRAW_16 = 5'd16,
				DRAW_17 = 5'd17,
				DRAW_18 = 5'd18,
				DRAW_19 = 5'd19,
				DRAW_20 = 5'd20,
				DRAW_21 = 5'd21,
				END = 5'd23;
	
	reg [4:0] current_state = END;
		
	/*
	x from centre
  	y from top
	draws left to right, top to bottom
	
	  xxx
	  xxx
	xxxxxxx
	xxxxxxx
	x     x	
	
	*/		
	always @(*)
	begin
		case (current_state)
				DRAW_0: next_state = DRAW_1;
				DRAW_1: next_state = DRAW_2;
				DRAW_2: next_state = DRAW_3;
				DRAW_3: next_state = DRAW_4;
				DRAW_4: next_state = DRAW_5;
				DRAW_5: next_state = DRAW_6;
				DRAW_6: next_state = DRAW_7;
				DRAW_7: next_state = DRAW_8;
				DRAW_8: next_state = DRAW_9;
				DRAW_9: next_state = DRAW_10;
				DRAW_10: next_state = DRAW_11;
				DRAW_11: next_state = DRAW_12;
				DRAW_12: next_state = DRAW_13;
				DRAW_13: next_state = DRAW_14;
				DRAW_14: next_state = DRAW_15;
				DRAW_15: next_state = DRAW_16;
				DRAW_16: next_state = DRAW_17;
				DRAW_17: next_state = DRAW_18;
				DRAW_18: next_state = DRAW_19;
				DRAW_19: next_state = DRAW_20;
				DRAW_20: next_state = DRAW_21;
				DRAW_21: next_state = END;
				default: next_state = END;
		endcase
	end
			
	always @(*)
	begin
		case (current_state)
				DRAW_0: x_out = x - 1;
				DRAW_1: x_out = x;
				DRAW_2: x_out = x + 1;
				DRAW_3: x_out = x - 1;
				DRAW_4: x_out = x;
				DRAW_5: x_out = x + 1;
				DRAW_6: x_out = x - 3;
				DRAW_7: x_out = x - 2;
				DRAW_8: x_out = x - 1;
				DRAW_9: x_out = x;
				DRAW_10: x_out = x + 1;
				DRAW_11: x_out = x + 2;
				DRAW_12: x_out = x + 3;
				DRAW_13: x_out = x - 3;
				DRAW_14: x_out = x - 2;
				DRAW_15: x_out = x - 1;
				DRAW_16: x_out = x;
				DRAW_17: x_out = x + 1;
				DRAW_18: x_out = x + 2;
				DRAW_19: x_out = x + 3;
				DRAW_20: x_out = x - 3;
				DRAW_21: x_out = x + 3;
				default: x_out = -1;
		endcase
	end
	
	always @(*)
	begin
		case (current_state)
				DRAW_0: y_out = y;
				DRAW_1: y_out = y;  
				DRAW_2: y_out = y;
				DRAW_3: y_out = y + 1;
				DRAW_4: y_out = y + 1;
				DRAW_5: y_out = y + 1;
				DRAW_6: y_out = y + 2;
				DRAW_7: y_out = y + 2;
				DRAW_8: y_out = y + 2;
				DRAW_9: y_out = y + 2;
				DRAW_10: y_out = y + 2;
				DRAW_11: y_out = y + 2;
				DRAW_12: y_out = y + 2;
				DRAW_13: y_out = y + 3;
				DRAW_14: y_out = y + 3;
				DRAW_15: y_out = y + 3;
				DRAW_16: y_out = y + 3;
				DRAW_17: y_out = y + 3;
				DRAW_18: y_out = y + 3;
				DRAW_19: y_out = y + 3;
				DRAW_20: y_out = y + 4;
				DRAW_21: y_out = y + 4;
				default: y_out = -1;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (reset)
			current_state <= DRAW_0;
		else
			current_state <= next_state;
	end
	
	assign done = (current_state == END && ~reset) ? 1 : 0;
endmodule

module draw_laser(clock, x, reset_draw_l, laser_on, shoot, reloaded, plot_x, plot_y, done);
	input clock;
	input [7:0] x;
	input reset_draw_l, laser_on, shoot, reloaded;
	output [7:0] plot_x;
	output [6:0] plot_y;
	output done;
	
	reg [6:0] new_y;
	 
	always @(posedge clock)
	begin
		if (shoot) begin
			if (reset_draw_l)
				new_y <= 114;
			else if (laser_on)
				new_y <= new_y - 1;
		end
	end
	
	assign done = (new_y == 0 | ~reloaded) ? 1 : 0;
	
	assign plot_x = x;
	assign plot_y = new_y;
endmodule

module laser_reload (clock, shoot, reloaded);
	input clock;
	input shoot;
	output reloaded;
	
	wire q;
	assign reloaded = q;
	
	frame_counter f60(.num(6'd60), .clock(clock), .reset(shoot), .q(q));
	
endmodule

/*
Goes high if collision is detected.
*/
module collision_check(laser_x, bird_x, q);
	input [7:0] laser_x;
	input [7:0] bird_x;
	output q;

	assign q = (laser_x <= bird_x && laser_x >= (bird_x-5)) ? 1 : 0;
endmodule

module frame_counter(num, clock, reset, q); // output 1 if designated number of frames reached.
	input [5:0] num;
	input clock;
	input reset;
	output q;
	
	wire one_frame;
	
	reg [5:0] temp = 0;
	
	rate_divider hz60(
		.clock(clock),
		.reset(reset),
		.one_frame(one_frame)
	);
	
	always @(posedge clock)
	begin
		if (one_frame)
			temp <= temp - 1;
		else if (temp == 0)
			temp <= num - 1;
	end
	
	assign q = (temp == 0) ? 1 : 0;
endmodule
	
module rate_divider(clock, reset, one_frame); //Goes high every 60th of a second.
	input clock;
	input reset;
	
	output one_frame;
	
	reg [19:0] q = 20'b11001011011100110110 - 1;
	
	always @(posedge clock)
	begin
		if (reset)
			q <= 20'b11001011011100110110 - 1;
		else
			begin
				if (q == 0)
					q <= 20'b11001011011100110110 - 1;//(1/60s)
				else
					q <= q - 1'b1;
			end
	end
	
	assign one_frame = (q == 0) ? 1 : 0;
endmodule
