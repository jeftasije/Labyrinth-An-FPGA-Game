----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2022/2023
-- Project Labyrinth
--
-- Input/Output controler for RGB matrix
--
-- authors:
-- Stefan Nikolovski IN 6/2021
-- Mirjana Todorovic IN 57/2021
-- Milica Radojevic 	IN 31/2021
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library work;

entity push_buttons_dec_io_ctrl is
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		iPB_UP     : in  std_logic;
		iPB_DOWN   : in  std_logic;
		iPB_LEFT   : in  std_logic;
		iPB_RIGHT  : in  std_logic;
		iBUS_A     : in  std_logic_vector(7 downto 0);
		oBUS_RD    : out std_logic_vector(15 downto 0);
		iBUS_WD    : in  std_logic_vector(15 downto 0);
		iBUS_WE    : in  std_logic;
		iSYNC_MATRIX : in std_logic
	);
end entity push_buttons_dec_io_ctrl;

architecture Behavioral of push_buttons_dec_io_ctrl is

	type tDIR is (NONE, UP, DOWN, LEFT, RIGHT);
	signal sDIR : tDIR;
	signal sDIR_PREV : tDIR := NONE;
	
	signal sMOVE_X : std_logic_vector(15 downto 0);
	signal sMOVE_Y : std_logic_vector(15 downto 0);
	

begin
	
	process(iBUS_A, sMOVE_X, sMOVE_Y)
	begin
		case iBUS_A is
			when x"00" =>
				oBUS_RD <= sMOVE_X;
			when x"01" =>
				oBUS_RD <= sMOVE_Y;
			when others =>
				oBUS_RD <= (others => '0');
		end case;
	end process;
	
	process(inRST, iCLK)
	begin
	
		if inRST = '0' then
			sDIR <= NONE;
		elsif(rising_edge(iCLK)) then
	
			if(iSYNC_MATRIX = '1') then

				if (iPB_UP = '1' and sDIR_PREV = NONE) then
						sDIR <= UP;
						sDIR_PREV <= UP;
				elsif(iPB_DOWN = '1' and sDIR_PREV = NONE) then
						sDIR <= DOWN;
						sDIR_PREV <= DOWN;
				elsif(iPB_LEFT = '1' and sDIR_PREV = NONE) then
						sDIR <= LEFT;
						sDIR_PREV <= LEFT;
				elsif(iPB_RIGHT = '1' and sDIR_PREV = NONE) then
						sDIR <= RIGHT;
						sDIR_PREV <= RIGHT;
				end if;
						
					case sDIR is
						when NONE =>
							sMOVE_X <= conv_std_logic_vector( 0, 16);
							sMOVE_Y <= conv_std_logic_vector( 0, 16);
						when UP =>
							if(iPB_UP = '0') then
								sMOVE_X <= conv_std_logic_vector( 0, 16);
								sMOVE_Y <= conv_std_logic_vector(-1, 16);
								sDIR_PREV <= NONE;
								sDIR <= NONE;
							end if;
						when DOWN =>
							if(iPB_DOWN = '0') then
								sMOVE_X <= conv_std_logic_vector( 0, 16);
								sMOVE_Y <= conv_std_logic_vector( 1, 16);
								sDIR_PREV <= NONE;
								sDIR <= NONE;
							end if;
						when LEFT =>
							if(iPB_LEFT = '0') then
								sMOVE_X <= conv_std_logic_vector(-1, 16);
								sMOVE_Y <= conv_std_logic_vector( 0, 16);
								sDIR_PREV <= NONE;
								sDIR <= NONE;
							end if;
						when RIGHT =>
							if(iPB_RIGHT = '0') then
								sMOVE_X <= conv_std_logic_vector( 1, 16);
								sMOVE_Y <= conv_std_logic_vector( 0, 16);
								sDIR_PREV <= NONE;
								sDIR <= NONE;
							end if;
					end case;
				end if;
		end if;
	end process;
	
	
end architecture;
