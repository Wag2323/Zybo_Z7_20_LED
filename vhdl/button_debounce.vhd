-------------------------------------------------------------------------------
-- Company: None
-- Engineer: Randy Waguespack
-- 
-- Create Date:  20191029
-- Description: Debounce button for eval boards
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


entity button_debounce is
  port (
    clk    : in  std_logic;
    input  : in  std_logic;
    output : out std_logic
    );
end button_debounce;

architecture rtl of button_debounce is

  signal counter : std_logic_vector(27 downto 0);
  signal slow_en : std_logic;
  signal in_q    : std_logic;
  signal in_q2   : std_logic;
  
begin

  ENABLE : process (clk)  -- slow enable for debounce
    begin
      if rising_edge(clk) then
        counter <= counter + 1;
        if counter >= x"17d7840" then -- 4Hz if clk = 100MHz
          counter <= x"0000000";
        end if;
      end if;
    end process ENABLE;
    
  slow_en <= '1' when counter = x"17d7840" else '0';
  
  DFF_DEBOUNCE : process (clk)
    begin
      if rising_edge(clk) then
        if slow_en = '1' then
          in_q  <= input;
          in_q2 <= in_q;
        end if;
      end if;
    end process DFF_DEBOUNCE;
    
  output <= in_q and (not in_q2) and slow_en;      
        
end rtl;