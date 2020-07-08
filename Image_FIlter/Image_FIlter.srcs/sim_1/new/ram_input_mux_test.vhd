----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2020 09:54:25 PM
-- Design Name: 
-- Module Name: ram_input_mux_test - Behavioral
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

entity ram_input_mux_test is
--  Port ( );
end ram_input_mux_test;

architecture Behavioral of ram_input_mux_test is

component ram_input_mux is
    Port ( padding_en_in : in STD_LOGIC;
           convolve_en_in : in STD_LOGIC;
           ioi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_pu_in : in STD_LOGIC_VECTOR (9 downto 0);
           ioi_addra_convu_in : in STD_LOGIC_VECTOR (9 downto 0);
           padi_wea_pu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_wea_convu_in : in STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_pu_in : in STD_LOGIC_VECTOR (9 downto 0);
           padi_addra_convu_in : in STD_LOGIC_VECTOR (9 downto 0);
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           ioi_addra_out : out STD_LOGIC_VECTOR (9 downto 0);
           padi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           padi_addra_out : out STD_LOGIC_VECTOR (9 downto 0));
end component;

signal padding_en_in : STD_LOGIC;
signal convolve_en_in : STD_LOGIC;
signal ioi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal padi_wea_pu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_wea_convu_in : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_pu_in : STD_LOGIC_VECTOR (9 downto 0);
signal padi_addra_convu_in : STD_LOGIC_VECTOR (9 downto 0);
signal ioi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal ioi_addra_out : STD_LOGIC_VECTOR (9 downto 0);
signal padi_wea_out : STD_LOGIC_VECTOR (0 downto 0);
signal padi_addra_out : STD_LOGIC_VECTOR (9 downto 0);

begin

uut1 : ram_input_mux
    port map (padding_en_in => padding_en_in,
              convolve_en_in => convolve_en_in,
              ioi_wea_pu_in => ioi_wea_pu_in,
              ioi_wea_convu_in => ioi_wea_convu_in,
              ioi_addra_pu_in => ioi_addra_pu_in,
              ioi_addra_convu_in => ioi_addra_convu_in,
              padi_wea_pu_in => padi_wea_pu_in,
              padi_wea_convu_in => padi_wea_convu_in,
              padi_addra_pu_in => padi_addra_pu_in,
              padi_addra_convu_in => padi_addra_convu_in,
              ioi_wea_out => ioi_wea_out,
              ioi_addra_out => ioi_addra_out,
              padi_wea_out => padi_wea_out,
              padi_addra_out => padi_addra_out);

stimuli : process
    begin
        padding_en_in <= '0';
        convolve_en_in <= '0';
        ioi_wea_pu_in <= "0";
        ioi_wea_convu_in <= "0";
        ioi_addra_pu_in <= "0000011111";
        ioi_addra_convu_in <= "1111100000";
        padi_wea_pu_in <= "0";
        padi_wea_convu_in <= "0";
        padi_addra_pu_in <= "0000011111";
        padi_addra_convu_in <= "1111100000";
        wait for 10ns;
        padding_en_in <= '1';
        wait for 20ns;
        padding_en_in <= '0';
        convolve_en_in <= '1';
        wait for 40ns;
        padding_en_in <= '0';
        convolve_en_in <= '0';
        wait for 20ns;
        padding_en_in <= '1';
        convolve_en_in <= '1';
        wait;
    end process;
end Behavioral;
