entity dong_ho_gio_phut_giay is
    port(
        ckht: in std_logic;
        btn0: in std_logic;
        sw:   in std_logic_vector(1 downto 0);
        sseg: out std_logic_vector(7 downto 0);
        anode: out std_logic_vector(7 downto 0)
    );
end dong_ho_gio_phut_giay;

architecture beha of dong_ho_gio_phut_giay is
    -- Khai báo tín hiệu
    signal ena_db:   std_logic;
    signal ena1hz:   std_logic;
    signal ena20hz:  std_logic;
    signal ena50hz:  std_logic;
    signal ena100hz: std_logic;
    signal ena1khz:  std_logic;
    signal rst:      std_logic;

    signal giay: std_logic_vector(5 downto 0);
    signal phut: std_logic_vector(5 downto 0);
    signal gio:  std_logic_vector(5 downto 0);

    signal ch_gio:   std_logic_vector(3 downto 0);
    signal dv_gio:   std_logic_vector(3 downto 0);
    signal ch_phut:  std_logic_vector(3 downto 0);
    signal dv_phut:  std_logic_vector(3 downto 0);
    signal ch_giay:  std_logic_vector(3 downto 0);
    signal dv_giay:  std_logic_vector(3 downto 0);
    signal dc_8led:  std_logic_vector(7 downto 0);
    signal ena_8led: std_logic_vector(7 downto 0);

begin
    -- Gán giá trị ban đầu cho các tín hiệu
    dc_8led <= x"00";
    ena_8led <= "11011011";
    rst <= btn0;

    ena_db <= ena1hz when sw = "00" else
              ena20hz when sw = "01" else
              ena50hz when sw = "10" else
              ena100hz;

    -- Khởi tạo các khối
    IC1: entity work.chia_10ena
        port map(
            ckht     => ckht,
            ena1hz   => ena1hz,
            ena20hz  => ena20hz,
            ena50hz  => ena50hz,
            ena100hz => ena100hz,
            ena1khz  => ena1khz
        );

    IC2: entity work.dem_giophutgiay
        port map(
            ckht   => ckht,
            rst    => rst,
            ena_db => ena_db,
            gio    => gio,
            phut   => phut,
            giay   => giay
        );

    IC3: entity work.hextobcd_gpg
        port map(
            gio      => gio,
            dv_gio   => dv_gio,
            ch_gio   => ch_gio,
            phut     => phut,
            dv_phut  => dv_phut,
            ch_phut  => ch_phut,
            giay     => giay,
            dv_giay  => dv_giay,
            ch_giay  => ch_giay
        );

    IC4: entity work.gm_ht_8led
        port map(
            ckht     => ckht,
            ena1khz  => ena1khz,
            led70    => dv_giay,
            led71    => ch_giay,
            led72    => x"f",
            led73    => dv_phut,
            led74    => ch_phut,
            led75    => x"f",
            led76    => dv_gio,
            led77    => ch_gio,
            anode    => anode,
            sseg     => sseg,
            dc_8led  => dc_8led,
            ena_8led => ena_8led
        );
end beha;