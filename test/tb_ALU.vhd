-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_ALU.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_ALU is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_ALU;

architecture mixed of tb_ALU is

    -- Define the total clock period time
    constant cCLK_PER  : time := gCLK_HPER * 2;


    component ALU is
        port( i_In1             : in std_logic_vector(31 downto 0);
              i_In2             : in std_logic_vector(31 downto 0);
              i_ALUop           : in std_logic_vector(6 downto 0);
              i_Movn            : in std_logic;
              i_SHAMT           : in std_logic_vector(4 downto 0);
              o_Equal           : out std_logic;
              o_OverFlow        : out std_logic;
              o_Out1            : out std_logic_vector(31 downto 0));
      
      end component;

    signal s_CLK : std_logic;

    signal s_In1            : std_logic_vector(31 downto 0) := 32x"a";
    signal s_In2            : std_logic_vector(31 downto 0) := 32x"8";

    signal s_ALUop          : std_logic_vector(6 downto 0) := 7x"0";

    signal s_SHAMT          : std_logic_vector(4 downto 0) := 5x"0";

    signal s_Movn           : std_logic := '0';
    signal s_Equal          : std_logic;
    signal s_OverFlow       : std_logic;

    signal s_Out1           : std_logic_vector(31 downto 0);
    
    

    begin

    DUT0: ALU
        port map(
            i_In1             => s_In1,
            i_In2             => s_In2,
            i_ALUop           => s_ALUop,
            i_Movn            => s_Movn,
            i_SHAMT           => s_SHAMT,
            o_Equal           => s_Equal,
            o_OverFlow        => s_OverFlow,
            o_Out1            => s_Out1
        );

    P_CLK: process
    begin
        s_CLK <= '0';
        wait for gCLK_HPER;
        s_CLK <= '1';
        wait for gCLK_HPER;
    end process;

    -- Assign inputs for each test case.
    P_TEST_CASES: process
    begin
        
        --Basic Add
        s_ALUop       <= "0000000";        

        wait for cCLK_PER;

        --Basic Sub
        s_ALUop       <= "0000100";        

        wait for cCLK_PER;

        --Add Overflow
        s_In1         <= 32x"7FFFFFFF";  
        s_In2         <= 32x"00000001";
        s_ALUop       <= "0000000";        

        wait for cCLK_PER;

        --Sub Overflow
        s_In1         <= 32x"80000000";  
        s_In2         <= 32x"00000001";
        s_ALUop       <= "0000100";        

        wait for cCLK_PER;

        --Equal
        s_In1         <= 32x"1234FDCB";  
        s_In2         <= 32x"1234FDCB";
        s_ALUop       <= "0000100";        

        wait for cCLK_PER;

        --AND
        s_In1         <= 32x"FFFF0000";  
        s_In2         <= 32x"1234FDCB";
        s_ALUop       <= "0010000";        

        wait for cCLK_PER;

        --OR
        s_In1         <= 32x"FFFF0000";  
        s_In2         <= 32x"1234FDCB";
        s_ALUop       <= "0100000";        

        wait for cCLK_PER;

        --XOR
        s_In1         <= 32x"FFFFFFFF";  
        s_In2         <= 32x"0000A5E1";
        s_ALUop       <= "1000000";        

        wait for cCLK_PER;

        --NOR
        s_In1         <= 32x"FFFF0000";  
        s_In2         <= 32x"0000A5E1";
        s_ALUop       <= "0110000";        

        wait for cCLK_PER;

        --SLT True
        s_In1         <= 32x"FFFF0000";  
        s_In2         <= 32x"0000A5E1";
        s_ALUop       <= "0001100";        

        wait for cCLK_PER;

        --SLT False
        s_In1         <= 32x"12345678";  
        s_In2         <= 32x"FFFF0000";
        s_ALUop       <= "0001100";        

        wait for cCLK_PER;

        --Movn
        s_In1         <= 32x"00000000";  
        s_In2         <= 32x"12345678";
        s_ALUop       <= "0000000";
        s_Movn        <= '1';    

        wait for cCLK_PER;


        

     
        wait;
    end process;

end mixed;