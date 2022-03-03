-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- barrelshifter.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshifter is
  port(
    A : in std_logic_vector(32-1 downto 0);
    O : out std_logic_vector(32-1 downto 0);
    offset : in std_logic_vector(5-1 downto 0);
    left : in std_logic
  );
  end barrelshifter;

architecture structural of barrelshifter is

    component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
    end component;
      
    signal flip1 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal layer1 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal layer2 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal layer3 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal layer4 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal layer5 : std_logic_vector(32-1 downto 0) := 32x"0";

    signal shift1 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal shift2 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal shift4 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal shift8 : std_logic_vector(32-1 downto 0) := 32x"0";
    signal shift16 : std_logic_vector(32-1 downto 0) := 32x"0";

    begin

        gen: for i in 0 to 32-1 generate
            flip1(i) <= A(i) when left='0' else A(32-1-i);
        end generate;

        shift16 <= A(32-1-16 downto 0) & 16x"0000"; 

        L1 : mux2t1_N
            generic map(N => 32)
            port map(
              i_S => offset(4),
              i_D0 => flip1,
              i_D1 => shift16,
              o_O => layer1
            );

        shift8 <= layer1(32-1-8 downto 0) & 8x"00"; 
        
        L2 : mux2t1_N
        generic map(N => 32)
            port map(
              i_S => offset(3),
              i_D0 => layer1,
              i_D1 => shift8,
              o_O => layer2
            );

        shift4 <= layer2(32-1-4 downto 0) & 4x"0"; 

        L3 : mux2t1_N
        generic map(N => 32)
            port map(
              i_S => offset(2),
              i_D0 => layer2,
              i_D1 => shift4,
              o_O => layer3
            );

        shift2 <= layer3(32-1-2 downto 0) & "00"; 

        L4 : mux2t1_N
        generic map(N => 32)
            port map(
              i_S => offset(1),
              i_D0 => layer3,
              i_D1 => shift2,
              o_O => layer4
            );

        shift1 <= layer4(32-1-1 downto 0) & '0'; 

        L5 : mux2t1_N
        generic map(N => 32)
            port map(
              i_S => offset(0),
              i_D0 => layer4,
              i_D1 => shift1,
              o_O => layer5
            );

        gener: for i in 0 to 32-1 generate
            O(i) <= layer5(i) when left='0' else layer5(32-1-i);
        end generate;
        

    end structural;
