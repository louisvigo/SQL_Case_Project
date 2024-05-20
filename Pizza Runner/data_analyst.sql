-- How many pizzas were ordered?
SELECT 
        pizza_table.pizza_name,
        COUNT(order_id)
FROM pizza_runner.customer_orders AS order_table
JOIN pizza_runner.pizza_names AS pizza_table ON pizza_table.pizza_id = order_table.pizza_id
GROUP BY pizza_table.pizza_name;

-- How many unique customer orders were made?
SELECT
        customer_orders.customer_id,
        COUNT(DISTINCT(customer_orders.order_id))
FROM pizza_runner.customer_orders
GROUP BY customer_orders.customer_id;

-- How many successful orders were delivered by each runner?
SELECT 
       runner_orders.runner_id,
       COUNT(customer_orders.customer_id) AS delivered
FROM pizza_runner.customer_orders AS customer_orders
LEFT JOIN pizza_runner.runner_orders AS runner_orders ON runner_orders.order_id = customer_orders.order_id
WHERE
        runner_orders.cancellation NOT LIKE '%Cancellation%' OR
        runner_orders.cancellation IS NULL
GROUP BY runner_orders.runner_id
ORDER BY runner_orders.runner_id ASC;

-- How many of each type of pizza was delivered?
SELECT 
       pizza_names.pizza_name,
       COUNT(customer_orders.customer_id) AS delivered
FROM pizza_runner.customer_orders AS customer_orders
LEFT JOIN pizza_runner.runner_orders AS runner_orders ON runner_orders.order_id = customer_orders.order_id
LEFT JOIN pizza_runner.pizza_names AS pizza_names ON pizza_names.pizza_id = customer_orders.pizza_id
WHERE
        runner_orders.cancellation NOT LIKE '%Cancellation%' OR
        runner_orders.cancellation IS NULL
GROUP BY pizza_name
ORDER BY delivered DESC;

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
        customer_orders.customer_id,
        COUNT(CASE WHEN pizza_names.pizza_name = 'Meatlovers' THEN 1 END) AS meat_lover,
        COUNT(CASE WHEN pizza_names.pizza_name = 'Vegetarian' THEN 1 END) AS vegetarian
FROM pizza_runner.customer_orders AS customer_orders
LEFT JOIN pizza_runner.runner_orders AS runner_orders ON runner_orders.order_id = customer_orders.order_id
LEFT JOIN pizza_runner.pizza_names AS pizza_names ON pizza_names.pizza_id = customer_orders.pizza_id
GROUP BY customer_orders.customer_id;

-- What was the maximum number of pizzas delivered in a single order?
SELECT
        customer_orders.order_time,
        COUNT(customer_orders.order_id) AS number_of_order
FROM pizza_runner.customer_orders AS customer_orders
LEFT JOIN pizza_runner.runner_orders AS runner_orders ON runner_orders.order_id = customer_orders.order_id
WHERE 
        runner_orders.cancellation NOT LIKE '%Cancellation%' OR
        runner_orders.cancellation IS NULL
GROUP BY customer_orders.order_time
ORDER BY COUNT(customer_orders.order_id) DESC;