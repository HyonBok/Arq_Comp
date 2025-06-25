library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is 
    port(   clk, reset, branch_en: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, fetch_en, wr_reg_en, mux_ula, pc_relativo, wr_ram_en, wr_en_flags_ffs, exception : out std_logic;
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
    signal exc : std_logic;

begin
    maq_estado : state_machine port map(
        clk=>clk, reset=>reset, estado=>estado_s
    );

    opcode <= instrucao(13 downto 10);

    nop <= '1' when instrucao(13 downto 6) = "00000000" else
           '0';

    -- Execeção
    exc <= '1' when   instrucao(13 downto 10) = "1011" or 
                            instrucao(13 downto 10) = "1101" or 
                            instrucao(13 downto 10) = "1110" else
                '0';

    exception <= exc;

    -- Estado 4 - PC (Ultimo estado)
    pc_en <= '1' when estado_s = "100" and exc = '0' else
                '0';

    -- Estado 1 - Fetch (Estado 0 é descartado para garantia de integridade)
    fetch_en <= '1' when estado_s = "001" else
                '0';

    -- Ativa os flip-flops de escrita de flags da ula caso seja uma conta
    wr_en_flags_ffs <=  '1' when opcode = "1001" or opcode="0000" else
                        '0';

    -- Estado 2 - Banco de Registradores
    -- Não é ativado caso seja uma instrução de salto (1111 - JMP, 1000 - BNE, 1010 - BVC), CMPR ou escrita na RAM (0111 - SW) e obviamente, caso seja NOP (0000_0000)
    -- Tem a exceção no LW, para carregar constante da RAM no banco
    wr_reg_en <= '1' when ((estado_s = "010" and reset = '0' and branch_en = '0' and opcode /= "1001"  and opcode(2 downto 1) /= "11" and opcode /= "1000" and opcode /= "1010") or (estado_s = "100" and opcode = "0110")) and nop = '0' and exc = '0' else
                '0';

    -- Estado 3 - RAM (Faz a escrita caso seja um SW - 0111)
    wr_ram_en <= '1' when estado_s = "011" and opcode = "0111" and nop = '0' and exc = '0' else
                '0';

    -- Seleciona operaçao da ULA
    -- Soma: 0000 (ADD), 0100 (ADDI), 0111 (SW), 0110 (LW)
    -- Subtração: 0000 (SUB), 0101 (SUBI), 1001 (CMPR)
    -- E lógico: 0010 (AND)
    -- Ou lógico: 0011 (OR)
    sel_op_ula <=  "00" when opcode = "0000" or opcode = "0100" or opcode = "0111" or opcode = "0110"  else -- Soma
                "01" when opcode = "0001" or opcode = "0101" or opcode = "1001" else -- Subtração
                "10" when opcode = "0010" else -- E lógico
                "11" when opcode = "0011" else -- Ou lógico
                "00";

    sel_mux_regs <= "11" when opcode = "0110" else
                    "01" when opcode = "1100" else
                    "00";

    -- Mux para a entrada da ULA (constante ou registrador)
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

    -- Opcode constante de 7 bits - casos: 1111 (JMP), 1000 (BNE), 1010 (BL), 1100 (LI)
    -- Opcode constante de 4 bits - casos: 0100 (ADDI), 0101 (SUBI)
    -- Opcode constante de 15 bits - casos: 0110 (LW), 0111 (SW)
    -- Os outros casos seriam descartados, pois as constantes não seriam utilizadas.
    const <=    const_7bits when opcode(3) = '1' else 
                const_i when opcode(1) = '0' else
                const_ram;

    estado <= estado_s;

    -- PC relativo em caso de BNE ou BVC
    pc_relativo <=  '0' when opcode(3 downto 2) = "11" else
                    '1';

    -- Novo endereço do PC em caso de JMP
    new_address <=  instrucao(6 downto 0);


end architecture;