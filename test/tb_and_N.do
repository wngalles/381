#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_and_N.do
#########################################################################

package require fileutil

eval vcom -2008 -work work [::fileutil::findByPattern . -glob *.vhd]


vsim -voptargs=+acc tb_and_N


add wave -noupdate -label CLK /tb_and_N/s_CLK
#add wave -noupdate -label reset /tb_and_N/s_RST

add wave -noupdate -divider {Inputs}
add wave -noupdate -label In_1 /tb_and_N/s_In1
add wave -noupdate -label In_2 /tb_and_N/s_In2

add wave -noupdate -divider {Outputs}
add wave -noupdate -label PC_OUT /tb_and_N/s_Out2

run 500 