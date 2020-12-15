library IEEE;
use IEEE.std_logic_1164.all;

--TODO: double check correctenss of the generate

entity Parallel_Multiplier is
    generic (
        Nbit_a : positive; 
        Nbit_b: positive
    );
    port(
        a_p: in std_logic_vector(Nbit_a - 1 downto 0);
        b_p: in std_logic_vector(Nbit_b - 1 downto 0);
        p: out std_logic_vector(Nbit_a*Nbit_b - 1 downto 0)
    );
end entity Parallel_Multiplier;

architecture rtl of Parallel_Multiplier is
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
    
    signal carry_signal: std_logic_vector((Nbit_a - 1)*(Nbit_b - 1) - 1 downto 0);
    signal sum_signal: std_logic_vector((Nbit_a - 1)*(Nbit_b - 2) - 1 downto 0);    
    signal last_carry_signal: std_logic_vector((Nbit_b - 1) downto 0);
begin
    GEN_a: for i in 1 to Nbit_a - 1 generate
        GEN_b: for j in 1 to Nbit_b - 1 generate
            FIRST_ROW: if i=1 generate
                LEFT: if j < Nbit_b -1 generate
	                ROW1_LEFT: HALF_ADDER
	                port map
	                (
	                    a    => (a_p(0) and b_p(Nbit_b - j)),
	                    b    => (a_p(1) and b_p(Nbit_b - j)), 
	                    s    => sum_signal(j - 1),
	                    cout => carry_signal(j - 1)
	                );
	            end generate LEFT;
	            RIGHT: if j = Nbit_b - 1 generate
	            	ROW1_RIGHT: HALF_ADDER
	                port map
	                (
	                    a    => (a_p(0) and b_p(Nbit_b - j)),
	                    b    => (a_p(1) and b_p(Nbit_b - j)), 
	                    s    => p(0),
	                    cout => carry_signal(j - 1)
	                );
	            end generate RIGHT; 
	        end generate FIRST_ROW;
	        
	        
            INTERNAL_ROW: if i > 1 and i < Nbit_a - 1 generate
            	LEFT: if j < Nbit_b - 1 generate 
                	ROW_INT_LEFT: FULL_ADDER
                	port map
                	(
                		a => (a_p(i - 1) and b_p(Nbit_b - j)),
                		b => (a_p(i) and b_p(Nbit_b - j)),
                		cin => carry_signal((i-1)*(j-1)),
                		s => sum_signal((i)*(j-1)),
                		cout => carry_signal((i)*(j-1))
                	);
            	end generate LEFT;
            	CENTER: if j > 1 and j < Nbit_b - 1 generate
                    ROW_INT_CENTER: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-1)*(j-1)),
                        b =>  (a_p(i) and b_p(Nbit_b - j)),
                        cin => carry_signal((i-1)*(j-1)),
                        s => sum_signal((i)*(j-1)),
                        cout => carry_signal((i)*(j-1))
                    );
                end generate CENTER;
            	RIGHT: if j = Nbit_b - 1 generate
            	    ROW_INT_RIGHT: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-1)*(j-1)),
                        b => (a_p(i) and b_p(Nbit_b - j)),
                        cin => carry_signal((i-1)*(j-1)),
                        s => p(i),
                        cout => carry_signal((i)*(j-1))
                    );
            	end generate RIGHT;
            end generate INTERNAL_ROW;
            
            
            LAST_ROW: if i = Nbit_a -1 generate
                LEFT: if j = 1 generate 
                    ROW_INT_LEFT: FULL_ADDER
                    port map
                    (
                        a => (a_p(Nbit_a - 1) and b_p(Nbit_b - j)),
                        b => carry_signal((i-1)*(j-1)),
                        cin => last_carry_signal((Nbit_b - 1) - j),
                        s => p((Nbit_a)*(Nbit_b) -1 - j),
                        cout => p((Nbit_a)*(Nbit_b) -1)
                    );
                end generate LEFT;
                CENTER: if j > 1 and j < Nbit_b - 1 generate
                    ROW_INT_CENTER: FULL_ADDER
                    port map
                    (
                        a => sum_signal((i-1)*(j-1)),
                        b =>  carry_signal((i-1)*(j-1)),
                        cin => last_carry_signal((Nbit_b - 1) - j),
                        s =>  p((Nbit_a)*(Nbit_b) -1 - j),
                        cout =>last_carry_signal((Nbit_b - 1) - j - 1)
                    );
                end generate CENTER;
                RIGHT: if j = Nbit_b - 1 generate
                    ROW_INT_RIGHT: HALF_ADDER
                    port map
                    (
                        a => sum_signal((i-1)*(j-1)),
                        b => carry_signal((i-1)*(j-1)),
                        s => p((Nbit_a)*(Nbit_b) -1 - j),
                        cout => last_carry_signal((Nbit_b - 1) - j - 1)
                    );
                end generate RIGHT;
            end generate LAST_ROW;
        end generate GEN_b;
    end generate GEN_a;
    

end architecture rtl; 