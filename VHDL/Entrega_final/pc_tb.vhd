library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is 
end;

architecture a_pc_tb of pc_tb is 
    component pc 
        port(   clk, rst, wr_en : in std_logic;
            data_out : out unsigned(6 downto 0)
    );
    end component;

    signal clk, rst : std_logic;
    signal wr_en : std_logic := '1';
    signal data_out : unsigned(6 downto 0);

    constant period_time : time      := 3 ns;
    signal   finished    : std_logic := '0';

begin 
    uut : pc port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        data_out => data_out
    );
    
    sim_time_proc: process
    begin
        wait for 10 us;         
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

    process 
    begin
        wait for 600 ns;
        wr_en <= '0';
        end process;
end architecture;
