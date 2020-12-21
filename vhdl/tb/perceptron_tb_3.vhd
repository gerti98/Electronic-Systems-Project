library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Perceptron_tb_3 is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end Perceptron_tb_3;


architecture bhv of Perceptron_tb_3 is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    -- All max positive test
    
    signal x_1_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_2_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_3_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_4_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_5_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_6_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_7_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_8_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_9_tb : std_logic_vector(7 downto 0) := "01111111";
    signal x_10_tb : std_logic_vector(7 downto 0) := "01111111";
    
   
    signal w_1_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_2_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_3_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_4_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_5_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_6_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_7_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_8_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_9_tb : std_logic_vector(8 downto 0) := "011111111";
    signal w_10_tb : std_logic_vector(8 downto 0) := "011111111";
    
    
    signal b_tb : std_logic_vector(8 downto 0) := "000000000";
    signal f_z_tb: std_logic_vector(15 downto 0) := (others => '0');
    
    signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
    signal rst_tb  : std_logic := '0'; -- reset signal  
    signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    
    
    component Perceptron
        port(
            x_1  : in  std_logic_vector(7 downto 0);
            x_2  : in  std_logic_vector(7 downto 0);
            x_3  : in  std_logic_vector(7 downto 0);
            x_4  : in  std_logic_vector(7 downto 0);
            x_5  : in  std_logic_vector(7 downto 0);
            x_6  : in  std_logic_vector(7 downto 0);
            x_7  : in  std_logic_vector(7 downto 0);
            x_8  : in  std_logic_vector(7 downto 0);
            x_9  : in  std_logic_vector(7 downto 0);
            x_10 : in  std_logic_vector(7 downto 0);
            w_1  : in  std_logic_vector(8 downto 0);
            w_2  : in  std_logic_vector(8 downto 0);
            w_3  : in  std_logic_vector(8 downto 0);
            w_4  : in  std_logic_vector(8 downto 0);
            w_5  : in  std_logic_vector(8 downto 0);
            w_6  : in  std_logic_vector(8 downto 0);
            w_7  : in  std_logic_vector(8 downto 0);
            w_8  : in  std_logic_vector(8 downto 0);
            w_9  : in  std_logic_vector(8 downto 0);
            w_10 : in  std_logic_vector(8 downto 0);
            b    : in  std_logic_vector(8 downto 0);
            clk  : in  std_logic;
            rst  : in  std_logic;
            f_z  : out std_logic_vector(15 downto 0)
        );
    end component Perceptron;
begin
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
        rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
      
        test_parallel_multiplier:  Perceptron
            port map(
                x_1  => x_1_tb,
                x_2  => x_2_tb,
                x_3  => x_3_tb,
                x_4  => x_4_tb,
                x_5  => x_5_tb,
                x_6  => x_6_tb,
                x_7  => x_7_tb,
                x_8  => x_8_tb,
                x_9  => x_9_tb,
                x_10 => x_10_tb,
                w_1  => w_1_tb,
                w_2  => w_2_tb,
                w_3  => w_3_tb,
                w_4  => w_4_tb,
                w_5  => w_5_tb,
                w_6  => w_6_tb,
                w_7  => w_7_tb,
                w_8  => w_8_tb,
                w_9  => w_9_tb,
                w_10 => w_10_tb,
                b    => b_tb,
                clk  => clk_tb,
                rst  => rst_tb,
                f_z  => f_z_tb
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
                    when 10 => 
--                        x_1_tb <= std_logic_vector(signed(x_1_tb) +1);
--                        x_2_tb <= std_logic_vector(signed(x_2_tb) +1);
--                        x_3_tb <= std_logic_vector(signed(x_3_tb) +1);
--                        x_4_tb <= std_logic_vector(signed(x_4_tb) +1);
--                        x_5_tb <= std_logic_vector(signed(x_5_tb) +1);
--                        x_6_tb <= std_logic_vector(signed(x_6_tb) +1);
--                        x_7_tb <= std_logic_vector(signed(x_7_tb) +1);
--                        x_8_tb <= std_logic_vector(signed(x_8_tb) +1);
--                        x_9_tb <= std_logic_vector(signed(x_9_tb) +1);
--                        x_10_tb <= std_logic_vector(signed(x_10_tb) +1);
                        b_tb <= std_logic_vector(signed(b_tb) +1);
                    when others => null; -- Specifying that nothing happens in the other cases
                end case;
--                case(modt_a) is
--                    when 0 => 
--                        w_1_tb <= std_logic_vector(signed(w_1_tb) +1);
--                        w_2_tb <= std_logic_vector(signed(w_2_tb) +1);
--                        w_3_tb <= std_logic_vector(signed(w_3_tb) +1);
--                        w_4_tb <= std_logic_vector(signed(w_4_tb) +1);
--                        w_5_tb <= std_logic_vector(signed(w_5_tb) +1);
--                        w_6_tb <= std_logic_vector(signed(w_6_tb) +1);
--                        w_7_tb <= std_logic_vector(signed(w_7_tb) +1);
--                        w_8_tb <= std_logic_vector(signed(w_8_tb) +1);
--                        w_9_tb <= std_logic_vector(signed(w_9_tb) +1);
--                        w_10_tb <= std_logic_vector(signed(w_10_tb) +1);
--                    when others => null; -- Specifying that nothing happens in the other cases
--                end case;    
                t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
                modt_b := (t mod 20);
                modt_a := (t mod 160);   
            end if;
        end process d_process;
    
end bhv;