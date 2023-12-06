LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.std_logic_arith.all;

entity pralka is
port 
(
 clk :  in std_logic;    
 clr :  in std_logic;
 start: in STD_LOGIC;
 drzwi: in STD_LOGIC;
 reset: in STD_LOGIC;
 SW:	in STD_LOGIC_VECTOR(3 downto 0); 
 SW2:   in STD_LOGIC_VECTOR(2 downto 0);
 SW3:   in STD_LOGIC_VECTOR(2 downto 0);
 segment_nr: out STD_LOGIC_VECTOR(6 downto 0);
 segment_czas: out STD_LOGIC_VECTOR(6 downto 0);
 segment_tmpr:  out STD_LOGIC_VECTOR(13 downto 0);
 segment_obroty: out STD_LOGIC_VECTOR(27 downto 0);
 LED:		out STD_LOGIC_VECTOR(4 downto 0)

);
end entity;
architecture Behavioral of pralka is 
TYPE state_typ IS (S0,S1,S2,S3,S4,S5,S6);
signal state: state_typ;
TYPE programy IS (SZYBKI,SYNTETYK,ZIMNE,BAWELNA,DELIKATNE,WELNA,SPORT,MIX,MANUAL);
SIGNAL obroty: integer range 0 to 1200:=0;
SIGNAL temperatura: integer range 0 to 90:=0;  



SIGNAL program: programy;
SIGNAL count: integer range 0 to 9:=0;
SIGNAL czas_pranie: std_logic_vector (3 downto 0) := "0000";
SIGNAL czas_plukanie: std_logic_vector (3 downto 0) := "0000";
SIGNAL czas_wirowanie: std_logic_vector (3 downto 0) := "0000";

begin
process(clr,clk)
begin

if clr = '1' then
		state <= S0;
		count <= 0;
	elsif clk 'event and clk = '1' then
case state is	
		when S0 =>
if SW="0001" then 	-- PROGRAM SZYBKI
program <= SZYBKI;
temperatura<= 30;
obroty<= 900;
elsif SW="0010" then -- PROGRAM SYNTETYK
program <= SYNTETYK;
temperatura<= 40;
obroty<= 800;
elsif SW="0011" then -- PROGRAM ZIMNE
program <= ZIMNE;
temperatura<= 20;
obroty<= 800;
elsif SW="0100" then -- PROGRAM BAWELNA
program <= BAWELNA;
temperatura<= 40;
obroty<= 1100;
elsif SW="0101" then -- PROGRAM DELIKATNE
program <= DELIKATNE;
temperatura<= 30;
obroty<= 900;
elsif SW="0110" then -- PROGRAM WELNA
program <= WELNA;
temperatura<= 60;
obroty<= 1200;
elsif SW="0111" then -- PROGRAM SPORT
program <= SPORT;
temperatura<= 60;
obroty<= 1000;
elsif SW="1000" then -- PROGRAM MIX
program <= MIX;
temperatura<= 60;
obroty<= 1100;
elsif SW="1001" then -- PROGRAM MANUAL
program <= MANUAL;
if SW2="000" then -- Ustawienie temperatury
temperatura<=0;
elsif SW2="001" then
temperatura <=20;
elsif SW2="010" then
temperatura <=30;
elsif SW2="011" then
temperatura <=40;
elsif SW2="100" then
temperatura <=60;
elsif SW2="101" then
temperatura <=90;
end if;
if SW3="000" then -- Wybor predkosci wirowania
obroty <=0;
elsif SW3="001" then
obroty <=800;
elsif SW3="010" then
obroty <=900;
elsif SW3="011" then
obroty <=1000;
elsif SW3="100" then
obroty <=1100;
elsif SW3="101" then
obroty <=1200;
end if;
end if;
if temperatura=0 then -- warunki czasu prania/plukania
czas_pranie <="0000";
czas_plukanie <="0000";
elsif temperatura=20 then
czas_pranie <="0011";
czas_plukanie <="0011";
elsif temperatura=30 then
czas_pranie <="0100";
czas_plukanie <="0100";
elsif temperatura=40 then
czas_pranie <="0101";
czas_plukanie <="0101";
elsif temperatura=60 then
czas_pranie <="0111";
czas_plukanie <="0111";
elsif temperatura=90 then
czas_pranie <="1000";
czas_plukanie <="1000";
end if;
if obroty=0 then -- warunki czasu prania/plukania
czas_wirowanie<="0000";
elsif obroty=800 then
czas_wirowanie<="0011";
elsif obroty=900 then
czas_wirowanie<="0100";
elsif obroty=1000 then
czas_wirowanie<="0101";
elsif obroty=1100 then
czas_wirowanie<="0111";
elsif obroty=1200 then
czas_wirowanie<="1000";
end if;
if drzwi = '1' then
led(0) <='1'; -- DIODA Sygnalizujaca otwarte drzwi pralki
else 
if start ='1' then -- Przycisk start
state <=S1;
end if; 
end if; 
when S1 =>
led(1) <='1'; -- DIODA Sygnalizujaca PRANIE
if count < czas_pranie then
				state <= S1;
				count <= count + 1;
			else
				state <= S2;
				count <=0;
			end if;
