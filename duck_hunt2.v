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

module duck_hunt(CLOCK_50, KEY,
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

	
	wire [7:0] x_out;
	wire [6:0] y_out;
	wire frame_reached, one_frame, reset_f_counter, reset;
	wire done_draw_1;
	
	assign frame_reached = KEY[1];
	assign reset = KEY[0];
	
	reg [4:0] current_state, next_state;
	
	localparam 	HOLD = 5'd0;
			ERASE_BIRD_1 = 5'd1;
			DRAW_BIRD_1 = 5'd2;
	/*
	Control
	*/
	always @(posedge CLOCK_50)
	begin
		case(current_state)
			HOLD: 		next_state = one_frame ? ERASE_BIRD_1 : HOLD;
			ERASE_BIRD_1: 	next_state = done_draw_1 ? DRAW_BIRD_1: ERASE_BIRD_1;
			DRAW_BIRD_1:	next_state = done_draw_1 ? HOLD /*ERASE_BIRDS_2*/ : DRAW_BIRDS_1;
// 			ERASE_BIRDS_2: next_state = done_draw_2 ? DRAW_BIRDS_2 : ERASE_BIRDS_2;
// 			DRAW_BIRDS_2: next_state = done_draw_2 ? ERASE_BIRDS_3 : DRAW_BIRDS_2;
// 			ERASE_BIRDS_3: next_state = done_draw_3 ? DRAW_BIRDS_3 : ERASE_BIRDS_3;
// 			DRAW_BIRDS_3: next_state = done_draw_3 ? ERASE_BIRDS_4 : DRAW_BIRDS_3;
// 			ERASE_BIRDS_4: next_state = done_draw_4 ? DRAW_BIRDS_4 : ERASE_BIRDS_4;
// 			DRAW_BIRDS_4: next_state = done_draw_4 ? ERASE_BIRDS_5 : DRAW_BIRDS_4;
// 			ERASE_BIRDS_5: next_state = done_draw_5 ? DRAW_BIRDS_5 : ERASE_BIRDS_5;
// 			DRAW_BIRDS_5: next_state = done_draw_5 ? ERASE_BIRDS_6 : DRAW_BIRDS_5;
// 			ERASE_BIRDS_6: next_state = done_draw_6 ? DRAW_BIRDS_6 : ERASE_BIRDS_6;
// 			DRAW_BIRDS_6: next_state = done_draw_6 ? ERASE_HUNTER : DRAW_BIRDS_6;
// 			ERASE_HUNTER: next_state = done_draw_h ? DRAW_HUNTER : ERASE_HUNTER;
// 			DRAW_HUNTER: next_state = done_draw_h ? (shoot ? DRAW_LASER : HOLD) : DRAW_HUNTER;
// 			DRAW_LASER: next_state = done_draw_l ? ERASE_LASER : DRAW_LASER;
// 			ERASE_LASER: next_state = done_draw_l ? HOLD : ERASE_LASER;
			default: next_state = HOLD;
		endcase
	end
	
	always @(posedge CLOCK_50 || posedge reset)
	begin
// 		if (posedge reset)
// 			current_state = HOLD;
// 		else
			current_state = next_state;
	end
	
	/*
	Datapath
	*/
	
	always @(*)
	begin
		case (current_state)
			ERASE_BIRDS_1: colour = 3'b000;
			DRAW_BIRDS_1: colour = 3'b111;
// 			ERASE_BIRDS_2: colour = 3'b000;
// 			DRAW_BIRDS_2: colour = 3'b111;
// 			ERASE_BIRDS_3: colour = 3'b000;
// 			DRAW_BIRDS_3: colour = 3'b111;
// 			ERASE_BIRDS_4: colour = 3'b000;
// 			DRAW_BIRDS_4: colour = 3'b111;
// 			ERASE_BIRDS_5: colour = 3'b000;
// 			DRAW_BIRDS_5: colour = 3'b111;
// 			ERASE_BIRDS_6: colour = 3'b000;
// 			DRAW_BIRDS_6: colour = 3'b111;
// 			ERASE_HUNTER: colour = 3'b000;
// 			DRAW_HUNTER: colour = 3'b001;
// 			DRAW_LASER: colour = 3'b010;
// 			ERASE_LASER: colour = 3'b000;
		endcase
	end
	
	always @(*)
	begin
		case (current_state)
			ERASE_BIRDS_1: reset_f_counter = 1'b0;
			DRAW_BIRDS_1: reset_f_counter = 1'b1;
// 			ERASE_BIRDS_2: ;
// 			DRAW_BIRDS_2: ;
// 			ERASE_BIRDS_3: ;
// 			DRAW_BIRDS_3: ;
// 			ERASE_BIRDS_4: ;
// 			DRAW_BIRDS_4: ;
// 			ERASE_BIRDS_5: ;
// 			DRAW_BIRDS_5: ;
// 			ERASE_BIRDS_6: ;
// 			DRAW_BIRDS_6: ;
// 			ERASE_HUNTER: ;
// 			DRAW_HUNTER: ;
// 			DRAW_LASER: ;
// 			ERASE_LASER: ;
		endcase
	end
	
	bird b1(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .x_out(x_out), .y_out(y_out), .done(done_draw_1));
//	
//	frame_counter f15(.num(6'b001111), .clock(CLOCK_50), .reset(1'b0), .q(frame_reached));
	frame_counter f1(.num(6'b000001), .clock(CLOCK_50), .reset(reset_f_counter), .q(one_frame));

	vga_adapter VGA(
		.resetn(KEY[0]),
		.clock(CLOCK_50),
		.colour(3'b111),
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

module bird(cclock, dclock, reset_counter, x_out, y_out, done);
	//cclock = clock for bird_counter
	//dclock = clock for draw_bird
	input cclock, dclock, reset_counter;
	output [7:0] x_out;
	output [6:0] y_out;
	output done;

	wire [7:0] x;
	wire [6:0] y = 7'b0000111;
	

	bird_counter bcount(
		.clock(cclock), 
		.reset(reset_counter), 
		.enable(1'b1), 
		.new_x(x));
		
//	random num1(
//		.clock(dclock),
//		.reset(reset),
//		.y(y));
	
	draw_bird d1(
		.clock(dclock),
		.x(x),
		.y(y), 
		.x_out(x_out), 
		.y_out(y_out),
		.done(done));
		
endmodule

module draw_bird(
		input clock,
		input [7:0] x,
		input	[6:0] y,
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output done
		);
		
	reg [3:0] current_state = BIRD_0;
	reg [3:0] next_state;
		
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
				END: next_state = BIRD_0;
				default:     next_state = END;
			endcase
	end
		
	always @(*)
	begin // set x
		case (current_state)
			BIRD_0: x_out = x ;
			BIRD_1: x_out =  x ;
			BIRD_2: x_out = x - 1 ;
			BIRD_3: x_out = x - 2 ;
			BIRD_4: x_out =  x - 3 ;
			BIRD_5: x_out =  x - 4 ; 
			BIRD_6: x_out =  x - 5 ;
			BIRD_7: x_out =  x - 3 ;
			BIRD_8: x_out =  x - 3 ;
			BIRD_9: x_out = x - 4 ;
			BIRD_10: x_out = x - 4 ;
			BIRD_11: x_out = x - 5 ;
			BIRD_12: x_out = x - 5 ;
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
			BIRD_9: y_out = y + 2 ;
			BIRD_10: y_out = y - 2 ;
			BIRD_11: y_out =  y + 3 ;
			BIRD_12: y_out =  y - 3 ;
      endcase
	end
	
	always @(posedge clock)
	begin
//		if (reset)
//			current_state <= BIRD_0;
//		else
			current_state <= next_state;
	end
	
	assign done = (current_state == END || ~draw_en) ? 1 : 0;
	
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
	
	always @(posedge clock | posedge reset)
	begin
		if (reset)
			q <= 0;
		else
			begin
				if (q == 0)
					q <= 20'b11001011011100110110;//(1/60s)
				else
					q <= q - 1'b1;
			end
	end
endmodule

		
