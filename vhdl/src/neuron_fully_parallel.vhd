----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2020 10:55:49
-- Design Name: 
-- Module Name: neuron_fully_parallel - Behavioral
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

library WORK;
use WORK.system_definition.all;
use WORK.MAC_unit;
use WORK.ReLU_function;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity neuron_fully_parallel is
    port (  clk     : in std_logic;
            b       : in std_logic_vector(data_precision-1 downto 0);
            x       : in data_vector;
            w       : in data_vector;
            y       : out std_logic_vector(data_precision-1 downto 0)
            );
end neuron_fully_parallel;

architecture Behavioral of neuron_fully_parallel is
    component MAC_unit
        port(   clk     : in std_logic;
                b       : in std_logic_vector (data_precision-1 downto 0);
                w       : in std_logic_vector (data_precision-1 downto 0);
                x       : in std_logic_vector (data_precision-1 downto 0);
                y       : out std_logic_vector (data_precision-1 downto 0) := (others => '0')
                );
    end component;
    
    component ReLU_function
        port (  clk     : in std_logic;
                x       : in std_logic_vector(data_precision-1 downto 0);
                y       : out std_logic_vector(data_precision-1 downto 0)
                );
    end component;           

    signal zero_value_vector        : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal normalize_value_vector   : std_logic_vector(data_precision-1 downto 0) := (fractional_bits => '1', others => '0');
    signal intermediate_result      : data_vector;
    signal final_sum                : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal input_activation_function: std_logic_vector(data_precision-1 downto 0) := (others => '0');
    
    signal in_w                 : data_vector;
    signal in_x                 : data_vector;  
begin
    i_MACU_unit_0 : MAC_unit port map(clk => clk, b => zero_value_vector, w => normalize_value_vector, x => b, y => intermediate_result(0));
    
    gen : for i in 1 to number_of_inputs-1 generate
        i_MACU_unit_i : MAC_unit port map(clk => clk, b => intermediate_result(i-1), w => w(i-1), x => x(i-1), y => intermediate_result(i));
    end generate;
        
    i_MACU_unit_last : MAC_unit port map(clk => clk, b => intermediate_result(number_of_inputs-1), w => w(number_of_inputs-1), x => x(number_of_inputs-1), y => final_sum);
    
    i_ReLU_function : ReLU_function port map(clk => clk, x => input_activation_function, y => y);
    
    main : process(clk)
    begin
        if rising_edge(clk) then
            in_w <= w;
            in_x <= x;
            input_activation_function <= final_sum;
        end if;
    end process main;
    
end Behavioral;
