-- Задание 1. Расчет кумулятивной выручки:
--			  Для каждой категории товаров (category) вычислите кумулятивную выручку на каждый день. 
--			  Это означает, что для каждой даты вам нужно будет посчитать сумму выручки для данной категории товаров на эту дату и для всех предыдущих дат.
SELECT
	s.category,     -- Категория товара
	s.order_date,   -- Дата продажи
	s.sale_id,      -- Идентификатор продажи
	s.revenue,      -- Выручка от продажи
	sum(s.revenue) OVER(PARTITION BY s.category, s.order_date ORDER BY s.sale_id) AS cumulative_revenue
FROM course_1t.sales AS s
ORDER BY s.category, s.order_date, s.sale_id;


-- Задание 2. Расчет среднего чека:
-- 			  Для каждой категории товаров на каждый день вычислите средний чек, который равен кумулятивной выручке на этот день,
--			  поделенной на кумулятивное количество заказов на этот день.
SELECT
	s.category,
	s.order_date,
	s.sale_id,
	s.revenue,
	sum(s.revenue) OVER(PARTITION BY s.category, s.order_date ORDER BY s.sale_id) AS cumulative_revenue,
	ROW_NUMBER() OVER(PARTITION BY s.category, s.order_date ORDER BY s.sale_id) AS cumulative_orders,
	ROUND(cumulative_revenue / cumulative_orders) AS average_check
FROM course_1t.sales AS s
ORDER BY s.category, s.order_date, s.sale_id;


-- Задание 3. Определение даты максимального среднего чека:
--			 	Найдите дату, на которой был достигнут максимальный средний чек для каждой категории товаров,
--				а также значение этого максимального среднего чека.
WITH avg_check_for_date_calc AS
(
	-- вычисляю средний чек на каждую дату
	SELECT
		s.category,
		s.order_date,
		s.sale_id,
		s.revenue,
		round(
			sum(s.revenue) OVER (PARTITION BY s.category, s.order_date)
			/ count(s.revenue) OVER (PARTITION BY s.category, s.order_date)
		) AS avg_check_for_date
	FROM course_1t.sales AS s
),
max_avg_check_value_calc AS (
	-- вычисляю макс средний чек
	SELECT
		s.category,
		s.order_date,
		s.sale_id,
		s.revenue,
		s.avg_check_for_date,
		max(s.avg_check_for_date) OVER (PARTITION BY s.category) AS max_avg_check_value
	FROM avg_check_for_date_calc AS s
)
-- определяю дату на которую был получен максимальный средний чек
SELECT DISTINCT
	category,
	order_date AS max_avg_check_date ,
	max_avg_check_value
FROM max_avg_check_value_calc
WHERE avg_check_for_date = max_avg_check_value