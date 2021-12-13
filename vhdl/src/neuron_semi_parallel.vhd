----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2020 10:55:49
-- Design Name: 
-- Module Name: neuron_semi_parallel - Behavioral
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

entity neuron_semi_parallel is
    port (  clk     : in std_logic;
            b       : in std_logic_vector(data_precision-1 downto 0);
            x       : in data_vector;
            w       : in data_vector;
            y       : out std_logic_vector(data_precision-1 downto 0)
            );
end neuron_semi_parallel;

architecture Behavioral of neuron_semi_parallel is
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
         
    signal act_x                  : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    
    signal mac_0_b                : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal mac_0_w                : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal mac_0_x                : std_logic_vector(data_precision-1 downto 0) := (others => '0');   
    signal intermediate_result_0  : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    
    signal mac_1_b                : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal mac_1_w                : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    signal mac_1_x                : std_logic_vector(data_precision-1 downto 0) := (others => '0');   
    signal intermediate_result_1  : std_logic_vector(data_precision-1 downto 0) := (others => '0');
    
    signal in_w                 : data_vector;
    signal in_x                 : data_vector;    
begin
    i_MACU_unit_0   : MAC_unit port map(clk => clk, b => mac_0_b, w => mac_0_w, x => mac_0_x, y => intermediate_result_0);
    i_MACU_unit_1   : MAC_unit port map(clk => clk, b => mac_1_b, w => mac_1_w, x => mac_1_x, y => intermediate_result_1); 
    i_ReLU_function : ReLU_function port map(clk => clk, x => act_x, y => y);
    
    main : process(clk)
        variable counter            : integer := 0;
        
        type state_type is (initial_state, repetitive_state, final_state);
        variable state              : state_type := initial_state;
        variable normalized_vector  : std_logic_vector(data_precision-1 downto 0) := (fractional_bits => '1', others => '0');     
    begin
        if rising_edge(clk) then
            case state is
                when initial_state =>
                    --assigne values of input ports to input register stage
                    in_w <= w;
                    in_x <= x;
                    --update input value of activation function
                    act_x <= intermediate_result_0;
                    --update input values of MAC_unit_0
                    mac_0_b <= (others => '0');
                    mac_0_w <= normalized_vector;
                    mac_0_x <= b;
                    --enter next state
                    state := repetitive_state; 
                when repetitive_state =>
                    --update input values of MAC_unit_0
                    mac_0_b <= intermediate_result_0;
                    mac_0_w <= in_w(counter); 
                    mac_0_x <= in_x(counter);
                    --update input values of MAC_unit_1
                    mac_1_b <= intermediate_result_1;
                    mac_1_w <= in_w(number_of_inputs/2 + counter); 
                    mac_1_x <= in_x(number_of_inputs/2 + counter);
                    --enter next state
                    if counter = (number_of_inputs/2) - 1 then
                        state := final_state;
                    else
                        counter := counter + 1; 
                    end if;
                when final_state =>
                    --update input values of MAC_unit_0
                    mac_0_b <= intermediate_result_0;
                    mac_0_w <= normalized_vector;
                    mac_0_x <= intermediate_result_1;             
                    --update input values of MAC_unit_1
                    mac_1_b <= (others => '0');
                    mac_1_w <= (others => '0');
                    mac_1_x <= (others => '0');
                    --enter next state
                    state := initial_state;
                    counter := 0;                  
                when others =>
                    NULL;
            end case;
        end if;
    end process main;
    
end Behavioral;
