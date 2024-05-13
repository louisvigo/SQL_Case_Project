SELECT 
        DISTINCT(customer_id) 
FROM
        dannys_diner.members

-------What is the total amount each customer spent at the restaurant?--------

SELECT
        sales.customer_id,
        SUM(menu.price) AS total_spent
FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
INNER JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
GROUP BY sales.customer_id
ORDER BY total_spent DESC;

------How many days has each customer visited the restaurant?-----------
SELECT 
        customer_id,
        COUNT(DISTINCT(order_date)) AS numb_of_days_visit
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id ASC;

------What was the first item from the menu purchased by each customer?--------------
SELECT 
    customer,
    order_date,
    STRING_AGG(product_name,',') AS product
FROM (
    SELECT
        sales.customer_id AS customer,
        sales.order_date,
        menu.product_name,
        DENSE_RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
    FROM dannys_diner.sales AS sales
    JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
) AS subquery
WHERE rank = 1
GROUP BY        
        customer,
        order_date;
