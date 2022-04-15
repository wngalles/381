-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- forward.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity forward is
  port( i_RegWrEX         : in std_logic;
        i_RegDestEX       : in std_logic_vector(4 downto 0);
        i_RegWrMEM        : in std_logic;
        i_RegDestMEM      : in std_logic_vector(4 downto 0);
        i_Reg1            : in std_logic_vector(4 downto 0);
        i_Reg2            : in std_logic_vector(4 downto 0);

        i_EX_RegMEM       : in std_logic;
        i_MEM_RegMEM      : in std_logic;

        i_EX_JAL          : in std_logic;
        i_MEM_JAL         : in std_logic;

        i_EX_AluOut       : in std_logic_vector(31 downto 0);
        i_MEM_AluOut      : in std_logic_vector(31 downto 0);
        i_DmemOut         : in std_logic_vector(31 downto 0);

        i_EX_PC4          : in std_logic_vector(31 downto 0);
        i_MEM_PC4         : in std_logic_vector(31 downto 0);


        o_R1              : out std_logic_vector(31 downto 0);
        o_R2              : out std_logic_vector(31 downto 0);

        o_R1ctl           : out std_logic;
        o_R2ctl           : out std_logic;

        o_Forward         : out std_logic); --Forward Signal

end forward;

architecture structural of forward is

    component equalsHaz is

        port(i_In1        : in std_logic_vector(4 downto 0);
             i_In2        : in std_logic_vector(4 downto 0);
             i_We         : in std_logic;
             o_Equal      : out std_logic);
      
      end component;

    signal s31            : std_logic_vector(4 downto 0) := "11111"; 
    signal En             : std_logic := '1';

    signal R1_EX          : std_logic;  
    signal R1_MEM         : std_logic; 
    signal R2_EX          : std_logic; 
    signal R2_MEM         : std_logic;

    signal R1_JAL         : std_logic; 
    signal R2_JAL         : std_logic;
    
    signal R1_Forward     : std_logic;
    signal R2_Forward     : std_logic;


    signal R1_Dmem_ALU    : std_logic_vector(31 downto 0);
    signal R1_ALU_MemPC   : std_logic_vector(31 downto 0); 
    signal R1_MemPC_ExPC  : std_logic_vector(31 downto 0); 

    signal R2_Dmem_ALU    : std_logic_vector(31 downto 0);
    signal R2_ALU_MemPC   : std_logic_vector(31 downto 0); 
    signal R2_MemPC_ExPC  : std_logic_vector(31 downto 0); 

    signal Ex_Zero       : std_logic;
    signal Mem_Zero      : std_logic;


begin

    H_EQUAL_R1_EX: equalsHaz      
    port map(i_In1            => i_Reg1,
             i_In2            => i_RegDestEX,
             i_We             => i_RegWrEX,
             o_Equal          => R1_EX);  

    H_EQUAL_R1_MEM: equalsHaz      
    port map(i_In1            => i_Reg1,
             i_In2            => i_RegDestMEM,
             i_We             => i_RegWrMEM,
             o_Equal          => R1_MEM);  

    H_EQUAL_R1_JAL: equalsHaz      
    port map(i_In1            => i_Reg1,
             i_In2            => s31,
             i_We             => i_EX_JAL or i_MEM_JAL,
             o_Equal          => R1_JAL);  

    H_EQUAL_R2_EX: equalsHaz      
    port map(i_In1            => i_Reg2,
             i_In2            => i_RegDestEX,
             i_We             => i_RegWrEX,
             o_Equal          => R2_EX);  

    H_EQUAL_R2_MEM: equalsHaz      
    port map(i_In1            => i_Reg2,
             i_In2            => i_RegDestMEM,
             i_We             => i_RegWrMEM,
             o_Equal          => R2_MEM); 

    H_EQUAL_R2_JAL: equalsHaz      
    port map(i_In1            => i_Reg2,
             i_In2            => s31,
             i_We             => i_EX_JAL or i_MEM_JAL,
             o_Equal          => R2_JAL);  

    with i_RegDestEX select Ex_Zero <=
    '1' when "00000",
    '0' when others;

    with i_RegDestMem select Mem_Zero <=
    '1' when "00000",
    '0' when others;

    
    R1_Forward <= (R1_JAL or R1_MEM or (R1_EX and not i_EX_RegMEM)) and not ((R1_EX and i_EX_RegMEM) or (R2_EX and i_EX_RegMEM);-- or (Ex_Zero and i_RegWrEX) or (Mem_Zero and i_RegWrMEM));
    R2_Forward <= (R2_JAL or R2_MEM or (R2_EX and not i_EX_RegMEM)) and not ((R1_EX and i_EX_RegMEM) or (R2_EX and i_EX_RegMEM);-- or (Ex_Zero and i_RegWrEX) or (Mem_Zero and i_RegWrMEM));

    o_Forward <= R1_Forward or R2_Forward;

    o_R1ctl <= R1_Forward;
    o_R2ctl <= R2_Forward;
    
    
    with i_MEM_RegMEM and R1_MEM select R1_Dmem_ALU <=
    i_DmemOut when '1',
    i_MEM_AluOut when others;

    with (not i_EX_RegMEM) and R1_EX select R1_ALU_MemPC <=
    i_EX_AluOut when '1',
    R1_Dmem_ALU when others;

    with i_MEM_JAL and R1_JAL select R1_MemPC_ExPC <=
    i_MEM_PC4 when '1',
    R1_ALU_MemPC when others;

    with i_EX_JAL and R1_JAL select o_R1 <=
    i_EX_PC4 when '1',
    R1_MemPC_ExPC when others;


    with i_MEM_RegMEM and R2_MEM select R2_Dmem_ALU <=
    i_DmemOut when '1',
    i_MEM_AluOut when others;

    with (not i_EX_RegMEM) and R2_EX select R2_ALU_MemPC <=
    i_EX_AluOut when '1',
    R2_Dmem_ALU when others;

    with i_MEM_JAL and R2_JAL select R2_MemPC_ExPC <=
    i_MEM_PC4 when '1',
    R2_ALU_MemPC when others;

    with i_EX_JAL and R2_JAL select o_R2 <=
    i_EX_PC4 when '1',
    R2_MemPC_ExPC when others;
    
  
end structural;
