library IEEE;
use IEEE.std_logic_1164.all;
use numeric_std;

entity soma_e_subtrai_tb is
end;

architecture a_soma_e_subtrai_tb of soma_e_subtrai is
    component soma_e_subtrai
        port map (   
            x,y       :  in  unsigned(7 downto 0);
            soma,subt :  out unsigned(7 downto 0)
        );
    end component;

    signal x,y,soma,subt: unsigned (7 downto 0);

begin
    uut: soma_e_subtrai port map(
        x => x,
        y => y,
        soma => soma,
        subt => subt,
    )