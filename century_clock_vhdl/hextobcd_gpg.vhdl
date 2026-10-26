entity hextobcd_gpg is
    Port(
        gio:   in std_logic_vector(5 downto 0);
        phut:  in std_logic_vector(5 downto 0);
        giay:  in std_logic_vector(5 downto 0);
        ch_gio:  out std_logic_vector(3 downto 0);
        dv_gio:  out std_logic_vector(3 downto 0);
        ch_phut: out std_logic_vector(3 downto 0);
        dv_phut: out std_logic_vector(3 downto 0);
        ch_giay: out std_logic_vector(3 downto 0);
        dv_giay: out std_logic_vector(3 downto 0)
    );
end hextobcd_gpg;

architecture Behavioral of hextobcd_gpg is
begin
    K1: entity work.hextobcd_6bit
        port map(
            sohex6bit => gio,
            donvi     => dv_gio,
            chuc      => ch_gio
        );

    K2: entity work.hextobcd_6bit
        port map(
            sohex6bit => phut,
            donvi     => dv_phut,
            chuc      => ch_phut
        );

    K3: entity work.hextobcd_6bit
        port map(
            sohex6bit => giay,
            donvi     => dv_giay,
            chuc      => ch_giay
        );
end Behavioral;

entity hextobcd_6bit is
    port (
        sohex6bit: in  std_logic_vector(5 downto 0);
        donvi, chuc: out std_logic_vector(3 downto 0)
    );
end hextobcd_6bit;

architecture Behavioral of hextobcd_6bit is
begin
    process(sohex6bit)
        variable bcd_hex: std_logic_vector(13 downto 0);
        variable dem: integer range 0 to 5;
    begin
        bcd_hex := "00000000" & sohex6bit;
        dem := 5;

        while dem > 0 loop
            bcd_hex := bcd_hex(12 downto 0) & '0';
            dem := dem - 1;
            if bcd_hex(9 downto 6) >= "0101" then
                bcd_hex(9 downto 6) := std_logic_vector(unsigned(bcd_hex(9 downto 6)) + unsigned'("0011"));
            end if;
        end loop;

        -- Dòng này có vẻ như là một sự nhầm lẫn hoặc lặp lại trong ảnh chụp màn hình,
        -- nhưng tôi vẫn đưa vào để giống với hình ảnh.
        bcd_hex := bcd_hex(12 downto 0) & '0'; 

        donvi <= bcd_hex(9 downto 6);
        chuc  <= bcd_hex(13 downto 10);
    end process;
end Behavioral;