ECHO OFF

del vsim.wlf
del transcript
del wlft*
del filter_test.vcd 
del filter_test.wlf
del *.png
RMDIR msim /S /Q
RMDIR work /S /Q
RMDIR __pycache__ /S /Q