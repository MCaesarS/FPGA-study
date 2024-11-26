library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
    generic(
        -- Константа времени дебаунсинга (0.2 мс для тактового сигнала 50 МГц)
        DEBOUNCE_LIMIT : natural := 500000
    );
    port(
        clk     : in  std_logic;
        rst_n   : in  std_logic;
        key_in  : in  std_logic;
        key_out : out std_logic
    );
end entity debouncer;

architecture BHV of debouncer is
    -- Сигнал счетчика
    signal debounce_counter : unsigned(19 downto 0);
    -- Сигнал хранения предыдущего состояния кнопки
    signal key_state        : std_logic;

begin
    -- Синхронный процесс избавления от дребезга
    sync_debounce_process : process(clk) is
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                -- Сброс значений счетчика и состояния кнопки
                debounce_counter <= (others => '0');
                key_state        <= '0';
            else
                if key_in /= key_state then
                    -- Увеличение счетчика
                    if debounce_counter < DEBOUNCE_LIMIT then
                        debounce_counter <= debounce_counter + 1;
                    else
                        -- Обновление состояния при достижении лимита
                        key_state        <= key_in;
                        debounce_counter <= (others => '0');
                    end if;
                else
                    -- Сброс счетчика
                    debounce_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process sync_debounce_process;

    -- Вывод установленного значения
    key_out <= key_state;

end architecture BHV;
