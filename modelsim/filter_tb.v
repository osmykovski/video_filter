`timescale 1ns / 1ps

module filter_tb();

	reg clk = 1'b0;
	reg rst = 1'b0;

	parameter PERIOD = 10;

	reg  [23:0] s_tdata;
	wire [23:0] m_tdata;
	reg  s_tvalid, s_tuser, s_tlast, m_tready;
	wire m_tvalid, m_tuser, m_tlast, s_tready;
	
	always @(posedge clk) s_tdata = $random;

	stream_video_filter
	#(
		.FILTER_CORE_DIM(5)
	)
	UUT (
		.clk                 (clk      ),
		.reset               (rst      ),

		.s_axis_video_tdata  (s_tdata  ),
		.s_axis_video_tvalid (s_tvalid ),
		.s_axis_video_tready (s_tready ),
		.s_axis_video_tuser  (s_tuser  ),
		.s_axis_video_tlast  (s_tlast  ),

		.m_axis_video_tdata  (m_tdata  ),
		.m_axis_video_tvalid (m_tvalid ),
		.m_axis_video_tready (m_tready ),
		.m_axis_video_tuser  (m_tuser  ),
		.m_axis_video_tlast  (m_tlast  )
	);

	always begin : clock_gen
		clk = 1'b1;
		#(PERIOD/2);
		clk = 1'b0;
		#(PERIOD/2);
	end

	assign taction = (s_tready && s_tvalid);

	localparam frame_lenght = 20;
	localparam frame_height = 10;

	reg [7:0] lenght_cnt = 0;
	reg [7:0] height_cnt = 0;

	// -------------------------------- //

	always @(posedge clk) begin
		if(!rst)
			lenght_cnt <= 0;
		else if(taction) begin
			if(lenght_cnt == frame_lenght-1)
				lenght_cnt <= 0;
			else
				lenght_cnt <= lenght_cnt + 1;
		end
	end

	always @* begin
		s_tlast = (lenght_cnt == frame_lenght-1);
		s_tuser = (height_cnt == 0) && (lenght_cnt == 0);
	end


	// -------------------------------- //

	always @(posedge clk) begin
		if (!rst)
			height_cnt <= 0;
		else if(taction && s_tlast) begin
			if(height_cnt == frame_height-1)
				height_cnt = 0;
			else
				height_cnt = height_cnt + 1;
		end
	end

	// -------------------------------- //

	initial begin : rst_gen
		s_tvalid = 1'b1;
		m_tready = 1'b1;
		#100;
		rst <= 1'b1;
	end

endmodule
