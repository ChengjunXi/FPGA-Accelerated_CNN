module final_top (
	input  logic        CLOCK_50,
	input  logic [1:0]  KEY,
	output logic [7:0]  LEDG,
	output logic [6:0]  HEX0,
	output logic [6:0]  HEX1,
	output logic [6:0]  HEX2,
	output logic [6:0]  HEX3,
	output logic [6:0]  HEX4,
	output logic [6:0]  HEX5,
	output logic [6:0]  HEX6,
	output logic [6:0]  HEX7,
    output logic [19:0] ADDR,
	output logic CE, UB, LB, OE, WE,
    input logic [15:0] Data
);

logic NN_START=1'b0,NN_START_in=1'b0;
logic NN_DONE;
logic allDONE;
logic [31:0] display;
integer prediction;
logic [15:0] address=16'b0,offset;

NN model(
	.*,
	.CLK(CLOCK_50),
	.RESET(~KEY[0])
);

enum logic [1:0]{WAIT,INIT,WORKING,DONE} state=WAIT,next_state=WAIT;
logic[1:0] counter,counter_in;

always_comb begin
	counter_in=counter;
	next_state=state;
	allDONE=1'b0;
	NN_START_in=NN_START;

	case(state)
	WAIT:
		if(~KEY[1])
			next_state=INIT;
		else
			next_state=WAIT;

	INIT:
		if(~KEY[1])
			next_state=WORKING;
		else
			next_state=INIT;

	WORKING:
		if(NN_DONE)
			next_state=DONE;
		else
			next_state=WORKING;
			
	DONE:
		if(counter==3)
			next_state=DONE;
		else if (~KEY[1])
			next_state=DONE;
		else
			next_state=INIT;
	endcase
			
	case(state)
	WAIT: begin
		NN_START_in=1'b0;
	end

	INIT:
		allDONE=1'b0;
		counter_in=0;

	WORKING:
		if(NN_DONE) begin
			counter_in=counter+1;
			NN_START_in=1'b0;
		end else begin
			NN_START_in=1'b1;
		end

	DONE:
		allDONE=1'b1;
	endcase
end

always_ff @ (posedge CLOCK_50) begin
	if (~KEY[0]) begin
		state <= WAIT;
		counter<=0;
		NN_START<=0;
	end else begin
		state<=next_state;
		counter<=counter_in;
		NN_START<=NN_START_in;
	end
end

always_comb begin
	offset=counter*392;
	ADDR = { 4'b00, address+offset };
	display = prediction;
    LEDG[0] = allDONE;
end

assign CE = 1'b0;
assign UB = 1'b0;
assign LB = 1'b0;
assign WE = 1'b1;
assign OE = 1'b0;

// Display the first 4 and the last 4 hex values of the received message
hexdriver hexdrv0 (
	.In(display[3:0]),
   .Out(HEX0)
);
hexdriver hexdrv1 (
	.In(display[7:4]),
   .Out(HEX1)
);
hexdriver hexdrv2 (
	.In(display[11:8]),
   .Out(HEX2)
);
hexdriver hexdrv3 (
	.In(display[15:12]),
   .Out(HEX3)
);
hexdriver hexdrv4 (
	.In(display[19:16]),
   .Out(HEX4)
);
hexdriver hexdrv5 (
	.In(display[23:20]),
   .Out(HEX5)
);
hexdriver hexdrv6 (
	.In(display[27:24]),
   .Out(HEX6)
);
hexdriver hexdrv7 (
	.In(display[31:28]),
   .Out(HEX7)
);

endmodule