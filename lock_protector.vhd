											 
library IEEE;
use IEEE.std_logic_1164.all;

entity lock_protector is
    port(
        code_in : in std_logic_vector(11 downto 0); 
        lock_out : out std_logic;
        correct_code : std_logic_vector(11 downto 0) := "101010101010";
        reset : in std_logic;
        clk : in std_logic
    );
end lock_protector;

architecture behavior of lock_protector is
    type state_type is (s0, s1);
    signal current_state, next_state : state_type;
begin
    process(current_state, code_in, reset, clk)
    begin
        if reset = '1' then
            current_state <= s0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
        
        case current_state is
            when s0 =>
                if code_in = correct_code then
                    lock_out <= '1';
                    next_state <= s1;
                else
                    lock_out <= '0';
                    next_state <= s0;
                end if;
            when s1 =>
                lock_out <= '1';
                next_state <= s1;
        end case;
    end process;
end behavior;
