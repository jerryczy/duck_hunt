//x
// x
//  x
//xxxxxx
//  x  x
// x
//x
// a duck

module test_hunt(CLOCK_50, reset_draw, draw_en);
	input CLOCK_50;
	input reset_draw;
	input draw_en;
	wire [7:0] plot_x_1;
	wire [6:0] plot_y_1;
	wire done_draw_1;
	bird b1(.cclock(1'b0), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw), .draw_en(draw_en), .x_out(plot_x_1), .y_out(plot_y_1), .done(done_draw_1));
endmodule

module duck_hunt(CLOCK_50, KEY,
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
	input [1:0] KEY;
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]	

	input PS2_DAT, PS2_CLK;
	


	wire [7:0] plot_x_1, plot_x_2, plot_x_3, plot_x_4, plot_x_5, plot_x_6, plot_x_h, plot_x_l, x_out;
	wire [6:0] plot_y_1, plot_y_2, plot_y_3, plot_y_4, plot_y_5, plot_y_6, plot_y_h, plot_y_l, y_out;
	wire frame_reached;
	wire done_draw_1, done_draw_2, done_draw_3, done_draw_4, done_draw_5, done_draw_6, done_draw_h, done_draw_l;
	wire [2:0] colour;

	wire [4:0] current_state;
	wire [5:0] reset_draw, reset_counter, draw_en;
	assign reset_counter = 0;
	wire reset_hunter, reset_laser;

	wire valid, makeBreak;
	wire [7:0] outCode;
	
	wire [7:0] hunter_X;
	wire shoot;

	assign draw_en = 6'b1111111; //for now

	/*
	INSTANTIATE MULTIPLE BIRDS AND HUNTER.
	*/
	bird b1(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[0]), .reset_draw(reset_draw[0]), .draw_en(draw_en[0]), .x_out(plot_x_1), .y_out(plot_y_1), .done(done_draw_1));
	bird b2(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[1]), .reset_draw(reset_draw[1]), .draw_en(draw_en[1]), .x_out(plot_x_2), .y_out(plot_y_2), .done(done_draw_2));
	bird b3(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[2]), .reset_draw(reset_draw[2]), .draw_en(draw_en[2]), .x_out(plot_x_3), .y_out(plot_y_3), .done(done_draw_3));
	bird b4(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[3]), .reset_draw(reset_draw[3]), .draw_en(draw_en[3]), .x_out(plot_x_4), .y_out(plot_y_4), .done(done_draw_4));
	bird b5(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[4]), .reset_draw(reset_draw[4]), .draw_en(draw_en[4]), .x_out(plot_x_5), .y_out(plot_y_5), .done(done_draw_5));
	bird b6(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(reset_counter[5]), .reset_draw(reset_draw[5]), .draw_en(draw_en[5]), .x_out(plot_x_6), .y_out(plot_y_6), .done(done_draw_6));
	hunter h1(.clock(CLOCK_50), .x(hunter_X), .reset_hunter(reset_hunter), .x_out(plot_x_h), .y_out(plot_y_h), .done(done_draw_h));
	hunter_action ha(.clock(CLOCK_50), .valid(valid), .makeBreak(makeBreak), .outCode(outCode), .x(hunter_X), .shoot(shoot));
	laser lh(.clock(CLOCK_50), .reset(reset_laser), .shoot(shoot), .x(hunter_x), .laser_x(plot_x_l), .laser_y(plot_y_l), .done(done_draw_l));
	
	control c1(
		.clock(CLOCK_50),
		.done_draw_1(done_draw_1), .done_draw_2(done_draw_2), .done_draw_3(done_draw_3), .done_draw_4(done_draw_4), .done_draw_5(done_draw_5), .done_draw_6(done_draw_6), .done_draw_l(done_draw_l),
		.done_draw_h(done_draw_h), .shoot(shoot),
		.reset(~KEY[0]),
		.reset_draw(reset_draw),
	 	.reset_hunter(reset_hunter), .reset_laser(reset_laser),
		.curr(current_state)
	);
	
	datapath d1(
		.current_state(current_state),
		.plot_x_1(plot_x_1), .plot_x_2(plot_x_2), .plot_x_3(plot_x_3), .plot_x_4(plot_x_4), .plot_x_5(plot_x_5), .plot_x_6(plot_x_6), .plot_x_h(plot_x_h), .plot_x_l(plot_x_l),
		.plot_y_1(plot_y_1), .plot_y_2(plot_y_2), .plot_y_3(plot_y_3), .plot_y_4(plot_y_4), .plot_y_5(plot_y_5), .plot_y_6(plot_y_6), .plot_y_h(plot_y_h), .plot_y_l(plot_y_l),
		.colour(colour),
		.x_out(x_out),
		.y_out(y_out)
	);
	
	/**
	MODULE INSTANTIATIONS
	*/
	frame_counter fram (.num(6'b001111), .clock(CLOCK_50), .reset(KEY[1]), .q(frame_reached));
	
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
		
	keyboard_press_driver k1(
		.CLOCK_50(CLOCK_50), 
		.valid(valid), .makeBreak(makeBreak), // 1 for make and 0 for break 
		.outCode(outCode),
		.PS2_DAT(PS2_DAT), // PS2 data line
		.PS2_CLK(PS2_CLK), // PS2 clock line
		.reset()// ??? needed
		);
endmodule

module control(
	input clock,
	input done_draw_1, done_draw_2, done_draw_3, done_draw_4, done_draw_5, done_draw_6, done_draw_h, done_draw_l,
	input shoot,
	input reset,
	output reg [5:0] reset_draw,
	output reg reset_hunter, reset_laser,
	output [4:0] curr
	);
	
	wire one_frame;

	localparam	HOLD = 5'd0,
					ERASE_BIRDS_1 = 5'd1,
					DRAW_BIRDS_1 = 5'd2,
					ERASE_BIRDS_2 = 5'd3,
					DRAW_BIRDS_2 = 5'd4,
					ERASE_BIRDS_3 = 5'd5,
					DRAW_BIRDS_3 = 5'd6,
					ERASE_BIRDS_4 = 5'd7,
					DRAW_BIRDS_4 = 5'd8,
					ERASE_BIRDS_5 = 5'd9,
					DRAW_BIRDS_5 = 5'd10,
					ERASE_BIRDS_6 = 5'd11,
					DRAW_BIRDS_6 = 5'd12,
					ERASE_HUNTER = 5'd13,
					DRAW_HUNTER = 5'd14,
					DRAW_LASER = 5'd15,
					ERASE_LASER = 5'd16;
					
	reg [4:0] current_state = HOLD;
	reg [4:0] next_state;
	
	assign curr = current_state;
				
	always@(*) 
	begin
		case (current_state) //when frame is reached, we must erase old birds and draw new birds.
			HOLD: next_state = (one_frame) ? ERASE_BIRDS_1 : HOLD;
			ERASE_BIRDS_1: next_state = done_draw_1 ? DRAW_BIRDS_1 : ERASE_BIRDS_1;
			DRAW_BIRDS_1: next_state = done_draw_1 ? ERASE_BIRDS_2 : DRAW_BIRDS_1;
			ERASE_BIRDS_2: next_state = done_draw_2 ? DRAW_BIRDS_2 : ERASE_BIRDS_2;
			DRAW_BIRDS_2: next_state = done_draw_2 ? ERASE_BIRDS_3 : DRAW_BIRDS_2;
			ERASE_BIRDS_3: next_state = done_draw_3 ? DRAW_BIRDS_3 : ERASE_BIRDS_3;
			DRAW_BIRDS_3: next_state = done_draw_3 ? ERASE_BIRDS_4 : DRAW_BIRDS_3;
			ERASE_BIRDS_4: next_state = done_draw_4 ? DRAW_BIRDS_4 : ERASE_BIRDS_4;
			DRAW_BIRDS_4: next_state = done_draw_4 ? ERASE_BIRDS_5 : DRAW_BIRDS_4;
			ERASE_BIRDS_5: next_state = done_draw_5 ? DRAW_BIRDS_5 : ERASE_BIRDS_5;
			DRAW_BIRDS_5: next_state = done_draw_5 ? ERASE_BIRDS_6 : DRAW_BIRDS_5;
			ERASE_BIRDS_6: next_state = done_draw_6 ? DRAW_BIRDS_6 : ERASE_BIRDS_6;
			DRAW_BIRDS_6: next_state = done_draw_6 ? ERASE_HUNTER : DRAW_BIRDS_6;
			ERASE_HUNTER: next_state = done_draw_h ? DRAW_HUNTER : ERASE_HUNTER;
			DRAW_HUNTER: next_state = done_draw_h ? (shoot ? DRAW_LASER : HOLD) : DRAW_HUNTER;
			DRAW_LASER: next_state = done_draw_l ? ERASE_LASER : DRAW_LASER;
			ERASE_LASER: next_state = done_draw_l ? HOLD : ERASE_LASER;
			default: next_state = HOLD;

		endcase
	end
	
	always@(posedge clock)
	begin
		if (reset)
			current_state <= HOLD;
		else begin
			if (current_state != next_state) //high for one clock cycle per draw state.
				begin
					case (next_state)
						ERASE_BIRDS_1: reset_draw[0] = 1;
						DRAW_BIRDS_1: reset_draw[0] = 1;
						ERASE_BIRDS_2: reset_draw[1] = 1;
						DRAW_BIRDS_2: reset_draw[1] = 1;
						ERASE_BIRDS_3: reset_draw[2] = 1;
						DRAW_BIRDS_3: reset_draw[2] = 1;
						ERASE_BIRDS_4: reset_draw[3] = 1;
						DRAW_BIRDS_4: reset_draw[3] = 1;
						ERASE_BIRDS_5: reset_draw[4] = 1;
						DRAW_BIRDS_5: reset_draw[4] = 1;
						ERASE_BIRDS_6: reset_draw[5] = 1;
						DRAW_BIRDS_6: reset_draw[5] = 1;
						ERASE_HUNTER: reset_hunter = 1;
						DRAW_HUNTER: reset_hunter = 1;
						DRAW_LASER: reset_laser = 1;
						ERASE_LASER: reset_laser = 1;
					endcase
				end
			else begin
				reset_draw[5:0] = 0;
				reset_hunter = 0;
			end
			current_state <= next_state;
		end
	end
	
	//Goes one_frame high every 1/60th of a second.
	frame_counter f1(.num(6'b000001), .clock(clock), .reset(reset), .q(one_frame));
endmodule

module datapath (
	input [4:0] current_state,
	input [7:0] plot_x_1, plot_x_2, plot_x_3, plot_x_4, plot_x_5, plot_x_6, plot_x_h, plot_x_l,
	input [6:0] plot_y_1, plot_y_2, plot_y_3, plot_y_4, plot_y_5, plot_y_6, plot_y_h, plot_y_l,
	output reg [2:0] colour,
	output reg [7:0] x_out,
	output reg [6:0] y_out
	);

	localparam	HOLD = 5'b0,
					ERASE_BIRDS_1 = 5'd1,
					DRAW_BIRDS_1 = 5'd2,
					ERASE_BIRDS_2 = 5'd3,
					DRAW_BIRDS_2 = 5'd4,
					ERASE_BIRDS_3 = 5'd5,
					DRAW_BIRDS_3 = 5'd6,
					ERASE_BIRDS_4 = 5'd7,
					DRAW_BIRDS_4 = 5'd8,
					ERASE_BIRDS_5 = 5'd9,
					DRAW_BIRDS_5 = 5'd10,
					ERASE_BIRDS_6 = 5'd11,
					DRAW_BIRDS_6 = 5'd12,
					ERASE_HUNTER = 5'd13,
					DRAW_HUNTER = 5'd14,
					DRAW_LASER = 5'd15,
					ERASE_LASER = 5'd16;
					
	always@(*) 
	begin // set colour
		case (current_state)
			ERASE_BIRDS_1: colour = 3'b000;
			DRAW_BIRDS_1: colour = 3'b111;
			ERASE_BIRDS_2: colour = 3'b000;
			DRAW_BIRDS_2: colour = 3'b111;
			ERASE_BIRDS_3: colour = 3'b000;
			DRAW_BIRDS_3: colour = 3'b111;
			ERASE_BIRDS_4: colour = 3'b000;
			DRAW_BIRDS_4: colour = 3'b111;
			ERASE_BIRDS_5: colour = 3'b000;
			DRAW_BIRDS_5: colour = 3'b111;
			ERASE_BIRDS_6: colour = 3'b000;
			DRAW_BIRDS_6: colour = 3'b111;
			ERASE_HUNTER: colour = 3'b000;
			DRAW_HUNTER: colour = 3'b001;
			DRAW_LASER: colour = 3'b010;
			ERASE_LASER: colour = 3'b000;
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
			ERASE_LASER: x_out = plot_x_l;
			DRAW_LASER: x_out = plot_x_l;
		
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
			ERASE_LASER: y_out = plot_y_l;
			DRAW_LASER: y_out = plot_y_l;
		endcase
	end

endmodule

module bird(cclock, dclock, reset_counter, reset_draw, draw_en, x_out, y_out, done);
	//cclock = clock for bird_counter
	//dclock = clock for draw_bird
	input cclock, dclock, reset_counter, reset_draw, draw_en;
	output [7:0] x_out;
	output [6:0] y_out;
	output done;
	
	wire [7:0] x;
	wire [6:0] y = 7'b0000111;
	

	bird_counter bcount(
		.clock(cclock), 
		.reset(reset_counter), 
		.enable(draw_en), 
		.new_x(x));
		
//	random num1(
//		.clock(dclock),
//		.reset(reset),
//		.y(y));
	
	draw_bird d1(
		.clock(dclock),
		.x(x),
		.y(y), 
		.reset(reset_draw), 
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
	output reg [7:0] new_x;
	output reg [6:0] new_y;
	output done;
	
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
			BIRD_0: new_x = draw_en ? x : -1;
			BIRD_1: new_x = draw_en ? x : -1;
			BIRD_2: new_x = draw_en ? x - 1 : -1;
			BIRD_3: new_x = draw_en ? x - 2 : -1;
			BIRD_4: new_x = draw_en ? x - 3 : -1;
			BIRD_5: new_x = draw_en ? x - 4 : -1; 
			BIRD_6: new_x = draw_en ? x - 5 : -1;
			BIRD_7: new_x = draw_en ? x - 3 : -1;
			BIRD_8: new_x = draw_en ? x - 3 : -1;
			BIRD_9: new_x = draw_en ? x - 4 : -1;
			BIRD_10: new_x = draw_en ? x - 4 : -1;
			BIRD_11: new_x = draw_en ? x - 5 : -1;
			BIRD_12: new_x = draw_en ? x - 5 : -1;
      endcase
	end
	
	always @(*)
	begin // set y
		case (current_state)
			BIRD_0: new_y = draw_en ? y : -1;
			BIRD_1: new_y = draw_en ? y + 1 : -1;
			BIRD_2: new_y = draw_en ? y : -1;
			BIRD_3: new_y = draw_en ? y : -1;
			BIRD_4: new_y = draw_en ? y : -1;
			BIRD_5: new_y = draw_en ? y : -1;
			BIRD_6: new_y = draw_en ? y : -1;
			BIRD_7: new_y = draw_en ? y + 1 : -1;
			BIRD_8: new_y = draw_en ? y - 1 : -1;
			BIRD_9: new_y = draw_en ? y + 2 : -1;
			BIRD_10: new_y = draw_en ? y - 2 : -1;
			BIRD_11: new_y = draw_en ? y + 3 : -1;
			BIRD_12: new_y = draw_en ? y - 3 : -1;
      endcase
	end
   
	always @(posedge clock)
	begin
		if (reset)
			current_state <= BIRD_0;
		else
			current_state <= next_state;
	end
   
	assign done = (current_state == END || ~draw_en) ? 1 : 0;
endmodule

module hunter(clock, x, reset_hunter, x_out, y_out, done);
	input clock;
	input [7:0] x;
	input reset_hunter;
	
	reg [7:0] temp_x;
	reg [6:0] temp_y;

	output [7:0] x_out;
	output [6:0] y_out;
	output done;
	
	assign x_out = temp_x;
	assign y_out = temp_y;
	
	/*
	 xx
	xxxx
	xxxx
	*/
	localparam	DRAW_0 = 4'b0000,
				DRAW_1 = 4'b0001,
				DRAW_2 = 4'b0010,
				DRAW_3 = 4'b0011,
				DRAW_4 = 4'b0100,
				DRAW_5 = 4'b0101,
				DRAW_6 = 4'b0110,
				DRAW_7 = 4'b0111,
				DRAW_8 = 4'b1000,
				DRAW_9 = 4'b1001,
				END = 4'b1010;
	reg [3:0] current_state = END;
	reg [3:0] next_state;
	
	assign y = 7'd118;
	
	
				
	always @(*)
	begin
		case (current_state)
			DRAW_0: next_state = DRAW_1;
			DRAW_1: next_state = DRAW_2;
			DRAW_2: next_state = DRAW_2;
			DRAW_3: next_state = DRAW_2;
			DRAW_4: next_state = DRAW_2;
			DRAW_5: next_state = DRAW_2;
			DRAW_6: next_state = DRAW_2;
			DRAW_7: next_state = DRAW_2;
			DRAW_8: next_state = DRAW_2;
			DRAW_9: next_state = END;
			END: next_state = (reset_hunter) ? DRAW_0 : END;
		endcase
	end
	
	//Set x.
	always @(*)
	begin
		case (current_state)
			DRAW_0: temp_x = x + 1;
			DRAW_1: temp_x = x + 2;
			DRAW_2: temp_x = x;
			DRAW_3: temp_x = x + 1;
			DRAW_4: temp_x = x + 2;
			DRAW_5: temp_x = x + 3;
			DRAW_6: temp_x = x;
			DRAW_7: temp_x = x + 1;
			DRAW_8: temp_x = x + 2;
			DRAW_9: temp_x = x + 3;
			default: temp_x = 0;
		endcase
	end
	
	//Set y
	always @(*)
	begin
		case (current_state)
			DRAW_0: temp_y = y;
			DRAW_1: temp_y = y;
			DRAW_2: temp_y = y + 1;
			DRAW_3: temp_y = y + 1;
			DRAW_4: temp_y = y + 1;
			DRAW_5: temp_y = y + 1;
			DRAW_6: temp_y = y + 2;
			DRAW_7: temp_y = y + 2;
			DRAW_8: temp_y = y + 2;
			DRAW_9: temp_y = y + 2;
			default: temp_y = 0;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (reset_hunter)
			current_state <= DRAW_0;
		else
			current_state <= next_state;
	end
	
	assign done = (current_state == END) ? 1 : 0;	
endmodule

module hunter_action(
	input clock,
	input valid, makeBreak,
	input [7:0] outCode,
	 output [7:0] x,
	output reg shoot
	);
	
	/*
	Keyboard input
	*/
	reg [7:0] temp_x = 8'd80;
	assign x = temp_x;
	reg left, right;
	reg reloaded = 1'b1;
	
	always@(*) begin
		if (valid) begin
			if (makeBreak)
				case (outCode)
					8'hE0,8'h75: shoot = 1'b1;
					8'hE0,8'h6B: left = 1'b1;
					8'hE0,8'h74: right = 1'b1;
				endcase
			else
				case (outCode)
					8'hE0,8'hF0,8'h75: shoot = 1'b0;
					8'hE0,8'hF0,8'h6B: left = 1'b0;
					8'hE0,8'hF0,8'h74: right = 1'b0;
				endcase
		end
	end
	// move
	always@(posedge clock) begin
		if (right && (temp_x != 8'd158))
			temp_x <= temp_x + 1;
		else if (left && (temp_x != 0))
			temp_x <= temp_x - 1;
	end
	
endmodule

module laser (clock, reset, shoot, x/*(hunter_x)*/, laser_x, laser_y, done);
	input clock;
	input reset, shoot;
	input [7:0] x;
	output [7:0] laser_x;
	output [6:0] laser_y;
	output done;

	reg [6:0] q;
	reg done = 1'b0;
	reg reloaded = 1;
	wire reload;

	always @(posedge clock)
	begin
		if (reloaded) begin
			if (reset)
				q <= 7'b1110110;
			else begin
				if (q == 0) begin
					done <= 1'b1;
					reloaded <= 0;
				end
				else
					q <= q - 1'b1;
			end
		end
		else if (reload)
			reloaded <= 1;
	end
	
	assign laser_y = q;
	assign laser_x = x + 2'b11;

	frame_counter framh (.num(6'b111100), .clock(clock), .reset(reset), .q(reload)); // 1s reload time

endmodule

module random(clock, reset, y);
	input clock;
   input reset;
   output [6:0] y;
	
	reg [2:0] num, num_next;
	
	assign y = num * 4'b1000 + 3'b100;

	always @(*) 
	begin
		num_next[2] = num[2] ^ num[0];
		num_next[1] = num[1] ^ num_next[2];
		num_next[0] = num[0] ^ num_next[1];
	end

	always @(posedge clock or negedge reset)
	begin
		if(!reset)
			num <= 4'b0110;
		else
			num <= num_next;
	end
endmodule

module frame_counter(num, clock, reset, q); // output 1 if desinated fram number reached.
	input [5:0] num;
	input clock;
	input reset;
	output reg q = 0;
	
	wire [19:0] count;
	
	reg [5:0] temp = 0;
	
	
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
