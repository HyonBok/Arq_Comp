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
        port(   clk, reset, jmp_en, pc_en, pc_relativo, branch_en : in std_logic;
                data_in  : in unsigned(6 downto 0);
                data_out : out unsigned(6 downto 0)
        );
    end component;

    component un_controle is 
        port(   clk, reset, branch_en: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, wr_reg_en, mux_ula, pc_relativo, wr_ram_en, sel_mux_regs, wr_en_flags_ffs : out std_logic;
            sel_op_ula: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0);
            estado: out unsigned(2 downto 0);
            new_address: out unsigned(6 downto 0)
    );  
    end component;

    component ula is
    port(   a0, a1, carry_flag:  in  unsigned(15 downto 0); -- Entradas
            selec:  in  unsigned(1 downto 0);
            resultado:  out  unsigned(15 downto 0);
            z, n, v, carry_subb: out std_logic
    );
    end component;

    component flip_flop is 
        port(   clk, reset, wr_en, data_in : in std_logic;
                data_out : out std_logic
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

    component ram is 
        port(   clk      : in std_logic;
                endereco : in unsigned(6 downto 0);
                wr_en    : in std_logic;
                dado_in  : in unsigned(15 downto 0);
                dado_out : out unsigned(15 downto 0) 
        );
    end component;

    
    signal pc_en_s, fetch_en_s, wr_reg_en, jmp_en_s, mux_ula_s, z_atual, z_saved, n, v_atual, v_saved, pc_relativo_s, branch_en_s, sel_mux_regs, wr_ram_en : std_logic;
    signal wr_en_flags, cf_atual, cf_saved : std_logic;
    signal saida_pc, new_address, entrada_ram : unsigned(6 downto 0);
    signal saida_rom, instrucao : unsigned(13 downto 0);
    signal reg1, reg2, entrada_ula2, saida_ula, entrada_data_wr, const_s, saida_ram: unsigned(15 downto 0);
    signal sel_reg1, sel_reg2, sel_reg_wr : unsigned(2 downto 0);
    signal sel_op_ula : unsigned(1 downto 0);

    signal estado: unsigned(2 downto 0);

begin
    pc1 : pc port map(
        clk=>clk, 
        reset=>reset, 
        jmp_en=>jmp_en_s, 
        pc_en=>pc_en_s,
        pc_relativo=>pc_relativo_s,
        data_in=>new_address, 
        data_out=>saida_pc,
        branch_en=>branch_en_s
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
        mux_ula=>mux_ula_s, 
        sel_op_ula=>sel_op_ula, 
        const=>const_s,
        estado=>estado,
        pc_relativo=>pc_relativo_s,
        new_address=>new_address,
        branch_en=>branch_en_s,
        wr_ram_en=>wr_ram_en,
        sel_mux_regs=>sel_mux_regs,
        wr_en_flags_ffs=>wr_en_flags
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
        carry_flag=>cf_saved,
        selec=>sel_op_ula, 
        resultado=>saida_ula, 
        z=>z_atual, 
        n=>n,
        v=>v_atual,
        carry_subb=>cf_atual
    );
    z_ff : flip_flop port map(
        clk=>clk,
        reset=>reset,
        data_in=>z_atual,
        data_out=>z_saved,
        wr_en=>wr_en_flags
    );
    v_ff : flip_flop port map(
        clk=>clk,
        reset=>reset,
        data_in=>v_atual,
        data_out=>v_saved,
        wr_en=>wr_en_flags
    );
    carry_flag_ff : flip_flop port map(
        clk=>clk,
        reset=>reset,
        data_in=>cf_atual,
        data_out=>cf_saved,
        wr_en=>wr_en_flags
    );
    banco : banco_reg port map(
        clk=>clk, 
        reset=>reset, 
        wr_en=>wr_reg_en,
        reg_wr=>sel_reg_wr,
        reg_r1=>sel_reg1,
        reg_r2=>sel_reg2,
        data_wr=>entrada_data_wr, 
        data_r1=>reg1, 
        data_r2=>reg2
    );
    ram1 : ram port map(
        clk=>clk,
        endereco=>entrada_ram,
        wr_en=>wr_ram_en,
        dado_in=>reg2,
        dado_out=>saida_ram
    );

    sel_reg_wr <= instrucao(9 downto 7) when sel_mux_regs = '0' else
                  instrucao(2 downto 0);
    sel_reg1 <= instrucao(5 downto 3);
    sel_reg2 <= instrucao(2 downto 0);

    entrada_data_wr <= saida_ula when sel_mux_regs = '0' else
                        saida_ram;

    entrada_ram <= saida_ula(6 downto 0);

    entrada_ula2 <= reg2 when mux_ula_s = '0' else
                    const_s;

    -- JMP
    jmp_en_s <= '1' when instrucao(13 downto 10) = "1111" else
                '0';

    -- BNE
    -- BL
    branch_en_s <= '1' when (instrucao(13 downto 10) = "1000" and z_saved = '0') or 
                            (instrucao(13 downto 10) = "1010" and v_saved = '0') else
                '0';

end architecture;

