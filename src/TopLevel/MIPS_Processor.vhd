-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component control is
    port(
      instruction : in std_logic_vector(32-1 downto 0);

      regDst     : out std_logic;
      jump        : out std_logic;
      branch      : out std_logic;
      memRead     : out std_logic;
      memToReg    : out std_logic;
      aluOp       : out std_logic_vector(4-1 downto 0); -- Not exactly sure how this will map out, but the can be tbd
      memWrite    : out std_logic;
      aluSrc      : out std_logic;
      regWrite    : out std_logic
    );
    end component;

    component reg_N is
      generic(N : integer); 
      port(i_CLK         : in std_logic;
            i_RST        : in std_logic;
            i_WE         : in std_logic;
            i_D          : in std_logic_vector(N-1 downto 0);
            o_Q          : out std_logic_vector(N-1 downto 0));
    
    end component;

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

    component fetch is
      port(i_PCin             : in std_logic_vector(31 downto 0);
           i_Instruction      : in std_logic_vector(31 downto 0);
           i_Immediate        : in std_logic_vector(31 downto 0);
           i_Register         : in std_logic_vector(31 downto 0);
           i_Jump             : in std_logic;
           i_JumpRegister     : in std_logic;
           i_BEQ              : in std_logic;
           i_BNE              : in std_logic;
           i_Equal            : in std_logic;
           o_PCout            : out std_logic_vector(31 downto 0));
    
    end component;

    component pc is
      port(i_CLK              : in std_logic;
           i_RST              : in std_logic;
           i_WE               : in std_logic;
           i_PCin             : in std_logic_vector(31 downto 0);
           o_PCout            : out std_logic_vector(31 downto 0));
    
    end component;

    component Bit16_32 is
      port( i_A          : in std_logic_vector(15 downto 0);
            i_S          : in std_logic;
            o_O          : out  std_logic_vector(31 downto 0));
    
    end component;

    component mux2t1_N is
      generic(N : integer);
      port(i_S          : in std_logic;
           i_D0         : in std_logic_vector(N-1 downto 0);
           i_D1         : in std_logic_vector(N-1 downto 0);
           o_O          : out std_logic_vector(N-1 downto 0));
    
    end component;



  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment





begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

  X_RegFile: reg_N
    generic map(32)
    port map(i_CLK    => 
             i_S      => 
             i_R1     => 
             i_R2     => 
             i_WE     => 
             i_RST    => 
             i_D      => 
             o_Q1     => 
             o_Q2     => );




end structure;

