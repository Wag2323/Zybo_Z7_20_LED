-------------------------------------------------------------------------------
-- Company: None
-- Engineer: Randy Waguespack
-- 
-- Create Date:  20191029
-- Description: Select and RGB LED color based on switch inputs
-- 
-- 
-- Revision 0.01 - File Created
--
-- Additional Comments:
-- 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

library UNISIM;
use UNISIM.VComponents.all;

entity rgb_led_top is 
  port(
    sysclk  : in  std_logic; -- 125MHz
    sw      : in  std_logic_vector(3 downto 0);
    led     : out std_logic_vector(3 downto 0); -- single green leds
    led5_r  : out std_logic;
    led5_g  : out std_logic;
    led5_b  : out std_logic
    );
end rgb_led_top;

architecture rtl of rgb_led_top is

  signal sw_input    : std_logic_vector(3 downto 0);
  signal color       : std_logic_vector(23 downto 0);
  signal red_out     : std_logic;
  signal green_out   : std_logic;
  signal blue_out    : std_logic;
  
begin
  
  color <= x"ff0000" when (sw = "0000") else --red
           x"ff8000" when (sw = "0001") else --orange
           x"ffff00" when (sw = "0010") else --yellow
           x"80ff00" when (sw = "0011") else --yellow green
           x"00ff00" when (sw = "0100") else --green
           x"00ff80" when (sw = "0101") else --green blue
           x"00ffff" when (sw = "0110") else --cyan
           x"0080ff" when (sw = "0111") else --cyan blue
           x"0000ff" when (sw = "1000") else --blue
           x"6600cc" when (sw = "1001") else --purple
           x"ff00ff" when (sw = "1010") else --pink
           x"ff007f" when (sw = "1011") else --magenta
           x"808080" when (sw = "1100") else --gray
           x"660000" when (sw = "1101") else --dark red
           x"ffffff" when (sw = "1110") else --white
           x"000000"; --black

  RGB_RED : entity work.pwm_led
    port map(
      clk    => sysclk,
      input  => color(23 downto 16),
      output => red_out
      );
      
  RGB_GREEN : entity work.pwm_led
    port map(
      clk    => sysclk,
      input  => color(15 downto 8),
      output => green_out
      );
      
  RGB_BLUE : entity work.pwm_led
    port map(
      clk    => sysclk,
      input  => color(7 downto 0),
      output => blue_out
      );
  
  --RGB LED output drives an open drain circuit no buffer needed
  led5_r <= red_out;
  led5_g <= green_out;
  led5_b <= blue_out;  
  
  --Put a copy of the individual color intensities on the single green leds
  --Not in an open drain circuit so use a buffer
  OUTPUT_BUF1 : OBUF
    port map(
      I  => red_out,
      O  => led(0)
      );
      
  OUTPUT_BUF2 : OBUF
    port map(
      I  => green_out,
      O  => led(1)
      );
      
  OUTPUT_BUF3 : OBUF
    port map(
      I  => blue_out,
      O  => led(2)
      );
  
end rtl;



