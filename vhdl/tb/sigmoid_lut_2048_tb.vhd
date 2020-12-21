library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sigmoid_lut_2048_tb is   -- The testbench has no interface, so it is an empty entity (Be careful: the keyword "is" was missing in the code written in class).
end sigmoid_lut_2048_tb;


architecture bhv of sigmoid_lut_2048_tb is -- Testbench architecture declaration
    -----------------------------------------------------------------------------------
    -- Testbench constants
    -----------------------------------------------------------------------------------
    constant T_CLK   : time := 10 ns; -- Clock period
    constant T_RESET : time := 25 ns; -- Period before the reset deassertion
    constant N_BIT : integer := 8;
    -----------------------------------------------------------------------------------
    -- Testbench signals
    -----------------------------------------------------------------------------------
    signal dds_out_tb       : std_logic_vector(15 downto 0); 
    signal address_tb       : std_logic_vector(10 downto 0);
    
    signal clk_tb : std_logic := '0'; -- clock signal, intialized to '0' 
    signal rst_tb  : std_logic := '0'; -- reset signal  
    signal end_sim : std_logic := '1'; -- signal to use to stop the simulation when there is nothing else to test
    signal t_tb : integer range 0 to 2047 := 0;
    
    component sigmoid_lut_2048
        port(
            address : in  std_logic_vector(10 downto 0);
            dds_out : out std_logic_vector(15 downto 0)
        );
    end component sigmoid_lut_2048;
    
    begin
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
        rst_tb <= '1' after T_RESET; -- Deasserting the reset after T_RESET nanosecods (remember: the reset is active low).
      
        test_ddfs: sigmoid_lut_2048
            port map(
                address => address_tb,
                dds_out => dds_out_tb
            );
        
      
        d_process: process(clk_tb, rst_tb) -- process used to make the testbench signals change synchronously with the rising edge of the clock
        variable t : integer := 0; -- variable used to count the clock cycle after the reset
        begin
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is   -- specifying the input a_tb, b_tb and end_sim depending on the value of t ( and so on the number of the passed clock cycles).
                    when 4096 => end_sim <= '0'; -- This command stops the simulation when t = 10
                    when others => address_tb <= std_logic_vector(to_unsigned(t_tb, 12)); -- Specifying that nothing happens in the other cases 
                
                end case;
                t := t + 1; -- the variable is updated exactly here (try to move this statement before the "case(t) is" one and watch the difference in the simulation)
                t_tb <= t_tb + 1;
            end if;
        end process d_process;
    
end bhv;