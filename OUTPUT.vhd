LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY OUTPUT IS
PORT(	CLK : IN STD_LOGIC;
		EN : IN STD_LOGIC;
		NOW_TIME_H1,NOW_TIME_H2,NOW_TIME_M1,NOW_TIME_M2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		FEE0,FEE1,FEE2,FEE3,FEE4,FEE5,FEE6,FEE7,FEE8,FEE9 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);				
		TIME0,TIME1,TIME2,TIME3,TIME4,TIME5,TIME6,TIME7,TIME8,TIME9 : IN STD_LOGIC_VECTOR(19 DOWNTO 0);	
		KEYIN0 : IN STD_LOGIC;		
		KEYIN1 : IN STD_LOGIC;			
		LED_H1,LED_H2,LED_M1,LED_M2,LED_T1,LED_T2,LED_X1,LED_X2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		LIGHT0,LIGHT1,LIGHT2,LIGHT3,LIGHT4,LIGHT5,LIGHT6,LIGHT7,LIGHT8,LIGHT9 : OUT STD_LOGIC
		
	);
END ENTITY;

ARCHITECTURE BHV OF OUTPUT IS
	TYPE STATES IS (S00,S0,S01,S1,S11,S2,S21,S3,S31,S4,S41,S5,S51,S6,S61,S7,S71,S8,S81,S9,S91);	
	SIGNAL CS,NS : STATES;	
	TYPE matrix_index is array (9 downto 0) of std_logic_vector(6 downto 0);	 
	SIGNAL REG: matrix_index;	
	SIGNAL NOW_TIME_H1_INT,NOW_TIME_H2_INT,NOW_TIME_M1_INT,NOW_TIME_M2_INT : INTEGER RANGE 0 TO 9;
	SIGNAL FEE0_INT,FEE1_INT,FEE2_INT,FEE3_INT,FEE4_INT,FEE5_INT,FEE6_INT,FEE7_INT,FEE8_INT,FEE9_INT : INTEGER RANGE 0 TO 999;		
	SIGNAL TIME0_INT,TIME1_INT,TIME2_INT,TIME3_INT,TIME4_INT,TIME5_INT,TIME6_INT,TIME7_INT,TIME8_INT,TIME9_INT : INTEGER RANGE 0 TO 999999;		
	SIGNAL LED1,LED2,LED3,LED4,LED00,LED01 : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL LED_1,LED_2 : STD_LOGIC_VECTOR(6 DOWNTO 0);			
	SIGNAL REG_C,REG_F : STD_LOGIC_VECTOR(6 DOWNTO 0);		
	SIGNAL REG_NULL : STD_LOGIC_VECTOR(6 DOWNTO 0);		
	SIGNAL KEY_LOW0,KEY_HIGH0,KEY_LOW1,KEY_HIGH1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL KEY_OUT0,KEY_OUT1 : STD_LOGIC;
	
