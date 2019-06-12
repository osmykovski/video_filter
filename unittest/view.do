# convert VCD waveforms to Modelsim WLF format
vcd2wlf filter_test.vcd filter_test.wlf
# open WLF file
vsim -view filter_test.wlf

do wave.do
view wave