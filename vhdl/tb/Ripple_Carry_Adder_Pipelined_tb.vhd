library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Ripple_Carry_Adder_Pipelined_tb is   
end Ripple_Carry_Adder_Pipelined_tb;


architecture bhv of Ripple_Carry_Adder_Pipelined_tb is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    constant N_BIT: integer := 9;
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    
    signal a_tb : std_logic_vector(N_BIT-2 downto 0) := (others => '0'); -- first operand 
    signal b_tb : std_logic_vector(N_BIT-2 downto 0) := (others => '0');
    signal s_tb : std_logic_vector(N_BIT-1 downto 0) := (others => '0');
    
    signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
    signal rst_tb  : std_logic := '0'; -- reset signal  
    signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    signal tmp: std_logic;
    
    component Ripple_Carry_Adder_Pipelined
        generic(Nbit : positive);
        port(
            a_r    : in  std_logic_vector(Nbit - 2 downto 0);
            b_r    : in  std_logic_vector(Nbit - 2 downto 0);
            cin_r  : in  std_logic;
            cout_r : out std_logic;
            s_r    : out std_logic_vector(Nbit - 1 downto 0);
            clk    : in  std_logic;
            rst    : in  std_logic
        );
    end component Ripple_Carry_Adder_Pipelined;
begin
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2; 
        rst_tb <= '1' after T_RESET; 
      
        test_parallel_multiplier:  Ripple_Carry_Adder_Pipelined
            generic map(
                Nbit => N_BIT
            )
            port map(
                a_r    => a_tb,
                b_r    => b_tb,
                cin_r  => '0',
                cout_r => tmp,
                s_r    => s_tb(N_BIT-1 downto 0),
                clk    => clk_tb,
                rst    => rst_tb
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
                    when 0 => b_tb <= std_logic_vector(signed(b_tb) +1);
                    when others => null; 
                end case;
                case(modt_a) is
                    when 0 => a_tb <= std_logic_vector(signed(a_tb) + 1);
                    when others => null; 
                end case;    
                t := t + 1; 
                modt_b := (t mod 5);
                modt_a := (t mod 160);   
            end if;
        end process d_process;
    
end bhv;