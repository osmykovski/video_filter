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

	parameter FILTER_CORE_DIM = 5;
	
	localparam LINE_TRANS_NUM = FILTER_CORE_DIM/2;
	localparam COPY_FIRST = FILTER_CORE_DIM/2;
	localparam COPY_LAST  = FILTER_CORE_DIM - FILTER_CORE_DIM/2 - 1;

	wire rxt; // rx transfer

	reg [7:0] line_cnt;
	reg [7:0] col_cnt;

	wire col_ready;
	reg res_valid, res_tlast;

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

	assign col_ready = (col_state != COL_COPY_FIRST) && (col_state != COL_COPY_LAST) && (col_state != COL_ENDL);

	always @(posedge clk) begin
		if (!reset) begin
			col_state <= COL_FIRST;
		end
		else case (col_state)
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
		if (!reset) begin
			col_cnt <= 0;
		end
		else if (col_state == COL_COPY_FIRST)
			col_cnt <= col_cnt + 1;
		else if (col_state == COL_COPY_LAST)
			col_cnt <= col_cnt + 1;
		else
			col_cnt <= 0;
	end

	always @* begin
		res_valid <= (col_state == COL_REMAINING) || (col_state == COL_COPY_LAST);
		res_tlast <= (col_cnt == COPY_LAST - 1) && (col_state == COL_COPY_LAST);
	end

	// -------------------------------- //

	`ifdef SIMULATION
		localparam LINE_TRANS     = "LINE_TRANS";
		localparam LINE_FIST_LINE = "LINE_FIST_LINE";
		localparam LINE_DATA      = "LINE_DATA";
		localparam lreg_msb = 120;
	`else
		localparam LINE_TRANS     = 3'b001;
		localparam LINE_FIST_LINE = 3'b010;
		localparam LINE_DATA      = 3'b010;
		localparam lreg_msb = 3;
	`endif

	reg [lreg_msb:0] line_state = LINE_TRANS;

	always @(posedge clk) begin
		if (!reset)
			line_state <= LINE_TRANS;
		else case (line_state)
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
		else if (line_state == LINE_TRANS && col_state == COL_ENDL)
			line_cnt <= line_cnt + 1;
		else if (rxt && s_axis_video_tuser)
			line_cnt <= 0;
	end

	// -------------------------------- //

	assign s_axis_video_tready = (col_ready && m_axis_video_tready);
	assign rxt = (s_axis_video_tready && s_axis_video_tvalid);

endmodule