BEGIN
	REG(0)	<=	"1000000";
	REG(1)	<=	"1111001";
	REG(2)	<=	"0100100";
	REG(3)	<=	"0110000";
	REG(4)	<=	"0011001";
	REG(5)	<=	"0010010";
	REG(6)	<=	"0000010";
	REG(7)	<=	"1111000";
	REG(8)	<=	"0000000";
	REG(9)	<=	"0010000";
	REG_C	<=	"1000110";		
	REG_F	<=	"0001110";		
	REG_NULL	<=	"1111111";	
	
	NOW_TIME_H1_INT <= CONV_INTEGER(NOW_TIME_H1);
	NOW_TIME_H2_INT <= CONV_INTEGER(NOW_TIME_H2);
	NOW_TIME_M1_INT <= CONV_INTEGER(NOW_TIME_M1);
	NOW_TIME_M2_INT <= CONV_INTEGER(NOW_TIME_M2);
	
	TIME0_INT <= CONV_INTEGER(TIME0);
	TIME1_INT <= CONV_INTEGER(TIME1);
	TIME2_INT <= CONV_INTEGER(TIME2);
	TIME3_INT <= CONV_INTEGER(TIME3);
	TIME4_INT <= CONV_INTEGER(TIME4);
	TIME5_INT <= CONV_INTEGER(TIME5);
	TIME6_INT <= CONV_INTEGER(TIME6);
	TIME7_INT <= CONV_INTEGER(TIME7);
	TIME8_INT <= CONV_INTEGER(TIME8);
	TIME9_INT <= CONV_INTEGER(TIME9);
	
	FEE0_INT <= CONV_INTEGER(FEE0);
	FEE1_INT <= CONV_INTEGER(FEE1);
	FEE2_INT <= CONV_INTEGER(FEE2);
	FEE3_INT <= CONV_INTEGER(FEE3);
	FEE4_INT <= CONV_INTEGER(FEE4);
	FEE5_INT <= CONV_INTEGER(FEE5);
	FEE6_INT <= CONV_INTEGER(FEE6);
	FEE7_INT <= CONV_INTEGER(FEE7);
	FEE8_INT <= CONV_INTEGER(FEE8);
	FEE9_INT <= CONV_INTEGER(FEE9);
	
	--LIGHT0,LIGHT1,LIGHT2,LIGHT3,LIGHT4,LIGHT5,LIGHT6,LIGHT7,LIGHT8,LIGHT9 <= '0';
	
PROCESS(EN,KEYIN0,KEY_LOW0,KEY_HIGH0,CLK,KEY_OUT0)
BEGIN
	IF CLK'EVENT AND CLK = '1' THEN		
		IF KEYIN0 = '0' THEN
			KEY_LOW0 <= KEY_LOW0 + 1;
		ELSE 
			KEY_LOW0 <= "0000";	
		END IF;
		
		IF KEYIN0 = '1' THEN
			KEY_HIGH0 <= KEY_HIGH0 + 1;
		ELSE
			KEY_HIGH0 <= "0000";	
		END IF;
		
		IF (KEY_HIGH0 > "1100") THEN
			KEY_OUT0 <= '1';
		ELSIF (KEY_LOW0 > "0011") THEN
			KEY_OUT0 <= '0';
		END IF;
	END IF;
END PROCESS;

PROCESS(EN,KEYIN1,KEY_LOW1,KEY_HIGH1,CLK,KEY_OUT1)
BEGIN
	IF CLK'EVENT AND CLK = '1' THEN		
		IF KEYIN1 = '0' THEN
			KEY_LOW1 <= KEY_LOW1 + 1;
		ELSE 
			KEY_LOW1 <= "0000";	
		END IF;
		
		IF KEYIN1 = '1' THEN
			KEY_HIGH1 <= KEY_HIGH1 + 1;
		ELSE
			KEY_HIGH1 <= "0000";	
		END IF;
		
		IF (KEY_HIGH1 > "1100") THEN
			KEY_OUT1 <= '1';
		ELSIF (KEY_LOW1 > "0011") THEN
			KEY_OUT1 <= '0';
		END IF;
	END IF;
END PROCESS;

PROCESS(EN,KEY_OUT0)
BEGIN
	IF EN = '0' THEN
		CS <= S00;
	ELSIF KEY_OUT0'EVENT AND KEY_OUT0 = '1' THEN
		CS <= NS;
	END IF;
END PROCESS;