when S2 =>
led(2) <='1'; -- DIODA Sygnalizujaca PLUKANE
if count < czas_plukanie then
				state <= S1;
				count <= count + 1;
			else
				state <= S3;
				count <=0;
				end if;
when S3 =>
count <=0;
led(3) <='1'; -- DIODA Sygnalizujaca WIROWANIE
if count < czas_wirowanie then
				state <= S1;
				count <= count + 1;
			else
				state <= S4;
				count <=0;
				end if;
when S4 =>
led(3) <='1'; -- DIODA Sygnalizujaca KONIEC
if reset='1' then -- Wraca do poczatku
state <=S0;
end if;
when S5 =>
when S6 =>
end case;
 end if;
end process;
process(count,SW,obroty,temperatura)
begin
		  if  SW="0000" then segment_nr   <= "1000000"; -- SEGMENT 1
        	elsif SW="0001" then segment_nr <= "1111001";
        	elsif SW="0010" then segment_nr <= "0100100";
        	elsif SW="0011" then segment_nr <= "0110000";
        	elsif SW="0100" then segment_nr <= "0011001";
        	elsif SW="0101" then segment_nr <= "0010010";
        	elsif SW="0110" then segment_nr <= "0000010";
        	elsif SW="0111" then segment_nr <= "1111000";
			elsif SW="1000" then segment_nr <= "0000000";
			elsif SW="1001" then segment_nr <= "0011000";
        end if;		  
		  if	  (count=0) then segment_czas <= "1000000"; -- SEGMENT 2
        	elsif (count=1) then segment_czas <= "1111001";
        	elsif (count=2) then segment_czas <= "0100100";
        	elsif (count=3) then segment_czas <= "0110000";
        	elsif (count=4) then segment_czas <= "0011001";
        	elsif (count=5) then segment_czas <= "0010010";
        	elsif (count=6) then segment_czas <= "0000010";
        	elsif (count=7) then segment_czas <= "1111000";
		  	elsif (count=8) then segment_czas <= "0000000";
		  	elsif (count=9) then segment_czas <= "0011000";
		end if;
		 if (temperatura=0) then segment_tmpr        <= "10000001000000"; -- SEGMENT 3 i 4
        	elsif(temperatura=20) then 	segment_tmpr <= "01001001000000";
		  	elsif(temperatura=30) then 	segment_tmpr <= "01100001000000";  
		  	elsif(temperatura=40) then 	segment_tmpr <= "00110011000000";
		  	elsif(temperatura=60) then 	segment_tmpr <= "00000101000000";
	     	elsif(temperatura=90) then 	segment_tmpr <= "00110001000000";	
		 end if;
		  if (obroty=0) then segment_obroty     <= "1000000100000010000001000000"; -- SEGMENT 4 do 8
		  elsif(obroty=800) then segment_obroty <= "1111111000000010000001000000";
		  elsif(obroty=900) then segment_obroty <= "1111111001100010000001000000";
		  elsif(obroty=1000)then segment_obroty <= "1111001100000010000001000000";
		  elsif(obroty=1100)then segment_obroty <= "1111001111100110000001000000";
		  elsif(obroty=1200)then segment_obroty <= "1111001010010010000001000000";
		  end if;
end process;
end Behavioral;