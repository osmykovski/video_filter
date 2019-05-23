ECHO OFF
del vsim.wlf/Q
del transcript/Q
del wlft*/Q
RMDIR work /S /Q

ECHO ON
call modelsim -do sim_func.do
