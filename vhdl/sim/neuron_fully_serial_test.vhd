----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2020 10:56:29
-- Design Name: 
-- Module Name: neuron_fully_serial_test - Behavioral
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
use WORK.neuron_fully_serial;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity neuron_fully_serial_test is
end neuron_fully_serial_test;

architecture Behavioral of neuron_fully_serial_test is
    component neuron_fully_serial
        port (  clk     : in std_logic;
                b       : in std_logic_vector(data_precision-1 downto 0);
                x       : in data_vector;
                w       : in data_vector;
                y       : out std_logic_vector(data_precision-1 downto 0)
                );
    end component;
    
    signal s_clk    : std_logic;
    signal s_b      : std_logic_vector(data_precision-1 downto 0);
    signal s_x      : data_vector;
    signal s_w      : data_vector;
    signal s_y      : std_logic_vector(data_precision-1 downto 0);
    
    type real_array is array (number_of_inputs-1 downto 0) of real;
    signal real_b   : real := 0.0;
    signal real_w   : real_array := (others => 0.0);
    signal real_x   : real_array := (others => 0.0);
    signal real_y   : real := 0.0;

begin
    UUT0 : neuron_fully_serial port map (clk => s_clk, b => s_b, x => s_x, w => s_w, y => s_y);

    main : process --it will take "(2*number_of_input + 1) clock cycle" until the result is shown at the output
    begin
        real_b <= real_b - 3.0;
        wait_fully_serial;
        
        for i in 0 to 5 loop
            real_b <= real_b + 1.0;
            wait_fully_serial;
        end loop;

        real_x(0) <= 1.0;
        real_w(0) <= 1.0;
        wait_fully_serial;
        
        real_x(1) <= 1.0;
        real_w(1) <= 1.0;
        wait_fully_serial;
        
        real_b <= 0.1;
        for i in 0 to number_of_inputs-1 loop 
            real_w(i) <= 0.1;
            real_x(i) <= 0.1;
        end loop;
        wait_fully_serial;
        
        real_b <= -203.0;
        for i in 0 to number_of_inputs-1 loop 
            real_w(i) <= real(i+1);
            real_x(i) <= real(i+1);
        end loop;
        wait_fully_serial;
        
        wait;
    end process main;

    assigne_signals : process(real_b, real_w, real_x)
    begin
        s_b <= return_std_logic_vector(real_b);
        for i in 0 to number_of_inputs-1 loop
            s_w(i) <= return_std_logic_vector(real_w(i));
            s_x(i) <= return_std_logic_vector(real_x(i));  
        end loop; 
    end process assigne_signals;

    clock_generate : process
    begin
        clock_cycle(s_clk);
    end process clock_generate;

    real_y <= return_real(s_y);
end Behavioral;
