library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
   port( clk,reset: in std_logic;
         estado: out unsigned(1 downto 0)
   );
end entity;
architecture a_state_machine of state_machine is
   signal estado_s: unsigned(1 downto 0) := "00";
begin
   process(clk,reset)
   begin
      if reset='1' then
         estado_s <= "00";
      elsif rising_edge(clk) then
         if estado_s="11" then        -- se agora esta em 3
            estado_s <= "00";         -- o prox vai voltar ao zero
         else
            estado_s <= estado_s+1;   -- senao avanca
         end if;
      end if;
   end process;
   estado <= estado_s;
end architecture;