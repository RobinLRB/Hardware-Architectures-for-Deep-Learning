----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2020 17:52:02
-- Design Name: 
-- Module Name: MAC_unit - Behavioral
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
use IEEE.numeric_std.all;

library WORK;
use WORK.system_definition.all;

entity MAC_unit is
    port(   clk     : in std_logic;
            b       : in std_logic_vector (data_precision-1 downto 0);
            w       : in std_logic_vector (data_precision-1 downto 0);
            x       : in std_logic_vector (data_precision-1 downto 0);
            y       : out std_logic_vector (data_precision-1 downto 0) := (others => '0')
            );
end MAC_unit;

architecture Behavioral of MAC_unit is
    signal res  : signed (data_precision*2-1 downto 0) := to_signed(0, data_precision*2);
begin
    res <= signed(w) * signed(x);
    y <= std_logic_vector(res((fractional_bits + data_precision - 1) downto fractional_bits) + signed(b));
end Behavioral;
