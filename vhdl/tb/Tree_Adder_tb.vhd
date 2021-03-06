library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Tree_Adder_tb is  
end Tree_Adder_tb;


architecture bhv of Tree_Adder_tb is 
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    
    
    signal in_1_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_2_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_3_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_4_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_5_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_6_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_7_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_8_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_9_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal in_10_tb: std_logic_vector(16 downto 0) := (others => '0');
    signal b_tb: std_logic_vector(8 downto 0) := (others => '0');
    
    signal z_tb: std_logic_vector(20 downto 0);
    
    signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
    signal rst_tb  : std_logic := '0'; -- reset signal  
    signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    
    
    component Tree_Adder
        port(
            in_1  : in  std_logic_vector(16 downto 0);
            in_2  : in  std_logic_vector(16 downto 0);
            in_3  : in  std_logic_vector(16 downto 0);
            in_4  : in  std_logic_vector(16 downto 0);
            in_5  : in  std_logic_vector(16 downto 0);
            in_6  : in  std_logic_vector(16 downto 0);
            in_7  : in  std_logic_vector(16 downto 0);
            in_8  : in  std_logic_vector(16 downto 0);
            in_9  : in  std_logic_vector(16 downto 0);
            in_10 : in  std_logic_vector(16 downto 0);
            b     : in  std_logic_vector(8 downto 0);
            clk   : in  std_logic;
            rst   : in  std_logic;
            z     : out std_logic_vector(20 downto 0)
        );
    end component Tree_Adder;
begin
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2; 
        rst_tb <= '1' after T_RESET; 
      
        test_tree_adder: Tree_Adder
            port map(
                in_1  => in_1_tb,
                in_2  => in_2_tb,
                in_3  => in_3_tb,
                in_4  => in_4_tb,
                in_5  => in_5_tb,
                in_6  => in_6_tb,
                in_7  => in_7_tb,
                in_8  => in_8_tb,
                in_9  => in_9_tb,
                in_10 => in_10_tb,
                b     => b_tb,
                clk   => clk_tb,
                rst   => rst_tb,
                z     => z_tb
            );
     
      
        d_process: process(clk_tb, rst_tb) 
        variable t : integer := 0;
        
        -- Variables that will be used to handle the incrementation of the inputs with a different velocity
        -- in order to see different outputs
        variable modt_b: integer := 0;
        begin    
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is  
                    when 40000 => end_sim <= '0'; 
                    when others => null;
                
                end case;
                case(modt_b) is
                    when 0 => 
                        in_1_tb <= std_logic_vector(signed(in_1_tb) +10);
                        in_2_tb <= std_logic_vector(signed(in_2_tb) +20);
                        in_3_tb <= std_logic_vector(signed(in_3_tb) +30);
                        in_4_tb <= std_logic_vector(signed(in_4_tb) +40);
                        in_5_tb <= std_logic_vector(signed(in_5_tb) +1);
                        in_6_tb <= std_logic_vector(signed(in_6_tb) +1);
                        in_7_tb <= std_logic_vector(signed(in_7_tb) +1);
                        in_8_tb <= std_logic_vector(signed(in_8_tb) +1);
                        in_9_tb <= std_logic_vector(signed(in_9_tb) +1);
                        in_10_tb <= std_logic_vector(signed(in_10_tb) +1);
                        b_tb <= std_logic_vector(signed(b_tb) + 1);
                    when others => null; 
                end case;
                t := t + 1; 
                modt_b := (t mod 10);
            end if;
        end process d_process;
    
end bhv;