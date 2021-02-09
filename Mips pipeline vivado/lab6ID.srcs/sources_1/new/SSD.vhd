----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2020 02:15:48 PM
-- Design Name: 
-- Module Name: 7segment - Behavioral
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

entity display_7segment is
  Port (clk : in std_logic;
  digit0, digit1, digit2, digit3 : in std_logic_vector(3 downto 0);
  cat : out std_logic_vector(6 downto 0);
  an : out std_logic_vector(3 downto 0) );
end display_7segment;

architecture Behavioral of display_7segment is

signal semnal : std_logic_vector(15 downto 0) := "0000000000000000";
signal O : std_logic_vector(3 downto 0);
signal O1 : std_logic_vector(3 downto 0);
signal i0: std_logic_vector(3 downto 0):="1110";
signal i1: std_logic_vector(3 downto 0):="1101";
signal i2: std_logic_vector(3 downto 0):="1011";
signal i3: std_logic_vector(3 downto 0):="0111";

begin

an <= O1;

process(clk)
begin
    if rising_edge(clk) then
        semnal <= semnal + 1;
    end if;
end process;

process(digit0, digit1, digit2, digit3, semnal(15 downto 14))
begin
 case semnal(15 downto 14) is
 when "00" => O <= digit0;
 when "01" => O <= digit1;
 when "10" => O <= digit2;
 when "11" => O <= digit3;
 end case;
end process;

process(i0, i1, i2, i3, semnal(15 downto 14))
begin
 case semnal(15 downto 14) is
 when "00" => O1 <= i0;
 when "01" => O1 <= i1;
 when "10" => O1 <= i2;
 when "11" => O1 <= i3;
 end case;
end process;

process (O)
begin
    case O is
        when "0000"=> cat <="1000000";
        when "0001"=> cat <="1111001";
        when "0010"=> cat <="0100100";
        when "0011"=> cat <="0110000";
        when "0100"=> cat <="0011001"; 
        when "0101"=> cat <="0010010";
        when "0110"=> cat <="0000010";
        when "0111"=> cat <="1111000";
        when "1000"=> cat <="0000000";
        when "1001"=> cat <="0010000";
        when "1010"=> cat <="0001000";
        when "1011"=> cat <="0000011";
        when "1100"=> cat <="1000110";
        when "1101"=> cat <="0100001";
        when "1110"=> cat <="0000110";
        when "1111"=> cat <="0001110";
    end case;
end process;

end Behavioral;