
library IEEE;
use IEEE.std_logic_1164.all;

entity HALF_ADDER is
    port(
        a: in std_logic;
        b: in std_logic;
        s: out std_logic;
        cout: out std_logic
    );
end HALF_ADDER;

architecture DataFlow of HALF_ADDER is
begin 
    s <= a xor b;
    cout <= (a and b);
end DataFlow;