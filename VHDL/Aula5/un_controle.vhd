library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(   clk, rst: in std_logic;
            instrucao : in unsigned(13 downto 0);
            sel_mux_pc, fetch_en, reg_wr_en, instr_beq, sel_mux_ula: out std_logic;
            sel_op_ula: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0)
    );
end entity;


architecture a_un_controle of un_controle is

    component state_machine is 
    port(   clk, rst : in std_logic;
            estado : out unsigned(1 downto 0)
    );
    end component;

    signal estado_s : unsigned(1 downto 0);
    signal opcode : unsigned(3 downto 0);

begin
    maq_estado : state_machine port map(
        clk=>clk, rst=>rst, estado=>estado_s
    );

    opcode <= instrucao(13 downto 10);

    sel_mux_pc <= '1' when estado_s = "00" else
                '0';

    fetch_en <= '1' when estado_s = "01" else
                '0';

    reg_wr_en <= '1' when estado_s = "10" else
                '0';
                
    instr_beq <=  '1' when opcode = "1111" else
                '0';

    sel_op_ula <=  "00" when opcode = "0001" or opcode = "1001" else -- Soma
                "01" when opcode = "0010" or opcode = "1010" else -- Subtração
                "10" when opcode = "0011" else -- E lógico
                "11" when opcode = "0100" else -- Ou lógico
                "00";

    sel_mux_ula <= '1' when opcode(3) = '1' else
                '0';

    const(15) <= instrucao(6);
    const(5 downto 0) <= instrucao(5 downto 0);
    const(14 downto 6) <= "000000000";

end architecture;