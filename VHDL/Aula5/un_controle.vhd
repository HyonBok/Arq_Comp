library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(   clk, reset: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, wr_reg_en, mux_pc, mux_ula: out std_logic;
            sel_op_ula: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0);
            estado: out unsigned(1 downto 0)
    );
end entity;


architecture a_un_controle of un_controle is

    component state_machine is 
    port(   clk, reset : in std_logic;
            estado : out unsigned(1 downto 0)
    );
    end component;

    signal const_i, const_load : unsigned(15 downto 0);
    signal estado_s : unsigned(1 downto 0);
    signal opcode : unsigned(3 downto 0);
    signal nop : unsigned(7 downto 0);
    signal reset_mk : std_logic := '0';

begin
    maq_estado : state_machine port map(
        clk=>clk, reset=>reset_mk, estado=>estado_s
    );
    
    -- 0000 0000 NOP
    -- 1111 JMP
    -- ULA:
    -- 0000 ADD
    -- 0001 SUB
    -- 0010 AND
    -- 0011 OR
    -- 0100 ADDI
    -- 0101 SUBI
    -- CARGA:
    -- 1100 LOAD
    -- 1101 SAVE

    opcode <= instrucao(13 downto 10);

    nop <= instrucao(13 downto 6);

    pc_en <= '1' when estado_s = "00" else
                '0';

    fetch_en <= '1' when estado_s = "01" else
                '0';

    wr_reg_en <= '1' when estado_s = "10" and opcode /= "1111" else
                '0';
    
    -- Escolhe entre o endereço do jump (const) ou não
    mux_pc <= '1' when opcode = "1111" else
                '0';

    reset_mk <= --'1' when opcode = "1111" and estado_s="10" else --or nop = "00000000" else
                '0';

    sel_op_ula <=  "00" when opcode = "0000" or opcode = "0100" else -- Soma
                "01" when opcode = "0001" or opcode = "0101" else -- Subtração
                "10" when opcode = "0010" else -- E lógico
                "11" when opcode = "0011" else -- Ou lógico
                "00";

    mux_ula <= '1' when opcode(2) = '1' else
                '0';

    const_i(15) <= instrucao(3);
    const_i(2 downto 0) <= instrucao(2 downto 0);
    const_i(14 downto 3) <= "000000000000";

    const_load(15) <= instrucao(6);
    const_load(5 downto 0) <= instrucao(5 downto 0);
    const_load(14 downto 6) <= "000000000";

    const <=    const_i when opcode(3) = '0' else 
                const_load;

    estado <= estado_s;

end architecture;