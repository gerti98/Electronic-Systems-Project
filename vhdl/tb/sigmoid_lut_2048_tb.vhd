library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sigmoid_lut_2048_tb is  
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
    
        clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2; 
        rst_tb <= '1' after T_RESET; 
      
        test_ddfs: sigmoid_lut_2048
            port map(
                address => address_tb,
                dds_out => dds_out_tb
            );
        
      
        d_process: process(clk_tb, rst_tb)
        variable t : integer := 0;
        begin
            if(rst_tb = '0') then
                t := 0;
            elsif(rising_edge(clk_tb)) then
                case(t) is  
                    when 4096 => end_sim <= '0';
                    when others => address_tb <= std_logic_vector(to_unsigned(t_tb, 12)); 
                
                end case;
                t := t + 1; 
                t_tb <= t_tb + 1;
            end if;
        end process d_process;
    
end bhv;