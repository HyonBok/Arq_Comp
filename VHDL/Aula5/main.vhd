library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port(   clk, reset : in std_logic
    );
end entity;

architecture a_main of main is 
 
    component rom is
        port(   clk, mem_read  : in std_logic;
                endereco : in unsigned(6 downto 0);
                dado     : out unsigned(13 downto 0)    
        );
    end component;

    component pc is
        port(   clk, rst, wr_en, pc_en  : in std_logic;
                data_in  : in unsigned(6 downto 0);
                data_out : out unsigned(6 downto 0)
        );
    end component;

    component un_controle is 
        port(   clk, rst: in std_logic;
                instrucao : in unsigned(13 downto 0);
                pc_en, jump_en, mem_read: out std_logic
        );
    end component;

    component ula is 
        port(   a0, a1:  in  unsigned(15 downto 0); -- Entradas
                selec:  in  unsigned(1 downto 0);
                resultado:  out  unsigned(15 downto 0);
                z, n: out std_logic
        );
    end component;

    component banco_reg is 
        port(   clk, rst, wr_en : in std_logic;
                reg_wr, reg_r1, reg_r2  : in unsigned(4 downto 0);
                data_wr : in unsigned(15 downto 0);
                data_r1, data_r2 : out unsigned(15 downto 0)
        );
    end component;

    component reg14bits is 
        port(   clk, rst, wr_en : in std_logic;
                data_in : in unsigned(13 downto 0);
                data_out : out unsigned(13 downto 0)
        );
    end component;


    signal pc_enable, pc_write, memory_read, z, n : std_logic;
    signal saida_pc, new_address : unsigned(6 downto 0);
    signal saida_rom, saida_fetch : unsigned(13 downto 0);
    signal saida_banco1, saida_banco2, saida_ula : unsigned(15 downto 0);
    signal sel_operacao : unsigned(1 downto 0);

begin
    pc1 : pc port map(
        clk=>clk, rst=>reset, wr_en=>pc_write, pc_en=>pc_enable,
        data_in=>new_address, data_out=>saida_pc
    );   
    rom1 : rom port map(
        clk=>clk, endereco=>saida_pc, mem_read=>memory_read,
        dado=>saida_rom
    );
    controle : un_controle port map(
        clk=>clk, rst=>reset, instrucao=>saida_fetch,
        pc_en=>pc_enable, jump_en=>pc_write, mem_read=>memory_read
    );
    reg14: reg14bits port map(
        clk=>clk, rst=>reset, wr_en=>pc_enable,
        data_in=>saida_rom, data_out=>saida_fetch
    );
    ula1 : ula port map(
        a0=>saida_banco1, a1=>saida_banco2, 
        selec=>sel_operacao, resultado=>saida_ula, 
        z=>z, n=>n
    );
    banco : banco_reg port map(
        clk=>clk, rst=>reset, wr_en=>/**/,
        reg_wr=>saida_fetch(2 downto 0), 
        reg_r1=>saida_fetch(5 downto 3), reg_r2=>saida_fetch(8 downto 6),
        data_wr=>entrada_escrita, 
        data_r1=>saida_banco1, data_r2=>saida_banco2
    );

    new_address <= saida_fetch(6 downto 0);
end architecture;

