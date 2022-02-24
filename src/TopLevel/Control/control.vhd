-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- control.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(
    instruction : in std_logic_vector(32-1 downto 0);

    alusrc : out std_logic;
    aluOp : out std_logic_vector(7-1 downto 0);
    memToReg : out std_logic;
    memWrite : out std_logic;
    regWrite : out std_logic;
    regDst : out std_logic;
    jal : out std_logic;
    jr : out std_logic;
    beq : out std_logic;
    bne : out std_logic;
    movn : out std_logic;
    j : out std_logic
  );
  end control;

architecture structural of control is

signal opcode : std_logic_vector(6-1 downto 0);
signal funct : std_logic_vector(6-1 downto 0);
signal control_vector : std_logic_vector(9-1 downto 0);
signal control_vector2 : std_logic_vector(9-1 downto 0);

signal use_fucnt : std_logic;

begin

  opcode <= instruction(32-1 downto 32-1-6);
  funct <= instructions(6-1 downto 0);

  with opcode select control_vector <=
    "1_0000000_0010_0000_00" when "001000", --addi
    "0_0000000_0000_0000_00" when "000000", --R type
    "1_0000000_0010_0000_00" when "001001", --addiu
    "1_0010000_0010_0000_00" when “001100”, --andi
    "1_1010010_0010_0000_00" when “001111”, --lui
    "1_0000000_1010_0000_00" when "100011", --lw
    "1_1000000_0010_0000_00" when "001110", --xori
    "1_0100000_0010_0000_00" when "001101", --ori
    "1_0001100_0010_0000_00" when "001010", --slti
    "1_0000000_0100_0000_00" when "101011", --sw
    "1_0000100_0000_0010_00" when "000100", --beq
    "1_0000100_0000_0001_00" when "000101", --bne
    "0_0000000_0000_0000_01" when "000010", --j
    "0_0000000_0010_1000_00" when "000011", --jal
    "0_0000000_0000_0000_00" when others;


  with funct select control_vector2 <=
    "0_0000000_0011_0000_00" when "100000", --add
    "0_0000000_0011_0000_00" when "100001", --addu 
    "0_0010000_0011_0000_00" when “100100”, --and
    "0_0110000_0011_0000_00" when "100111", --nor
    "0_1000000_0011_0000_00" when "100110", --xor
    "0_0100000_0011_0000_00" when "100101", --or
    "0_0001100_0011_0000_00" when "101010", --slt
    "0_1010010_0011_0000_00" when "000000", --sll
    "0_1010000_0011_0000_00" when "000010", --srl
    "0_1010001_0011_0000_00" when "000011", --sra
    "0_0000100_0011_0000_00" when "100010", --sub
    "0_0000100_0011_0000_00" when "100011", --subu
    "0_0000000_0001_0100_00" when "001000", --jr
    "0_0000000_0011_0000_10" when "001011", --movn is this right?
    "0_0000000_0000_0000_00" when others;

  with opcode select control_vector <=
    control_vector2 when "000000",
    control_vector when others;

  alusrc <= control_vector(17);

  aluOp <= control_vector(16 downto 10);

  memToReg <= control_vector(9);
  memWrite <= control_vector(8);
  regWrite <= control_vector(7);
  regDst <= control_vector(6);

  jal <= control_vector(5);
  jr <= control_vector(4);
  beq <= control_vector(3);
  bne <= control_vector(2);

  movn <= control_vector(1);
  j <= control_vector(0);


end structural;