PROCESS(CS)
BEGIN
CASE CS IS
	WHEN S00 => NS <= S0;
	WHEN S0 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S01;
		ELSE 
			NS <= S1;
		END IF;
	WHEN S01 => NS <= S1;
	
	WHEN S1 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S11;
		ELSE 
			NS <= S2;
		END IF;
	WHEN S11 => NS <= S2;
	
	WHEN S2 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S21;
		ELSE 
			NS <= S3;
		END IF;
	WHEN S21 => NS <= S3;
	
	WHEN S3 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S31;
		ELSE 
			NS <= S4;
		END IF;
	WHEN S31 => NS <= S4;
	
	WHEN S4 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S41;
		ELSE 
			NS <= S5;
		END IF;
	WHEN S41 => NS <= S5;
	
	WHEN S5 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S51;
		ELSE 
			NS <= S6;
		END IF;
	WHEN S51 => NS <= S6;
	
	WHEN S6 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S61;
		ELSE 
			NS <= S7;
		END IF;
	WHEN S61 => NS <= S7;
	
	WHEN S7 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S71;
		ELSE 
			NS <= S8;
		END IF;
	WHEN S71 => NS <= S8;
	
	WHEN S8 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S81;
		ELSE 
			NS <= S9;
		END IF;
	WHEN S81 => NS <= S9;
	
	WHEN S9 => 
		IF (KEY_OUT1 = '1') THEN
			NS <= S91;
		ELSE 
			NS <= S00;
		END IF;
	WHEN S91 => NS <= S00;
	WHEN OTHERS => NS <= S00;
END CASE;
END PROCESS;

