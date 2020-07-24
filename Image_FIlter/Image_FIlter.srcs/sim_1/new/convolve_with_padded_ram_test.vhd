----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2020 12:06:20 PM
-- Design Name: 
-- Module Name: convolve_with_padded_ram_test - Behavioral
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

entity convolve_with_padded_ram_test is
--  Port ( );
end convolve_with_padded_ram_test;

architecture Behavioral of convolve_with_padded_ram_test is

component Convolution is
    Port ( dina : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           clock  : in STD_LOGIC;
           raddr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
           waddr : out STD_LOGIC_VECTOR(4 DOWNTO 0);
           wea : out STD_LOGIC_VECTOR( 0 downto 0 ) := "0";
           paddone : in STD_LOGIC;
           convdone : out STD_LOGIC:='0';
           rst_n : in STD_LOGIC);
end component;

component padded_image_ram is
  port (clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

signal dina : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clock: STD_LOGIC :='0';
signal paddone: STD_LOGIC;
signal rst_n: STD_LOGIC;
signal douta: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal wea: STD_LOGIC_VECTOR ( 0 downto 0) := "0";
signal wea_to_padded: STD_LOGIC_VECTOR ( 0 downto 0) := "0";
signal raddr : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal waddr : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal convdone : STD_LOGIC;
signal doutb_dontcare : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

uut1 : Convolution
    port map(dina=>dina,
             clock=>clock,
             rst_n => rst_n,
             paddone=>paddone,
             douta=>douta,
             wea=>wea,
             raddr=>raddr,
             waddr=>waddr,
             convdone=>convdone);

uut_3 : padded_image_ram
  port map (clka => clock,
            wea => wea_to_padded,
            addra => raddr,
            dina => "00000000",
            douta => dina,
            clkb => clock,
            web => "0",
            addrb => raddr,
            dinb => "00000000",
            doutb => doutb_dontcare);

clock <= not clock after 5ns;

stimuli : process
    begin
        paddone <= '0';
        wea_to_padded <= "0";
        rst_n <= '1';
        wait for 5ns;
        paddone <= '1';
--        wait for 10ns;
--        paddone <= '0';
        wait;
    end process;

end Behavioral;
