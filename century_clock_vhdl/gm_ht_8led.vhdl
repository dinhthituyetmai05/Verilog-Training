entity gm_ht_8led is
    port (
        ckht:     in  std_logic;
        ena1khz:  in  std_logic;
        led70:    in  std_logic_vector(3 downto 0);
        led71:    in  std_logic_vector(3 downto 0);
        led72:    in  std_logic_vector(3 downto 0);
        led73:    in  std_logic_vector(3 downto 0);
        led74:    in  std_logic_vector(3 downto 0);
        led75:    in  std_logic_vector(3 downto 0);
        led76:    in  std_logic_vector(3 downto 0);
        led77:    in  std_logic_vector(3 downto 0);
        dc_8led:  in  std_logic_vector(7 downto 0);
        ena_8led: in  std_logic_vector(7 downto 0);
        anode:    out std_logic_vector(7 downto 0);
        sseg:     out std_logic_vector(7 downto 0)
    );
end gm_ht_8led;

architecture behavioral of gm_ht_8led is
    signal s3b:      std_logic_vector(2 downto 0);
    signal so_gma:   std_logic_vector(3 downto 0);
    signal dc_1led:  std_logic;
    signal ena_1led: std_logic;
begin
    K1: entity work.dem_3bit
        port map (
            ena1khz => ena1khz,
            ckht    => ckht,
            q       => s3b
        );

    K2: entity work.giaima_38h
        port map (
            i => s3b,
            o => anode
        );

    K3: entity work.dahop_8kenh
        port map (
            s    => s3b,
            dc8  => dc_8led,
            dc1  => dc_1led,
            ena8 => ena_8led,
            ena1 => ena_1led,
            i0   => led70,
            i1   => led71,
            i2   => led72,
            i3   => led73,
            i4   => led74,
            i5   => led75,
            i6   => led76,
            i7   => led77,
            o    => so_gma
        );

    K4: entity work.giaima_7doan_ena
        port map (
            so_gma => so_gma,
            dp     => dc_1led,
            ena    => ena_1led,
            sseg   => sseg
        );
end behavioral;

--K1:


entity dem_3bit is
    port (
        ckht:    in  std_logic;
        ena1khz: in  std_logic;
        q:       out std_logic_vector(2 downto 0)
    );
end dem_3bit;

architecture behavioral of dem_3bit is
    signal q_r: std_logic_vector(2 downto 0) := "000";
    signal q_n: std_logic_vector(2 downto 0) := "000";
begin
    process (ckht)
    begin
        if falling_edge(ckht) then
            q_r <= q_n;
        end if;
    end process;

    q_n <= std_logic_vector(unsigned(q_r) + 1) when ena1khz = '1' else
           q_r;
    q <= q_r;
end behavioral;


--K2:


entity giaima_38h is
    port (
        i: in  std_logic_vector(2 downto 0);
        o: out std_logic_vector(7 downto 0)
    );
end giaima_38h;

architecture behavioral of giaima_38h is
begin
    process(i)
    begin
        case i is
            when "000"  => o <= "00000001";
            when "001"  => o <= "00000010";
            when "010"  => o <= "00000100";
            when "011"  => o <= "00001000";
            when "100"  => o <= "00010000";
            when "101"  => o <= "00100000";
            when "110"  => o <= "01000000";
            when others => o <= "10000000";
        end case;
    end process;
end behavioral;

--K3:


entity dahop_8kenh is
    port (
        s:    in  std_logic_vector(2 downto 0);
        dc8:  in  std_logic_vector(7 downto 0);
        dc1:  out std_logic;
        ena8: in  std_logic_vector(7 downto 0);
        ena1: out std_logic;
        i0:   in  std_logic_vector(3 downto 0);
        i1:   in  std_logic_vector(3 downto 0);
        i2:   in  std_logic_vector(3 downto 0);
        i3:   in  std_logic_vector(3 downto 0);
        i4:   in  std_logic_vector(3 downto 0);
        i5:   in  std_logic_vector(3 downto 0);
        i6:   in  std_logic_vector(3 downto 0);
        i7:   in  std_logic_vector(3 downto 0);
        o:    out std_logic_vector(3 downto 0)
    );
end dahop_8kenh;

architecture behavioral of dahop_8kenh is
begin
    process(s, i0, i1, i2, i3, i4, i5, i6, i7, dc8, ena8)
    begin
        case s is
            when "000" =>
                o <= i0;
                dc1 <= dc8(0);
                ena1 <= ena8(0);
            when "001" =>
                o <= i1;
                dc1 <= dc8(1);
                ena1 <= ena8(1);
            when "010" =>
                o <= i2;
                dc1 <= dc8(2);
                ena1 <= ena8(2);
            when "011" =>
                o <= i3;
                dc1 <= dc8(3);
                ena1 <= ena8(3);
            when "100" =>
                o <= i4;
                dc1 <= dc8(4);
                ena1 <= ena8(4);
            when "101" =>
                o <= i5;
                dc1 <= dc8(5);
                ena1 <= ena8(5);
            when "110" =>
                o <= i6;
                dc1 <= dc8(6);
                ena1 <= ena8(6);
            when others =>
                o <= i7;
                dc1 <= dc8(7);
                ena1 <= ena8(7);
        end case;
    end process;
end behavioral;

--K4:


entity giaima_7doan_ena is
    port (
        so_gma: in  std_logic_vector(3 downto 0);
        ena, dp:  in  std_logic;
        sseg:   out std_logic_vector(7 downto 0)
    );
end giaima_7doan_ena;

architecture behavioral of giaima_7doan_ena is
    signal ss7: std_logic_vector(6 downto 0);
    signal ss8: std_logic_vector(7 downto 0);
begin
    -- Giả định rằng 'dp' là bit thứ 8 (bit dấu chấm thập phân)
    ss8 <= dp & ss7;
    sseg <= ss8 when ena = '1' else x"00";

    process(so_gma)
    begin
        case so_gma is
            when x"0"   => ss7 <= "0111111"; -- 0
            when x"1"   => ss7 <= "0000110"; -- 1
            when x"2"   => ss7 <= "1011011"; -- 2
            when x"3"   => ss7 <= "1001111"; -- 3
            when x"4"   => ss7 <= "1100110"; -- 4
            when x"5"   => ss7 <= "1101101"; -- 5
            when x"6"   => ss7 <= "1111101"; -- 6
            when x"7"   => ss7 <= "0000111"; -- 7
            when x"8"   => ss7 <= "1111111"; -- 8
            when x"9"   => ss7 <= "1101111"; -- 9
            when x"a"   => ss7 <= "1110111"; -- A
            when x"b"   => ss7 <= "1111100"; -- b
            when x"c"   => ss7 <= "0111001"; -- C
            when x"d"   => ss7 <= "1011110"; -- d
            when x"e"   => ss7 <= "1111001"; -- E
            when others => ss7 <= "1110001"; -- F (giả định)
        end case;
    end process;
end behavioral;