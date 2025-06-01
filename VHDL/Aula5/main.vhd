library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    port(   clk, reset : in std_logic
    );
end entity;

architecture a_main of main is 
 
    component rom is
        port(   clk  : in std_logic;
                endereco : in unsigned(6 downto 0);
                dado     : out unsigned(13 downto 0)    
        );
    end component;

    component pc is
        port(   clk, rst, pc_mux, pc_en  : in std_logic;
                data_in  : in unsigned(6 downto 0);
                data_out : out unsigned(6 downto 0)
        );
    end component;

    component un_controle is 
        port(   clk, rst: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, reg_en, mux_pc, mux_ula: out std_logic;
            sel_op_ula: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0)
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
                reg_wr, reg_r1, reg_r2  : in unsigned(2 downto 0);
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

    
    signal pc_en_s, fetch_en_s, reg_en_s, mux_pc_s, mux_ula_s, z, n : std_logic;
    signal saida_pc, new_address : unsigned(6 downto 0);
    signal saida_rom, saida_fetch : unsigned(13 downto 0);
    signal saida_banco1, saida_banco2, entrada_ula2, saida_ula, const_s : unsigned(15 downto 0);
    signal sel_reg1, sel_reg2, sel_reg_wr : unsigned(2 downto 0);
    signal sel_op_ula : unsigned(1 downto 0);
    signal clk_inv : std_logic;

begin
    pc1 : pc port map(
        clk=>clk, 
        rst=>reset, 
        pc_mux=>mux_pc_s, 
        pc_en=>pc_en_s,
        data_in=>new_address, 
        data_out=>saida_pc
    );   
    rom1 : rom port map(
        clk=>clk, 
        endereco=>saida_pc, 
        dado=>saida_rom
    );
    controle : un_controle port map(
        clk=>clk, 
        rst=>reset, 
        instrucao=>saida_fetch,
        pc_en=>pc_en_s, 
        fetch_en=>fetch_en_s, 
        reg_en=>reg_en_s,
        mux_pc=>mux_pc_s, 
        mux_ula=>mux_ula_s, 
        sel_op_ula=>sel_op_ula, 
        const=>const_s
    );
    fetch: reg14bits port map(
        clk=> clk_inv, rst=>reset, 
        wr_en=>fetch_en_s,
        data_in=>saida_rom, 
        data_out=>saida_fetch
    );
    ula1 : ula port map(
        a0=>saida_banco1, 
        a1=>entrada_ula2, 
        selec=>sel_op_ula, 
        resultado=>saida_ula, 
        z=>z, n=>n
    );
    banco : banco_reg port map(
        clk=>clk, 
        rst=>reset, 
        wr_en=>reg_en_s,
        reg_wr=>sel_reg_wr,
        reg_r1=>sel_reg1,
        reg_r2=>sel_reg2,
        data_wr=>saida_ula, 
        data_r1=>saida_banco1, 
        data_r2=>saida_banco2
    );

    clk_inv <= not clk;

    sel_reg_wr <= saida_fetch(9 downto 7);
    sel_reg1 <= saida_fetch(6 downto 4);
    sel_reg2 <= saida_fetch(3 downto 1);

    entrada_ula2 <= saida_banco2 when mux_ula_s = '0' else
                    const_s;

    new_address <= saida_fetch(6 downto 0);
end architecture;

