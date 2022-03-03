-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the first datapath
--              
-- 2/24/2022 by Austin Beinder::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_control is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_control;

architecture mixed of tb_control is

    -- Define the total clock period time
    constant cCLK_PER  : time := gCLK_HPER * 2;


    component control is
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
    end component;

    signal instruction : std_logic_vector(32-1 downto 0);
    signal opcode : std_logic_vector(6-1 downto 0);
    signal funct : std_logic_vector(6-1 downto 0);

    signal alusrc : std_logic;
    signal aluOp : std_logic_vector(7-1 downto 0);

    signal memToReg : std_logic;
    signal memWrite : std_logic;
    signal regWrite : std_logic;
    signal regDst : std_logic;

    signal jal : std_logic;
    signal jr : std_logic;
    signal beq : std_logic;
    signal bne : std_logic;

    signal movn : std_logic;
    signal j : std_logic;


    signal test_case_number : integer;
    signal is_r_type : integer;

    signal expected : std_logic_vector(18-1 downto 0);
    signal passed : boolean;
    signal control_vector : std_logic_vector(18-1 downto 0);

    begin

    DUT0: control
        port map(
        instruction => instruction,
    
        alusrc => alusrc,

        aluOp => aluOp,

        memToReg => memToReg,
        memWrite => memWrite,
        regWrite => regWrite,
        regDst => regDst,

        jal => jal,
        jr => jr,
        beq => beq,
        bne => bne,

        movn => movn,
        j => j,
        control_vector => control_vector
        );

    -- Assign inputs for each test case.
    P_TEST_CASES: process
    begin
        is_r_type <= 0;
        wait for gCLK_HPER;
        ----------------------------------------------
        -- addi
        opcode <= "001000";
        funct <= "000000";

        expected <= "1" & "0000000" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 1;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- addiu
        opcode <= "001001";
        funct <= "000000";

        expected <= "1" & "0000000" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 2;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- andi
        opcode <= "001100";
        funct <= "000000";
        
        expected <= "1" & "0010000" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 3;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- lui
        opcode <= "001111";
        funct <= "000000";
        
        expected <= "1" & "1010010" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 4;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- lw
        opcode <= "100011";
        funct <= "000000";
        
        expected <= "1" & "0000000" & "1010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 5;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- xori
        opcode <= "001110";
        funct <= "000000";
        
        expected <= "1" & "1000000" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 6;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- ori
        opcode <= "001101";
        funct <= "000000";
        
        expected <= "1" & "0100000" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 7;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- slti
        opcode <= "001010";
        funct <= "000000";
        
        expected <= "1" & "0001100" & "0010" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 8;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- sw
        opcode <= "101011";
        funct <= "000000";
        
        expected <= "1" & "0000000" & "0100" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        
 
        test_case_number <= 9;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- beq
        opcode <= "000100";
        funct <= "000000";
        
        expected <= "1" & "0000100" & "0000" & "0010" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 10;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- bne
        opcode <= "000101";
        funct <= "000000";
        
        expected <= "1" & "0000100" & "0000" & "0001" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 11;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- j
        opcode <= "000010";
        funct <= "000000";
        
        expected <= "0" & "0000000" & "0000" & "0000" & "01";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 12;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- jal
        opcode <= "000011";
        funct <= "000000";
        
        expected <= "0" & "0000000" & "0010" & "1000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 13;
        wait for gCLK_HPER*2;

        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        is_r_type <= 1;

        ----------------------------------------------
        -- add
        opcode <= "000000";
        funct <= "100000";
        
        expected <= "0" & "0000000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 14;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- addu
        opcode <= "000000";
        funct <= "100001";
        
        expected <= "0" & "0000000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 15;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- and
        opcode <= "000000";
        funct <= "100100";
        
        expected <= "0" & "0010000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 16;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- nor
        opcode <= "000000";
        funct <= "100111";
        
        expected <= "0" & "0110000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 17;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- xor
        opcode <= "000000";
        funct <= "100110";
        
        expected <= "0" & "1000000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 18;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- or
        opcode <= "000000";
        funct <= "100101";
        
        expected <= "0" & "0100000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 19;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- slt
        opcode <= "000000";
        funct <= "101010";
        
        expected <= "0" & "0001100" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 20;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- sll
        opcode <= "000000";
        funct <= "000000";
        
        expected <= "0" & "1010010" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 21;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- srl
        opcode <= "000000";
        funct <= "000010";
        
        expected <= "0" & "1010000" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 22;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- sra
        opcode <= "000000";
        funct <= "000011";
        
        expected <= "0" & "1010001" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 23;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- sub
        opcode <= "000000";
        funct <= "100010";
        
        expected <= "0" & "0000100" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 24;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- subu
        opcode <= "000000";
        funct <= "100011";
        
        expected <= "0" & "0000100" & "0011" & "0000" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 25;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- jr
        opcode <= "000000";
        funct <= "001000";
        
        expected <= "0" & "0000000" & "0001" & "0100" & "00";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 26;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- movn
        opcode <= "000000";
        funct <= "001011";
        
        expected <= "0" & "0000000" & "0011" & "0000" & "10";
        wait for gCLK_HPER;
        instruction <= opcode & 20x"0" & funct;
        wait for gCLK_HPER;
        passed <= expected = control_vector;
        

        test_case_number <= 27;
        wait for gCLK_HPER*2;
        
    end process;

end mixed;