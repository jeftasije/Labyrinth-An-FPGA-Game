-------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2022/2023
-- Project Labyrinth
--
-- Data RAM
--
-- authors:
-- Stefan Nikolovski IN 6/2021
-- Mirjana Todorovic IN 57/2021
-- Milica Radojevic 	IN 31/2021
-------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity data_ram is
	port(
		iCLK  : in  std_logic;
		inRST : in  std_logic;
		iA    : in  std_logic_vector(7 downto 0);
		iD    : in  std_logic_vector(15 downto 0);
		iWE   : in  std_logic;
		oQ    : out std_logic_vector(15 downto 0)
	);
end entity data_ram;

architecture Behavioral of data_ram is

	type tMEM is array(0 to 255) of std_logic_vector(15 downto 0);
	signal rMEM : tMEM;
	signal sMEM : tMEM := (others => x"0000");

begin

	process(iCLK, inRST)
	begin
		if inRST = '0' then
			for i in 0 to 255 loop
				rMEM(i) <= sMEM(i);
			end loop;
		elsif rising_edge(iCLK) then
			if iWE = '1' then
				rMEM(conv_integer(iA)) <= iD;
			end if;
		end if;
	end process;
-- ubaciti sadrzaj *.dat datoteke generisane pomocu lprsasm ------
sMEM(0) <= x"0005";
sMEM(1) <= x"0100";
sMEM(2) <= x"0140";
sMEM(3) <= x"0200";
sMEM(4) <= x"0300";
------------------------------------------------------------------
	
	oQ <= rMEM(conv_integer(iA));

end Behavioral;
