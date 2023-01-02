----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2022/2023
-- Project Labyrinth
--
-- Program Counter.
--
-- authors:
-- Stefan Nikolovski IN 6/2021
-- Mirjana Todorovic IN 57/2021
-- Milica Radojevic 	IN 31/2021
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity cnt is
	port(
		iCLK  : in  std_logic;
		inRST : in  std_logic;
		iD    : in  std_logic_vector(15 downto 0);
		iLOAD : in  std_logic;
		oQ    : out std_logic_vector(15 downto 0)
	);
end entity cnt;

architecture arch of cnt is

	signal sCNT : std_logic_vector(15 downto 0);

begin

	process(iCLK, inRST)
	begin
		if inRST = '0' then
			sCNT <= (others => '0');
		elsif rising_edge(iCLK) then
			if iLOAD = '1' then
				sCNT <= iD;
			else
				sCNT <= sCNT + 1;
			end if;
		end if;
	end process;
	
	oQ <= sCNT;

end architecture;
