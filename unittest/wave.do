onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/FILTER_DIM
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/LINE_TRANS_NUM
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/COPY_FIRST
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/COPY_LAST
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/COE_WIDTH
add wave -noupdate -group const -radix ascii -radixshowbase 0 /filter_test/dut/COE_FILE
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/MAX_IMG_RES
add wave -noupdate -group const -radix unsigned -radixshowbase 0 /filter_test/dut/NORM_FACTOR
add wave -noupdate /filter_test/dut/clk
add wave -noupdate /filter_test/dut/reset
add wave -noupdate -divider {bus in}
add wave -noupdate -radix hexadecimal -radixshowbase 0 /filter_test/dut/s_axis_video_tdata
add wave -noupdate /filter_test/dut/s_axis_video_tvalid
add wave -noupdate /filter_test/dut/s_axis_video_tready
add wave -noupdate /filter_test/dut/s_axis_video_tuser
add wave -noupdate /filter_test/dut/s_axis_video_tlast
add wave -noupdate -divider {bus out}
add wave -noupdate -radix hexadecimal -radixshowbase 0 /filter_test/dut/m_axis_video_tdata
add wave -noupdate /filter_test/dut/m_axis_video_tvalid
add wave -noupdate /filter_test/dut/m_axis_video_tready
add wave -noupdate /filter_test/dut/m_axis_video_tuser
add wave -noupdate /filter_test/dut/m_axis_video_tlast
add wave -noupdate -divider {bus out}
add wave -noupdate /filter_test/dut/rxt
add wave -noupdate /filter_test/dut/line_cnt
add wave -noupdate /filter_test/dut/col_cnt
add wave -noupdate -radix ascii -radixshowbase 0 /filter_test/dut/col_state
add wave -noupdate -radix ascii -radixshowbase 0 /filter_test/dut/line_state
add wave -noupdate /filter_test/dut/col_ready
add wave -noupdate /filter_test/dut/buff_cnt
add wave -noupdate /filter_test/dut/in_data_buff
add wave -noupdate /filter_test/dut/res_valid
add wave -noupdate /filter_test/dut/res_tlast
add wave -noupdate /filter_test/dut/res_tuser
add wave -noupdate /filter_test/dut/mat_we
add wave -noupdate /filter_test/dut/data_tmp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4343225 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {225162002 ns}
