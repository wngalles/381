#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_rippleAdder_N.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              2-1 mux
##              
## 01/04/2020 by H3::Design created.
#########################################################################



vsim -voptargs=+acc tb_rippleAdder_N

# Setup the wave form with useful signals

# Add the standard, non-data clock and reset input signals.
# First, add a helpful header label.
add wave -noupdate -divider {Standard Inputs}
add wave -noupdate -label CLK /tb_rippleAdder_N/CLK
add wave -noupdate -label reset /tb_rippleAdder_N/reset

# Add data inputs that are specific to this design. These are the ones set during our test cases.
# Note that I've set the radix to unsigned, meaning that the values in the waveform will be displayed
# as unsigned decimal values. This may be more convenient for your debugging. However, you should be
# careful to look at the radix specifier (e.g., the decimal value 32'd10 is the same as the hexidecimal
# value 32'hA.
add wave -noupdate -divider {Data Inputs}
add wave -noupdate /tb_rippleAdder_N/s_iC
add wave -noupdate /tb_rippleAdder_N/s_X
add wave -noupdate /tb_rippleAdder_N/s_Y


# Add data outputs that are specific to this design. These are the ones that we'll check for correctness.
add wave -noupdate -divider {Data Outputs}
add wave -noupdate /tb_rippleAdder_N/s_S
add wave -noupdate /tb_rippleAdder_N/s_oC


add wave -noupdate -divider {Data Inputs - Decimal}
add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_iC
add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_X
add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_Y

add wave -noupdate -divider {Data Outputs - Decimal}
add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_S
add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_oC

#add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_iD1
#add wave -noupdate -radix unsigned /tb_rippleAdder_N/s_iS

run 185 