module stream_video_filter(
	input           clk                     ,
	input           reset                   ,

	input    [23:0] s_axis_video_tdata      ,   // Video Data
	input           s_axis_video_tvalid     ,   // Valid
	output          s_axis_video_tready     ,   // Ready
	input           s_axis_video_tuser      ,   // Start Of Frame
	input           s_axis_video_tlast      ,   // End Of Line

	output   [23:0] m_axis_video_tdata      ,   // Video Data
	output          m_axis_video_tvalid     ,   // Valid
	input           m_axis_video_tready     ,   // Ready
	output          m_axis_video_tuser      ,   // Start Of Frame
	output          m_axis_video_tlast          // End Of Line
);

	`define SIMULATION = 1;

	parameter FILTER_DIM = 5;

	localparam LINE_TRANS_NUM = FILTER_DIM/2;
	localparam COPY_FIRST = FILTER_DIM/2;
	localparam COPY_LAST  = FILTER_DIM - FILTER_DIM/2 - 1;

	parameter COE_WIDTH = 16;
	parameter COE_FILE = "../coe.dat";

	reg signed [COE_WIDTH-1:0] coe_matrix [FILTER_DIM-1:0][FILTER_DIM-1:0];
	initial
		$readmemh(COE_FILE, coe_matrix);

	wire rxt; // rx transfer

	reg [7:0] line_cnt;
	reg [7:0] col_cnt;

	// -------------------------------- //

	`ifdef SIMULATION
		localparam COL_FIRST      = "COL_FIRST     ";
		localparam COL_COPY_FIRST = "COL_COPY_FIRST";
		localparam COL_SECOND     = "COL_SECOND    ";
		localparam COL_REMAINING  = "COL_REMAINING ";
		localparam COL_COPY_LAST  = "COL_COPY_LAST ";
		localparam COL_ENDL       = "COL_ENDL      ";
		localparam creg_msb = 120;
	`else
		localparam COL_FIRST      = 6'b000001;
		localparam COL_COPY_FIRST = 6'b000010;
		localparam COL_SECOND     = 6'b000100;
		localparam COL_REMAINING  = 6'b001000;
		localparam COL_COPY_LAST  = 6'b010000;
		localparam COL_ENDL       = 6'b100000;
		localparam creg_msb = 6;
	`endif

	reg [creg_msb:0] col_state = COL_FIRST;

	always @(posedge clk) begin
		if (!reset)
			col_state <= COL_FIRST;
		else if (m_axis_video_tready && s_axis_video_tvalid) case (col_state)
			COL_FIRST : begin
				if (rxt)
					col_state <= COL_COPY_FIRST;
			end
			COL_COPY_FIRST : begin
				if (col_cnt == COPY_FIRST - 1)
					col_state <= COL_SECOND;
			end
			COL_SECOND : begin
				if (rxt)
					col_state <= COL_REMAINING;
			end
			COL_REMAINING : begin
				if (rxt && s_axis_video_tlast)
					col_state <= COL_COPY_LAST;
			end
			COL_COPY_LAST : begin
				if (col_cnt == COPY_LAST - 1)
					col_state <= COL_ENDL;
			end
			COL_ENDL : begin
				col_state <= COL_FIRST;
			end
			default: begin
				col_state <= COL_FIRST;
			end
		endcase
	end

	always @(posedge clk) begin
		if (!reset)
			col_cnt <= 0;
		else if (m_axis_video_tready && s_axis_video_tvalid)
			if (col_state == COL_COPY_FIRST)
				col_cnt <= col_cnt + 1;
			else if (col_state == COL_COPY_LAST)
				col_cnt <= col_cnt + 1;
			else
				col_cnt <= 0;
	end

	// -------------------------------- //

	`ifdef SIMULATION
		localparam LINE_TRANS     = "LINE_TRANS    ";
		localparam LINE_FIST_LINE = "LINE_FIST_LINE";
		localparam LINE_DATA      = "LINE_DATA     ";
		localparam lreg_msb = 120;
	`else
		localparam LINE_TRANS     = 3'b001;
		localparam LINE_FIST_LINE = 3'b010;
		localparam LINE_DATA      = 3'b100;
		localparam lreg_msb = 3;
	`endif

	reg [lreg_msb:0] line_state = LINE_TRANS;

	always @(posedge clk) begin
		if (!reset)
			line_state <= LINE_TRANS;
		else if (m_axis_video_tready && s_axis_video_tvalid) case (line_state)
			LINE_TRANS : begin
				if (col_state == COL_ENDL && line_cnt == LINE_TRANS_NUM - 1)
					line_state <= LINE_FIST_LINE;
			end
			LINE_FIST_LINE : begin
				if (col_state == COL_ENDL)
					line_state <= LINE_DATA;
			end
			LINE_DATA : begin
				if (rxt && s_axis_video_tuser)
					line_state <= LINE_TRANS;
			end
			default: begin
				line_state <= LINE_TRANS;
			end
		endcase
	end

	always @(posedge clk) begin
		if (!reset)
			line_cnt <= 0;
		else if (m_axis_video_tready && s_axis_video_tvalid)
			if (line_state == LINE_TRANS && col_state == COL_ENDL)
				line_cnt <= line_cnt + 1;
			else if (rxt && s_axis_video_tuser)
				line_cnt <= 0;
	end

	// -------------------------------- //

	assign col_ready = (col_state != COL_COPY_FIRST) &&
		(col_state != COL_COPY_LAST) &&
		(col_state != COL_ENDL);
	assign s_axis_video_tready = (col_ready && m_axis_video_tready);
	assign rxt = (s_axis_video_tready && s_axis_video_tvalid);

	// -------------------------------- //

	parameter MAX_IMG_RES = 20;

	reg [23:0] linebuff [FILTER_DIM-1:0][MAX_IMG_RES-1:0];

	reg [15:0] buff_cnt;

	reg [23:0] buff_out[FILTER_DIM-1:0];

	always @(posedge clk) begin
		if (!reset)
			buff_cnt <= 0;
		else if (m_axis_video_tready && rxt) begin
			if (s_axis_video_tlast)
				buff_cnt <= 0;
			else
				buff_cnt <= buff_cnt + 1;
		end
	end

	integer i, j, t;

	reg [23:0] in_data_buff;

	always @(posedge clk) begin
		if (!reset) begin
			in_data_buff <= 24'b0;
			for (i=0; i<FILTER_DIM; i=i+1)
				for (j=0; j<MAX_IMG_RES; j=j+1)
					linebuff[i][j] <= 24'b0;
			for (i=0; i<FILTER_DIM; i=i+1)
				buff_out[i] <= 24'b0;
		end else if (m_axis_video_tready)
			if (rxt) begin
				for (t=0; t<FILTER_DIM; t=t+1)
					buff_out[t] <= linebuff[t][buff_cnt];
				for (t=1; t<FILTER_DIM; t=t+1)
					linebuff[t][buff_cnt] <= linebuff[t-1][buff_cnt];
				linebuff[0][buff_cnt] <= s_axis_video_tdata;
				in_data_buff <= s_axis_video_tdata;
			end
	end

	// -------------------------------- //

	reg [3:0] res_valid, res_tlast;
	reg [4:0] res_tuser;

	always @(posedge clk) begin
		if (!reset) begin
			res_valid <= 'b0;
			res_tlast <= 'b0;
			res_tuser <= 'b0;
		end else if (m_axis_video_tready && s_axis_video_tvalid) begin
			res_valid <= {res_valid[2:0],
				(col_state != COL_FIRST) &&
				(col_state != COL_COPY_FIRST) &&
				(col_state != COL_SECOND) &&
				(col_state != COL_ENDL)
			};
			res_tlast <= {res_tlast[2:0],
				(col_state == COL_COPY_LAST) &&
				(col_cnt == COPY_LAST - 1)
			};
			res_tuser <= {res_tuser[3:0],
				(col_state == COL_SECOND) &&
				(line_state == LINE_FIST_LINE)
			};
		end
	end

	// -------------------------------- //

	reg [23:0] matrix_data [FILTER_DIM-1:0][FILTER_DIM-1:0];

	reg [FILTER_DIM-1:0] mat_we;

	always @(posedge clk) begin
		if (!reset)
			mat_we <= {FILTER_DIM{1'b0}};
		else if (m_axis_video_tready && s_axis_video_tvalid)
			// LINE_TRANS -> LINE_FIST_LINE
			if (col_state == COL_FIRST && rxt && line_state == LINE_FIST_LINE)
				for (t=0; t<FILTER_DIM; t=t+1)
					mat_we[t] <= (t <= LINE_TRANS_NUM) ? 1'b1 : 1'b0;

			// LINE_DATA -> LINE_TRANS
			else if (line_state == LINE_DATA && rxt && s_axis_video_tuser)
				mat_we[0] = 1'b0;

			// shift left
			else if (col_state == COL_FIRST)
				mat_we <= {mat_we[FILTER_DIM-2:0], mat_we[0]};
	end

	reg [23:0] data_tmp = 24'b0;

	always @(posedge clk) begin
		if (!reset)
			for (i=0; i<FILTER_DIM; i=i+1)
				for (j=0; j<FILTER_DIM; j=j+1)
					matrix_data[i][j] <= 0;
		else if (m_axis_video_tready && s_axis_video_tvalid) begin
			// first, shift the data
			for (i=0; i<FILTER_DIM; i=i+1)
				for (j=1; j<FILTER_DIM; j=j+1)
					matrix_data[i][j] <= matrix_data[i][j-1];

			// then update first column
			if (line_state == LINE_TRANS) begin
				for (t=0; t<FILTER_DIM; t=t+1) begin
					// fill from buffer according to mask
					if (mat_we[t])
						matrix_data[t][0] <= buff_out[t-1];

					// fill the last lines with the same data
					else
						matrix_data[t][0] <= buff_out[line_cnt];
				end
			end else begin
				for (t=1; t<FILTER_DIM; t=t+1) begin
					// fill from buffer according to mask
					if (mat_we[t]) begin
						matrix_data[t][0] <= buff_out[t-1];
						data_tmp = buff_out[t-1];

					// repeat last line
					end else matrix_data[t][0] <= data_tmp;
				end
				// first line goes directly from bus
				if (mat_we[0])
					matrix_data[0][0] <= in_data_buff;
			end
		end
	end

	// -------------------------------- //

	reg signed [8:0] mul_out_matrix [FILTER_DIM-1:0][FILTER_DIM-1:0][2:0];

	// 1 sign + 8 data + COE_WIDTH coeff - 1 coeff sign
	reg signed [8+COE_WIDTH:0] reg_rgb[2:0];

	always @(posedge clk) begin
		if (!reset)
			for (i=0; i<FILTER_DIM; i=i+1)
				for (j=0; j<FILTER_DIM; j=j+1) begin
					mul_out_matrix[i][j][0] <= 'b0;
					mul_out_matrix[i][j][1] <= 'b0;
					mul_out_matrix[i][j][2] <= 'b0;
				end
		else if (m_axis_video_tready && s_axis_video_tvalid)
			for (i=0; i<FILTER_DIM; i=i+1)
				for (j=0; j<FILTER_DIM; j=j+1) begin

					// note: matrix_data is flipped horizontally and vertically
					reg_rgb[0] = $signed({1'b0, matrix_data[i][j][23:16]}) * coe_matrix[i][j];
					reg_rgb[1] = $signed({1'b0, matrix_data[i][j][15:8]})  * coe_matrix[i][j];
					reg_rgb[2] = $signed({1'b0, matrix_data[i][j][7:0]})   * coe_matrix[i][j];

					mul_out_matrix[i][j][0] <= reg_rgb[0] / 2**(COE_WIDTH-1);
					mul_out_matrix[i][j][1] <= reg_rgb[1] / 2**(COE_WIDTH-1);
					mul_out_matrix[i][j][2] <= reg_rgb[2] / 2**(COE_WIDTH-1);
				end
	end

	// -------------------------------- //

	parameter integer NORM_FACTOR = (2**16)/(FILTER_DIM**2);

	reg signed [23:0] conv_sum[2:0];
	reg signed [23:0] conv_div[2:0];

	always @(posedge clk) begin
		if (!reset)
			for (t=0; t<3; t=t+1)
				conv_sum[t] <= 'b0;
		else if (m_axis_video_tready && s_axis_video_tvalid) begin
			for (t=0; t<3; t=t+1)
				conv_sum[t] = 'b0;
			for (t=0; t<3; t=t+1)
				for (i=0; i<FILTER_DIM; i=i+1)
					for (j=0; j<FILTER_DIM; j=j+1)
						conv_sum[t] = conv_sum[t] + mul_out_matrix[i][j][t];
		end
	end

	always @(posedge clk) begin
		if (!reset)
			for (t=0; t<3; t=t+1)
				conv_div[t] <= 'b0;
		else if (m_axis_video_tready && s_axis_video_tvalid)
			for (t=0; t<3; t=t+1)
				conv_div[t] <= conv_sum[t] * NORM_FACTOR / 2**16;
	end
	
	assign m_axis_video_tdata  = {conv_div[0][7:0], conv_div[1][7:0], conv_div[2][7:0]};
	assign m_axis_video_tvalid = res_valid[3] && s_axis_video_tvalid;
	assign m_axis_video_tlast  = res_tlast[3];
	assign m_axis_video_tuser  = res_tuser[4];

endmodule