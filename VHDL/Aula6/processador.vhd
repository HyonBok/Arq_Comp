library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(   clk, reset : in std_logic
    );
end entity;

architecture a_processador of processador is 
 
    component rom is
        port(   clk  : in std_logic;
                endereco : in unsigned(6 downto 0);
                dado     : out unsigned(13 downto 0)    
        );
    end component;

    component pc is
        port(   clk, reset, pc_mux, pc_en, pc_relativo, jmp_en : in std_logic;
                data_in  : in unsigned(6 downto 0);
                data_out : out unsigned(6 downto 0)
        );
    end component;

    component un_controle is 
        port(   clk, reset: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, wr_reg_en, mux_pc, mux_ula, pc_relativo: out std_logic;
            sel_op_ula: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0);
            estado: out unsigned(2 downto 0);
            new_address: out unsigned(6 downto 0)
    );  
    end component;

    component ula is 
        port(   a0, a1:  in  unsigned(15 downto 0); -- Entradas
                selec:  in  unsigned(1 downto 0);
                resultado:  out  unsigned(15 downto 0);
                z, n, dif_zero: out std_logic
        );
    end component;

    component banco_reg is 
        port(   clk, reset, wr_en : in std_logic;
                reg_wr, reg_r1, reg_r2  : in unsigned(2 downto 0);
                data_wr : in unsigned(15 downto 0);
                data_r1, data_r2 : out unsigned(15 downto 0)
        );
    end component;

    component reg14bits is 
        port(   clk, reset, wr_en : in std_logic;
                data_in : in unsigned(13 downto 0);
                data_out : out unsigned(13 downto 0)
        );
    end component;

    
    signal pc_en_s, fetch_en_s, wr_reg_en, mux_pc_s, mux_ula_s, z, n, pc_relativo_s, dif_zero_s, jmp_en_s : std_logic;
    signal saida_pc, new_address : unsigned(6 downto 0);
    signal saida_rom, instrucao : unsigned(13 downto 0);
    signal reg1, reg2, entrada_ula2, saida_ula, const_s : unsigned(15 downto 0);
    signal sel_reg1, sel_reg2, sel_reg_wr : unsigned(2 downto 0);
    signal sel_op_ula : unsigned(1 downto 0);

    signal estado: unsigned(2 downto 0);

begin
    pc1 : pc port map(
        clk=>clk, 
        reset=>reset, 
        pc_mux=>mux_pc_s, 
        pc_en=>pc_en_s,
        pc_relativo=>pc_relativo_s,
        data_in=>new_address, 
        data_out=>saida_pc,
        jmp_en=>jmp_en_s
    );   
    rom1 : rom port map(
        clk=>clk, 
        endereco=>saida_pc, 
        dado=>saida_rom
    );
    controle : un_controle port map(
        clk=>clk, 
        reset=>reset, 
        instrucao=>instrucao,
        pc_en=>pc_en_s, 
        fetch_en=>fetch_en_s, 
        wr_reg_en=>wr_reg_en,
        mux_pc=>mux_pc_s, 
        mux_ula=>mux_ula_s, 
        sel_op_ula=>sel_op_ula, 
        const=>const_s,
        estado=>estado,
        pc_relativo=>pc_relativo_s,
        new_address=>new_address
    );
    fetch: reg14bits port map(
        clk=> clk, reset=>reset, 
        wr_en=>fetch_en_s,
        data_in=>saida_rom, 
        data_out=>instrucao
    );
    ula1 : ula port map(
        a0=>reg1, 
        a1=>entrada_ula2, 
        selec=>sel_op_ula, 
        resultado=>saida_ula, 
        z=>z, 
        n=>n,
        dif_zero=>dif_zero_s
    );
    banco : banco_reg port map(
        clk=>clk, 
        reset=>reset, 
        wr_en=>wr_reg_en,
        reg_wr=>sel_reg_wr,
        reg_r1=>sel_reg1,
        reg_r2=>sel_reg2,
        data_wr=>saida_ula, 
        data_r1=>reg1, 
        data_r2=>reg2
    );

    sel_reg_wr <= instrucao(9 downto 7);
    sel_reg1 <= instrucao(6 downto 4);
    sel_reg2 <= instrucao(3 downto 1);

    entrada_ula2 <= reg2 when mux_ula_s = '0' else
                    const_s;

    jmp_en_s <= '1' when mux_pc_s = '1' and dif_zero_s = '1' else
                '0';

end architecture;

