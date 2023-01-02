----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2022/2023
-- Project Labyrinth
--
-- Random Number Generator
--
-- authors:
-- Stefan Nikolovski IN 6/2021
-- Mirjana Todorovic IN 57/2021
-- Milica Radojevic 	IN 31/2021
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;

entity rng is
Port ( 
		iCLK : in std_logic;
		inRST : in std_logic;
		iBUS_A : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic
		);
		 
end rng;

architecture Behavioral of rng is

	signal sTEMP1: STD_LOGIC := '0';
	signal sTEMP7: STD_LOGIC := '0';
	signal sQT1: STD_LOGIC_VECTOR(15 downto 0) := x"0001"; 		-- constant seed
	signal sQT7: STD_LOGIC_VECTOR(15 downto 0) := x"0001";		-- constant seed
	signal sRNG1 : std_logic;
	signal sRNG7 : std_logic_vector (2 downto 0);

begin

	process(iCLK, inRST)		--random number generator for numbers between 0 and 1 
	begin

		if(inRST = '0') then
			sQT1 <= x"0001"; 
		elsif rising_edge(iCLK) then
		
			sTEMP1 <= sQT1(15) XOR sQT1(14) XOR sQT1(13) XOR sQT1(11) XOR sQT1(10) XOR sQT1(9) XOR sQT1(7) XOR sQT1(6) XOR sQT1(4) XOR sQT1(3) XOR sQT1(2) XOR sQT1(1) XOR sQT1(0);
			sQT1 <= sTEMP1 & sQT1(15 downto 1);
			
		end if;
	end process;


	process(iCLK, inRST)		--random number generator for numbers between 0 and 7
	begin

		if(inRST = '0') then
			sQT7 <= x"0001"; 
		elsif rising_edge(iCLK) then
		
			sTEMP7 <= sQT7(15) XOR sQT7(14) XOR sQT7(13) XOR sQT7(11) XOR sQT7(10) XOR sQT7(9) XOR sQT7(7) XOR sQT7(6) XOR sQT7(4) XOR sQT7(3) XOR sQT7(2) XOR sQT7(1) XOR sQT7(0);
			sQT7 <= sTEMP7 & sQT7(15 downto 1);
			
		end if;
	end process;

	sRNG7 <= sQT7(2 downto 0);
	sRNG1 <= sQT1(0);

	process(iBUS_A, sRNG1, sRNG7)
	begin
		case iBUS_A is
			when x"00" =>
				oBUS_RD <= "000000000000000" & sRNG1;
			when x"01" =>
				oBUS_RD <= "0000000000000" & sRNG7;
			when others =>
				oBUS_RD <= (others => '0');
		end case;
	end process;

end Behavioral;