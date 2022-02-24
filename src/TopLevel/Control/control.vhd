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
    j : out std_logic;
    control_vector : out std_logic_vector(18-1 downto 0)
  );
  end control;

architecture structural of control is

signal opcode : std_logic_vector(6-1 downto 0);
signal funct : std_logic_vector(6-1 downto 0);
signal control_vector1 : std_logic_vector(18-1 downto 0);
signal control_vector2 : std_logic_vector(18-1 downto 0);
signal control_vector3 : std_logic_vector(18-1 downto 0);

signal use_fucnt : std_logic;

begin

  opcode <= instruction(32-1 downto 32-1-5);
  funct <= instruction(6-1 downto 0);

  with opcode select control_vector1 <=
    "1" & "0000000" & "0010" & "0000" & "00" when "001000", --addi
    "0" & "0000000" & "0000" & "0000" & "00" when "000000", --R type
    "1" & "0000000" & "0010" & "0000" & "00" when "001001", --addiu
    "1" & "0010000" & "0010" & "0000" & "00" when "001100", --andi
    "1" & "1010010" & "0010" & "0000" & "00" when "001111", --lui
    "1" & "0000000" & "1010" & "0000" & "00" when "100011", --lw
    "1" & "1000000" & "0010" & "0000" & "00" when "001110", --xori
    "1" & "0100000" & "0010" & "0000" & "00" when "001101", --ori
    "1" & "0001100" & "0010" & "0000" & "00" when "001010", --slti
    "1" & "0000000" & "0100" & "0000" & "00" when "101011", --sw
    "1" & "0000100" & "0000" & "0010" & "00" when "000100", --beq
    "1" & "0000100" & "0000" & "0001" & "00" when "000101", --bne
    "0" & "0000000" & "0000" & "0000" & "01" when "000010", --j
    "0" & "0000000" & "0010" & "1000" & "00" when "000011", --jal
    "0" & "0000000" & "0000" & "0000" & "00" when others;


  with funct select control_vector2 <=
    "0" & "0000000" & "0011" & "0000" & "00" when "100000", --add
    "0" & "0000000" & "0011" & "0000" & "00" when "100001", --addu 
    "0" & "0010000" & "0011" & "0000" & "00" when "100100", --and
    "0" & "0110000" & "0011" & "0000" & "00" when "100111", --nor
    "0" & "1000000" & "0011" & "0000" & "00" when "100110", --xor
    "0" & "0100000" & "0011" & "0000" & "00" when "100101", --or
    "0" & "0001100" & "0011" & "0000" & "00" when "101010", --slt
    "0" & "1010010" & "0011" & "0000" & "00" when "000000", --sll
    "0" & "1010000" & "0011" & "0000" & "00" when "000010", --srl
    "0" & "1010001" & "0011" & "0000" & "00" when "000011", --sra
    "0" & "0000100" & "0011" & "0000" & "00" when "100010", --sub
    "0" & "0000100" & "0011" & "0000" & "00" when "100011", --subu
    "0" & "0000000" & "0001" & "0100" & "00" when "001000", --jr
    "0" & "0000000" & "0011" & "0000" & "10" when "001011", --movn
    "0" & "0000000" & "0000" & "0000" & "00" when others;

  with opcode select control_vector3 <=
    control_vector2 when "000000",
    control_vector1 when others;

  alusrc <= control_vector3(17);

  aluOp <= control_vector3(16 downto 10);

  memToReg <= control_vector3(9);
  memWrite <= control_vector3(8);
  regWrite <= control_vector3(7);
  regDst <= control_vector3(6);

  jal <= control_vector3(5);
  jr <= control_vector3(4);
  beq <= control_vector3(3);
  bne <= control_vector3(2);

  movn <= control_vector3(1);
  j <= control_vector3(0);

  control_vector <= control_vector3;


end structural;
