-- Creating a new schema for the Data Mart
CREATE SCHEMA dentalpro_datamart;

-- Creating View for Question 1 All transactions for a given week
CREATE VIEW dentalpro_datamart.weekly_transactions AS
SELECT o.order_id, o.order_date, c.first_name || ' ' || c.last_name AS customer_name,
       s.product_name, oi.quantity, (oi.quantity * s.price) AS total_price, 
       p.payment_type, p.payment_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stocks s ON oi.stock_id = s.stock_id
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '7 days';

-- Creating View for Question 3 Stock (by supplier) purchased by you
CREATE VIEW dentalpro_datamart.stock_by_supplier AS
SELECT sup.supplier_name, s.product_name, s.price, s.quantity_in_stock
FROM stocks s
JOIN suppliers sup ON s.supplier_id = sup.supplier_id;

-- Creating View for Question 4 Total stock sold grouped by supplier
CREATE VIEW dentalpro_datamart.total_stock_sold_by_supplier AS
SELECT sup.supplier_name, s.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN stocks s ON oi.stock_id = s.stock_id
JOIN suppliers sup ON s.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name, s.product_name;
