module filter_test;

	reg           clk                 ;
	reg           reset               ;
	
	reg    [23:0] s_axis_video_tdata  ;
	reg           s_axis_video_tvalid ;
	wire          s_axis_video_tready ;
	reg           s_axis_video_tuser  ;
	reg           s_axis_video_tlast  ;
	
	wire   [23:0] m_axis_video_tdata  ;
	wire          m_axis_video_tvalid ;
	reg           m_axis_video_tready ;
	wire          m_axis_video_tuser  ;
	wire          m_axis_video_tlast  ;
	
	initial begin
		$from_myhdl (
			clk, reset,
			s_axis_video_tdata,
			s_axis_video_tvalid,
			s_axis_video_tuser,
			s_axis_video_tlast,
			m_axis_video_tready
		);
		$to_myhdl (
			s_axis_video_tready,
			m_axis_video_tdata,
			m_axis_video_tvalid,
			m_axis_video_tuser,
			m_axis_video_tlast
		);
	end
	
	stream_video_filter dut (
		
		.clk                (clk                ),
		.reset              (reset              ),
		
		.s_axis_video_tdata (s_axis_video_tdata ),
		.s_axis_video_tvalid(s_axis_video_tvalid),
		.s_axis_video_tready(s_axis_video_tready),
		.s_axis_video_tuser (s_axis_video_tuser ),
		.s_axis_video_tlast (s_axis_video_tlast ),
		
		.m_axis_video_tdata (m_axis_video_tdata ),
		.m_axis_video_tvalid(m_axis_video_tvalid),
		.m_axis_video_tready(m_axis_video_tready),
		.m_axis_video_tuser (m_axis_video_tuser ),
		.m_axis_video_tlast (m_axis_video_tlast )
	);
	
	localparam IDENTITY_COEF = "./coefficients/coef_identity.txt";
	localparam EDETECT1_COEF = "./coefficients/coef_edetect1.txt";
	localparam EDETECT2_COEF = "./coefficients/coef_edetect2.txt";
	localparam EDETECT3_COEF = "./coefficients/coef_edetect3.txt";
	localparam SHARPEN_COEF = "./coefficients/coef_sharpen.txt";
	localparam BOX_BLUR_COEF = "./coefficients/coef_box_blur.txt";
	localparam GAUSSIAN_BLUR_COEF = "./coefficients/coef_gaussian_blur.txt";
	localparam GAUSSIAN_BLUR_5_5_COEF = "./coefficients/coef_gaussian_blur_5_5.txt";
	localparam UNSHARP_MASKING_COEF = "./coefficients/coef_unsharp_masking.txt";
	
	defparam dut.FILTER_DIM      = `FILTER_DIM     ;
	defparam dut.COE_WIDTH       = `COE_WIDTH      ;
	defparam dut.COE_FILE        = `COE_FILE_NAME  ;
	defparam dut.MAX_IMG_RES     = `MAX_IMG_RES    ;
	defparam dut.NORM_FACTOR     = `NORM_FACTOR    ;
	
endmodule
