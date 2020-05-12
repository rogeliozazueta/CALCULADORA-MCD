library ieee;
use ieee.std_logic_1164.all;

entity controller is 
    port(
        X_i, Y_i : out std_logic_vector(3 downto 0);
        X_sel, Y_sel: out std_logic;
        X_ld, Y_ld : out std_logic;
        X_sub, Y_sub : out std_logic;
        O_enb : out std_logic;
        timer : in std_logic;
        X_gt_Y, X_eq_Y, X_lt_Y : in std_logic --ENTRADAS QUE RECIBE DEL DATAPATH
        );
end controller;

architecture behave of controller is
    type state_type is (LESS, EQUAL, GREATER); 
    signal present_state, future_state : state_type;
    signal X_gt_Y1, X_eq_Y1, X_lt_Y1 : std_logic;
begin

--- SECUENCIAL
    process (timer)
    begin
    --  if timer = '1' and timer'event then
        if rising_edge(timer) then
            present_state <= future_state;
        end if;
    end process;

--- COMBINACIONAL
    process(X_gt_Y,X_eq_Y,X_lt_Y,present_state)
    begin
    X_sel <= '0';
    Y_sel <= '0';
    X_ld <= '1';
    Y_ld <= '1';
    X_sub <= '0';
    Y_sub <= '1';
    O_enb <= '0';
    future_state <= present_state;
    X_gt_Y1 <= X_gt_Y;
    X_eq_Y1 <= X_eq_Y;
    X_lt_Y1 <= X_lt_Y;
    case(present_state) is
        when LESS =>
        X_sel <= '1';
        Y_sel <= '1';
        X_ld <= '1';
        Y_ld <= '1';
        X_sub <= '0';
        Y_sub <= '1';
        O_enb <= '0';
        if(X_lt_Y1='1') then future_state <= LESS;
        elsif (X_gt_Y1='1') then future_state <= GREATER;  
        else future_state <= EQUAL;
        end if;
        when EQUAL =>
        X_sel <= '0';
        Y_sel <= '0';
        X_ld <= '0';
        Y_ld <= '0';
        X_sub <= '0';
        Y_sub <= '0';
        O_enb <= '1';
        if(X_lt_Y1='1') then future_state <= EQUAL;
        elsif (X_gt_Y1='1') then future_state <= EQUAL;  
        else future_state <= EQUAL;
        end if;
        when GREATER =>
        X_sel <= '0';
        Y_sel <= '0';
        X_ld <= '0';
        Y_ld <= '0';
        X_sub <= '0';
        Y_sub <= '0';
        O_enb <= '0';
        if(X_lt_Y1='1') then future_state <= GREATER;
        elsif (X_gt_Y1='0') then future_state <= GREATER;  
        else future_state <= GREATER   ;
        end if;
    end case;
end process;
end behave ;