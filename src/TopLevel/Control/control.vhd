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
    halt : out std_logic;
    signExt : out std_logic;
    control_vector : out std_logic_vector(20-1 downto 0)
  );
  end control;

architecture structural of control is

signal opcode : std_logic_vector(6-1 downto 0);
signal funct : std_logic_vector(6-1 downto 0);
signal control_vector1 : std_logic_vector(20-1 downto 0);
signal control_vector2 : std_logic_vector(20-1 downto 0);
signal control_vector3 : std_logic_vector(20-1 downto 0);

signal use_fucnt : std_logic;

begin

  opcode <= instruction(32-1 downto 32-1-5);
  funct <= instruction(6-1 downto 0);

  with opcode select control_vector1 <=
    "01" & "1" & "0000000" & "0010" & "0000" & "00" when "001000", --addi
    "01" & "0" & "0000000" & "0000" & "0000" & "00" when "000000", --R type
    "01" & "1" & "0000000" & "0010" & "0000" & "00" when "001001", --addiu
    "00" & "1" & "0010000" & "0010" & "0000" & "00" when "001100", --andi
    "01" & "1" & "1100000" & "0010" & "0000" & "00" when "001111", --lui
    "01" & "1" & "0000000" & "1010" & "0000" & "00" when "100011", --lw
    "00" & "1" & "1000000" & "0010" & "0000" & "00" when "001110", --xori
    "00" & "1" & "0100000" & "0010" & "0000" & "00" when "001101", --ori
    "01" & "1" & "0001100" & "0010" & "0000" & "00" when "001010", --slti
    "01" & "1" & "0000000" & "0100" & "0000" & "00" when "101011", --sw
    "01" & "0" & "0000100" & "0000" & "0010" & "00" when "000100", --beq
    "01" & "0" & "0000100" & "0000" & "0001" & "00" when "000101", --bne
    "01" & "0" & "0000000" & "0000" & "0000" & "01" when "000010", --j
    "01" & "0" & "0000000" & "0010" & "1000" & "01" when "000011", --jal
    "11" & "0" & "0000000" & "0000" & "0000" & "00" when "010100", --halt
    "01" & "0" & "0000000" & "0000" & "0000" & "00" when others;


  with funct select control_vector2 <=
    "01" & "0" & "0000000" & "0011" & "0000" & "00" when "100000", --add
    "01" & "0" & "0000000" & "0011" & "0000" & "00" when "100001", --addu 
    "01" & "0" & "0010000" & "0011" & "0000" & "00" when "100100", --and
    "01" & "0" & "0110000" & "0011" & "0000" & "00" when "100111", --nor
    "01" & "0" & "1000000" & "0011" & "0000" & "00" when "100110", --xor
    "01" & "0" & "0100000" & "0011" & "0000" & "00" when "100101", --or
    "01" & "0" & "0001100" & "0011" & "0000" & "00" when "101010", --slt
    "01" & "0" & "1010000" & "0011" & "0000" & "00" when "000000", --sll
    "01" & "0" & "1010010" & "0011" & "0000" & "00" when "000010", --srl
    "01" & "0" & "1010011" & "0011" & "0000" & "00" when "000011", --sra
    "01" & "0" & "0000100" & "0011" & "0000" & "00" when "100010", --sub
    "01" & "0" & "0000100" & "0011" & "0000" & "00" when "100011", --subu
    "01" & "0" & "0000000" & "0001" & "0100" & "00" when "001000", --jr
    "01" & "0" & "0000000" & "0011" & "0000" & "10" when "001011", --movn
    "01" & "0" & "0000000" & "0000" & "0000" & "00" when others;

  with opcode select control_vector3 <=
    control_vector2 when "000000",
    control_vector1 when others;

  halt   <= control_vector3(19);
  signExt <= control_vector3(18);

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
