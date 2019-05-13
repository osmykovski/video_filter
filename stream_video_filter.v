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

	parameter FILTER_CORE_DIM = 5;

endmodule