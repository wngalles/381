#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_and_N.do
#########################################################################

package require fileutil

vcom -2008 -work work src/TopLevel/BarrelShifter/*.vhd
vcom -2008 -work work src/TopLevel/Mux/mux2t1_N.vhd
vcom -2008 -work work src/TopLevel/Mux/mux2t1.vhd
vcom -2008 -work work src/TopLevel/Logic/*.vhd
vcom -2008 -work work test/*.vhd


vsim -voptargs=+acc tb_barrelshifter

add wave -noupdate -divider {Inputs}
add wave -noupdate -label Input -radix binary /tb_barrelshifter/A
add wave -noupdate -label Offset -radix binary /tb_barrelshifter/offset
add wave -noupdate -label Pass -radix binary /tb_barrelshifter/passed
add wave -noupdate -label Pass -radix binary /tb_barrelshifter/expected

add wave -noupdate -label left -radix binary /tb_barrelshifter/left
add wave -noupdate -label arith -radix binary /tb_barrelshifter/arith

add wave -noupdate -label TestCaseNumber -radix unsigned /tb_barrelshifter/test_case_number

add wave -noupdate -divider {Outputs}
add wave -noupdate -label Output -radix binary /tb_barrelshifter/O

add wave -noupdate -divider {Internal}
add wave -noupdate -radix binary /tb_barrelshifter/DUT0/*



run 400 