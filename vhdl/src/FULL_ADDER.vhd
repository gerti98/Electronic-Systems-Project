
library IEEE;
use IEEE.std_logic_1164.all;

entity FULL_ADDER is
    port(
        a: in std_logic;
        b: in std_logic;
        cin: in std_logic;
        s: out std_logic;
        cout: out std_logic
    );
end FULL_ADDER;

architecture DataFlow of FULL_ADDER is
begin 
    s <= a xor (b xor cin);
    cout <= (b and cin) or (a and b) or (a and cin);
end DataFlow;