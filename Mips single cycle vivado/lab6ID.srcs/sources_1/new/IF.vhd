----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2020 04:51:03 PM
-- Design Name: 
-- Module Name: IF - Behavioral
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

entity IF1 is
  Port (clk : in std_logic;
  enable : in std_logic;
  rst : in std_logic;
  ba : in std_logic_vector(15 downto 0);
  pcsrc : in std_logic;
  ja : in std_logic_vector(15 downto 0);
  jump : in std_logic;
  instr : out std_logic_vector(15 downto 0);
  pc1 : out std_logic_vector(15 downto 0));
end IF1;

architecture Behavioral of IF1 is

--addi $1, $0, 3 initializeaza R1 cu 3
--addi $2, $0, 5 initializeaza R2 cu 5
--add $3, $1, $2 pune in R3 pe R1 + R2
--sub $4, $2, $1 pune in R4 pe R1 - R2
--sll $5, $2, 1 pune in R5 pe R2 deplasat la stanga cu 1 bit
--srl $5, $5, 1 pune in R5 pe el insusi deplasat la dreapta cu un bit
--sw $3, 1($1) pune in memorie valoarea din R3 la adresa 1 + R1
--lw $4, 1($1) ia din memorie si pune in R4 valoarea de la adresa 1 + R1
--beq $3, $4, 2 daca R3 = R4 sare 3 instructiuni
--j 1 salt la instructiunea cu index 1, a doua din program
--and $3, $3, $4 pune in R3, valoarea din R3 si logic cu valoarea din R4
--or $3, $3, $4 pune in R3, valoarea din R3 sau logic cu valoarea din R4
--xor $5, $1, $2 pune in R5, valoarea din R1 sau exclusiv cu valoarea din R2
--sra $5, $5, 1 pune in R5 pe el insusi deplasat la dreapta cu semn
--bgez $5, -6 daca R5 e mai mare sau egal cu 0, sare inapoi cu 5 instructiuni
--bgtz $3, -7 daca R3 e mai mare decat 0, sare inapoi cu 6 instructiuni

type mem is array (0 to 31) of std_logic_vector (15 downto 0);
signal rom : mem := (
B"001_000_001_0000011", --addi $1, $0, 3   X"2083"
B"001_000_010_0000101", --addi $2, $0, 5   X"2105"
B"000_001_010_011_0_000", --add $3, $1, $2   X"530"
B"000_010_001_100_0_001", --sub $4, $2, $1   X"8C1"
B"000_000_010_101_1_010", --sll $5, $2, 1   X"15A"
B"000_000_101_101_1_011", --srl $5, $5, 1   X"2DB"
B"011_001_011_0000001", --sw $3, 1($1)   X"6581"
B"010_001_100_0000001", --lw $4, 1($1)   X"4601"
B"100_011_100_0000010", --beq $3, $4, 2   X"8E02"
B"111_0000000000001", --j 1   X"E001"
B"000_011_100_011_0_100", --and $3, $3, $4   X"E34"
B"000_011_100_011_0_101", --or $3, $3, $4   X"E35"
B"000_001_010_101_0_110", --xor $5, $1, $2   X"556"
B"000_000_101_101_1_111", --sra $5, $5, 1   X"2DF"
B"101_101_001_1111010", --bgez $5, -6   X"B4FA"
B"110_011_000_1111001", --bgtz $3, -7   X"CC79"
others => x"0000");

signal q : std_logic_vector(15 downto 0);
signal d : std_logic_vector(15 downto 0);
signal mux_inter : std_logic_vector(15 downto 0);

begin

process(clk)
begin
if rising_edge(clk) then
    if rst = '1' then
        q <= x"0000";
    elsif enable = '1' then
        q <= d;
    end if;
end if;
end process;

mux_inter <= ba when pcsrc = '1' else (q + 1);

pc1 <= q + 1;

d <= ja when jump = '0' else mux_inter;

instr <= rom(conv_integer(q(4 downto 0)));

end Behavioral;