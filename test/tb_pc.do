#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_pc.do
#########################################################################

vcom -2008 -work work src/*.vhd
vcom -2008 -work work src/TopLevel/*.vhd
vcom -2008 -work work src/TopLevel/Adders/*.vhd
vcom -2008 -work work src/TopLevel/BasicGates/*.vhd
vcom -2008 -work work src/TopLevel/Fetch/*.vhd
vcom -2008 -work work src/TopLevel/Mux/*.vhd
vcom -2008 -work work src/TopLevel/Registers/*.vhd

vcom -2008 -work work test/*.vhd


vsim -voptargs=+acc tb_pc



add wave -noupdate -label CLK /tb_pc/s_CLK
add wave -noupdate -label reset /tb_pc/s_RST

add wave -noupdate -divider {Inputs}
add wave -noupdate -label Write_Enable /tb_pc/s_WE
add wave -noupdate -label PC_IN /tb_pc/s_PCin


add wave -noupdate -divider {Outputs}
add wave -noupdate -label PC_OUT /tb_pc/s_PCout

run 500 