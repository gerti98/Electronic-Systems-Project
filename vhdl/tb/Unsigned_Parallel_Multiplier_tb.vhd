library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Unsigned_Parallel_Multiplier_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end Unsigned_Parallel_Multiplier_tb;


architecture bhv of Unsigned_Parallel_Multiplier_tb is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    constant N_BIT_A: integer := 8;
    constant N_BIT_B: integer := 9;
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    
    signal a_tb : std_logic_vector(N_BIT_A-1 downto 0) := (others => '0'); -- first operand 
    signal b_tb : std_logic_vector(N_BIT_B-1 downto 0) := (others => '0');
    signal p_tb : std_logic_vector((N_BIT_A) + (N_BIT_B)-1 downto 0);
    
    signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
    signal rst_tb  : std_logic := '0'; -- reset signal  
    signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    
    
    component Unsigned_Parallel_Multiplier
        generic(
            Nbit_a : positive;
            Nbit_b : positive
        );
        port(
            a_p : in  std_logic_vector(Nbit_a - 1 downto 0);
            b_p : in  std_logic_vector(Nbit_b - 1 downto 0);
            p   : out std_logic_vector(Nbit_a + Nbit_b - 1 downto 0)
        );
    end component Unsigned_Parallel_Multiplier;
begin
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
        rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
      
        test_parallel_multiplier: Unsigned_Parallel_Multiplier
            generic map(
                Nbit_a => N_BIT_A,
                Nbit_b => N_BIT_B
            )
            port map(
                a_p => a_tb,
                b_p => b_tb,
                p   => p_tb
            );
     
      
        d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
        variable t : integer := 0; -- variable used to count the clock cycle after the reset
        variable modt_b: integer := 0;
        variable modt_a: integer := 0;
        begin    
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is   -- specifying the input a_tb, b_tb and end_sim depending on the value of t ( and so on the number of the passed clock cycles).
                    when 40000 => end_sim <= '0'; -- This command stops the simulation when t = 10
                    when others => null; -- Specifying that nothing happens in the other cases 
                
                end case;
                case(modt_b) is
                    when 0 => b_tb <= std_logic_vector(unsigned(b_tb) +1);
                    when others => null; -- Specifying that nothing happens in the other cases
                end case;
                case(modt_a) is
                    when 0 => a_tb <= std_logic_vector(unsigned(a_tb) + 1);
                    when others => null; -- Specifying that nothing happens in the other cases
                end case;    
                t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
                modt_b := (t mod 5);
                modt_a := (t mod 160);   
            end if;
        end process d_process;
    
end bhv;