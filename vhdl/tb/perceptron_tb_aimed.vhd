library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Perceptron_tb_Aimed is   
end Perceptron_tb_Aimed;


architecture bhv of Perceptron_tb_Aimed is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    
    signal x_1_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_2_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_3_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_4_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_5_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_6_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_7_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_8_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_9_tb : std_logic_vector(7 downto 0) := "10000000";
    signal x_10_tb : std_logic_vector(7 downto 0) := "10000000";
    
   
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
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;
        rst_tb <= '1' after T_RESET; 
      
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
     
      
        d_process: process(clk_tb, rst_tb) 
        variable t : integer := 0; 
        begin    
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is   
                    -- Test #2
                    when 2000 =>
                        x_1_tb <= "10100000";
                        x_2_tb <= "10100000";
                        x_3_tb <= "10100000";
                        x_4_tb <= "10100000";
                        x_5_tb <= "10100000";
                        x_6_tb <= "10100000";
                        x_7_tb <= "10100000";
                        x_8_tb <= "10100000";
                        x_9_tb <= "10100000";
                        x_10_tb <= "10100000";
                    
                    -- Test #3
                    when 4000 =>
                        x_1_tb <= "11000000";
                        x_2_tb <= "11000000";
                        x_3_tb <= "11000000";
                        x_4_tb <= "11000000";
                        x_5_tb <= "11000000";
                        x_6_tb <= "11000000";
                        x_7_tb <= "11000000";
                        x_8_tb <= "11000000";
                        x_9_tb <= "11000000";
                        x_10_tb <= "11000000";
                    
                    -- Test #4
                    when 6000 => 
                        w_1_tb <= "010000000";
                        w_2_tb <= "010000000";
                        w_3_tb <= "010000000";
                        w_4_tb <= "010000000";
                        w_5_tb <= "010000000";
                        w_6_tb <= "010000000";
                        w_7_tb <= "010000000";
                        w_8_tb <= "010000000";
                        w_9_tb <= "010000000";
                        w_10_tb <= "010000000";
                       
                    -- Test #5
                    when 8000 => 
                        w_1_tb <= "000000000";
                        w_2_tb <= "000000000";
                        w_3_tb <= "000000000";
                        w_4_tb <= "000000000";
                        w_5_tb <= "000000000";
                        w_6_tb <= "000000000";
                        w_7_tb <= "000000000";
                        w_8_tb <= "000000000";
                        w_9_tb <= "000000000";
                        w_10_tb <= "000000000";
                    
                    -- Test #6
                    when 10000 =>
                        w_1_tb <= "110000000";
                        w_2_tb <= "110000000";
                        w_3_tb <= "110000000";
                        w_4_tb <= "110000000";
                        w_5_tb <= "110000000";
                        w_6_tb <= "110000000";
                        w_7_tb <= "110000000";
                        w_8_tb <= "110000000";
                        w_9_tb <= "110000000";
                        w_10_tb <= "110000000";
                    
                    -- Test #7    
                when 12000 =>
                    
                        x_1_tb <= "01000000";
                        x_2_tb <= "01000000";
                        x_3_tb <= "01000000";
                        x_4_tb <= "01000000";
                        x_5_tb <= "01000000";
                        x_6_tb <= "01000000";
                        x_7_tb <= "01000000";
                        x_8_tb <= "01000000";
                        x_9_tb <= "01000000";
                        x_10_tb <= "01000000";
                        
                        w_1_tb <= "011111111";
                        w_2_tb <= "011111111";
                        w_3_tb <= "011111111";
                        w_4_tb <= "011111111";
                        w_5_tb <= "011111111";
                        w_6_tb <= "011111111";
                        w_7_tb <= "011111111";
                        w_8_tb <= "011111111";
                        w_9_tb <= "011111111";
                        w_10_tb <= "011111111";
                       
                    -- Test #8
                    when 14000 =>
                        x_1_tb <= "01100000";
                        x_2_tb <= "01100000";
                        x_3_tb <= "01100000";
                        x_4_tb <= "01100000";
                        x_5_tb <= "01100000";
                        x_6_tb <= "01100000";
                        x_7_tb <= "01100000";
                        x_8_tb <= "01100000";
                        x_9_tb <= "01100000";
                        x_10_tb <= "01100000";
                    
                    
                    --Test #9
                    when 16000 =>
                        x_1_tb <= "01111111";
                        x_2_tb <= "01111111";
                        x_3_tb <= "01111111";
                        x_4_tb <= "01111111";
                        x_5_tb <= "01111111";
                        x_6_tb <= "01111111";
                        x_7_tb <= "01111111";
                        x_8_tb <= "01111111";
                        x_9_tb <= "01111111";
                        x_10_tb <= "01111111";
                    
                    -- Test #10
                    when 18000 =>
                        b_tb <= "011111111";
                        
                        
                    -- Test #11    
                    when 20000 =>
                        b_tb <= "100000000";
                        x_1_tb <= "10000000";
                        x_2_tb <= "10000000";
                        x_3_tb <= "10000000";
                        x_4_tb <= "10000000";
                        x_5_tb <= "10000000";
                        x_6_tb <= "10000000";
                        x_7_tb <= "10000000";
                        x_8_tb <= "10000000";
                        x_9_tb <= "10000000";
                        x_10_tb <= "10000000";
                    when 22000 => end_sim <= '0'; 
                    when others => null;
                
                end case;
--               
                t := t + 1; 
            end if;
        end process d_process;
    
end bhv;