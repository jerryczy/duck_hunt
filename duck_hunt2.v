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

	
	wire [7:0] x_out [0:6];
	wire [7:0] test_x;
	reg [7:0] plot_x;
	wire [6:0] y_out [0:6];
	wire [6:0] test_y;
	reg [6:0] plot_y;
	reg [2:0] colour;
	
	wire [4:0] current_state;
	wire frame_reached, one_frame; 

	wire [6:0] done_draw;
	wire [6:0] reset_draw;
	
	wire reset;
	assign reset = KEY[0];
	
	/*
	Datapath (Because Verilog won't let you pass 2D arrays as input for some reason).
	*/
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
				DRAW_BIRD_6 = 5'd14;
				
	always @(*)
	begin
		colour = 3'b000;
		case (current_state)
			ERASE_BIRD_0: begin
				plot_x = x_out[0];
				plot_y = y_out[0];
			end
			DRAW_BIRD_0: begin
				colour = 3'b111;
				plot_x = x_out[0];
				plot_y = y_out[0];
			end
			ERASE_BIRD_1: begin
				plot_x = x_out[1];
				plot_y = y_out[1];
			end
			DRAW_BIRD_1: begin
				colour = 3'b111;
				plot_x = x_out[1];
				plot_y = y_out[1];
			end
			ERASE_BIRD_2: begin
				plot_x = x_out[2];
				plot_y = y_out[2];
			end
			DRAW_BIRD_2: begin
				colour = 3'b111;
				plot_x = x_out[2];
				plot_y = y_out[2];
			end
			ERASE_BIRD_3: begin
				plot_x = x_out[3];
				plot_y = y_out[3];
			end
			DRAW_BIRD_3: begin
				colour = 3'b111;
				plot_x = x_out[3];
				plot_y = y_out[3];
			end
			ERASE_BIRD_4: begin
				plot_x = x_out[4];
				plot_y = y_out[4];
			end
			DRAW_BIRD_4: begin
				colour = 3'b111;
				plot_x = x_out[4];
				plot_y = y_out[4];
			end
			ERASE_BIRD_5: begin
				plot_x = x_out[5];
				plot_y = y_out[5];
			end
			DRAW_BIRD_5: begin
				colour = 3'b111;
				plot_x = x_out[5];
				plot_y = y_out[5];
			end
			ERASE_BIRD_6: begin
				plot_x = x_out[6];
				plot_y = y_out[6];
			end
			DRAW_BIRD_6: begin
				colour = 3'b111;
				plot_x = x_out[6];
				plot_y = y_out[6];
			end
