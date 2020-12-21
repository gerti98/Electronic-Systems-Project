library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Unsigned_Parallel_Multiplier_tb is  
end Unsigned_Parallel_Multiplier_tb;


architecture bhv of Unsigned_Parallel_Multiplier_tb is
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
    
    signal a_tb : std_logic_vector(N_BIT_A-1 downto 0) := (others => '0');
    signal b_tb : std_logic_vector(N_BIT_B-1 downto 0) := (others => '0');
    signal p_tb : std_logic_vector((N_BIT_A) + (N_BIT_B)-1 downto 0);
    
    signal clk_tb : std_logic := '0';
    signal rst_tb  : std_logic := '0';
    signal end_sim : std_logic := '1';
    
    
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
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
        rst_tb <= '1' after T_RESET;
      
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
     
      
        d_process: process(clk_tb, rst_tb)
        variable t : integer := 0;

        -- Variables that will be used to handle the incrementation of the inputs with a different velocity
        -- in order to see different outputs
        variable modt_b: integer := 0;
        variable modt_a: integer := 0;
        begin    
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is 
                    when 40000 => end_sim <= '0';
                    when others => null;
                
                end case;
                case(modt_b) is
                    when 0 => b_tb <= std_logic_vector(unsigned(b_tb) +1);
                    when others => null;
                end case;
                case(modt_a) is
                    when 0 => a_tb <= std_logic_vector(unsigned(a_tb) + 1);
                    when others => null;
                end case;    
                t := t + 1;
                modt_b := (t mod 5);
                modt_a := (t mod 160);   
            end if;
        end process d_process;
    
end bhv;