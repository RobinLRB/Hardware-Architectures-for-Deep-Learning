----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.11.2020 17:34:54
-- Design Name: 
-- Module Name: ReLU_function_test - Behavioral
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
use IEEE.math_real.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.system_definition.all;
use WORK.ReLU_function;
use WORK.system_definition.all;

entity ReLU_function_test is
end ReLU_function_test;

architecture Behavioral of ReLU_function_test is

    component ReLU_function
        port(   clk     : in std_logic;
                x       : in std_logic_vector (data_precision-1 downto 0);
                y       : out std_logic_vector (data_precision-1 downto 0)
                );
    end component;
    
    signal s_clk    : std_logic;
    signal s_x      : std_logic_vector (data_precision-1 downto 0);
    signal s_y      : std_logic_vector (data_precision-1 downto 0);
    
    signal real_x   : real := 0.0;
    signal real_y   : real;
     
begin
    UUT0 : ReLU_function port map (clk => s_clk, x => s_x, y => s_y);
    
    main : process
        -- value range of used data precision
        variable v_low_base : real := -1.0 * 2**(data_precision - fractional_bits - 1);
        variable v_high_base : real := 1.0 * 2**(data_precision - fractional_bits - 1) - 1.0;
        variable v_number_of_steps : natural := 200;
        variable v_intervall_size : real := (v_high_base - v_low_base) / real(v_number_of_steps);
    begin
       
        -- first test intervall
        double_clock_cycle(s_clk);
        real_x <= v_low_base;
        clock_cycle(s_clk);
        for i in 1 to v_number_of_steps-1 loop
            real_x <= v_low_base + real(i) * v_intervall_size;
            clock_cycle(s_clk);
        end loop;
        real_x <= v_high_base;
        clock_cycle(s_clk);
        
        -- second test intervall
        v_low_base := -1.0;
        v_high_base := 1.0;
        v_intervall_size := (v_high_base - v_low_base) / real(v_number_of_steps);
        double_clock_cycle(s_clk);
        real_x <= v_low_base;
        clock_cycle(s_clk);
        for i in 1 to v_number_of_steps loop
            real_x <= v_low_base + real(i) * v_intervall_size;
            clock_cycle(s_clk);
        end loop; 
        real_x <= v_high_base;
        clock_cycle(s_clk);
       
        -- third test intervall
        v_number_of_steps := 64;
        v_intervall_size := (v_high_base - v_low_base) / real(v_number_of_steps);
        double_clock_cycle(s_clk);
        real_x <= v_low_base;
        clock_cycle(s_clk);
        for i in 1 to v_number_of_steps loop
            real_x <= v_low_base + real(i) * v_intervall_size;
            clock_cycle(s_clk);
        end loop;       
        real_x <= v_high_base;
        clock_cycle(s_clk);
        
        double_clock_cycle(s_clk);
        wait;
    end process main;

    assigne_signals : process(real_x)
    begin
        s_x <= return_std_logic_vector(real_x);
    end process assigne_signals;

    real_y <= return_real(s_y);

end Behavioral;
