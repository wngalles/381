#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_fetch.do
#########################################################################

vcom -2008 -work work src/*.vhd
vcom -2008 -work work src/TopLevel/*.vhd
vcom -2008 -work work src/TopLevel/Adders/*.vhd
vcom -2008 -work work src/TopLevel/BasicGates/*.vhd
vcom -2008 -work work src/TopLevel/Fetch/*.vhd
vcom -2008 -work work src/TopLevel/Mux/*.vhd
vcom -2008 -work work src/TopLevel/Registers/*.vhd

vcom -2008 -work work test/*.vhd


vsim -voptargs=+acc tb_fetch



add wave -noupdate -label CLK /tb_fetch/s_CLK
#add wave -noupdate -label reset /tb_fetch/s_RST

add wave -noupdate -divider {Inputs}
add wave -noupdate -label PC_IN /tb_fetch/s_PCin
add wave -noupdate -label Instruction /tb_fetch/s_Instruction
add wave -noupdate -label Immediate /tb_fetch/s_Immediate
add wave -noupdate -label Jump /tb_fetch/s_Jump
add wave -noupdate -label Branch /tb_fetch/s_Branch
add wave -noupdate -label Zero /tb_fetch/s_Zero


add wave -noupdate -divider {Outputs}
add wave -noupdate -label PC_OUT /tb_fetch/s_PCout

run 500 