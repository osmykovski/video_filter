onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /filter_tb/UUT/clk
add wave -noupdate /filter_tb/UUT/reset
add wave -noupdate -radix hexadecimal -radixshowbase 0 /filter_tb/UUT/s_axis_video_tdata
add wave -noupdate /filter_tb/UUT/s_axis_video_tvalid
add wave -noupdate /filter_tb/UUT/s_axis_video_tready
add wave -noupdate /filter_tb/UUT/s_axis_video_tuser
add wave -noupdate /filter_tb/UUT/s_axis_video_tlast
add wave -noupdate /filter_tb/UUT/m_axis_video_tdata
add wave -noupdate /filter_tb/UUT/m_axis_video_tvalid
add wave -noupdate /filter_tb/UUT/m_axis_video_tready
add wave -noupdate /filter_tb/UUT/m_axis_video_tuser
add wave -noupdate /filter_tb/UUT/m_axis_video_tlast
add wave -noupdate /filter_tb/UUT/rxt
add wave -noupdate -radix unsigned -radixshowbase 0 /filter_tb/UUT/line_cnt
add wave -noupdate -radix unsigned -radixshowbase 0 /filter_tb/UUT/col_cnt
add wave -noupdate /filter_tb/UUT/col_ready
add wave -noupdate /filter_tb/UUT/res_valid
add wave -noupdate /filter_tb/UUT/res_tlast
add wave -noupdate -radix ascii -radixshowbase 0 /filter_tb/UUT/line_state
add wave -noupdate -radix ascii -radixshowbase 0 /filter_tb/UUT/col_state
add wave -noupdate -divider {New Divider}
add wave -noupdate -radix unsigned -radixshowbase 0 /filter_tb/UUT/buff_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5250 ns}
