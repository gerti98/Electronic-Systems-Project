library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity Parallel_Multiplier is
    generic (
        Nbit_a : positive; 
        Nbit_b: positive
    );
    port(
        a_p_signed: in std_logic_vector(Nbit_a - 1 downto 0);
        b_p_signed: in std_logic_vector(Nbit_b - 1 downto 0);
        p_signed: out std_logic_vector(Nbit_a + Nbit_b - 1 downto 0)
    );
end entity Parallel_Multiplier;

architecture rtl of Parallel_Multiplier is

    -- Building blocks of the Parallel Multiplier
    component Unsigned_Parallel_Multiplier
        generic(
            Nbit_a : positive;
            Nbit_b : positive
        );
        port(
            a_p: in  std_logic_vector(Nbit_a - 1 downto 0);
            b_p : in  std_logic_vector(Nbit_b - 1 downto 0);
            p   : out std_logic_vector(Nbit_a + Nbit_b - 1 downto 0)
        );
    end component Unsigned_Parallel_Multiplier;
    
	
	-- Unsigned component (will work for the unsigned parallel multiplier
    signal p_unsigned: std_logic_vector(Nbit_a + Nbit_b - 1 downto 0);
    signal a_p_unsigned: std_logic_vector(Nbit_a - 1 downto 0);
    signal b_p_unsigned: std_logic_vector(Nbit_b - 1 downto 0);
    
	-- will carry the sign bit for the signed rapresentation of the inputs
	signal a_sign: std_logic;
    signal b_sign: std_logic;
    
begin

	-- Compute the unsigned representation from the signed one
    a_p_unsigned <= std_logic_vector(abs(signed(a_p_signed)));
    b_p_unsigned <= std_logic_vector(abs(signed(b_p_signed)));
    
    -- 2's complement rapresentation, the result sign uis computed through the xor op. between a and b
    p_signed <= std_logic_vector(unsigned(not(p_unsigned)) + 1) when (((a_sign xor b_sign) = '1')) else p_unsigned;
    
	-- Getting of the sign from a and b (the MSB of the C2 representation)
    a_sign <= a_p_signed(Nbit_a - 1);
    b_sign <= b_p_signed(Nbit_b - 1);
    
    unsigned_parallel_mul: Unsigned_Parallel_Multiplier
        generic map(
            Nbit_a => Nbit_a,
            Nbit_b => Nbit_b
        )
        port map(
            a_p =>  a_p_unsigned,
            b_p =>  b_p_unsigned,
            p   => p_unsigned
        );
 
end architecture rtl; 