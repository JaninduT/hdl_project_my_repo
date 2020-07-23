----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2020 06:05:14 PM
-- Design Name: 
-- Module Name: uart_receive - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity uart_comm_unit is
    Generic (mem_addr_size_g : integer := 10;
             pixel_data_size_g : integer := 8);

    Port ( clk : in STD_LOGIC;
           rst_n : in STD_LOGIC;
           start_op_in : in STD_LOGIC;
           finished_op_out : out STD_LOGIC;
           send_rec_select_in : in STD_LOGIC;
           ioi_addra_out : out STD_LOGIC_VECTOR (mem_addr_size_g -1 downto 0);
           ioi_dina_out : out STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_douta_in : in STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
           ioi_wea_out : out STD_LOGIC_VECTOR (0 downto 0);
           uart_interrupt_in : in STD_LOGIC;
           uart_s_axi_awaddr_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_awvalid_out : out STD_LOGIC;
           uart_s_axi_awready_in : in STD_LOGIC;
           uart_s_axi_wdata_out : out STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_wstrb_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_wvalid_out : out STD_LOGIC;
           uart_s_axi_wready_in : in STD_LOGIC;
           uart_s_axi_bresp_in : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_bvalid_in : in STD_LOGIC;
           uart_s_axi_bready_out : out STD_LOGIC;
           uart_s_axi_araddr_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           uart_s_axi_arvalid_out : out STD_LOGIC;
           uart_s_axi_arready_in : in STD_LOGIC;
           uart_s_axi_rdata_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
           uart_s_axi_rresp_in : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           uart_s_axi_rvalid_in : in STD_LOGIC;
           uart_s_axi_rready_out : out STD_LOGIC);
end uart_comm_unit;

architecture Behavioral of uart_comm_unit is

type main_state is (Idle, Set_CTRL_Reg, Fetching, Sending, Receiving, Storing, Incrementing_Send, Incrementing_Rec, Done);
signal comm_state : main_state;
type axi_state is (Set_Rx_Write_Up, Wait_Rx_Ready, Set_Tx_Write_Down,
                   Set_Write_Resp_Up, Set_Write_Resp_Down, Wait_Tx_Done,
                   Set_CR_Write_Up, Wait_CR_Ready, Set_CR_Write_Down,
                   Set_CR_Normal, Get_Rx_Data, Set_Read_Ready_High,
                   Set_Read_Ready_Low, Wait_Rx_Done, Interrupt_wait,
                   Set_Tx_Write_Up, Wait_Tx_Ready);
signal axi_rx_sub_state : axi_state;
signal axi_tx_sub_state : axi_state;
signal axi_set_cr_sub_state : axi_state;
signal pix_data : STD_LOGIC_VECTOR (pixel_data_size_g -1 downto 0);
signal rec_op : STD_LOGIC;

