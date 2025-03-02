-- ==========================================================================
--   Название модуля: binary_counter
-- ==========================================================================
--   Описание: Модуль для управления бинарным счетчиком с использованием кнопок
--   Входные порты:
--     clk   - Тактовый сигнал
--     rst_n - Сигнал сброса (активный низкий уровень)
--     keys  - Входные сигналы ключей (2 ключа)
--   Выходные порты:
--     leds  - Светодиоды (4 светодиода)
--   Генерики:
--     DEBOUNCE_LIMIT - Лимит дебаунсинга в тактах (по умолчанию 500000)
--   Функциональность: Управляет бинарным счетчиком на основе нажатий кнопок
--   Автор: Максим
--   Дата создания: 23.11.2024
--   Версия: 1.0
-- ==========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is
    port(
        clk   : in  std_logic;
        rst_n : in  std_logic;
        keys  : in  std_logic_vector(1 downto 0);
        leds  : out std_logic_vector(3 downto 0)
    );
end entity binary_counter;

architecture STR of binary_counter is

    -- Сигнал для хранения дебаунсированных значений кнопок
    signal deb_keys  : std_logic_vector(1 downto 0);
    -- Сигнал для хранения фронтов сигналов кнопок
    signal key_edges : std_logic_vector(1 downto 0);

begin

    -- Генерация детекторов фронтов и дебаунсеров для каждого ключа
    key_handler_gen : for i in 0 to 1 generate
        -- Детектор фронтов
        edge_detector_inst : entity work.edge_detector
            port map(
                clk   => clk,
                rst_n => rst_n,
                en    => '1',
                data  => deb_keys(i),
                fall  => key_edges(i)
            );
        -- Дебаунсер
        debouncer_inst : entity work.debouncer
            generic map(
                -- 0.2 мс для тактового сигнала 50 МГц
                DEBOUNCE_LIMIT => 500000
            )
            port map(
                clk     => clk,
                rst_n   => rst_n,
                key_in  => keys(i),
                key_out => deb_keys(i)
            );
    end generate key_handler_gen;

    -- Счетчик, управляющий светодиодами
    counter_inst : entity work.counter
        port map(
            clk   => clk,
            rst_n => rst_n,
            keys  => key_edges,
            leds  => leds
        );

end architecture STR;
