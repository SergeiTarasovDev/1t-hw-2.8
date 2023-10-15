
CREATE TABLE course_1t.sales
(
	order_date Date,
	category String,
	product_name String,
	revenue Int32
)
ENGINE = AggregatingMergeTree
PARTITION BY toYYYYMM(order_date)
ORDER BY (order_date, product_name)
PRIMARY KEY (order_date, product_name)