begin

    process (clk, rst_n)
        constant mem_size : integer := 625;
        constant base_val : integer := 0;
        constant write_wait_delay : integer := 3;
        constant fetch_wait_delay : integer := 3;
        variable mem_addra : integer := 0;
        variable write_wait : integer := 0;
        variable fetch_wait : integer := 0;
        variable clear_rx_tx : STD_LOGIC := '1';
        begin
            if (rst_n = '0') then
                comm_state <= Idle;
                pix_data <= std_logic_vector(to_unsigned(base_val, pix_data 'length));
                mem_addra := 0;
                ioi_wea_out <= "0";
                write_wait := 0;
                clear_rx_tx := '1';
                finished_op_out <= '0';
                rec_op <= '0';
            elsif (clk 'event and clk = '1') then
                case comm_state is
                    when Idle =>
                        ioi_wea_out <= "0";
                        finished_op_out <= '0';
                        pix_data <= std_logic_vector(to_unsigned(base_val, pix_data 'length));
                        if (start_op_in = '1') then
                            if (send_rec_select_in = '1') then
                                rec_op <= '1';
                            else
                                rec_op <= '0';
                            end if;
                            comm_state <= Set_CTRL_Reg;
                            axi_set_cr_sub_state <= Set_CR_Write_Up;
                            clear_rx_tx := '1';
                        end if;
                    when Set_CTRL_Reg =>
                        case axi_set_cr_sub_state is
                            when Set_CR_Write_Up =>
                                uart_s_axi_awaddr_out <= "1100";
                                uart_s_axi_wstrb_out <= "0001";
                                if (clear_rx_tx = '1') then
                                    uart_s_axi_wdata_out <= "00000000000000000000000000010011";
                                else
                                    uart_s_axi_wdata_out <= "00000000000000000000000000010000";
                                end if;
                                uart_s_axi_awvalid_out <= '1';
                                uart_s_axi_wvalid_out <= '1';
                                axi_set_cr_sub_state <= Wait_CR_Ready;
                            when Wait_CR_Ready =>
                                if (uart_s_axi_awready_in = '1' and uart_s_axi_wready_in = '1') then
                                    axi_set_cr_sub_state <= Set_CR_Write_Down;
                                end if;
                            when Set_CR_Write_Down =>
                                uart_s_axi_awvalid_out <= '0';
                                uart_s_axi_wvalid_out <= '0';
                                axi_set_cr_sub_state <= Set_Write_Resp_Up;
                            when Set_Write_Resp_Up =>
                                if (uart_s_axi_bvalid_in = '1') then
                                    uart_s_axi_bready_out <= '1';
                                    axi_set_cr_sub_state <= Set_Write_Resp_Down;
                                end if;
                            when Set_Write_Resp_Down =>
                                uart_s_axi_bready_out <= '0';
                                axi_set_cr_sub_state <= Set_CR_Normal;
                            when Set_CR_Normal =>
                                if (clear_rx_tx = '1') then
                                    clear_rx_tx := '0';
                                    axi_set_cr_sub_state <= Set_CR_Write_Up;
                                else
                                    if (rec_op = '1') then
                                        comm_state <= Receiving;
                                        axi_rx_sub_state <= Interrupt_wait;
                                    else
                                        comm_state <= Fetching;
                                    end if;
                                end if;
                            when others =>
                                null;
                        end case;
                    when Receiving =>
                        case axi_rx_sub_state is
                            when Interrupt_wait =>
                                if(uart_interrupt_in = '1') then
                                    axi_rx_sub_state <= Set_Rx_Write_Up;
                                end if;
                            when Set_Rx_Write_Up =>
                                uart_s_axi_araddr_out <= "0000";
                                uart_s_axi_arvalid_out <= '1';
                                axi_rx_sub_state <= Wait_Rx_Ready;
                            when Wait_Rx_Ready =>
                                if (uart_s_axi_arready_in = '1') then
                                    axi_rx_sub_state <= Get_Rx_Data;
                                end if;
                            when Get_Rx_Data =>
                                uart_s_axi_arvalid_out <= '0';
                                axi_rx_sub_state <= Set_Read_Ready_High;
                            when Set_Read_Ready_High =>
                                uart_s_axi_rready_out<='1';
                                if (uart_s_axi_rvalid_in = '1') then
                                    pix_data <= std_logic_vector(resize(unsigned(uart_s_axi_rdata_in), ioi_dina_out 'length));
                                    axi_rx_sub_state <= Set_Read_Ready_Low;
                                end if;
                            when Set_Read_Ready_Low =>
                                uart_s_axi_rready_out <= '0';
                                axi_rx_sub_state <= Interrupt_wait;
                                comm_state <= Storing;
                            when others =>
                                null;
                        end case;
                    when Storing =>
                        if (write_wait = 0) then
                            ioi_addra_out <= std_logic_vector(to_unsigned(mem_addra, ioi_addra_out 'length));
                            ioi_dina_out <= pix_data;
                            ioi_wea_out <= "1";
                            write_wait := 1;
                        elsif (write_wait = write_wait_delay) then
                            ioi_wea_out <= "0";
                            write_wait := 0;
                            comm_state <= Incrementing_Rec;
                        else
                            write_wait := write_wait + 1;
                        end if;
                    when Fetching =>
                        if (fetch_wait = 0) then
                            ioi_wea_out <= "0";
                            ioi_addra_out <= std_logic_vector(to_unsigned(mem_addra, ioi_addra_out 'length));
                            fetch_wait := 1;
                        elsif (fetch_wait = fetch_wait_delay) then
                            pix_data <= ioi_douta_in;
                            fetch_wait := 0;
                            comm_state <= Sending;
                            axi_tx_sub_state <= Set_Tx_Write_Up;
                        else
                            fetch_wait := fetch_wait + 1;
                        end if;
                    when Sending =>
                        case axi_tx_sub_state is
                            when Set_Tx_Write_Up =>
                                uart_s_axi_awaddr_out <= "0100";
                                uart_s_axi_wdata_out <= std_logic_vector(resize(unsigned(pix_data), uart_s_axi_wdata_out 'length));
                                uart_s_axi_awvalid_out <= '1';
                                uart_s_axi_wvalid_out <= '1';
                                axi_tx_sub_state <= Wait_Tx_Ready;
                            when Wait_Tx_Ready =>
                                if (uart_s_axi_awready_in = '1' and uart_s_axi_wready_in = '1') then
                                    axi_tx_sub_state <= Set_Tx_Write_Down;
                                end if;
                            when Set_Tx_Write_Down =>
                                uart_s_axi_awvalid_out <= '0';
                                uart_s_axi_wvalid_out <= '0';
                                axi_tx_sub_state <= Set_Write_Resp_Up;
                            when Set_Write_Resp_Up =>
                                if (uart_s_axi_bvalid_in = '1') then
                                    uart_s_axi_bready_out <= '1';
                                    axi_tx_sub_state <= Set_Write_Resp_Down;
                                end if;
                            when Set_Write_Resp_Down =>
                                uart_s_axi_bready_out <= '0';
                                axi_tx_sub_state <= Wait_Tx_Done;
                            when Wait_Tx_Done =>
                                if (uart_interrupt_in = '1') then
                                    axi_tx_sub_state <= Set_Tx_Write_Up;
                                    comm_state <= Incrementing_Send;
                                end if;
                            when others =>
                                null;
                        end case;
                    when Incrementing_Rec =>
                        ioi_wea_out <= "0";
                        if (mem_addra = mem_size-1) then
                            comm_state <= Done;
                        else
                            mem_addra := mem_addra + 1;
                            comm_state <= Receiving;
                        end if;
                    when Incrementing_Send =>
                        if (mem_addra = mem_size-1) then
                            comm_state <= Done;
                        else
                            mem_addra := mem_addra + 1;
                            comm_state <= Fetching;
                        end if;
                    when Done =>
                        mem_addra := 0;
                        write_wait := 0;
                        fetch_wait := 0;
                        pix_data <= std_logic_vector(to_unsigned(base_val, pix_data 'length));
                        comm_state <= Idle;
                        finished_op_out <= '1';
                    when others =>
                        null;
                end case;
            end if;
        end process;
end Behavioral;

