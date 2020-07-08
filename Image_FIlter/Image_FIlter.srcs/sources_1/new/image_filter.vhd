----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2020 11:12:09 AM
-- Design Name: 
-- Module Name: image_filter - Behavioral
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

entity image_filter is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           start_in : in STD_LOGIC;
           --wea_to_ioi : inout STD_LOGIC_VECTOR(0 DOWNTO 0);
           --dina_to_ioi : inout STD_LOGIC_VECTOR(7 DOWNTO 0);
           --addra_to_ioi : inout STD_LOGIC_VECTOR (9 DOWNTO 0);
           finished_out : out STD_LOGIC );
end image_filter;

architecture Behavioral of image_filter is

component input_output_ram is
    Port ( clka : IN STD_LOGIC;
           wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
           dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
           douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component padded_image_ram is
  port (clka : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        clkb : IN STD_LOGIC;
        web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        dinb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component padding_unit is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           start_in : in STD_LOGIC;
           finished_out : out STD_LOGIC;
           ioi_wea_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           ioi_addra_out : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           ioi_douta_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           padi_wea_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           padi_addra_out : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           padi_dina_out : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           padi_web_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);
           padi_addrb_out : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           padi_dinb_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)
           );
end component;

component Convolution is
    
    Generic (addr_bit_size : INTEGER := 9;   -- image has less than 1024 pixels.
             data_bit_size : INTEGER := 7;   -- value range of a pixel (0-255) 
             total_bit_size : INTEGER :=11); -- addition of 9 pixel values (0-2295)             
    
    Port ( data_a_in : in STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);       -- data in bus from the padded image ram.
           data_a_out : out STD_LOGIC_VECTOR(data_bit_size DOWNTO 0);     -- data out bus to final output image ram.
           clk  : in STD_LOGIC;                                           -- clock
           read_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0);  -- address bus to the padded image ram (to read a pixel value).  
           write_addr_out : out STD_LOGIC_VECTOR(addr_bit_size DOWNTO 0); -- address bus to the final output image ram (to write a pixel value). 
           write_en_a_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- enable pin to the output ram (will be 1 when data_a_out is ready). 
           write_en_p_out : out STD_LOGIC_VECTOR(0 DOWNTO 0);             -- enable pin to the padded image ram.
           paddone_in : in STD_LOGIC;                                     -- signal notifying the padding is done.
           convdone_out : out STD_LOGIC;                             -- signal notifying the concolution is done.
           reset_in :in STD_LOGIC );                                 -- reset signal  
end component;

component control_unit is
    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           padding_done_in : in STD_LOGIC;
           convolve_done_in : in STD_LOGIC;
           start_op_in : in STD_LOGIC;
           finished_op_out : out STD_LOGIC;
           enable_mux_padding_out : out STD_LOGIC;
           enable_mux_convolve_out : out STD_LOGIC;
           start_padding_out : out STD_LOGIC;
           start_convolve_out : out STD_LOGIC);
end component;

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

signal start_padding_cu_to_pu : STD_LOGIC;
signal start_convolve_cu_to_convu : STD_LOGIC;
signal finished_pu_to_cu : STD_LOGIC;
signal finished_convu_to_cu : STD_LOGIC;
signal enable_mux_padding_cu_to_mux : STD_LOGIC;
signal enable_mux_convolve_cu_to_mux : STD_LOGIC;
signal wea_to_ioi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_ioi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dina_to_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_ioi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal wea_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addra_to_padi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dina_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal douta_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal web_to_padi : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal addrb_to_padi : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal dinb_to_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal doutb_from_padi : STD_LOGIC_VECTOR (7 DOWNTO 0);
signal ioi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_pu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal ioi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal ioi_addra_convu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal padi_wea_pu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_pu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);
signal padi_wea_convu_to_mux : STD_LOGIC_VECTOR (0 DOWNTO 0);
signal padi_addra_convu_to_mux : STD_LOGIC_VECTOR (9 DOWNTO 0);

begin

input_output_ram_1_ioi : input_output_ram
    port map (clka => clk,
              wea => wea_to_ioi,
              addra => addra_to_ioi,
              dina => dina_to_ioi,
              douta => douta_from_ioi);

padded_image_ram_1_padi : padded_image_ram
  port map (clka => clk,
            wea => wea_to_padi,
            addra => addra_to_padi,
            dina => dina_to_padi,
            douta => douta_from_padi,
            clkb => clk,
            web => web_to_padi,
            addrb => addrb_to_padi,
            dinb => dinb_to_padi,
            doutb => doutb_from_padi);

padding_unit_1_pu : padding_unit
    port map (clk => clk,
              rst_n => rst_n,
              start_in =>  start_padding_cu_to_pu,
              finished_out => finished_pu_to_cu,
              ioi_wea_out => ioi_wea_pu_to_mux,
              ioi_addra_out => ioi_addra_pu_to_mux,
              ioi_douta_in => douta_from_ioi,
              padi_wea_out => padi_wea_pu_to_mux,
              padi_addra_out => padi_addra_pu_to_mux,
              padi_dina_out => dina_to_padi,
              padi_web_out => web_to_padi,
              padi_addrb_out => addrb_to_padi,
              padi_dinb_out => dinb_to_padi);

convolution_unit_1_convu : Convolution
    port map(data_a_in => douta_from_padi,
             clk => clk,
             reset_in => rst_n,
             paddone_in => start_convolve_cu_to_convu,
             data_a_out => dina_to_ioi,
             write_en_a_out => ioi_wea_convu_to_mux,
             write_en_p_out => padi_wea_convu_to_mux,
             read_addr_out => padi_addra_convu_to_mux,
             write_addr_out => ioi_addra_convu_to_mux,
             convdone_out => finished_convu_to_cu);

control_unit_1_cu : control_unit
    port map(clk => clk,
             rst_n => rst_n,
             padding_done_in => finished_pu_to_cu,
             convolve_done_in => finished_convu_to_cu,
             start_op_in => start_in,
             finished_op_out => finished_out,
             enable_mux_padding_out => enable_mux_padding_cu_to_mux,
             enable_mux_convolve_out => enable_mux_convolve_cu_to_mux,
             start_padding_out => start_padding_cu_to_pu,
             start_convolve_out => start_convolve_cu_to_convu);

ram_input_mux_1 : ram_input_mux
    port map (padding_en_in => enable_mux_padding_cu_to_mux,
              convolve_en_in => enable_mux_convolve_cu_to_mux,
              ioi_wea_pu_in => ioi_wea_pu_to_mux,
              ioi_wea_convu_in => ioi_wea_convu_to_mux,
              ioi_addra_pu_in => ioi_addra_pu_to_mux,
              ioi_addra_convu_in => ioi_addra_convu_to_mux,
              padi_wea_pu_in => padi_wea_pu_to_mux,
              padi_wea_convu_in => padi_wea_convu_to_mux,
              padi_addra_pu_in => padi_addra_pu_to_mux,
              padi_addra_convu_in => padi_addra_convu_to_mux,
              ioi_wea_out => wea_to_ioi,
              ioi_addra_out => addra_to_ioi,
              padi_wea_out => wea_to_padi,
              padi_addra_out => addra_to_padi);

end Behavioral;
