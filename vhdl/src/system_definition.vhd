----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2020 22:28:44
-- Design Name: 
-- Module Name: system_definition - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

package system_definition is
    --definitions for synthesis and simulation
        --global constants
        constant data_precision : natural := 32;
        constant fractional_bits : natural := 20;
        constant number_of_inputs : natural := 8;
        type data_vector is array (number_of_inputs-1 downto 0) of std_logic_vector(data_precision-1 downto 0);
        --step function constants
        constant step_function_parameter_a_real : real := 0.0;
        constant step_function_parameter_a : natural := natural(step_function_parameter_a_real * 2.0**fractional_bits);
        constant step_function_high_output : natural := natural(1.0 * 2.0**fractional_bits);
    

    --definitions for simulation
        -- simulation clock
        constant half_clock_period : time := 1 ns;
        procedure clock_cycle(signal clk : out std_logic);
        procedure double_clock_cycle(signal clk : out std_logic);
        procedure wait_fully_serial;
        procedure wait_fully_parallel;
        procedure wait_semi_parallel;
        -- functions to converter real to std_logic_value and the other way around
        function return_std_logic_vector(constant value : real) return std_logic_vector;
        function return_real(constant value : std_logic_vector(data_precision-1 downto 0)) return real;
    
end system_definition;

package body system_definition is

    procedure wait_fully_serial is
    begin
        wait for (2*number_of_inputs + 2) * half_clock_period;
    end procedure wait_fully_serial;
    
    procedure wait_fully_parallel is
    begin
        wait for 2 * half_clock_period;
    end procedure wait_fully_parallel;
    
    procedure wait_semi_parallel is
    begin
        wait for natural(real(number_of_inputs) * 0.5 + 2.0) * 2 * half_clock_period;
    end procedure wait_semi_parallel;

    function return_std_logic_vector(constant value : real) return std_logic_vector is
        variable return_value : std_logic_vector (data_precision-1 downto 0);
    begin
        return_value := std_logic_vector(conv_signed(integer(value * 2.0**fractional_bits), data_precision));
        return return_value;
    end function return_std_logic_vector;
    
    function return_real(constant value : std_logic_vector(data_precision-1 downto 0)) return real is
    begin
        return real(to_integer(ieee.numeric_std.signed(value)))/(2.0**fractional_bits);
    end function return_real;
    
    procedure clock_cycle(signal clk : out std_logic) is
    begin
        clk <= '1';
        wait for half_clock_period;
        clk <= '0';
        wait for half_clock_period;
    end procedure clock_cycle;
    
        procedure double_clock_cycle(signal clk : out std_logic) is
    begin
        clk <= '1';
        wait for half_clock_period;
        clk <= '0';
        wait for half_clock_period;
        clk <= '1';
        wait for half_clock_period;
        clk <= '0';
        wait for half_clock_period;
    end procedure double_clock_cycle;
end system_definition;
