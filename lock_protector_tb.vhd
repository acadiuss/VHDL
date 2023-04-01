library IEEE;
use IEEE.std_logic_1164.all;

entity lock_protector_tb is
end lock_protector_tb;

architecture behavior of lock_protector_tb is
    -- Deklaracja komponentu do symulacji
    component lock_protector
        port(
            code_in : in std_logic_vector(11 downto 0); 
            lock_out : out std_logic;
            correct_code : std_logic_vector(11 downto 0) := "101010101010";
            reset : in std_logic;
            clk : in std_logic
        );
    end component;
    
    -- Sygnaly wejsciowe i wyjsciowe dla symulacji
    signal code_in : std_logic_vector(11 downto 0);
    signal lock_out : std_logic;
    signal reset : std_logic;
    signal clk : std_logic;
    
begin
    -- Instancja komponentu do symulacji
    UUT: lock_protector port map (
        code_in => code_in,
        lock_out => lock_out,
        reset => reset,
        clk => clk
    );
    
    -- Generowanie sygnalów wejsciowych
    process
    begin
      -- Ustawienie stanu poczatkowego
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        
        -- Generowanie sygnalu zegarowego
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        
        -- Przeprowadzenie symulacji dla róznych wejsc
        code_in <= "000000000000";
        wait for 10 ns;
        code_in <= "111111111111";
        wait for 10 ns;
        code_in <= "101010101010";
        wait for 10 ns;
		code_in <= "010000001000";
        wait for 10 ns;
        code_in <= "011111111101";
        wait for 10 ns;
        code_in <= "101010101010";
        wait for 10 ns;
        
        -- Zakonczenie symulacji
        wait;
    end process;
    
end behavior;
