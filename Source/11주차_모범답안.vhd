-- hb_piano.VHD

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hb_piano IS
PORT(
	RESETN : IN STD_LOGIC;						-- RESET 입력
	CLK : IN STD_LOGIC;							-- CLK (1MHz)
    BCD : IN STD_LOGIC_VECTOR(15 DOWNTO 0);		-- 16개의 입력버튼
    a, b, c, d, e, f, g : OUT STD_LOGIC;		-- DECODE용 번호
	PIEZO : OUT STD_LOGIC						-- 피에조
);
END hb_piano;

ARCHITECTURE HB OF hb_piano IS

	SIGNAL DECODE : STD_LOGIC_VECTOR(6 DOWNTO 0);		--DECODE 시그널
	
	CONSTANT CNT_DO : INTEGER RANGE 0 TO 2047 := 1910;     
	CONSTANT CNT_RE : INTEGER RANGE 0 TO 2047 := 1701;      
	CONSTANT CNT_MI : INTEGER RANGE 0 TO 2047 := 1516;     
	CONSTANT CNT_FA : INTEGER RANGE 0 TO 2047 := 1431;     
	CONSTANT CNT_SOL : INTEGER RANGE 0 TO 2047 := 1275;     
	CONSTANT CNT_RA : INTEGER RANGE 0 TO 2047 := 1135;     
	CONSTANT CNT_SI : INTEGER RANGE 0 TO 2047 := 1011;     
	CONSTANT CNT_HDO : INTEGER RANGE 0 TO 2047 := 955;
	CONSTANT CNT_HRE : INTEGER RANGE 0 TO 2047 := 852;
	CONSTANT CNT_HMI : INTEGER RANGE 0 TO 2047 := 759;
	CONSTANT CNT_HFA: INTEGER RANGE 0 TO 2047 := 716;
	CONSTANT CNT_HSOL : INTEGER RANGE 0 TO 2047 := 638;
 	CONSTANT CNT_HRA : INTEGER RANGE 0 TO 2047 := 569;
	CONSTANT CNT_HSI : INTEGER RANGE 0 TO 2047 := 507;
	CONSTANT CNT_ODO : INTEGER RANGE 0 TO 2047 := 478;
	
	CONSTANT SHARP_DO : INTEGER RANGE 0 TO 2047 := 1804;
	CONSTANT SHARP_RE : INTEGER RANGE 0 TO 2047 := 1607;
	CONSTANT SHARP_FA : INTEGER RANGE 0 TO 2047 := 1352;
	CONSTANT SHARP_SOL : INTEGER RANGE 0 TO 2047 := 1204;
	CONSTANT SHARP_RA : INTEGER RANGE 0 TO 2047 := 1073;
	CONSTANT SHARP_HDO : INTEGER RANGE 0 TO 2047 := 902;
	CONSTANT SHARP_HRE : INTEGER RANGE 0 TO 2047 := 804;
	CONSTANT SHARP_HFA : INTEGER RANGE 0 TO 2047 := 676;
	CONSTANT SHARP_HSOL : INTEGER RANGE 0 TO 2047 := 602;
	CONSTANT SHARP_HRA : INTEGER RANGE 0 TO 2047 := 536;
	
	SIGNAL REG : STD_LOGIC;
	SIGNAL CNT : INTEGER RANGE 0 TO 2047;     
	SIGNAL LIMIT : INTEGER RANGE 0 TO 2047; 

BEGIN

PROCESS(BCD) 
BEGIN     
	CASE BCD IS    
		WHEN "1000000000000000" => LIMIT <= CNT_DO;    
		WHEN "0100000000000000" => LIMIT <= CNT_RE;    
		WHEN "0010000000000000" => LIMIT <= CNT_MI;    
		WHEN "0001000000000000" => LIMIT <= CNT_FA;   
		WHEN "0000100000000000" => LIMIT <= CNT_SOL;    
		WHEN "0000010000000000" => LIMIT <= CNT_RA;     
		WHEN "0000001000000000" => LIMIT <= CNT_SI;    
		WHEN "0000000100000000" => LIMIT <= CNT_HDO;
		WHEN "0000000010000000" => LIMIT <= CNT_HRE;
		WHEN "0000000001000000" => LIMIT <= CNT_HMI;
		WHEN "0000000000100000" => LIMIT <= CNT_HFA;
		WHEN "0000000000010000" => LIMIT <= CNT_HSOL;
		WHEN "0000000000001000" => LIMIT <= CNT_HRA;
		WHEN "0000000000000100" => LIMIT <= CNT_HSI;
		WHEN "0000000000000010" => LIMIT <= CNT_ODO;
		
		WHEN "1000000000000001" => LIMIT <= SHARP_DO; 
		WHEN "0100000000000001" => LIMIT <= SHARP_RE; 
		WHEN "0001000000000001" => LIMIT <= SHARP_FA; 
		WHEN "0000100000000001" => LIMIT <= SHARP_SOL; 
		WHEN "0000010000000001" => LIMIT <= SHARP_RA; 
		WHEN "0000000100000001" => LIMIT <= SHARP_HDO; 
		WHEN "0000000010000001" => LIMIT <= SHARP_HRE; 
		WHEN "0000000000100001" => LIMIT <= SHARP_HFA; 
		WHEN "0000000000010001" => LIMIT <= SHARP_HSOL; 
		WHEN "0000000000001001" => LIMIT <= SHARP_HRA; 
		
		WHEN OTHERS => LIMIT <= 0;  
	END CASE; 
END PROCESS; 

PROCESS(RESETN, CLK) 
BEGIN  
   IF RESETN = '0' THEN 
	    CNT <= 0;     
	    REG <= '0';   
   ELSIF CLK'EVENT AND CLK = '1' THEN  
		IF CNT >= LIMIT THEN           
			CNT <= 0;         
			REG <= NOT REG;     
	    ELSE           
			CNT <= CNT + 1;      
	    END IF;  
   END IF; 
END PROCESS; 
 
PROCESS(BCD)
BEGIN
    CASE BCD IS
		WHEN "0000000000000000" => DECODE <= "0000001";
		WHEN "1000000000000000" | "0000000100000000" | "0000000000000010"=> DECODE <= "1001110"; -- c
		WHEN "0100000000000000" | "0000000010000000"=> DECODE <= "0111101"; -- d
		WHEN "0010000000000000" | "0000000001000000"=> DECODE <= "1001111"; -- e
		WHEN "0001000000000000" | "0000000000100000"=> DECODE <= "1000111"; -- f
		WHEN "0000100000000000" | "0000000000010000"=> DECODE <= "1011110"; -- g
		WHEN "0000010000000000" | "0000000000001000"=> DECODE <= "1110111"; -- a
		WHEN "0000001000000000" | "0000000000000100"=> DECODE <= "0011111"; -- b
		WHEN "1000000000000001" | "0100000000000001" | "0001000000000001" | "0000100000000001" 
		| "0000010000000001"=> DECODE <= "0001110"; -- Low Sharp (DO, RE, FA, SOL, RA)
		WHEN "0000000100000001" | "0000000010000001" | "0000000000100001" | "0000000000010001"
		| "0000000000001001"=> DECODE <= "0110111"; -- High Sharp (DO, RE, FA, SOL, RA)
		WHEN OTHERS => NULL;
    END CASE;
END PROCESS;

a <= DECODE(6);
b <= DECODE(5);
c <= DECODE(4);
d <= DECODE(3);
e <= DECODE(2);
f <= DECODE(1);
g <= DECODE(0);

PIEZO <= REG;
END HB;