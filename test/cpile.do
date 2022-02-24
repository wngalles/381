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

<<<<<<< HEAD:cpile.do
vcom -2008 -work work src/*.vhd
vcom -2008 -work work src/TopLevel/*.vhd
vcom -2008 -work work src/TopLevel/Adders/*.vhd
vcom -2008 -work work src/TopLevel/BasicGates/*.vhd
vcom -2008 -work work src/TopLevel/Fetch/*.vhd
vcom -2008 -work work src/TopLevel/Mux/*.vhd
vcom -2008 -work work src/TopLevel/Registers/*.vhd

vcom -2008 -work work test/*.vhd

=======

package require fileutil

eval vcom -2008 -work work [::fileutil::findByPattern . -glob *.vhd]
>>>>>>> 3f901b15113e6b516483f8684a7e9676628fdc49:test/cpile.do

