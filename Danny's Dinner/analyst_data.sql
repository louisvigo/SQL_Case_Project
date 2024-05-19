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

--      What is the most purchased item on the menu and how many times was it 
--      purchased by all customers?
SELECT
        menu.product_name AS product,
       -- sales.customer_id,
        COUNT(sales.order_date) AS order_count
        
FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
LEFT JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
GROUP BY product --,sales.customer_id
ORDER BY order_count DESC;

-- Which item was the most popular for each customer?
SELECT
        menu.product_name AS product,
        sales.customer_id,
        COUNT(sales.order_date) AS order_count
        
FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
LEFT JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
GROUP BY product ,sales.customer_id
ORDER BY sales.customer_id ASC, order_count DESC;

-- Which item was purchased first by the customer after they became a member?
SELECT
        sales.customer_id,
        members.join_date,
        sales.order_date,
        menu.product_name

FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
LEFT JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
WHERE sales.order_date > members.join_date
ORDER BY order_date ASC;

-- Which item was purchased just before the customer became a member?
WITH purchased_before_join AS
(SELECT
        sales.customer_id AS customer_id,
        members.join_date AS join_date,
        sales.order_date AS order_date,
        menu.product_name AS product_name,
        DENSE_RANK() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS rank
FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
LEFT JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
WHERE sales.order_date < members.join_date
ORDER BY sales.order_date DESC)

SELECT
        customer_id,
        join_date,
        order_date,
        STRING_AGG(product_name,',') AS product_name
FROM purchased_before_join
WHERE rank = 1
GROUP BY
        customer_id,
        join_date,
        order_date;

-- What is the total items and amount spent for each member before they became a member?
SELECT
        sales.customer_id,
        members.join_date,
        COUNT(sales.order_date) AS total_purchase,
        SUM(menu.price) AS total_price

FROM 
        dannys_diner.sales AS sales
LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
LEFT JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
WHERE sales.order_date < members.join_date
GROUP BY
        sales.customer_id,
        members.join_date
 ORDER BY total_price DESC;

-- If each $1 spent equates to 10 points 
-- and sushi has a 2x points multiplier - how many points would each customer have?
WITH points_table AS (
        SELECT
        sales.customer_id,
        menu.product_name,
        menu.price,
        COUNT(sales.order_date) AS number_of_visit,
        CASE
        WHEN menu.product_name LIKE '%sushi%' THEN (menu.price * 2)
        ELSE menu.price
        END AS points_earn
FROM 
        dannys_diner.sales AS sales
INNER JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
GROUP BY
        sales.customer_id,
        menu.product_name,
        menu.price)
SELECT 
        customer_id,
        SUM (number_of_visit * points_earn) AS total_points
FROM points_table
GROUP BY customer_id
ORDER BY total_points DESC;

-- In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?
WITH points_table AS (
    SELECT
        sales.customer_id,
        menu.product_name,
        menu.price,
        COUNT(sales.order_date) AS number_of_visit,
        SUM(
            CASE
                WHEN (menu.product_name LIKE '%sushi%' 
                      OR (sales.order_date >= members.join_date AND sales.order_date <= members.join_date + INTERVAL '7 day'))
                     AND sales.order_date <= '2021-01-31' 
                THEN (menu.price * 2)
                ELSE menu.price
            END
        ) AS total_points
    FROM 
        dannys_diner.sales AS sales
    INNER JOIN dannys_diner.menu AS menu ON menu.product_id = sales.product_id
    LEFT JOIN dannys_diner.members AS members ON sales.customer_id = members.customer_id
    GROUP BY
        sales.customer_id,
        menu.product_name,
        menu.price,
        members.join_date
)
SELECT 
    customer_id,
    SUM(total_points) AS total_points
FROM points_table
GROUP BY customer_id
ORDER BY total_points DESC;