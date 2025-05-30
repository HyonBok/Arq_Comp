library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

/*
reg_wr_en
sel_mux_regs
sel_op_ULA
sel_mux_ULA
*/
entity un_controle is 
    port(   clk, rst: in std_logic;
            instrucao : in unsigned(13 downto 0);
            pc_en, jump_en, mem_read: out std_logic
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
        clk=>clk, rst=>rst, estado_s=>estado
    );

    opcode <= instrucao(13 downto 10);

    pc_en <= '1' when estado_s='1' else
                '0';
            
    mem_read <= '1' when estado_s='0' else
                '0';

    jump_en <=  '1' when opcode="1111" else
                '0';

end architecture;