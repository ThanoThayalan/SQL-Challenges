-- How many unique nodes are there on the Data Bank system?
-- What is the number of nodes per region?
-- How many customers are allocated to each region?
-- How many days on average are customers reallocated to a different node?
-- What is the median, 80th and 95th percentile for this same reallocation days metric for each region?

-- Question 1
select count(distinct node_id) as distinct_count
from customer_nodes

-- Question 2
select count(distinct node_id) as count , region_name
from customer_nodes
join regions on regions.region_id=customer_nodes.region_id
group by region_name

-- Question 3
select count(distinct customer_id) as count,
region_name
from customer_nodes
join regions on regions.region_id=customer_nodes.region_id
group by region_name

-- Question 4
with cte as(
select customer_id,node_id,
sum(datediff('days',start_date,end_date)) as daysinnode
from customer_nodes
where end_date!='9999-12-31'
group by customer_id, node_id
)
select 
round(avg(daysinnode),0) as avg_days_in_node
from cte

-- Question 5
with cte as(
select region_name,
customer_id,
node_id,
sum(datediff('days',start_date,end_date)) as daysinnode
from customer_nodes
join regions on regions.region_id=customer_nodes.region_id
where end_date!='9999-12-31'
group by customer_id, node_id, region_name
)
select region_name,
round(avg(daysinnode),0) as avg_days_in_node,
median(daysinnode) as median,
percentile_cont(0.8) within group (order by daysinnode) as percentile_80,
percentile_cont(0.95) within group (order by daysinnode) as percentile_95
from cte
group by region_name