library IEEE;
use IEEE.std_logic_1164.all;

-- Realize a Ripple Carry Adder in a structural way

entity Ripple_Carry_Adder_Pipelined is
    generic (Nbit: positive);
    port(
        -- Inputs
        a_r: in std_logic_vector(Nbit-2 downto 0);
        b_r: in std_logic_vector(Nbit-2 downto 0);
        cin_r: in std_logic;
        cout_r: out std_logic;
        
        -- Will store the result of a_r+b_r
        s_r: out std_logic_vector(Nbit-1 downto 0);
        clk: in std_logic;
        rst: in std_logic
    );
end Ripple_Carry_Adder_Pipelined;

architecture rtl of Ripple_Carry_Adder_Pipelined is 
    -- Building blocks of the Ripple Carry Adder Pipelined 
    component FULL_ADDER
        port(
            a: in std_logic;
            b: in std_logic;
            cin: in std_logic;
            s: out std_logic;
            cout: out std_logic
        );
    end component FULL_ADDER;
    
    -- Need of a register to obtain the pipelined version
    component DFF
        port(
            d_dff      : in  std_logic;
            clk_dff    : in  std_logic;
            resetn_dff : in  std_logic;
            q_dff      : out std_logic
        );
    end component DFF;
    
    signal carry_signal: std_logic_vector(Nbit-1 downto 1);
    signal dff_signal: std_logic_vector(Nbit-1 downto 0) := (others => '0');
    
begin
    -- Implemented in a structured way in a similar fashion as seen in the Lab lessions
    GEN: for i in 1 to Nbit generate
        FIRST: if i=1 generate
            -- First FA
            FFI: FULL_ADDER port map (a_r(0), b_r(0), cin_r, s_r(0), carry_signal(1));
        end generate FIRST;
        INTERNAL: if i > 1 and i < Nbit generate
            -- Need of Register detection
            PIPE: if (i mod 3 = 0) generate
                DFF_I: DFF
                    port map(
                        d_dff      => carry_signal(i-1),
                        clk_dff    => clk,
                        resetn_dff => rst,
                        q_dff      => dff_signal(i-1)
                    );
                FFI: FULL_ADDER port map (a_r(i-1), b_r(i-1), dff_signal(i-1), s_r(i-1), carry_signal(i));
            end generate PIPE;
            -- No need of a register
            NOT_PIPE: if (i mod 3 /= 0) generate
                FFI: FULL_ADDER port map (a_r(i-1), b_r(i-1), carry_signal(i-1), s_r(i-1), carry_signal(i));
            end generate NOT_PIPE;           
        end generate INTERNAL;

        -- Implicit extension (the inputs have Nbit-2 bits, the output has Nbit-1 bits and there
        -- are Nbit-1 FA so the last bit is replicated in order to make the extension in the 
        -- correct way in C2 representation)

        LAST: if i=Nbit generate
            FFI: FULL_ADDER port map (a_r(Nbit-2), b_r(Nbit-2), carry_signal(Nbit-1), s_r(Nbit-1), cout_r);
        end generate LAST;
    end generate GEN;
end rtl;

