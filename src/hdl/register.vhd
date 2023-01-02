----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2022/2023
-- Project Labyrinth
--
-- Register
--
-- authors:
-- Stefan Nikolovski IN 6/2021
-- Mirjana Todorovic IN 57/2021
-- Milica Radojevic 	IN 31/2021
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    Generic ( WIDTH : integer := 16 );
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           iD : in  STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           iWE : in  STD_LOGIC;
           oQ : out  STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end reg;

architecture Behavioral of reg is

    signal sREG : std_logic_vector(WIDTH-1 downto 0);

begin

    process (iCLK, inRST) begin
        if (inRST = '0') then
            sREG <= (others => '0');
        elsif (iCLK'event and iCLK = '1') then
            if (iWE = '1') then
                sREG <= iD;
            end if;
        end if;
    end process;
    
    oQ <= sREG;

end Behavioral;
