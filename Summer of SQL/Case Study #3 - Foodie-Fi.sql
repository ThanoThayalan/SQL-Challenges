select *
from subscriptions
join plans on plans.plan_id=subscriptions.plan_id
where CUSTOMER_ID = 1 OR CUSTOMER_ID = 2 OR CUSTOMER_ID = 11 OR CUSTOMER_ID = 13 OR
CUSTOMER_ID = 15 OR CUSTOMER_ID = 16 OR CUSTOMER_ID = 18 OR CUSTOMER_ID = 19

-- Customer 1 had a trial and then went to a basic monthly plan
-- Customer 2 had a trial and then went to a pro yearly plan
-- Customer 11 had a trial and didn't extend 
-- Customer 13 had a trial, went to a basic monthly plan before upgrading to a pro monthly plan
-- Customer 15 had a trial, went to a pro monthly plan before ending their plan a month later
-- Customer 16 had a trial, went to a basic monthly plan before upgrading to a pro yearly plan
-- Customer 18 had a trial and then went to a pro monthly plan
-- Customer 19 had a trial and then went to a pro monthly plan

-- QB1: How many customers has Foodie-Fi ever had
select count(distinct customer_id) as no_of_customers
from subscriptions
-- A: 1000

-- QB2: What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
select count(customer_id) as count, date_trunc('month',start_date) as start_month
from subscriptions as S
join plans as P on P.plan_id=S.plan_id
where s.plan_id=0
group by date_trunc('month',start_date)

-- QB3: What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select count(customer_id) as event_count, plan_name
from subscriptions
join plans on plans.plan_id=subscriptions.plan_id
where date_part('year',start_date) > 2020
group by plan_name

-- QB4: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
select (select
count(distinct customer_id) from subscriptions) as no_of_customers,
count(distinct customer_id) as churn_count,
round(churn_count/no_of_customers*100,1) as percentage
from subscriptions
join plans on plans.plan_id=subscriptions.plan_id
where plan_name= 'churn'
group by plan_name= 'churn'

-- QB5: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
with cte as (
select *,
row_number() over(partition BY customer_id ORDER BY start_date ASC) as rn
from subscriptions as s
join plans as p on p.plan_id=s.plan_id
)

select
count(distinct customer_id) as no_of_customers,
(select count(distinct customer_id) 
from cte
where rn = 2 and plan_name='churn') as countd,
round(countd/no_of_customers*100,0) as percentage
from cte

-- QB6: What is the number and percentage of customer plans after their initial free trial?
with cte as (
select *,
row_number() over(partition BY customer_id ORDER BY start_date ASC) as rn
from subscriptions as s
join plans as p on p.plan_id=s.plan_id
)

select plan_name,
count(distinct customer_id) as no_of_customers,
round(no_of_customers/(select count(distinct customer_id) from cte)*100,1) as percentage
from cte
where rn =2
group by plan_name

-- QB7: What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
with cte as (
select *,
row_number() over(partition BY customer_id ORDER BY start_date DESC) as rn,
from subscriptions as s
join plans as p on p.plan_id=s.plan_id
where start_date<= '2020-12-31')

select plan_name,
count(distinct customer_id) as no_of_customers,
round(no_of_customers/(select count(distinct customer_id) from subscriptions)*100,1) as percentage
from cte
where rn =1
group by plan_name

-- QB8: How many customers have upgraded to an annual plan in 2020?
select
count(distinct customer_id) as no_of_customers
from subscriptions as s
join plans as p on p.plan_id=s.plan_id
where s.plan_id=3 and start_date<='2020-12-31'

-- QB9: How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
with TRIAL as (
select 
customer_id,
start_date as trial_start
from subscriptions
where plan_id = 0
)
, ANNUAL AS (
select 
customer_id,
start_date as annual_start
from subscriptions
where plan_id = 3
)
select 
round(avg(datediff('days',trial_start,annual_start)),0) as average_days_from_trial_to_annual
from TRIAL as T
join ANNUAL as A on T.customer_id = A.customer_id;

-- QB10: Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
with TRIAL as (
select 
customer_id,
start_date as trial_start
from subscriptions
where plan_id = 0
)
, ANNUAL AS (
select 
customer_id,
start_date as annual_start
from subscriptions
where plan_id = 3
)
select
--round((datediff('days',trial_start,annual_start)),0) as days_from_trial_to_annual,
case
when round((datediff('days',trial_start,annual_start)),0)<31 then '0-30 days'
when 31<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<61 then '31-60 days'
when 61<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<91 then '61-90 days'
when 91<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<121 then '91-120 days'
when 121<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<151 then '121-150 days'
when 151<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<181 then '151-180 days'
when 181<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<211 then '181-210 days'
when 211<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<241 then '211-240 days'
when 241<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<271 then '241-270 days'
when 271<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<301 then '271-300 days'
when 301<=round((datediff('days',trial_start,annual_start)),0) and round((datediff('days',trial_start,annual_start)),0)<331 then '301-330 days'
when 331<=round((datediff('days',trial_start,annual_start)),0) then '331+ days'
end as days_bucket,
count(distinct T.customer_id)
from trial as T
join annual as A on T.customer_id = A.customer_id 
group by days_bucket

-- QB11: How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
select *,
row_number() over(partition by customer_id order by start_date asc) as rn
from subscriptions as s
join plans as p on p.plan_id=s.plan_id
where date_part('year', start_date)=2020 and (plan_name='pro monthly' and p.plan_id=1)