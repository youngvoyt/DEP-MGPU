-- Проверка количества записей в источнике и приемнике
SELECT COUNT(*) as stg_orders_count FROM stg.orders;
SELECT COUNT(*) as dw_sales_fact_count FROM dw.sales_fact;

-- Проверка распределения данных
SELECT category, COUNT(*) as product_count
FROM dw.product_dim
GROUP BY category;

-- Проверка отсутствия дубликатов
SELECT customer_id, COUNT(*)
FROM dw.customer_dim
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Проверка ссылочной целостности
SELECT COUNT(*) as broken_links
FROM dw.sales_fact f
LEFT JOIN dw.customer_dim c ON f.cust_id = c.cust_id
WHERE c.cust_id IS NULL;

-- Проверка корректности агрегатов
SELECT
    SUM(sales) as total_sales,
    SUM(profit) as total_profit,
    AVG(discount) as avg_discount
FROM stg.orders;

SELECT
    SUM(sales) as total_sales,
    SUM(profit) as total_profit,
    AVG(discount) as avg_discount
FROM dw.sales_fact;