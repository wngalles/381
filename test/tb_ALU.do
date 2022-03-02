#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_ALU.do
#########################################################################

package require fileutil

eval vcom -2008 -work work [::fileutil::findByPattern . -glob *.vhd]


vsim -voptargs=+acc tb_ALU


add wave -noupdate -label CLK /tb_ALU/s_CLK
#add wave -noupdate -label reset /tb_ALU/s_RST

add wave -noupdate -divider {Inputs}
add wave -noupdate -label In_1 /tb_ALU/s_In1
add wave -noupdate -label In_2 /tb_ALU/s_In2
add wave -noupdate -label ALU_Op /tb_ALU/s_ALUop
add wave -noupdate -label Movn /tb_ALU/s_Movn
add wave -noupdate -label SHAMT /tb_ALU/s_SHAMT

add wave -noupdate -divider {Outputs}
add wave -noupdate -label Equal /tb_ALU/s_Equal
add wave -noupdate -label OverFlow /tb_ALU/s_OverFlow
add wave -noupdate -label Out /tb_ALU/s_Out1

#add wave -noupdate -label Out /tb_ALU/DUT0/s_OpSelect



run 200 