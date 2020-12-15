library IEEE;
use IEEE.std_logic_1164.all;

-- Realize a Ripple Carry Adder in a structural way

entity RIPPLE_CARRY_ADDER is
    generic (Nbit: positive := 12);
    port(
        a_r: in std_logic_vector(Nbit-1 downto 0);
        b_r: in std_logic_vector(Nbit-1 downto 0);
        cin_r: in std_logic;
        cout_r: out std_logic;
        s_r: out std_logic_vector(Nbit-1 downto 0)
    );
end RIPPLE_CARRY_ADDER;

architecture rtl of RIPPLE_CARRY_ADDER is 
    component FULL_ADDER
        port(
            a: in std_logic;
            b: in std_logic;
            cin: in std_logic;
            s: out std_logic;
            cout: out std_logic
        );
    end component FULL_ADDER;
    
    signal carry_signal: std_logic_vector(Nbit-1 downto 1);
begin

    GEN: for i in 1 to Nbit generate
        FIRST: if i=1 generate
            FFI: FULL_ADDER port map (a_r(0), b_r(0), cin_r, s_r(0), carry_signal(1));
        end generate FIRST;
        INTERNAL: if i > 1 and i < Nbit generate
            FFI: FULL_ADDER port map (a_r(i-1), b_r(i-1), carry_signal(i-1), s_r(i-1), carry_signal(i));
        end generate INTERNAL;
        LAST: if i=Nbit generate
            FFI: FULL_ADDER port map (a_r(Nbit-1), b_r(Nbit-1), carry_signal(Nbit-1), s_r(Nbit-1), cout_r);
        end generate LAST;
    end generate GEN;
end rtl;

