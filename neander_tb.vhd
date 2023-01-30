
library ieee;                 
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity neander is
end neander;

architecture behavior of neander is
    component projeto is
        port(
	
        clock: in std_logic;
        reset: in std_logic;
        count_load: in std_logic;
        en_ULA: in std_logic;

        Z: out std_logic;
        N: out std_logic;
        decoder: out std_logic_vector(3 downto 0);
        );
    end component;
    
    signal clock, reset, count_load, en_ULA, Z, N : std_logic;
    signal decoder : std_logic_vector(3 downto 0);

    begin

	DUT : entity work.neander port map (clock => clock, reset => reset, count_load => count_load, en_ULA => en_ULA);
	
			
	-- clock continuo
	
	process 
    begin
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;
    end process;
    
    reset	<=	'0', '1' after 10 ns;
	
end architecture;