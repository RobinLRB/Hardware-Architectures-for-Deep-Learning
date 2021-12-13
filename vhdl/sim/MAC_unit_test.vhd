----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.11.2020 18:09:01
-- Design Name: 
-- Module Name: MAC_unit_test - Behavioral
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
library WORK;
use WORK.MAC_unit;
use WORK.system_definition.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAC_unit_test is
end MAC_unit_test;

architecture Behavioral of MAC_unit_test is
    component MAC_unit
        port(   clk     : in std_logic;
                b       : in std_logic_vector (data_precision-1 downto 0);
                w       : in std_logic_vector (data_precision-1 downto 0);
                x       : in std_logic_vector (data_precision-1 downto 0);
                y       : out std_logic_vector (data_precision-1 downto 0) 
                );
    end component;
    
    signal s_clk    : std_logic;
    signal s_b      : std_logic_vector (data_precision-1 downto 0) := std_logic_vector(to_signed(0, data_precision));
    signal s_w      : std_logic_vector (data_precision-1 downto 0) := std_logic_vector(to_signed(0, data_precision));
    signal s_x      : std_logic_vector (data_precision-1 downto 0) := std_logic_vector(to_signed(0, data_precision));
    signal s_y      : std_logic_vector (data_precision-1 downto 0) := std_logic_vector(to_signed(0, data_precision));
    
    signal real_b   : real := 0.0;
    signal real_w   : real := 0.0;
    signal real_x   : real := 0.0;
    signal real_y   : real := 0.0;

begin
    UUT0 : MAC_Unit port map (clk => s_clk, b => s_b, w => s_w, x => s_x, y => s_y);
    
    main : process
    begin   
        double_clock_cycle(s_clk);
        real_w <= 1.0;
        real_x <= 1.0;     
        double_clock_cycle(s_clk);
        real_w <= 2.0;
        real_x <= -2.0;  
        double_clock_cycle(s_clk);
        real_b <= 6.0;
        double_clock_cycle(s_clk);
        real_w <= 0.1;
        real_x <= 0.1;  
        real_b <= 0.0;
        double_clock_cycle(s_clk);
        real_b <= -1.0;
        double_clock_cycle(s_clk);
        wait;
    end process main;
    
    
    assigne_signals : process(real_b, real_w, real_x)
    begin
        s_b <= return_std_logic_vector(real_b);
        s_w <= return_std_logic_vector(real_w);
        s_x <= return_std_logic_vector(real_x);   
    end process assigne_signals;

    real_y <= return_real(s_y);
end Behavioral;
