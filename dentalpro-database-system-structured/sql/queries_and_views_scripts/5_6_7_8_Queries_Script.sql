-- 5. Detail and total all transactions (SALES) for the month-to-date. (A Group By with Roll-Up)  – 1 month

SELECT s.product_name, SUM(oi.quantity) AS total_quantity_sold, 
      SUM(oi.quantity * s.price) AS total_sales
FROM order_items oi
JOIN stocks s ON oi.stock_id = s.stock_id
JOIN orders o ON oi.order_id = o.order_id
WHERE DATE_TRUNC('month', o.order_date) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY ROLLUP(s.product_name);





-- 6. Detail and total all SALES for the year-to-date. (A Group By with Roll-Up)  – All months

SELECT TO_CHAR(o.order_date, 'Month') AS month, s.product_name,
       SUM(oi.quantity) AS total_quantity_sold, SUM(oi.quantity * s.price) AS total_sales
FROM order_items oi
JOIN stocks s ON oi.stock_id = s.stock_id
JOIN orders o ON oi.order_id = o.order_id
WHERE DATE_TRUNC('year', o.order_date) = DATE_TRUNC('year', CURRENT_DATE)
GROUP BY ROLLUP (TO_CHAR(o.order_date, 'Month'), s.product_name)





-- 7. Display the growth in sales/services (as a percentage) for your business, from the 1st month of opening until now. 

SELECT TO_CHAR(DATE_TRUNC('month', o.order_date), 'MM-YYYY') AS month,
       SUM(oi.quantity * s.price) AS total_sales, ROUND(100.0 * (SUM(oi.quantity * s.price) - 
       FIRST_VALUE(SUM(oi.quantity * s.price)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)))
       / NULLIF(FIRST_VALUE(SUM(oi.quantity * s.price)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)), 
				 0), 2) AS sales_growth_percentage
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stocks s ON oi.stock_id = s.stock_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);





-- 8. Display all returns to date. 
SELECT r.return_id, r.return_date, r.reason, r.refund_amount, s.product_name,
       c.first_name || ' ' || c.last_name AS customer_name
FROM returns r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN stocks s ON oi.stock_id = s.stock_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY r.return_date DESC;
ORDER BY TO_DATE(TO_CHAR(o.order_date, 'Month'), 'Month'), s.product_name;
