library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is 
end;

architecture a_main_tb of main_tb is 
    component main 
        port(   clk, reset : in std_logic
    );
    end component;

    signal clk, reset : std_logic;
    signal data_out : unsigned(13 downto 0);

    constant period_time : time      := 50 ns;
    signal   finished    : std_logic := '0';

begin 
    uut : main port map (
        clk => clk,
        reset => reset
    );
    
    reset_global: process
    begin
        reset <= '1';
        wait for period_time*2;
        reset <= '0';
        wait;
    end process;


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

end architecture;
