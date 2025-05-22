library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_reg_tb is
end;

architecture a_banco_reg_tb of banco_reg_tb is
    component banco_reg
        port(   clk, rst, wr_en : in std_logic;
                reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
                data_wr : in unsigned(15 downto 0);
                data_r1, data_r2 : out unsigned(15 downto 0)
        );
    end component;

    signal data_wr, data_r1, data_r2 : unsigned(15 downto 0);
    signal clk, reset, wr_en : std_logic;
    signal reg_r1, reg_r2, reg_wr : unsigned(4 downto 0);
    
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';

begin
    uut: banco_reg port map(
        clk => clk,
        rst => reset,
        wr_en => wr_en,
        data_wr => data_wr,
        data_r1 => data_r1,
        data_r2 => data_r2,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
        reg_r2 => reg_r2

    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2; -- espera 2 clocks, pra garantir
        reset <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;

    process                      -- sinais dos casos de teste (p.ex.)
    begin
        wait for 200 ns;
        wr_en <= '1';
        data_wr <= "0000000000000111";
        reg_wr <= "00001";
        reg_r1 <= "00000";
        reg_r2 <= "00000";
        wait for 100 ns;
        wr_en <= '1';
        data_wr <= "0000000000000111";
        reg_wr <= "00001";
        reg_r1 <= "00001";
        reg_r2 <= "00010";
        wait for 100 ns;
        wr_en <= '1';
        data_wr <= "0000000000000111";
        reg_wr <= "00010";
        reg_r1 <= "00001";
        reg_r2 <= "00010";

        wait;                
    end process;
end architecture a_banco_reg_tb;

