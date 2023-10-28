CREATE DATABASE IF NOT EXISTS course_1t;
CREATE TABLE IF NOT EXISTS course_1t.sales
(
    sale_id     Int32,      -- Идентификатор продажи
	order_date  Date,       -- Дата продажи
	category    String,     -- Категория товара
	revenue     Int32       -- Выручка от продажи
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(order_date)
ORDER BY (sale_id, order_date, category)
PRIMARY KEY (sale_id)