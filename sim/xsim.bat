call F:Xilinx\Vivado\2022.1\bin\xvlog -sv ../rtl/fir_filter.sv ../tb/fir_filter_tb.sv

call F:Xilinx\Vivado\2022.1\bin\xelab fir_filter_tb --snapshot fir_filter_tb -log elaborate.log --debug typical

call F:Xilinx\Vivado\2022.1\bin\xsim fir_filter_tb --tclbatch xsim_cfg.tcl

@REM call F:Xilinx\Vivado\2022.1\bin\xsim --gui fir_filter_tb