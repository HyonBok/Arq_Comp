library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(   clk, reset, branch_en: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, wr_reg_en, mux_ula, pc_relativo, wr_ram_en, wr_en_flags_ffs : out std_logic;
            sel_op_ula, sel_mux_regs: out unsigned(1 downto 0);
            const: out unsigned(15 downto 0);
            estado: out unsigned(2 downto 0);
            new_address: out unsigned(6 downto 0)
    );
end entity;


architecture a_un_controle of un_controle is

    component state_machine is 
    port(   clk, reset : in std_logic;
            estado : out unsigned(2 downto 0)
    );
    end component;

    signal const_i, const_7bits, const_ram : unsigned(15 downto 0);
    signal estado_s : unsigned(2 downto 0);
    signal opcode : unsigned(3 downto 0);
    signal nop : std_logic;

begin
    maq_estado : state_machine port map(
        clk=>clk, reset=>reset, estado=>estado_s
    );
    
    -- 0000 0000 NOP
    -- BRANCH:
    -- 1111 JMP
    -- 1000 BNE
    -- ULA:
    -- 0000 ADD
    -- 0001 SUB
    -- 0010 AND
    -- 0011 OR
    -- 0100 ADDI
    -- 0101 SUBI
    -- 1100 LI
    -- CARGA:
    -- 0110 LOAD
    -- 0111 SAVE

    opcode <= instrucao(13 downto 10);

    nop <= '1' when instrucao(13 downto 6) = "00000000" else
           '0';

    pc_en <= '1' when estado_s = "100" else
                '0';

    fetch_en <= '1' when estado_s = "001" else
                '0';

    wr_en_flags_ffs <=  '1' when opcode = "1001" or opcode = "1011" else
                        '0';

    wr_reg_en <= '1' when ((estado_s = "010" and reset = '0' and branch_en = '0' and opcode /= "1001" and opcode /= "1011" and opcode(2 downto 1) /= "11" and opcode /= "1000" and opcode /= "1010") or (estado_s = "100" and opcode = "0110")) and nop = '0' else
                '0';

    wr_ram_en <= '1' when estado_s = "011" and opcode = "0111" and nop = '0' else
                '0';

    sel_op_ula <=  "00" when opcode = "0000" or opcode = "0100" or opcode = "0111" or opcode = "0110" or opcode = "1011" else -- Soma
                "01" when opcode = "0001" or opcode = "0101" or opcode = "1001" else -- Subtração
                "10" when opcode = "0010" else -- E lógico
                "11" when opcode = "0011" else -- Ou lógico
                "00";

    sel_mux_regs <= "11" when opcode = "0110" else
                    "01" when opcode = "1100" else
                    "00";

    mux_ula <= '1' when opcode(2) = '1' else
                '0';

    const_i(15) <= instrucao(6);
    const_i(2 downto 0) <= instrucao(2 downto 0);
    const_i(14 downto 3) <= "111111111111" when instrucao(6) = '1' else
                            "000000000000";

    const_7bits(15) <= instrucao(6);
    const_7bits(5 downto 0) <= instrucao(5 downto 0);
    const_7bits(14 downto 6) <= "111111111" when instrucao(6) = '1' else
                                "000000000";

    const_ram(15) <= instrucao(9);
    const_ram(2 downto 0) <= instrucao(8 downto 6);
    const_ram(14 downto 3) <= "111111111111" when instrucao(9) = '1' else
                              "000000000000";

    const <=    const_7bits when opcode(3) = '1' else 
                const_i when opcode(1) = '0' else
                const_ram;

    estado <= estado_s;

    pc_relativo <=  '0' when opcode(3 downto 2) = "11" else
                    '1';

    new_address <=  instrucao(6 downto 0);



end architecture;