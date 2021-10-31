module NN (
	input  CLK,
	input  RESET,
	input  NN_START,
	input  logic [15:0] Data,
	output logic [15:0] address,
	output NN_DONE=0,
	output integer prediction
);

reg [31:0] weights_mem [6779:0];
logic [677:0][9:0][31:0] weights;
logic [675:0][31:0] to_sum,to_sum_in;
logic [31:0] probs,probs_in,old_probs,old_probs_in;
logic [31:0] multi,multi2;
logic [31:0] to_multi1,to_multi2,to_multi3,to_multi4;
logic[3:0] prediction_in;
enum logic [3:0]{WAIT,imgINIT,imgRD,imgLD,INIT,CONV,RELU,MULTI,SUM,BIAS,COMPARE,DONE} state=WAIT,next_state=WAIT;
logic[9:0] i,counter,counter_in;
logic[3:0] number,number_in;
logic[4:0] j;
logic [675:0][31:0] feature_map;
logic [25:0][25:0][31:0] feature_map_2D,feature_map_2D_in;
logic [27:0][27:0][7:0] img2D;
logic [783:0][7:0] img,img_in;
//reg [7:0] img [783:0];
logic [4:0] row,row_in,col,col_in,kernel_row,kernel_col,kernel_row_in,kernel_col_in;
logic [2:0][2:0][31:0] kernel;

initial
begin
    $readmemh("weights.txt", weights_mem);
end

always_comb begin 
	for(i=0;i<678;i=i+1) begin
		for(j=0;j<10;j=j+1)
			weights[i][j]=weights_mem[i*10+j];
	end

	for(i=0;i<3;i=i+1) begin
		for(j=0;j<3;j=j+1)
			kernel[i][j]=weights[677][i*3+j];
	end

	for(i=0;i<28;i=i+1) begin
		for(j=0;j<28;j=j+1) begin
			img2D[i][j]=img[i*28+j];
		end
	end

	for(i=0;i<26;i=i+1) begin
		for(j=0;j<26;j=j+1) begin
			feature_map[i*26+j]=feature_map_2D[i][j];
		end
	end

	to_multi1=feature_map[counter];
	to_multi2=weights[counter][number];

	multi=to_multi1*to_multi2;

	to_multi3=img2D[row+kernel_row][col+kernel_col];
	to_multi4=kernel[kernel_row][kernel_col];

	multi2=to_multi3*to_multi4;	

	next_state=state;
	counter_in=counter;
	probs_in=probs;
	NN_DONE=1'b0;
	prediction_in=prediction;
	i=0;
	j=0;
	to_sum_in = to_sum;
	number_in=number;
	old_probs_in=old_probs;
	feature_map_2D_in=feature_map_2D;
	row_in=row;
	col_in=col;
	img_in=img;
	kernel_row_in=kernel_row;
	kernel_col_in=kernel_col;

	case(state)
	WAIT: //1
		if(NN_START)
			next_state=imgINIT;
		else
			next_state=WAIT;

	imgINIT: //2
		next_state=imgRD;
	
	imgRD: //2+392=394
		if(counter==391)
			next_state=INIT;
		else
			next_state=imgLD;
	
	imgLD: //394+392=786
		next_state=imgRD;	

	INIT: //787
		next_state=CONV;
	
	CONV: //787+26*26*10=7547
		if(row==25 && col==25 && kernel_row==3)
			next_state=RELU;
		else
			next_state=CONV;

	RELU: //7547+26*26=8223
		if(row==25 && col==25)
			next_state=MULTI;
		else
			next_state=RELU;	

	MULTI: //8223+676=8899
		if(counter==675)
			next_state=SUM;
		else
			next_state=MULTI;

	SUM: //8899+676=9575
		if(counter==675)
			next_state=BIAS;
		else
			next_state=SUM;

	BIAS: //9576
		next_state=COMPARE;

	COMPARE: //9586
		if(number==9)
			next_state=DONE;
		else
			next_state=MULTI;

	DONE: //9587
		if(NN_START)
			next_state=DONE;
		else
			next_state=WAIT;
	endcase
			
	case(state)
	WAIT:
		NN_DONE=1'b0;

	imgINIT: begin
		NN_DONE=1'b0;
		counter_in=0;
	end
	
	imgRD: begin
		counter_in=counter+1;
		img_in[counter*2] = Data[7:0];
		img_in[counter*2+1] = Data[15:8];
	end
	
	imgLD:;

	INIT: begin
		counter_in=0;
		probs_in=32'b0;
		old_probs_in=32'h80000000;
		number_in=0;
		prediction_in=0;
		row_in=0;
		col_in=0;
		kernel_row_in=0;
		kernel_col_in=0;
		feature_map_2D_in=27040'b0;
	end

	CONV: begin
		if(kernel_row!=3) begin
			feature_map_2D_in[row][col]=feature_map_2D[row][col]+multi2;
			if(kernel_col==2) begin
				kernel_col_in=0;
				kernel_row_in=kernel_row+1;
			end else
				kernel_col_in=kernel_col+1;
		end else begin
			feature_map_2D_in[row][col]=feature_map_2D[row][col]+weights[677][9];
			if(row==25 && col==25) begin
				row_in=0;
				col_in=0;
			end else if (col==25) begin
				row_in=row+1;
				col_in=0;
				kernel_row_in=0;
				kernel_col_in=0;
			end else begin
				col_in=col+1;	
				kernel_row_in=0;
				kernel_col_in=0;	
			end
		end
	end

	RELU: begin
		if(feature_map_2D[row][col][31])
			feature_map_2D_in[row][col]=0;
		else;

		if(row==25 && col==25) begin
			counter_in=0;
		end else if (col==25) begin
			row_in=row+1;
			col_in=0;
		end else begin
			col_in=col+1;		
		end
	end


	MULTI: begin
		if(counter!=675) begin
			counter_in=counter+1;
		end else begin
			counter_in=0;
		end
		to_sum_in[counter]=multi;
	end	

	SUM: begin
		counter_in=counter+1;
		probs_in=probs+to_sum[counter];
	end

	BIAS: begin
		probs_in=probs+weights[676][number];
	end

	COMPARE: begin
		counter_in=0;
		probs_in=0;
		number_in=number+1;
		if(probs[31]) begin
			if(old_probs[31]) begin
				if(probs<old_probs) begin
					prediction_in=number;
					old_probs_in=probs;
				end else;
			end else;
		end else begin
			if(old_probs[31]) begin
				prediction_in=number;
				old_probs_in=probs;
			end	else begin
				if(probs>old_probs) begin
					prediction_in=number;
					old_probs_in=probs;
				end else;
				end
			end

	end

	DONE:
		NN_DONE=1;
	endcase
end

assign address = {6'b0,counter[9:0]};

always_ff @ (posedge CLK) begin
	if (RESET) begin
		state <= WAIT;
		prediction<=0;
	end else begin
		state<=next_state;
		counter<=counter_in;
		probs<=probs_in;
		prediction<={28'b0,prediction_in};
		old_probs<=old_probs_in;
		to_sum<=to_sum_in;
		number<=number_in;
		col<=col_in;
		row<=row_in;
		img<=img_in;
		feature_map_2D<=feature_map_2D_in;
		kernel_row<=kernel_row_in;
		kernel_col<=kernel_col_in;
	end
end

endmodule
