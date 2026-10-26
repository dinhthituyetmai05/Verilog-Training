entity dem_giophutgiay is
    port(
        ckht:   in std_logic;
        ena_db: in std_logic;
        rst:    in std_logic;
        giay:   out std_logic_vector(5 downto 0);
        phut:   out std_logic_vector(5 downto 0);
        gio:    out std_logic_vector(5 downto 0)
    );
end dem_giophutgiay;

architecture behavioral of dem_giophutgiay is
    signal giay_r: std_logic_vector(5 downto 0);
    signal giay_n: std_logic_vector(5 downto 0);
    signal phut_r: std_logic_vector(5 downto 0);
    signal phut_n: std_logic_vector(5 downto 0);
    signal gio_r:  std_logic_vector(4 downto 0);
    signal gio_n:  std_logic_vector(4 downto 0);
begin
    --register
    process (ckht, rst)
    begin
        if rst = '1' then
            giay_r <= "000000";
            phut_r <= "000000";
            gio_r  <= "00000";
        elsif falling_edge(ckht) then
            giay_r <= giay_n;
            phut_r <= phut_n;
            gio_r  <= gio_n;
        end if;
    end process;

    --next state logic
    process (giay_r, ena_db)
    begin
        giay_n <= giay_r;
        if ena_db = '1' then
            if giay_r = "111011" then -- 59
                giay_n <= "000000";
            else
                giay_n <= giay_r + 1;
            end if;
        end if;
    end process;

    process (giay_r, phut_r, ena_db)
    begin
        phut_n <= phut_r;
        if ena_db = '1' and giay_r = "111011" then -- 59
            if phut_r = "111011" then -- 59
                phut_n <= "000000";
            else
                phut_n <= phut_r + 1;
            end if;
        end if;
    end process;

    process (giay_r, phut_r, gio_r, ena_db)
    begin
        gio_n <= gio_r;
        if ena_db = '1' and giay_r = "111011" and phut_r = "111011" then
            if gio_r = "10111" then -- 23
                gio_n <= "00000";
            else
                gio_n <= gio_r + 1;
            end if;
        end if;
    end process;

    --output logic
    giay <= giay_r;
    phut <= phut_r;
    gio  <= '0' & gio_r;
end behavioral;