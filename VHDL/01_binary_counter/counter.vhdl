library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port(
        clk   : in  std_logic;
        rst_n : in  std_logic;
        keys  : in  std_logic_vector(1 downto 0);
        leds  : out std_logic_vector(3 downto 0)
    );
end entity counter;

architecture BHV of counter is
    -- Сигнал для хранения текущего значения счетчика
    signal cnt_val : unsigned(3 downto 0);

begin

    -- Синхронный процесс подсчета
    sync_cnt_proc : process(clk) is
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                -- Сброс счетчика
                cnt_val <= (others => '0');
            else
                -- Обработка входных сигналов кнопок
                case keys is
                    -- Инкрементирование
                    when "01" =>
                        if cnt_val < 15 then
                            cnt_val <= cnt_val + 1;
                        end if;
                    -- Декрементирование
                    when "10" =>
                        if cnt_val > 0 then
                            cnt_val <= cnt_val - 1;
                        end if;
                    -- Непредвиденный случай
                    when others =>
                        cnt_val <= cnt_val;
                end case;
            end if;
        end if;
    end process sync_cnt_proc;

    -- Присваивание значения счетчика выходному светодиоду
    leds <= std_logic_vector(cnt_val);

end architecture BHV;
