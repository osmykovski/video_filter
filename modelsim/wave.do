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
add wave -noupdate -radix ascii -radixshowbase 0 /filter_tb/UUT/line_state
add wave -noupdate -radix ascii -radixshowbase 0 /filter_tb/UUT/col_state
add wave -noupdate -radix unsigned -radixshowbase 0 /filter_tb/UUT/buff_cnt
add wave -noupdate -radix hexadecimal -radixshowbase 0 /filter_tb/UUT/in_data_buff
add wave -noupdate -radix hexadecimal -childformat {{{/filter_tb/UUT/buff_out[4]} -radix hexadecimal} {{/filter_tb/UUT/buff_out[3]} -radix hexadecimal} {{/filter_tb/UUT/buff_out[2]} -radix hexadecimal} {{/filter_tb/UUT/buff_out[1]} -radix hexadecimal} {{/filter_tb/UUT/buff_out[0]} -radix hexadecimal}} -radixshowbase 0 -subitemconfig {{/filter_tb/UUT/buff_out[4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/buff_out[3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/buff_out[2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/buff_out[1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/buff_out[0]} {-height 15 -radix hexadecimal -radixshowbase 0}} /filter_tb/UUT/buff_out
add wave -noupdate -radix hexadecimal -childformat {{{/filter_tb/UUT/linebuff[4]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[3]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[2]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1]} -radix hexadecimal -childformat {{{/filter_tb/UUT/linebuff[1][19]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][18]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][17]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][16]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][15]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][14]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][13]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][12]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][11]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][10]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][9]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][8]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][7]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][6]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][5]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][4]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][3]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][2]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][1]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][0]} -radix hexadecimal}}} {{/filter_tb/UUT/linebuff[0]} -radix hexadecimal -childformat {{{/filter_tb/UUT/linebuff[0][19]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][18]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][17]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][16]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][15]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][14]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][13]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][12]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][11]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][10]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][9]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][8]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][7]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][6]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][5]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][4]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][3]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][2]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][1]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][0]} -radix hexadecimal}}}} -radixshowbase 0 -subitemconfig {{/filter_tb/UUT/linebuff[4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/linebuff[1][19]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][18]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][17]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][16]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][15]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][14]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][13]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][12]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][11]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][10]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][9]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][8]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][7]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][6]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][5]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][4]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][3]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][2]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][1]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[1][0]} -radix hexadecimal}} -radixshowbase 0} {/filter_tb/UUT/linebuff[1][19]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][18]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][17]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][16]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][15]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][14]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][13]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][12]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][11]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][10]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][9]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][8]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][7]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][6]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][5]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[1][0]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/linebuff[0][19]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][18]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][17]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][16]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][15]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][14]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][13]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][12]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][11]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][10]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][9]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][8]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][7]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][6]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][5]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][4]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][3]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][2]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][1]} -radix hexadecimal} {{/filter_tb/UUT/linebuff[0][0]} -radix hexadecimal}} -radixshowbase 0} {/filter_tb/UUT/linebuff[0][19]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][18]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][17]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][16]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][15]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][14]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][13]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][12]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][11]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][10]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][9]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][8]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][7]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][6]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][5]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/linebuff[0][0]} {-height 15 -radix hexadecimal -radixshowbase 0}} /filter_tb/UUT/linebuff
add wave -noupdate /filter_tb/UUT/res_valid
add wave -noupdate /filter_tb/UUT/res_tlast
add wave -noupdate /filter_tb/UUT/mat_valid
add wave -noupdate -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[4]} -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[4][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][0]} -radix hexadecimal}}} {{/filter_tb/UUT/matrix_data[3]} -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[3][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][0]} -radix hexadecimal}}} {{/filter_tb/UUT/matrix_data[2]} -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[2][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][0]} -radix hexadecimal}}} {{/filter_tb/UUT/matrix_data[1]} -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[1][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][0]} -radix hexadecimal}}} {{/filter_tb/UUT/matrix_data[0]} -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[0][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][0]} -radix hexadecimal}}}} -radixshowbase 0 -subitemconfig {{/filter_tb/UUT/matrix_data[4]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[4][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[4][0]} -radix hexadecimal}} -radixshowbase 0 -expand} {/filter_tb/UUT/matrix_data[4][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[4][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[4][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[4][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[4][0]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[3]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[3][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[3][0]} -radix hexadecimal}} -radixshowbase 0 -expand} {/filter_tb/UUT/matrix_data[3][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[3][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[3][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[3][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[3][0]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[2]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[2][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[2][0]} -radix hexadecimal}} -radixshowbase 0 -expand} {/filter_tb/UUT/matrix_data[2][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[2][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[2][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[2][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[2][0]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[1]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[1][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[1][0]} -radix hexadecimal}} -radixshowbase 0 -expand} {/filter_tb/UUT/matrix_data[1][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[1][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[1][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[1][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[1][0]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[0]} {-height 15 -radix hexadecimal -childformat {{{/filter_tb/UUT/matrix_data[0][4]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][3]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][2]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][1]} -radix hexadecimal} {{/filter_tb/UUT/matrix_data[0][0]} -radix hexadecimal}} -radixshowbase 0 -expand} {/filter_tb/UUT/matrix_data[0][4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[0][3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[0][2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[0][1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/filter_tb/UUT/matrix_data[0][0]} {-height 15 -radix hexadecimal -radixshowbase 0}} /filter_tb/UUT/matrix_data
add wave -noupdate /filter_tb/UUT/mat_we
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {910000 ps} 0}
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
