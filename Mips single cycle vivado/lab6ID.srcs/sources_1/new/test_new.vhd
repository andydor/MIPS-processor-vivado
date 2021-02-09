----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2020 09:27:21 PM
-- Design Name: 
-- Module Name: test_new - Behavioral
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

entity test_new is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_new;

architecture Behavioral of test_new is

component MPG is
    Port( en : out std_logic;
    input : in std_logic;
    clock : in std_logic);
end component;

component IF1 is
  Port (clk : in std_logic;
  enable : in std_logic;
  rst : in std_logic;
  ba : in std_logic_vector(15 downto 0);
  pcsrc : in std_logic;
  ja : in std_logic_vector(15 downto 0);
  jump : in std_logic;
  instr : out std_logic_vector(15 downto 0);
  pc1 : out std_logic_vector(15 downto 0));
end component;

component display_7segment is
  Port (clk : in std_logic;
  digit0, digit1, digit2, digit3 : in std_logic_vector(3 downto 0);
  cat : out std_logic_vector(6 downto 0);
  an : out std_logic_vector(3 downto 0) );
end component;

component ID is
  Port (clk : in std_logic;
  RegWrite : in std_logic;
  Instr : in std_logic_vector (15 downto 0);
  RegDst : in std_logic;
  ExtOp : in std_logic;
  en : in std_logic;
  WD : in std_logic_vector (15 downto 0);
  RD1 : out std_logic_vector (15 downto 0);
  RD2 : out std_logic_vector (15 downto 0);
  Ext_Imm : out std_logic_vector (15 downto 0);
  func : out std_logic_vector (2 downto 0);
  sa : out std_logic);
end component;

component UC is
  Port (instr : in std_logic_vector(2 downto 0);
  RegDst : out std_logic;
  Extop : out std_logic;
  ALUSrc : out std_logic;
  Branch : out std_logic;
  BrGTZ : out std_logic;
  BrGEZ : out std_logic;
  Jump : out std_logic;
  ALUOp : out std_logic_vector(1 downto 0);
  MemWrite : out std_logic;
  MemtoReg : out std_logic;
  RegWrite : out std_logic);
end component;

component EX is
  Port (RD1 : in std_logic_vector(15 downto 0);
  ALUSrc : in std_logic;
  RD2 : in std_logic_vector(15 downto 0);
  Ext_Imm : in std_logic_vector(15 downto 0);
  sa : in std_logic;
  func : in std_logic_vector(2 downto 0);
  AluOp : in std_logic_vector(1 downto 0);
  PC1 : in std_logic_vector(15 downto 0);
  GT : out std_logic;
  GE : out std_logic;
  Zero : out std_logic;
  ALURes : out std_logic_vector(15 downto 0);
  BranchAddress : out std_logic_vector(15 downto 0));
end component;

component MEM is
  Port (MemWrite : in std_logic;
  ALUResIn : in std_logic_vector(15 downto 0);
  WD : in std_logic_vector(15 downto 0);
  clk : in std_logic;
  en : in std_logic;
  ReadData : out std_logic_vector(15 downto 0);
  ALUResOut : out std_logic_vector(15 downto 0));
end component;

signal enable_if : std_logic;
signal instr : std_logic_vector(15 downto 0);
signal pc1 : std_logic_vector(15 downto 0);
signal rst : std_logic;
signal out1 : std_logic_vector (15 downto 0);
signal RegDst : std_logic;
signal Extop : std_logic;
signal Jump : std_logic;
signal RegWrite : std_logic;
signal sum_out : std_logic_vector(15 downto 0);
signal rd1 : std_logic_vector(15 downto 0);
signal rd2 : std_logic_vector(15 downto 0);
signal Ext_Imm : std_logic_vector(15 downto 0);
signal func : std_logic_vector(2 downto 0);
signal sa : std_logic;
signal func1 : std_logic_vector(15 downto 0);
signal sa1 : std_logic_vector(15 downto 0);
signal BrGEZ : std_logic;
signal BrGTZ : std_logic;
signal GT : std_logic;
signal GZ : std_logic;
signal ja : std_logic_vector(15 downto 0);
signal BranchAddress : std_logic_vector(15 downto 0);
signal ALUSrc : std_logic;
signal ALUOp : std_logic_vector(1 downto 0);
signal Zero : std_logic;
signal ALUResIn : std_logic_vector(15 downto 0);
signal MemWrite : std_logic;
signal MemToReg : std_logic;
signal Branch : std_logic;
signal ALUResOut : std_logic_vector(15 downto 0);
signal MemData : std_logic_vector(15 downto 0);
signal WD : std_logic_vector(15 downto 0);
signal PCSrc : std_logic;

begin

InF : IF1 port map(clk, enable_if, rst, BranchAddress, PCSrc, ja, Jump, instr, pc1);

WD <= ALUResOut when MemtoReg = '0' else MemData;

EX1 : EX port map(rd1, ALUSrc, rd2, Ext_Imm, sa, func, ALUOp, pc1, GT, GZ, Zero, ALUResIn, BranchAddress);

MEM1 : MEM port map(MemWrite, ALUResIn, rd2, clk, enable_if, ALUResOut, MemData);

ja <= pc1(15 downto 13) & instr(12 downto 0);

PCSrc <= (BrGTZ and GT) or (BrGEZ and GZ) or (Branch and Zero);

led (11 downto 0) <= BrGTZ & BrGEZ & ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

UC1 : UC port map(instr(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, BrGTZ, BrGEZ, Jump, ALUOp, MemWrite, MemToReg, RegWrite);

ID1 : ID port map(clk, RegWrite, instr, RegDst, ExtOp, enable_if, WD, rd1, rd2, Ext_Imm, func, sa);

MPG2 : MPG port map(enable_if, btn(0), clk);

MPG3 : MPG port map(rst, btn(1), clk);

SSD : display_7segment port map(clk, out1(3 downto 0), out1(7 downto 4), out1(11 downto 8), out1(15 downto 12), cat, an);

process(sw(7 downto 5), instr, pc1, rd1, rd2, Ext_Imm, ALUResOut, MemData, WD)
begin
case sw(7 downto 5) is
    when "000" => out1 <= instr;
    when "001" => out1 <= pc1;
    when "010" => out1 <= rd1;
    when "011" => out1 <= rd2;
    when "100" => out1 <= Ext_Imm;
    when "101" => out1 <= ALUResOut;
    when "110" => out1 <= MemData;
    when "111" => out1 <= WD;
end case;
end process;

end Behavioral;