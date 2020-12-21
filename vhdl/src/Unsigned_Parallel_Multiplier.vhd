library IEEE;
use IEEE.std_logic_1164.all;

entity Unsigned_Parallel_Multiplier is
    generic (
        Nbit_a : positive; 
        Nbit_b: positive
    );
    port(
        -- Unsigned representation of inputs
        a_p: in std_logic_vector(Nbit_a - 1 downto 0);
        b_p: in std_logic_vector(Nbit_b - 1 downto 0);
        
        -- p = a_p * b_p
        p: out std_logic_vector(Nbit_a + Nbit_b - 1 downto 0)
    );
end entity Unsigned_Parallel_Multiplier;

architecture rtl of Unsigned_Parallel_Multiplier is
    -- Building blocks of the Unsigned Parallel Multiplier
    component FULL_ADDER is
    port
    (
        a    : IN std_logic ;
        b    : IN std_logic ;
        cin  : IN std_logic ;
        s    : OUT std_logic ;
        cout : OUT std_logic 
    );
    end component;
    
    component HALF_ADDER is
    port
    (
        a    : IN std_logic ;
        b    : IN std_logic ;
        s    : OUT std_logic ;
        cout : OUT std_logic 
    );
    end component;
    
    -- Will hold the carry signals among the whole architecture
    signal carry_signal: std_logic_vector((Nbit_a - 1)*(Nbit_b - 1) - 1 downto 0);
    signal last_carry_signal: std_logic_vector((Nbit_b - 1) downto 0);
    
    -- Will hold the sum result of the FA and HA among the whole architecture
    signal sum_signal: std_logic_vector((Nbit_a - 1)*(Nbit_b - 2) - 1 downto 0);  
    
    -- will hold the precomputed values for the inputs a and b of the various Half Adder and Full Adder
    signal a_multiplier: std_logic_vector(Nbit_a + Nbit_b - 2 downto 0);
    signal b_multiplier: std_logic_vector((Nbit_a - 1)*(Nbit_b - 1) - 1 downto 0);
    
begin
    
    -- First bit of the result
    p(0) <= (a_p(0) and b_p(0));
    
    
    -- Computation of the various inputs of each HA and FA
    d_process: process(a_p, b_p)
    begin
        
        for j in 1 to Nbit_b loop
            a_multiplier(j - 1) <= (a_p(0) and b_p(Nbit_b - j));
        end loop;
        
        for i in 2 to Nbit_a loop
            a_multiplier(Nbit_b + i - 2) <= (a_p(i - 1) and b_p(Nbit_b - 1));
        end loop;
        
        for i in 1 to Nbit_a-1 loop
            for j in 1 to Nbit_b - 1 loop
                b_multiplier((i-1)*(Nbit_b -1) + j - 1) <= (a_p(i) and b_p(Nbit_b - j - 1));
            end loop;
        end loop;
    end process d_process;
    
    
    -- Architecture will follow schema of the Parallel Multiplier
    -- Row index i
    GEN_a: for i in 1 to Nbit_a generate
        -- Column index j
        GEN_b: for j in 1 to Nbit_b - 1 generate 
        FIRST_ROW: if i=1 generate
                -- In the first Row only HA
                LEFT: if j < Nbit_b -1 generate
                    ROW1_LEFT: HALF_ADDER
                    port map
                    (
                        a    => a_multiplier(j - 1), 
                        b    => b_multiplier(j - 1), 
                        s    => sum_signal(j - 1), 
                        cout => carry_signal(j - 1) 
                    );
                end generate LEFT;
                RIGHT: if j = Nbit_b - 1 generate
                    ROW1_RIGHT: HALF_ADDER
                    port map
                    (
                        a    => a_multiplier(j - 1), 
                        b    => b_multiplier(j - 1), 
                        s    => p(1), -- Result bit 
                        cout => carry_signal(j - 1) 
                    );
                end generate RIGHT; 
            end generate FIRST_ROW;
            
            
            INTERNAL_ROW: if i > 1 and i < Nbit_a generate
                -- Internal Rows only FA
                LEFT: if j = 1 generate 
                    ROW_INT_LEFT: FULL_ADDER
                    port map
                    (
                        a => a_multiplier(Nbit_b + i - 2),  
                        b => b_multiplier((i-1)*(Nbit_b -1) + j - 1), 
                        cin => carry_signal((i-2)*(Nbit_b - 1) + (j-1)), 
                        s => sum_signal((i-1)*(Nbit_b - 2) + (j-1)), 
                        cout => carry_signal((i-1)*(Nbit_b - 1) + (j-1)) 
                    );
                end generate LEFT;
                CENTER: if j > 1 and j < Nbit_b - 1 generate
                    ROW_INT_CENTER: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-2)*(Nbit_b - 2) + (j-2)), 
                        b =>  b_multiplier((i-1)*(Nbit_b -1) + j - 1), 
                        cin => carry_signal((i-2)*(Nbit_b - 1) + (j-1)),
                        s => sum_signal((i-1)*(Nbit_b - 2) + (j-1)),
                        cout => carry_signal((i-1)*(Nbit_b - 1) + (j-1))
                    );
                end generate CENTER;
                RIGHT: if j = Nbit_b - 1 generate
                    ROW_INT_RIGHT: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-2)*(Nbit_b - 2) + (j-2)), 
                        b => b_multiplier((i-1)*(Nbit_b -1) + j - 1), 
                        cin => carry_signal((i-2)*(Nbit_b - 1) + (j-1)), 
                        s => p(i), -- Result bit
                        cout => carry_signal((i-1)*(Nbit_b - 1) + (j-1)) 
                    );
                end generate RIGHT;
            end generate INTERNAL_ROW;
            
            
            LAST_ROW: if i = Nbit_a generate
                -- Last row FA and an HA on the rightmost block
                LEFT: if j = 1 generate 
                    ROW_INT_LEFT: FULL_ADDER
                    port map
                    (
                        a => a_multiplier(Nbit_b + i - 2), 
                        b => carry_signal((i-2)*(Nbit_b - 1) + (j-1)), 
                        cin => last_carry_signal(Nbit_b - j), 
                        s => p((Nbit_a) + (Nbit_b) - 1 - j), -- Result bit
                        cout => p((Nbit_a) + (Nbit_b) -1) -- Result bit
                    );
                end generate LEFT;
                CENTER: if j > 1 and j < Nbit_b - 1 generate
                    ROW_INT_CENTER: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-2)*(Nbit_b - 2) + (j-2)), 
                        b =>  carry_signal((i-2)*(Nbit_b - 1) + (j-1)), 
                        cin => last_carry_signal(Nbit_b - j), 
                        s =>  p((Nbit_a) + (Nbit_b) - 1 - j), -- Result bit
                        cout =>last_carry_signal(Nbit_b - j + 1) 
                    );
                end generate CENTER;
                RIGHT: if j = Nbit_b - 1 generate
                    ROW_INT_RIGHT: HALF_ADDER
                    port map
                    (
                        a => sum_signal((i-2)*(Nbit_b - 2) + (j-2)),
                        b => carry_signal((i-2)*(Nbit_b - 1) + (j-1)), 
                        s => p((Nbit_a) + (Nbit_b) -1 - j), -- Result bit
                        cout =>last_carry_signal(Nbit_b - j + 1)
                    );
                end generate RIGHT;
            end generate LAST_ROW;
        end generate GEN_b;
    end generate GEN_a;
end architecture rtl; 