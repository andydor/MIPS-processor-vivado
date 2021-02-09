----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 06:21:05 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
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
end UC;

architecture Behavioral of UC is

begin

process(instr)
begin
RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; Branch <= '0'; Jump <= '0'; MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '0'; RegWrite <= '0'; ALUOp <= "00"; BrGTZ <= '0'; BrGEZ <= '0';
case instr is
    when "000" => RegDst <= '1'; RegWrite <= '1'; ALUOp <= "11";
    when "001" => ExtOp <= '1'; ALUSrc <= '1'; RegWrite <= '1'; ALUOp <= "00";
    when "010" => ExtOp <= '1'; ALUSrc <= '1'; MemtoReg <= '1'; RegWrite <= '1'; ALUOp <= "00";
    when "011" => ExtOp <= '1'; ALUSrc <= '1'; MemWrite <= '1'; ALUOp <= "00";
    when "100" => ExtOp <= '1'; Branch <= '1'; ALUOp <= "01";
    when "101" => ExtOp <= '1'; ALUOp <= "01"; BrGEZ <= '1';
    when "110" => ExtOp <= '1'; ALUOp <= "01"; BrGTZ <= '1';
    when "111" => Jump <= '1'; ALUOp <= "00";
    end case;
end process;
end Behavioral;
