#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_fetch.do
#########################################################################

package require fileutil

eval vcom -2008 -work work [::fileutil::findByPattern . -glob *.vhd]


vsim -voptargs=+acc tb_fetch



add wave -noupdate -label CLK /tb_fetch/s_CLK
#add wave -noupdate -label reset /tb_fetch/s_RST

add wave -noupdate -divider {Inputs}
add wave -noupdate -label PC_IN /tb_fetch/s_PCin
add wave -noupdate -label Instruction /tb_fetch/s_Instruction
add wave -noupdate -label Immediate /tb_fetch/s_Immediate
add wave -noupdate -label Register /tb_fetch/s_Register
add wave -noupdate -label Jump /tb_fetch/s_Jump
add wave -noupdate -label JumpRegister /tb_fetch/s_JumpRegister
add wave -noupdate -label BEQ /tb_fetch/s_BEQ
add wave -noupdate -label BNE /tb_fetch/s_BNE
add wave -noupdate -label Equal /tb_fetch/s_Equal


add wave -noupdate -divider {Outputs}
add wave -noupdate -label PC_OUT /tb_fetch/s_PCout

run 1000 