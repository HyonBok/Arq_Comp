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

    signal pc_enable, pc_write, memory_read : std_logic;
    signal saida_pc, new_address : unsigned(6 downto 0);
    signal saida_rom : unsigned(13 downto 0);


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
        clk=>clk, rst=>reset, instrucao=>saida_rom, 
        pc_en=>pc_enable, jump_en=>pc_write, mem_read=>memory_read
    );

    new_address <= saida_rom(6 downto 0);
end architecture;

