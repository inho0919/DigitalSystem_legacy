--Question.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Question IS
	PORT(
		START 	 : IN  STD_LOGIC_VECTOR(0 DOWNTO 0); -- START BUTTON
		RESETN    : IN  STD_LOGIC;      -- RESET
		CLK       : IN  STD_LOGIC;      -- CLOCK 1Hz
		a, b, c, d, e, f, g : OUT STD_LOGIC;
		COUNT_OUT : BUFFER STD_LOGIC_VECTOR(0 TO 15); -- LED OUTPUT
		SEG_COM : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END Question;

ARCHITECTURE HB OF Question IS
	SIGNAL CNT_8BIT : STD_LOGIC_VECTOR(0 TO 7);
	SIGNAL HOLD : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL DECODE : STD_LOGIC_VECTOR(6 DOWNTO 0);
	
BEGIN

SEG_COM <= "1111";

	PROCESS(START, RESETN, CLK)
		BEGIN
			IF START = 1 THEN
				IF RESETN = '0' THEN
					CNT_8BIT <= (OTHERS => '0');
				ELSIF CLK'EVENT AND CLK = '1' THEN
					IF CNT_8BIT = "1111" THEN
						CNT_8BIT <= (OTHERS => '0');
					ELSE
						CNT_8BIT <= CNT_8BIT + 1;
					END IF;
				END IF;
			END IF;		
	END PROCESS;

	PROCESS(CLK)
		BEGIN
		IF CNT_8BIT = "00000001" THEN
			COUNT_OUT <= "0000000000000001";
		ELSIF CNT_8BIT = "00000010" THEN
			COUNT_OUT <= "0000000000000010";
		ELSIF CNT_8BIT = "00000011" THEN
			COUNT_OUT <= "0000000000000100";	
		ELSIF CNT_8BIT = "00000100" THEN
			COUNT_OUT <= "0000000000001000";
		ELSIF CNT_8BIT = "00000101" THEN
			COUNT_OUT <= "0000000000010000";	
		ELSIF CNT_8BIT = "00000110" THEN
			COUNT_OUT <= "0000000000100000";
		ELSIF CNT_8BIT = "00000111" THEN
			COUNT_OUT <= "0000000001000000";
		ELSIF CNT_8BIT = "00001000" THEN
			COUNT_OUT <= "0000000010000000";
		ELSIF CNT_8BIT = "00001001" THEN
			COUNT_OUT <= "0000000100000000";
		ELSIF CNT_8BIT = "00001010" THEN
			COUNT_OUT <= "0000001000000000";
		ELSIF CNT_8BIT = "00001011" THEN
			COUNT_OUT <= "0000010000000000";
		ELSIF CNT_8BIT = "00001100" THEN
			COUNT_OUT <= "0000100000000000";
		ELSIF CNT_8BIT = "00001101" THEN
			COUNT_OUT <= "0001000000000000";
		ELSIF CNT_8BIT = "00001110" THEN
			COUNT_OUT <= "0010000000000000";
		ELSIF CNT_8BIT = "00001111" THEN
			COUNT_OUT <= "0100000000000000";
		ELSE
			COUNT_OUT <= "1000000000000000";
		END IF;	
	END PROCESS;
	
	--
	PROCESS(CLK)
		BEGIN
			CASE COUNT_OUT IS
				WHEN "1000000000000000" => DECODE <= "1111110"; -- 0
				WHEN "0000000000000001" => DECODE <= "0110000"; -- 1
				WHEN "0000000000000010" => DECODE <= "1101101"; -- 2
				WHEN "0000000000000100" => DECODE <= "1111001"; -- 3
				WHEN "0000000000001000" => DECODE <= "0110011"; -- 4
				WHEN "0000000000010000" => DECODE <= "1011011"; -- 5
				WHEN "0000000000100000" => DECODE <= "1011111"; -- 6
				WHEN "0000000001000000" => DECODE <= "1110000"; -- 7
				WHEN "0000000010000000" => DECODE <= "1111111"; -- 8
				WHEN "0000000100000000" => DECODE <= "1111011"; -- 9
				WHEN "0000001000000000" => DECODE <= "1110111"; -- A
				WHEN "0000010000000000" => DECODE <= "0011111"; -- B
				WHEN "0000100000000000" => DECODE <= "1001110"; -- C
				WHEN "0001000000000000" => DECODE <= "0111101"; -- D
				WHEN "0010000000000000" => DECODE <= "1001111"; -- E
				WHEN "0100000000000000" => DECODE <= "1000111"; -- F		  
				WHEN OTHERS => NULL;
			END CASE;
	END PROCESS;
	--
	
a <= DECODE(6);
b <= DECODE(5);
c <= DECODE(4);
d <= DECODE(3);
e <= DECODE(2);
f <= DECODE(1);
g <= DECODE(0);
	
END HB;