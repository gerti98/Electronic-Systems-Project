library ieee;
    use ieee.std_logic_1164.all;

entity Parallel_DFF is
    generic (Nbit: integer);
    port(
        d_dff: in std_logic_vector(Nbit-1 downto 0);
        clk_dff: in std_logic;
        resetn_dff: in std_logic;
        q_dff: out std_logic_vector(Nbit-1 downto 0)
    );
end Parallel_DFF;

architecture rtl of Parallel_DFF is
    begin
        parallel_dff: process(clk_dff, resetn_dff)
        begin
            if(resetn_dff = '0') then
                q_dff <= (others => '0');
            elsif(rising_edge(clk_dff)) then
                q_dff <= d_dff;
            end if;
        end process parallel_dff;
	end rtl;