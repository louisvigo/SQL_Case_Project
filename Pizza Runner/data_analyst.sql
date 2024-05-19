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
