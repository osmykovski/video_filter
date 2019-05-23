set PrefSource(font) {{Courier New Cyr} 9 normal}

vlib work

vlog ../stream_video_filter.v
vlog ./filter_tb.v

vsim -t 1ps -novopt filter_tb
##
do wave.do
view wave

run 5 us