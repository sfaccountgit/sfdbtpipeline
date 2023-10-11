{{
  config(
    materialized='view'
  )
}}
with customers as(
    select id,first_name,last_name from raw.jaffle_shop.customers 
),
orders as(
    select id,user_id as customer_id,order_date, status from raw.jaffle_shop.orders
),
customers_orders as(
    select customer_id,
    min(order_date) first_order_date,
    max(order_date) most_recent_order_date,
    count(id) number_of_orders from orders group by 1
),
final as
(select 
customers.id, customers.first_name,customers.last_name, 
customers_orders.first_order_date, customers_orders.most_recent_order_date,
customers_orders.number_of_orders from customers
left join customers_orders on customers.id=customers_orders.customer_id)
select * from final