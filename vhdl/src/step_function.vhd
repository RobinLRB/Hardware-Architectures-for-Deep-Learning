----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2020 15:32:29
-- Design Name: 
-- Module Name: step_function - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity step_function is
    port (  clk     : in std_logic;
            x       : in std_logic_vector(data_precision-1 downto 0);
            y       : out std_logic_vector(data_precision-1 downto 0)
            );
end step_function;

architecture Behavioral of step_function is

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if signed(x) >= to_signed(integer(step_function_parameter_a), data_precision) then
                y <= std_logic_vector(to_signed(integer(step_function_high_output), data_precision));
            else
                y <= std_logic_vector(to_signed(-integer(step_function_high_output), data_precision));
            end if;
        end if;
    end process;
end Behavioral;
