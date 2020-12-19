library ieee;
    use ieee.std_logic_1164.all;

entity DFF is
    port(
        d_dff: in std_logic;
        clk_dff: in std_logic;
        resetn_dff: in std_logic;
        q_dff: out std_logic
    );
end DFF;

architecture rtl of DFF is
    begin
        parallel_dff: process(clk_dff, resetn_dff)
        begin
            if(resetn_dff = '0') then
                q_dff <= '0';
            elsif(rising_edge(clk_dff)) then
                q_dff <= d_dff;
            end if;
        end process parallel_dff;
    end rtl;