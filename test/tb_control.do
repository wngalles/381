#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_and_N.do
#########################################################################

package require fileutil

vcom -2008 -work work src/TopLevel/Control/*.vhd
vcom -2008 -work work test/*.vhd


vsim -voptargs=+acc tb_control

add wave -noupdate -divider {Inputs}
add wave -noupdate -label Opcode -radix binary /tb_control/opcode
add wave -noupdate -label Fucnt -radix binary /tb_control/funct
add wave -noupdate -label Pass -radix binary /tb_control/passed

add wave -noupdate -label Control -radix binary /tb_control/control_vector
add wave -noupdate -label Expected -radix binary /tb_control/expected

add wave -noupdate -label TestCaseNumber -radix unsigned /tb_control/test_case_number

add wave -noupdate -divider {Outputs}
add wave -noupdate -label ControlVector -radix binary /tb_control/DUT0/control_vector

run 1100 