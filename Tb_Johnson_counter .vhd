library ieee;
use ieee.std_logic_1164.all;

entity tb_Johnson_counter is
end tb_Johnson_counter;

architecture tb of tb_Johnson_counter is

    component Johnson_counter
        port (clk : in std_logic;
              rst : in std_logic;
              Q   : out std_logic_vector (3 downto 0));
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
    signal Q   : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 1000 ns; 
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Johnson_counter
    port map (clk => clk,
              rst => rst,
              Q   => Q);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

  
    clk <= TbClock;

    stimuli : process
    begin
        
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        
        wait for 100 * TbPeriod;

        
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
configuration cfg_tb_Johnson_counter of tb_Johnson_counter is
    for tb
    end for;
end cfg_tb_Johnson_counter;
 
