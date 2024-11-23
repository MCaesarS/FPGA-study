-- ==========================================================================
--   Название модуля: blinky_led
-- ==========================================================================
--   Описание: Модуль для управления миганием светодиода
--   Входные порты:
--     clk   - Тактовый сигнал
--     rst_n - Сигнал сброса (активный низкий уровень)
--   Выходные порты:
--     led   - Светодиод
--   Генерики:
--     BLINK_PERIOD - Период мигания светодиода в тактах (по умолчанию 25_000_000)
--   Функциональность: Управляет миганием светодиода с заданной частотой
--   Автор: Максим
--   Дата создания: 23.11.2024
--   Версия: 1.0
-- ==========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blinky_led is
    -- Установка периода мигания светодиода
    -- Значение 25_000_000 соответствует периоду в 1 с при частоте тактового сигнала 50 МГц
    generic(BLINK_PERIOD : positive := 25_000_000);
    port(
        clk   : in  std_logic;
        rst_n : in  std_logic;
        led   : out std_logic
    );
end entity blinky_led;

architecture BHV of blinky_led is

    -- Максимальное значение счетчика
    constant max_cnt : unsigned(31 downto 0) := to_unsigned(BLINK_PERIOD - 1, 32);

    -- Счетчик
    signal cnt : unsigned(31 downto 0);

    -- Сигнал состояния светодиода
    signal led_state : std_logic;

begin
    -- Синхронный процесс для мигания светодиода
    blinky_proc : process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                -- Сброс счетчика и состояния светодиода
                cnt       <= (others => '0');
                led_state <= '0';
            else
                -- Инкрементирование счетчика до достижения максимального значения
                if cnt < max_cnt then
                    cnt <= cnt + 1;
                else
                    -- Сброс счетчика и инвертирование состояния светодиода
                    cnt       <= (others => '0');
                    led_state <= not led_state;
                end if;
            end if;
        end if;
    end process blinky_proc;

    -- Управление выходным сигналом светодиода
    led <= led_state;

end architecture BHV;
