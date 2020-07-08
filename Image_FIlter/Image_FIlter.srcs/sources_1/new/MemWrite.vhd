----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2020 05:27:46 PM
-- Design Name: 
-- Module Name: MemWrite - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemWrite is
    Port (dina : in STD_LOGIC_VECTOR(7 DOWNTO 0);
          waddr : in STD_LOGIC_VECTOR(9 DOWNTO 0);
          wea : in STD_LOGIC_VECTOR (0 downto 0) :="0";
          doutr : out STD_LOGIC_VECTOR(7 DOWNTO 0) );
end MemWrite;

architecture Behavioral of MemWrite is

begin
    process ( wea, dina, waddr)
        begin
            if ( wea 'event and wea = "1") then
                doutr<=dina;
                --addr<=waddr
                --val<=dina
            end if;
    end process;
end Behavioral;
