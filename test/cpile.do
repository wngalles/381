#########################################################################
## Will Galles
## Department of Electrical and Computer Engineering
## Iowa State University
#########################################################################
## tb_Bit16_32.do
#########################################################################
## DESCRIPTION: This file contains a do file for the testbench for the 
##              n-bit register
##              
## 01/04/2020 by H3::Design created.
#########################################################################


package require fileutil

eval vcom -2008 -work work [::fileutil::findByPattern . -glob *.vhd]

