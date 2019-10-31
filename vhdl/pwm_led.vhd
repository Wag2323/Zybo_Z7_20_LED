-------------------------------------------------------------------------------
-- Company: None
-- Engineer: Randy Waguespack
-- 
-- Create Date:  20191029
-- Description: Pulse Width Modulation based on 8 bit input.
-- 
-- 
-- Revision 0.01 - File Created
--
-- Additional Comments:
-- 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pwm_led is
  port (
    clk    : in  std_logic;
    input  : in  std_logic_vector(7 downto 0);
    output : out std_logic
    );
end pwm_led;

architecture rtl of pwm_led is

  signal counter  : std_logic_vector(8 downto 0);
  signal int      : std_logic_vector(8 downto 0);
    
begin
  
  int <= '0' & input;
  
  PWM : process (clk)
    begin
      if rising_edge(clk) then
        counter <= counter + '1';
        if counter <= int then --even input of 0 gets one clk
          output <= '1';
        else 
          output <= '0';
        end if;
      end if;
    end process PWM;
        
end rtl;