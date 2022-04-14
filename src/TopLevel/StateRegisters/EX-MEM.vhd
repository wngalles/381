-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- EX_MEM.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity EX_MEM is
  port(i_CLK              : in std_logic;
        i_Stall           : in std_logic;
        i_Flush           : in std_logic;

        i_Jal             : in std_logic;
        i_Equal           : in std_logic;
        i_Mem_Reg         : in std_logic;
        i_Mem_Wr          : in std_logic;
        i_Movn            : in std_logic;
        i_Reg_Wr          : in std_logic;
        i_Halt            : in std_logic;
        i_Ovf             : in std_logic;
        

        o_Jal             : out std_logic;
        o_Equal           : out std_logic;
        o_Mem_Reg         : out std_logic;
        o_Mem_Wr          : out std_logic;
        o_Movn            : out std_logic;
        o_Reg_Wr          : out std_logic;
        o_Halt            : out std_logic;
        o_Ovf             : out std_logic;

        i_RegDest         : in std_logic_vector(4 downto 0);
        o_RegDest         : out std_logic_vector(4 downto 0);

        i_PC4             : in std_logic_vector(31 downto 0);
        i_ALUout          : in std_logic_vector(31 downto 0);
        i_Reg1            : in std_logic_vector(31 downto 0);
        i_Reg2            : in std_logic_vector(31 downto 0);
        o_PC4             : out std_logic_vector(31 downto 0);
        o_ALUout          : out std_logic_vector(31 downto 0);
        o_Reg1            : out std_logic_vector(31 downto 0);
        o_Reg2            : out std_logic_vector(31 downto 0));

end EX_MEM;

architecture structural of EX_MEM is

    component reg_N is
        generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_CLK         : in std_logic;
              i_RST        : in std_logic;
              i_WE         : in std_logic;
              i_D          : in std_logic_vector(N-1 downto 0);
              o_Q          : out std_logic_vector(N-1 downto 0));
      
      end component;


    component dffg is
        port(i_CLK       : in std_logic;     -- Clock input
            i_RST        : in std_logic;     -- Reset input
            i_WE         : in std_logic;     -- Write enable input
            i_D          : in std_logic;     -- Data value input
            o_Q          : out std_logic);   -- Data value output
      end component;



begin

  REG_R1: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Reg1,  
    o_Q       => o_Reg1);

  REG_R2: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Reg2,  
    o_Q       => o_Reg2);

  REG_ALU_OUT: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_ALUout,  
    o_Q       => o_ALUout);

  REG_PC4: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_PC4,  
    o_Q       => o_PC4);

  REG_DEST: reg_N generic map(5) port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_RegDest,  
    o_Q       => o_RegDest);
    
  DFF_JAL: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Jal,  
    o_Q       => o_Jal);
    
  DFF_EQUAL: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Equal,  
    o_Q       => o_Equal); 

  DFF_MEM_REG: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Mem_Reg,  
    o_Q       => o_Mem_Reg);
    
  DFF_MEM_WR: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Mem_Wr,  
    o_Q       => o_Mem_Wr); 

  DFF_MOVN: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Movn,  
    o_Q       => o_Movn); 

  DFF_REG_WR: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Reg_Wr,  
    o_Q       => o_Reg_Wr); 

  DFF_HALT: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Halt,  
    o_Q       => o_Halt); 

  DFF_OVF: dffg port map(
    i_CLK     => i_CLK,
    i_RST     => i_Flush,       
    i_WE      => i_Stall,  
    i_D       => i_Ovf,  
    o_Q       => o_Ovf); 


  
end structural;
