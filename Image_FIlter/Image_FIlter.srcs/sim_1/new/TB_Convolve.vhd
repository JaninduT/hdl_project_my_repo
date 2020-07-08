----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2020 07:37:49 AM
-- Design Name: 
-- Module Name: TB_Convolve - Behavioral
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

entity tb_convolve is

end tb_convolve;

architecture Behavioral of tb_convolve is

component Convolution is
    Port ( dina : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           clock  : in STD_LOGIC ;
           raddr : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           waddr : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           wea : out STD_LOGIC_VECTOR (0 downto 0);
           paddone : in STD_LOGIC;
           convdone : out STD_LOGIC:='0');
end component;

signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clock: STD_LOGIC :='0';
signal paddone: STD_LOGIC;
signal douta: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal wea: STD_LOGIC_VECTOR (0 downto 0) :="0";
signal raddr: STD_LOGIC_VECTOR(9 DOWNTO 0);

begin

uut1 : Convolution
    port map(dina=>dina,
             clock=>clock,
             paddone=>paddone,
             douta=>douta,
             wea=>wea,
             raddr=>raddr);

clock <= not clock after 10ns;

stimuli : process
    begin
        wait for 20ns;
        paddone<='1';
        dina<="00000000";--Frsme 1/ 1 2 3 4 5 6 7 8 9 =45
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00001010"; -- frame 2 54
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000011"; -- frame 3 47
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000111"; --frame 4 51 
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00001000"; -- frame 5 52 
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000000"; -- frame 6 44
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000001"; -- frame 7 45
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000000"; -- frame 8 44
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait for 20ns;
        dina<="00000001";--frame 9- 45
        wait for 20ns;
        dina<="00000010";
        wait for 20ns;
        dina<="00000011";
        wait for 20ns;
        dina<="00000100";
        wait for 20ns;
        dina<="00000101";
        wait for 20ns;
        dina<="00000110";
        wait for 20ns;
        dina<="00000111";
        wait for 20ns;
        dina<="00001000";
        wait for 20ns;
        dina<="00001001";
        wait;
    end process;
    
end Behavioral;
