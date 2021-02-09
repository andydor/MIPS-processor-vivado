----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 10:24:19 AM
-- Design Name: 
-- Module Name: ID - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
  Port (clk : in std_logic;
  RegWrite : in std_logic;
  Instr : in std_logic_vector (15 downto 0);
  ExtOp : in std_logic;
  en : in std_logic;
  WA : in std_logic_vector(2 downto 0);
  WD : in std_logic_vector (15 downto 0);
  RD1 : out std_logic_vector (15 downto 0);
  RD2 : out std_logic_vector (15 downto 0);
  Ext_Imm : out std_logic_vector (15 downto 0);
  func : out std_logic_vector (2 downto 0);
  sa : out std_logic;
  rt : out std_logic_vector(2 downto 0);
  rd : out std_logic_vector(2 downto 0));
end ID;

architecture Behavioral of ID is

signal ra1 : std_logic_vector (2 downto 0);
signal ra2 : std_logic_vector (2 downto 0);
type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := (others => x"0000");

begin

Ext_Imm <= "000000000" & instr (6 downto 0) when ExtOp = '0' else "000000000" & instr (6 downto 0) when instr(6) = '0' else "111111111" & instr (6 downto 0);

ra1 <= instr(12 downto 10);

ra2 <= instr(9 downto 7);

func <= instr(2 downto 0);

sa <= instr(3);

process(clk)
begin
    if falling_edge(clk) then
        if en = '1' and RegWrite = '1' then
            reg_file(conv_integer(WA)) <= WD;
        end if;
    end if;
end process;

RD1 <= reg_file(conv_integer(ra1));
RD2 <= reg_file(conv_integer(ra2));

rt <= instr(9 downto 7);
rd <= instr(6 downto 4);

end Behavioral;