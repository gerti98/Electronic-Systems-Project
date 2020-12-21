library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity Perceptron is
    port(
        
        x_1: in std_logic_vector(7 downto 0);
        x_2: in std_logic_vector(7 downto 0);
        x_3: in std_logic_vector(7 downto 0);
        x_4: in std_logic_vector(7 downto 0);
        x_5: in std_logic_vector(7 downto 0);
        x_6: in std_logic_vector(7 downto 0);
        x_7: in std_logic_vector(7 downto 0);
        x_8: in std_logic_vector(7 downto 0);
        x_9: in std_logic_vector(7 downto 0);
        x_10: in std_logic_vector(7 downto 0);
        
        w_1: in std_logic_vector(8 downto 0);
        w_2: in std_logic_vector(8 downto 0);
        w_3: in std_logic_vector(8 downto 0);
        w_4: in std_logic_vector(8 downto 0);
        w_5: in std_logic_vector(8 downto 0);
        w_6: in std_logic_vector(8 downto 0);
        w_7: in std_logic_vector(8 downto 0);
        w_8: in std_logic_vector(8 downto 0);
        w_9: in std_logic_vector(8 downto 0);
        w_10: in std_logic_vector(8 downto 0);
        
        b: in std_logic_vector(8 downto 0);
        clk: in std_logic;
        rst: in std_logic;
        
        f_z: out std_logic_vector(15 downto 0)
    );
end Perceptron;

architecture rtl of Perceptron is
    component Parallel_DFF
        generic(Nbit : integer);
        port(
            d_dff      : in  std_logic_vector(Nbit - 1 downto 0);
            clk_dff    : in  std_logic;
            resetn_dff : in  std_logic;
            q_dff      : out std_logic_vector(Nbit - 1 downto 0)
        );
    end component Parallel_DFF;
    
    component Parallel_Multiplier
        generic(
            Nbit_a : positive;
            Nbit_b : positive
        );
        port(
            a_p_signed : in  std_logic_vector(Nbit_a - 1 downto 0);
            b_p_signed : in  std_logic_vector(Nbit_b - 1 downto 0);
            p_signed   : out std_logic_vector(Nbit_a + Nbit_b - 1 downto 0)
        );
    end component Parallel_Multiplier;
    
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
    
    component sigmoid_lut_2048
        port(
            address : in  std_logic_vector(10 downto 0);
            dds_out : out std_logic_vector(15 downto 0)
        );
    end component sigmoid_lut_2048;
    
    signal xw_1 : std_logic_vector(16 downto 0);
    signal xw_2 : std_logic_vector(16 downto 0);
    signal xw_3 : std_logic_vector(16 downto 0);
    signal xw_4 : std_logic_vector(16 downto 0);
    signal xw_5 : std_logic_vector(16 downto 0);
    signal xw_6 : std_logic_vector(16 downto 0);
    signal xw_7 : std_logic_vector(16 downto 0);
    signal xw_8 : std_logic_vector(16 downto 0);
    signal xw_9 : std_logic_vector(16 downto 0);
    signal xw_10 : std_logic_vector(16 downto 0);
    
    signal xw_1_in : std_logic_vector(16 downto 0);
    signal xw_2_in : std_logic_vector(16 downto 0);
    signal xw_3_in : std_logic_vector(16 downto 0);
    signal xw_4_in : std_logic_vector(16 downto 0);
    signal xw_5_in : std_logic_vector(16 downto 0);
    signal xw_6_in : std_logic_vector(16 downto 0);
    signal xw_7_in : std_logic_vector(16 downto 0);
    signal xw_8_in : std_logic_vector(16 downto 0);
    signal xw_9_in : std_logic_vector(16 downto 0);
    signal xw_10_in : std_logic_vector(16 downto 0);
    
    signal z : std_logic_vector(20 downto 0);
    signal z_in : std_logic_vector(20 downto 0);
    signal z_in_lut: std_logic_vector(20 downto 0);
    signal f_z_todo : std_logic_vector(15 downto 0);
    
begin
    -- Multiplications
    MUL_1: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_1,
            b_p_signed => w_1,
            p_signed   => xw_1
        );
    REG_1: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_1,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_1_in
        );
        
    MUL_2: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_2,
            b_p_signed => w_2,
            p_signed   => xw_2
        );
    REG_2: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_2,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_2_in
        );
    MUL_3: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_3,
            b_p_signed => w_3,
            p_signed   => xw_3
        );
    REG_3: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_3,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_3_in
        );
    MUL_4: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_4,
            b_p_signed => w_4,
            p_signed   => xw_4
        );
    REG_4: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_4,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_4_in
        );
   MUL_5: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_5,
            b_p_signed => w_5,
            p_signed   => xw_5
        );
    REG_5: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_5,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_5_in
        );
    MUL_6: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_6,
            b_p_signed => w_6,
            p_signed   => xw_6
        );
    REG_6: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_6,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_6_in
        );
    MUL_7: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_7,
            b_p_signed => w_7,
            p_signed   => xw_7
        );
    REG_7: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_7,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_7_in
        );
    MUL_8: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_8,
            b_p_signed => w_8,
            p_signed   => xw_8
        );
    REG_8: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_8,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_8_in
        );
    MUL_9: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_9,
            b_p_signed => w_9,
            p_signed   => xw_9
        );
    REG_9: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_9,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_9_in
        );
    MUL_10: Parallel_Multiplier
        generic map(
            Nbit_a => 8,
            Nbit_b => 9
        )
        port map(
            a_p_signed => x_10,
            b_p_signed => w_10,
            p_signed   => xw_10
        );
    REG_10: Parallel_DFF
        generic map(
            Nbit => 17
        )
        port map(
            d_dff      => xw_10,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => xw_10_in
        );
    
    -- Tree Adder
    TREE_ADD: Tree_Adder
        port map(
            in_1  => xw_1_in,
            in_2  => xw_2_in,
            in_3  => xw_3_in,
            in_4  => xw_4_in,
            in_5  => xw_5_in,
            in_6  => xw_6_in,
            in_7  => xw_7_in,
            in_8  => xw_8_in,
            in_9  => xw_9_in,
            in_10 => xw_10_in,
            b     => b,
            clk   => clk,
            rst   => rst,
            z     => z
        );
        
    REG_TREE: Parallel_DFF
        generic map(
            Nbit => 21
        )
        port map(
            d_dff      => z,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => z_in
        );
        
    LUT: sigmoid_lut_2048
        port map(
            address => z_in_lut(19 downto 9),
            dds_out => f_z_todo
        );
    
    d_process: process(clk, rst)
    begin
        if(z_in(20) = '1') then
            z_in_lut <= std_logic_vector(unsigned(not(z_in)) + 1);
        else
            z_in_lut <= z_in;
        end if;
        
        --f_z <= std_logic_vector(32766 - unsigned(f_z_todo));
        if (z_in(20) = '1') then 
            f_z <= std_logic_vector(32766 - unsigned(f_z_todo));
        else
            f_z <= std_logic_vector(unsigned(f_z_todo));
        end if;
    end process d_process;
    
end rtl; 