// 			ERASE_HUNTER: colour = 3'b000;
// 			DRAW_HUNTER: colour = 3'b001;
// 			DRAW_LASER: colour = 3'b010;
// 			ERASE_LASER: colour = 3'b000;
		endcase
	end
	
	/*
	Module Instantiations
	*/
	bird b0(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[0]), .x_out(x_out[0]), .y_out(y_out[0]), .done(done_draw[0]), .test_x(test_x), .test_y(test_y));
	bird b1(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[1]), .x_out(x_out[1]), .y_out(y_out[1]), .done(done_draw[1]));
	bird b2(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[2]), .x_out(x_out[2]), .y_out(y_out[2]), .done(done_draw[2]));
	bird b3(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[3]), .x_out(x_out[3]), .y_out(y_out[3]), .done(done_draw[3]));
	bird b4(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[4]), .x_out(x_out[4]), .y_out(y_out[4]), .done(done_draw[4]));
	bird b5(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[5]), .x_out(x_out[5]), .y_out(y_out[5]), .done(done_draw[5]));
	bird b6(.cclock(frame_reached), .dclock(CLOCK_50), .reset_counter(1'b0), .reset_draw(reset_draw[6]), .x_out(x_out[6]), .y_out(y_out[6]), .done(done_draw[6]));
	
	draw_control dc(.clock(CLOCK_50), .done_draw(done_draw), .one_frame(one_frame),  .reset(reset), .reset_draw(reset_draw), .current_state(current_state));
	
	frame_counter fbird(.num(6'b111111), .clock(CLOCK_50), .reset(1'b0), .q(frame_reached));
	rate_divider f1(.clock(CLOCK_50), .reset(1'b0), .one_frame(one_frame));

	/*
	vga_adapter VGA(
		.resetn(KEY[0]),
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
	*/
		
endmodule

module draw_control(clock, done_draw, one_frame, reset, reset_draw, current_state);
	input clock, reset, one_frame;
	input [6:0] done_draw;
	output reg [6:0] reset_draw = 7'b0;
	
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
				DRAW_BIRD_6 = 5'd14;
				
	output reg [4:0] current_state = HOLD;
	reg [4:0] next_state;
		
	always @(*)
	begin
		case(current_state)
			HOLD: next_state = one_frame ? ERASE_BIRD_0 : HOLD;
			ERASE_BIRD_0: next_state = done_draw[0] ? DRAW_BIRD_0 : ERASE_BIRD_0;
			DRAW_BIRD_0: next_state = done_draw[0] ? ERASE_BIRD_1 : DRAW_BIRD_0;
			ERASE_BIRD_1: 	next_state = done_draw[1] ? DRAW_BIRD_1 : ERASE_BIRD_1;
			DRAW_BIRD_1:	next_state = done_draw[1] ? ERASE_BIRD_2 : DRAW_BIRD_1;
			ERASE_BIRD_2: next_state = done_draw[2] ? DRAW_BIRD_2 : ERASE_BIRD_2;
			DRAW_BIRD_2: next_state = done_draw[2] ? ERASE_BIRD_3 : DRAW_BIRD_2;
			ERASE_BIRD_3: next_state = done_draw[3] ? DRAW_BIRD_3 : ERASE_BIRD_3;
			DRAW_BIRD_3: next_state = done_draw[3] ? ERASE_BIRD_4 : DRAW_BIRD_3;
			ERASE_BIRD_4: next_state = done_draw[4] ? DRAW_BIRD_4 : ERASE_BIRD_4;
			DRAW_BIRD_4: next_state = done_draw[4] ? ERASE_BIRD_5 : DRAW_BIRD_4;
			ERASE_BIRD_5: next_state = done_draw[5] ? DRAW_BIRD_5 : ERASE_BIRD_5;
			DRAW_BIRD_5: next_state = done_draw[5] ? ERASE_BIRD_6 : DRAW_BIRD_5;
			ERASE_BIRD_6: next_state = done_draw[6] ? DRAW_BIRD_6 : ERASE_BIRD_6;
			DRAW_BIRD_6: next_state = done_draw[6] ? HOLD : DRAW_BIRD_6;
			
// 			ERASE_HUNTER: next_state = done_draw_h ? DRAW_HUNTER : ERASE_HUNTER;
// 			DRAW_HUNTER: next_state = done_draw_h ? (shoot ? DRAW_LASER : HOLD) : DRAW_HUNTER;
// 			DRAW_LASER: next_state = done_draw_l ? ERASE_LASER : DRAW_LASER;
// 			ERASE_LASER: next_state = done_draw_l ? HOLD : ERASE_LASER;
			default: next_state = HOLD;
		endcase
	end
	
	always @(posedge clock)
	begin
		if (current_state != next_state) begin
			case(next_state)
				ERASE_BIRD_0: reset_draw[0] = 1;
				DRAW_BIRD_0: reset_draw[0] = 1;
				ERASE_BIRD_1: reset_draw[1] = 1;
				DRAW_BIRD_1: reset_draw[1] = 1;
				ERASE_BIRD_2: reset_draw[2] = 1;
				DRAW_BIRD_2: reset_draw[2] = 1;
				ERASE_BIRD_3: reset_draw[3] = 1;
				DRAW_BIRD_3: reset_draw[3] = 1;
				ERASE_BIRD_4: reset_draw[4] = 1;
				DRAW_BIRD_4: reset_draw[4] = 1;
				ERASE_BIRD_5: reset_draw[5] = 1;
				DRAW_BIRD_5: reset_draw[5] = 1;
				ERASE_BIRD_6: reset_draw[6] = 1;
				DRAW_BIRD_6: reset_draw[6] = 1;
			endcase
		end
		else begin
			reset_draw = 7'b0;
		end
		current_state <= next_state;
	end
endmodule

module bird(cclock, dclock, reset_counter, reset_draw, x_out, y_out, done, test_x, test_y);
	//cclock = clock for bird_counter
	//dclock = clock for draw_bird
	input cclock, dclock, reset_counter, reset_draw;
	output [7:0] x_out, test_x;
	output [6:0] y_out, test_y;
	output done;

	wire [7:0] x;
	wire [6:0] y = $urandom%20;
		assign test_x = x;
		assign test_y = y;
	
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
		
	localparam  	BIRD_0  = 4'b0000,//body 1
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
				END: next_state = END;
				default: next_state = END;
			endcase
	end
		
	always @(*)
	begin // set x
		case (current_state)
			BIRD_0: x_out = x ;
			BIRD_1: x_out =  x ;
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
			temp <= num;
	end
	
	assign q = (temp == 0) ? 1 : 0;
	
endmodule
	
module rate_divider(clock, reset, one_frame); //Goes high every 60th of a second.
	input clock;
	input reset;
	
	output one_frame;
	
	reg [19:0] q = 2'b11;
	
	always @(posedge clock)
	begin
		if (reset)
			q <= 1'b1;
		else
			begin
				if (q == 0)
					q <= 2'b11; //20'b11001011011100110110;//(1/60s)
				else
					q <= q - 1'b1;
			end
	end
	
	assign one_frame = (q == 20'b00000000000000000000) ? 1 : 0;
endmodule

		
