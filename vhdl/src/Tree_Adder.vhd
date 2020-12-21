library IEEE;
use IEEE.std_logic_1164.all;

entity Tree_Adder is
    port(
        -- Inputs: result of the multiplication of xi*wi
        in_1: in std_logic_vector(16 downto 0);
        in_2: in std_logic_vector(16 downto 0);
        in_3: in std_logic_vector(16 downto 0);
        in_4: in std_logic_vector(16 downto 0);
        in_5: in std_logic_vector(16 downto 0);
        in_6: in std_logic_vector(16 downto 0);
        in_7: in std_logic_vector(16 downto 0);
        in_8: in std_logic_vector(16 downto 0);
        in_9: in std_logic_vector(16 downto 0);
        in_10: in std_logic_vector(16 downto 0);
        
        -- Bias input
        b: in std_logic_vector(8 downto 0);

        clk: in std_logic;
        rst: in std_logic;
        
        -- Output
        z: out std_logic_vector(20 downto 0)
    );
end Tree_Adder;

architecture rtl of Tree_Adder is 
    -- Building block that will perform the single summation
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
    
    -- Output of each Ripple carry Adder will be stored in a register
    component Parallel_DFF
        generic(Nbit : integer);
        port(
            d_dff      : in  std_logic_vector(Nbit - 1 downto 0);
            clk_dff    : in  std_logic;
            resetn_dff : in  std_logic;
            q_dff      : out std_logic_vector(Nbit - 1 downto 0)
        );
    end component Parallel_DFF;       

    -- Intermediate signals for every level of the tree adder
    signal first_level_out1: std_logic_vector(17 downto 0);
    signal first_level_out2: std_logic_vector(17 downto 0);
    signal first_level_out3: std_logic_vector(17 downto 0);
    signal first_level_out4: std_logic_vector(17 downto 0);
    signal first_level_out5: std_logic_vector(17 downto 0);
    
    signal second_level_in1: std_logic_vector(17 downto 0);
    signal second_level_in2: std_logic_vector(17 downto 0);
    signal second_level_in3: std_logic_vector(17 downto 0);
    signal second_level_in4: std_logic_vector(17 downto 0);
    signal second_level_in5: std_logic_vector(17 downto 0);
    
    signal second_level_out1: std_logic_vector(18 downto 0);
    signal second_level_out2: std_logic_vector(18 downto 0);
    signal second_level_out3: std_logic_vector(18 downto 0);
    
    signal third_level_in1: std_logic_vector(18 downto 0);
    signal third_level_in2: std_logic_vector(18 downto 0);
    
    signal third_level_out1: std_logic_vector(19 downto 0);
    
    signal fourth_level_in1: std_logic_vector(19 downto 0);
    signal fourth_level_in2: std_logic_vector(19 downto 0);
    
begin
    -- A Structured approach was not possible due to the format of the inputs
    -- In fact there is not a single std_logic_vector, which would grant a possibility to exploit the
    -- structured approach, but many std_logic_vector with 17 bits
    -- FIRST LEVEL
    sum_1_1: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 18
        )
        port map(
            a_r    => in_1,
            b_r    => in_2,
            cin_r  => '0',
            cout_r => open,
            s_r    => first_level_out1,
            clk    => clk,
            rst    => rst
        );
    reg_1_1: Parallel_DFF
        generic map(
            Nbit => 18
        )
        port map(
            d_dff      => first_level_out1,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => second_level_in1
        );
    sum_1_2: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 18
        )
        port map(
            a_r    => in_3,
            b_r    => in_4,
            cin_r  => '0',
            cout_r => open,
            s_r    => first_level_out2,
            clk    => clk,
            rst    => rst
        );
    reg_1_2: Parallel_DFF
        generic map(
            Nbit => 18
        )
        port map(
            d_dff      => first_level_out2,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => second_level_in2
        );
    sum_1_3: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 18
        )
        port map(
            a_r    => in_5,
            b_r    => in_6,
            cin_r  => '0',
            cout_r => open,
            s_r    => first_level_out3,
            clk    => clk,
            rst    => rst
        );
    reg_1_3: Parallel_DFF
        generic map(
            Nbit => 18
        )
        port map(
            d_dff      => first_level_out3,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => second_level_in3
        );
    sum_1_4: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 18
        )
        port map(
            a_r    => in_7,
            b_r    => in_8,
            cin_r  => '0',
            cout_r => open,
            s_r    => first_level_out4,
            clk    => clk,
            rst    => rst
        );
    reg_1_4: Parallel_DFF
        generic map(
            Nbit => 18
        )
        port map(
            d_dff      => first_level_out4,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => second_level_in4
        );
    sum_1_5: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 18
        )
        port map(
            a_r    => in_9,
            b_r    => in_10,
            cin_r  => '0',
            cout_r => open,
            s_r    => first_level_out5,
            clk    => clk,
            rst    => rst
        );
    reg_1_5: Parallel_DFF
        generic map(
            Nbit => 18
        )
        port map(
            d_dff      => first_level_out5,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => second_level_in5
        );
    
    --SECOND LEVEL
    sum_2_1: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 19
        )
        port map(
            a_r    => second_level_in1,
            b_r    => second_level_in2,
            cin_r  => '0',
            cout_r => open,
            s_r    => second_level_out1,
            clk    => clk,
            rst    => rst
        );
    reg_2_1: Parallel_DFF
        generic map(
            Nbit => 19
        )
        port map(
            d_dff      => second_level_out1,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => third_level_in1
        );
    sum_2_2: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 19
        )
        port map(
            a_r    => second_level_in3,
            b_r    => second_level_in4,
            cin_r  => '0',
            cout_r => open,
            s_r    => second_level_out2,
            clk    => clk,
            rst    => rst
        );
    reg_2_2: Parallel_DFF
        generic map(
            Nbit => 19
        )
        port map(
            d_dff      => second_level_out2,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => third_level_in2
        );
    sum_2_3: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 19
        )
        port map(
            a_r    => second_level_in5,
            b_r(8 downto 0) => "000000000",
            b_r(17 downto 9) => b,
            cin_r  => '0',
            cout_r => open,
            s_r    => second_level_out3,
            clk    => clk,
            rst    => rst
        );
    reg_2_3: Parallel_DFF
        generic map(
            Nbit => 20
        )
        port map(
            d_dff(18 downto 0) => second_level_out3,
            d_dff(19) => second_level_out3(18),
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => fourth_level_in2
        );
        
    --- THIRD LEVEL
    sum_3_1: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 20
        )
        port map(
            a_r    => third_level_in1,
            b_r    => third_level_in2,
            cin_r  => '0',
            cout_r => open,
            s_r    => third_level_out1,
            clk    => clk,
            rst    => rst
        );
    reg_3_1: Parallel_DFF
        generic map(
            Nbit => 20
        )
        port map(
            d_dff      => third_level_out1,
            clk_dff    => clk,
            resetn_dff => rst,
            q_dff      => fourth_level_in1
        );
    --- FOURTH LEVEL
    sum_4_1: Ripple_Carry_Adder_Pipelined
        generic map(
            Nbit => 21
        )
        port map(
            a_r    => fourth_level_in1,
            b_r    => fourth_level_in2,
            cin_r  => '0',
            cout_r => open,
            s_r    => z,
            clk    => clk,
            rst    => rst
        );
        
end rtl;