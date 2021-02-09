----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 05:37:44 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
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
end EX;

architecture Behavioral of EX is

signal ALUCtrl : std_logic_vector(2 downto 0);
signal Mux_Out : std_logic_vector(15 downto 0);
signal inter : std_logic_vector(15 downto 0);
signal inter1 : std_logic;

begin

Zero <= inter1;

ALURes <= inter;

Mux_Out <= RD2 when ALUSrc = '0' else Ext_Imm;

BranchAddress <= Ext_Imm + PC1;

inter1 <= '1' when inter = x"0000" else '0';

GE <=  not(inter(15));

GT <= not(inter(15)) and not(inter1);

ALUControl: process(AluOp, func)
begin
    case AluOp is
        when "11" =>
            case func is
                when "000" => ALUCtrl <= "000";
                when "001" => ALUCtrl <= "001";
                when "010" => ALUCtrl <= "010";
                when "011" => ALUCtrl <= "011";
                when "100" => ALUCtrl <= "100";
                when "101" => ALUCtrl <= "101";
                when "110" => ALUCtrl <= "110";
                when "111" => ALUCtrl <= "111";
            end case;
        when "00" => ALUCtrl <= "000";
        when "01" => ALUCtrl <= "001";
        when others => ALUCtrl <= (others => '0');
    end case;
end process;

process(RD1, Mux_Out, ALUCtrl, sa)
begin
case ALUCtrl is
    when "000" => inter <= RD1 + Mux_Out;
    when "001" => inter <= RD1 - Mux_Out;
    when "010" => if sa = '1' then
                    inter <= Mux_out(14 downto 0) & '0';
                  else 
                    inter <= Mux_out;
                  end if;
    when "011" => if sa = '1' then
                    inter <= '0' & Mux_out(15 downto 1);
                  else 
                    inter <= Mux_out;
                  end if;
    when "100" => inter <= RD1 and Mux_Out;
    when "101" => inter <= RD1 or Mux_Out;
    when "110" => inter <= RD1 xor Mux_Out;
    when "111" => if sa = '1' then
                    inter <= Mux_out(15) & Mux_out(15 downto 1);
                  else 
                    inter <= Mux_out;
                  end if;
end case;
end process;

end Behavioral;