-- =============================================
-- Вариант 10: Решение всех трех заданий
-- =============================================

-- Задание 1: Определить продажи по городам
-- Описание: Создание представления для анализа суммарных продаж по городам
-- Логика: Группировка данных о продажах по географическим признакам (город, штат, страна)
-- с агрегацией ключевых метрик: общий объем продаж и количество заказов
CREATE OR REPLACE VIEW dw.sales_by_city AS
SELECT 
    g.city,
    g.state,
    g.country,
    SUM(f.sales) as total_sales,
    COUNT(f.order_id) as order_count,
    SUM(f.quantity) as total_quantity
FROM dw.sales_fact f
JOIN dw.geo_dim g ON f.geo_id = g.geo_id
GROUP BY g.city, g.state, g.country
ORDER BY total_sales DESC;

-- Задание 2: Создать таблицу по прибыли сегментов  
-- Описание: Создание материализованной таблицы с агрегированными данными по прибыльности сегментов клиентов
-- Логика: Анализ прибыльности по сегментам с расчетом средних значений и общего объема продаж
-- Особенности: Используется материализованная таблица для хранения агрегированных данных и ускорения отчетов
DROP TABLE IF EXISTS dw.segment_profit;
CREATE TABLE dw.segment_profit AS
SELECT 
    p.segment,
    SUM(f.profit) as total_profit,
    AVG(f.profit) as avg_profit_per_order,
    COUNT(f.order_id) as order_count,
    SUM(f.sales) as total_sales,
    CASE 
        WHEN SUM(f.sales) = 0 THEN 0 
        ELSE (SUM(f.profit) / SUM(f.sales)) * 100 
    END as profit_margin
FROM dw.sales_fact f
JOIN dw.product_dim p ON f.prod_id = p.prod_id
GROUP BY p.segment
ORDER BY total_profit DESC;

-- Задание 3: Найти среднюю скидку по категориям
-- Описание: Создание представления для анализа уровня скидок по товарным категориям
-- Логика: Расчет статистики по скидкам (среднее, минимум, максимум) с группировкой по категориям товаров
-- Особенности: Включены дополнительные метрики для комплексного анализа политики скидок
CREATE OR REPLACE VIEW dw.avg_discount_by_category AS
SELECT 
    p.category,
    ROUND(AVG(f.discount * 100), 2) as avg_discount_percent,
    ROUND(MIN(f.discount * 100), 2) as min_discount_percent,
    ROUND(MAX(f.discount * 100), 2) as max_discount_percent,
    COUNT(f.order_id) as order_count,
    SUM(f.quantity) as total_quantity
FROM dw.sales_fact f
JOIN dw.product_dim p ON f.prod_id = p.prod_id
GROUP BY p.category
ORDER BY avg_discount_percent DESC;