PROCESS(CS,EN)
BEGIN
	IF EN = '1' THEN
		CASE CS IS
		WHEN S00 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_NULL;
			LED_2 <= REG_NULL;
			LED1 <= REG(NOW_TIME_H1_INT);
			LED2 <= REG(NOW_TIME_H2_INT);
			LED3 <= REG(NOW_TIME_M1_INT);
			LED4 <= REG(NOW_TIME_M2_INT);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S0 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(0);
			LED1 <= REG_F;
			LED2 <= REG(FEE0_INT/100);
			LED3 <= REG(FEE0_INT/10 rem 10);
			LED4 <=	REG(FEE0_INT rem 10);
			LIGHT0 <= '1';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S1 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(1);
			LED1 <= REG_F;
			LED2 <= REG(FEE1_INT/100);
			LED3 <= REG(FEE1_INT/10 rem 10);
			LED4 <=	REG(FEE1_INT REM 10);
			LIGHT0 <= '0';LIGHT1 <= '1';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S2 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(2);
			LED1 <= REG_F;
			LED2 <= REG(FEE2_INT/100);
			LED3 <= REG(FEE2_INT/10 rem 10);
			LED4 <=	REG(FEE2_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '1';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S3 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(3);
			LED1 <= REG_F;
			LED2 <= REG(FEE3_INT/100);
			LED3 <= REG(FEE3_INT/10 rem 10);
			LED4 <=	REG(FEE3_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '1';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S4 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(4);
			LED1 <= REG_F;
			LED2 <= REG(FEE4_INT/100);
			LED3 <= REG(FEE4_INT/10 rem 10);
			LED4 <=	REG(FEE4_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '1';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S5 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(5);
			LED1 <= REG_F;
			LED2 <= REG(FEE5_INT/100);
			LED3 <= REG(FEE5_INT/10 rem 10);
			LED4 <=	REG(FEE5_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '1';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S6 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(6);
			LED1 <= REG_F;
			LED2 <= REG(FEE6_INT/100);
			LED3 <= REG(FEE6_INT/10 rem 10);
			LED4 <=	REG(FEE6_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '1';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S7 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(7);
			LED1 <= REG_F;
			LED2 <= REG(FEE7_INT/100);
			LED3 <= REG(FEE7_INT/10 rem 10);
			LED4 <=	REG(FEE7_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '1';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S8 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(8);
			LED1 <= REG_F;
			LED2 <= REG(FEE8_INT/100);
			LED3 <= REG(FEE8_INT/10 rem 10);
			LED4 <=	REG(FEE8_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '1';
			LIGHT9 <= '0';
		WHEN S9 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(9);
			LED1 <= REG_F;
			LED2 <= REG(FEE9_INT/100);
			LED3 <= REG(FEE9_INT/10 rem 10);
			LED4 <=	REG(FEE9_INT rem 10);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '1';
		WHEN S01 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(0);
			LED1  <= REG(TIME0_INT / 36000 );
			LED2  <= REG(TIME0_INT rem 36000 / 3600);
			LED3  <= REG(TIME0_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME0_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '1';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S11 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(1);
			LED1  <= REG(TIME1_INT / 36000 );
			LED2  <= REG(TIME1_INT rem 36000 / 3600);
			LED3  <= REG(TIME1_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME1_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '1';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S21 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(2);
			LED1  <= REG(TIME2_INT / 36000 );
			LED2  <= REG(TIME2_INT rem 36000 / 3600);
			LED3  <= REG(TIME2_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME2_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '1';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S31 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(3);
			LED1  <= REG(TIME3_INT / 36000 );
			LED2  <= REG(TIME3_INT rem 36000 / 3600);
			LED3  <= REG(TIME3_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME3_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '1';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S41 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(4);
			LED1  <= REG(TIME4_INT / 36000 );
			LED2  <= REG(TIME4_INT rem 36000 / 3600);
			LED3  <= REG(TIME4_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME4_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '1';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S51 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(5);
			LED1  <= REG(TIME5_INT / 36000 );
			LED2  <= REG(TIME5_INT rem 36000 / 3600);
			LED3  <= REG(TIME5_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME5_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '1';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S61 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(6);
			LED1  <= REG(TIME6_INT / 36000 );
			LED2  <= REG(TIME6_INT rem 36000 / 3600);
			LED3  <= REG(TIME6_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME6_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '1';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S71 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(7);
			LED1  <= REG(TIME7_INT / 36000 );
			LED2  <= REG(TIME7_INT rem 36000 / 3600);
			LED3  <= REG(TIME7_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME7_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '1';LIGHT8 <= '0';
			LIGHT9 <= '0';
		WHEN S81 =>
			LED_1 <= REG_C;
			LED_2 <= REG(8);
			LED1  <= REG(TIME8_INT / 36000 );
			LED2  <= REG(TIME8_INT rem 36000 / 3600);
			LED3  <= REG(TIME8_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME8_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '1';
			LIGHT9 <= '0';
		WHEN S91 =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_C;
			LED_2 <= REG(9);
			LED1  <= REG(TIME9_INT / 36000 );
			LED2  <= REG(TIME9_INT rem 36000 / 3600);
			LED3  <= REG(TIME9_INT rem 36000 rem 3600 / 600);
			LED4  <= REG(TIME9_INT rem 36000 rem 3600 rem 600 /60);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '1';
		WHEN OTHERS =>
			LED00<=REG_NULL;
			LED01<=REG_NULL;
			LED_1 <= REG_NULL;
			LED_2 <= REG_NULL;
			LED1 <= REG(NOW_TIME_H1_INT);
			LED2 <= REG(NOW_TIME_H2_INT);
			LED3 <= REG(NOW_TIME_M1_INT);
			LED4 <= REG(NOW_TIME_M2_INT);
			LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
			LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
			LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
			LIGHT9 <= '0';
		END CASE;
	ELSE 
		LED00 <= REG(4);
		LED01 <= REG(0);
		LED_1 <= REG(6);
		LED_2 <= REG(8);
		LED1 <= REG(4);
		LED2 <= REG(0);
		LED3 <= REG(5);
		LED4 <= REG(6);
		LIGHT0 <= '0';LIGHT1 <= '0';LIGHT2 <= '0';
		LIGHT3 <= '0';LIGHT4 <= '0';LIGHT5 <= '0';
		LIGHT6 <= '0';LIGHT7 <= '0';LIGHT8 <= '0';
		LIGHT9 <= '0';
	END IF;
	
		LED_H1 <= LED1;
		LED_H2 <= LED2;
		LED_M1 <= LED3;
		LED_M2 <= LED4;
		LED_T1 <= LED_1; 
		LED_T2 <= LED_2; 
		LED_X1 <= LED00;
		LED_X2 <= LED01;
END PROCESS;


END BHV;
		
		
		
		
	























