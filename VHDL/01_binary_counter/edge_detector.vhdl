library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity edge_detector is
    port(
        clk    : in  std_logic;
        rst_n  : in  std_logic;
        en     : in  std_logic;
        data   : in  std_logic;
        rise   : out std_logic;
        toggle : out std_logic;
        fall   : out std_logic
    );
end entity edge_detector;

architecture BHV of edge_detector is
    -- Сигнал хранения предыдущего состояния данных
    signal prev_data  : std_logic;
    -- Сигнал обнаружения фронта
    signal rise_det   : std_logic;
    -- Сигнал обнаружения спада
    signal fall_det   : std_logic;
    -- Сигнал обнаружения переключения
    signal toggle_det : std_logic;

begin
    -- Логика обнаружения фронта, спада и переключения
    rise_det   <= data and not prev_data;
    fall_det   <= not data and prev_data;
    toggle_det <= rise_det or fall_det;

    -- Синхронный процесс установки выходных значений
    sync_out_proc : process(clk) is
    begin
        if clk'event and clk = '1' then
            if rst_n = '0' then
                -- Сброс выходных сигналов
                rise   <= '0';
                toggle <= '0';
                fall   <= '0';
            elsif en = '1' then
                -- Установка выходных сигналов
                rise   <= rise_det;
                toggle <= toggle_det;
                fall   <= fall_det;
            end if;
        end if;
    end process sync_out_proc;

    -- Синхронный процесс чтения данных
    sync_data_proc : process(clk) is
    begin
        if clk'event and clk = '1' then
            if rst_n = '0' then
                -- Сброс предыдущего состояния данных
                prev_data <= '0';
            elsif en = '1' then
                -- Обновление предыдущего состояния данных
                prev_data <= data;
            end if;
        end if;
    end process sync_data_proc;

end architecture BHV;
