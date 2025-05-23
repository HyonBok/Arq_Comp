library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main_tb is
end;

architecture a_main_tb of main_tb is
    component main
        port(   clk, reset, wr_en, sel_write : in std_logic;
                reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
                sel_operacao:  in  unsigned(1 downto 0);
                data_wr : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0);
                z, n : out std_logic

                
        );
    end component;

    signal data_wr, data_out : unsigned(15 downto 0);
    signal clk, reset, wr_en , z, n, sel_write : std_logic;
    signal reg_r1, reg_r2, reg_wr : unsigned(4 downto 0);
    signal sel_operacao : unsigned(1 downto 0);
    
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';

begin
    uut: main port map(
        clk => clk,
        reset => reset,
        wr_en => wr_en,
        data_wr => data_wr,
        reg_wr => reg_wr,
        reg_r1 => reg_r1,
        reg_r2 => reg_r2,
        sel_write => sel_write,
        sel_operacao => sel_operacao,
        data_out => data_out,
        z => z,
        n => n
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

    process                     
    begin
        --escreve 7 no R1 
        wait for 200 ns;
        wr_en <= '1';
        reset <= '0';
        sel_operacao <= "00";   --define como soma
        sel_write <= '0';       --entrada do banco definida como data_wr
        reg_wr <= "00001";      --registrador a escrever R1
        reg_r1 <= "00001";
        reg_r2 <= "00010";
        data_wr <= "0000000000000111"; 
        
        --escreve 3 no R2
        wait for 100 ns;
        wr_en <= '1';
        reset <= '0';
        sel_operacao <= "00";   
        sel_write <= '0';       --entrada do banco definida como data_wr
        reg_wr <= "00010";      --registrador a escrever
        reg_r1 <= "00001";
        reg_r2 <= "00010";
        data_wr <= "0000000000000011";

        --escrever a soma de 7 + 3 no R3
        wait for 100 ns;
        wr_en <= '1';
        reset <= '0';
        sel_operacao <= "00";   --define como soma
        sel_write <= '1';       --entrada do banco definida como ula
        reg_wr <= "00011";      --registrador a escrever R3
        reg_r1 <= "00001";
        reg_r2 <= "00010";
        data_wr <= "0000000000000111";

        --soma na ula oque tem no R1 mais R3
        wait for 100 ns;
        wr_en <= '0';           --desabilita a escrita
        reset <= '0';
        sel_operacao <= "00";   --define como soma
        sel_write <= '0';       
        reg_wr <= "00001";      
        reg_r1 <= "00001";      --entrada 1 da ula R1
        reg_r2 <= "00011";      --entrada 2 da ula R3
        data_wr <= "0000000000000111";

        --reseta o banco
        wait for 100 ns;
        wr_en <= '0';           --desabilita a escrita
        reset <= '1';           
        sel_operacao <= "00";   --define como soma
        sel_write <= '0';       
        reg_wr <= "00001";      
        reg_r1 <= "00001";
        reg_r2 <= "00011";
        data_wr <= "0000000000000111";

        wait;                
    end process;
end architecture a_main_tb;

