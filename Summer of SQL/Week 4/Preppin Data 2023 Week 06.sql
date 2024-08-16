-- Reshape the data so we have 5 rows for each customer, with responses for the Mobile App and Online Interface being in separate fields on the same row
-- Clean the question categories so they don't have the platform in from of them
-- e.g. Mobile App - Ease of Use should be simply Ease of Use
-- Exclude the Overall Ratings, these were incorrectly calculated by the system
-- Calculate the Average Ratings for each platform for each customer 
-- Calculate the difference in Average Rating between Mobile App and Online Interface for each customer
-- Catergorise customers as being:
-- Mobile App Superfans if the difference is greater than or equal to 2 in the Mobile App's favour
-- Mobile App Fans if difference >= 1
-- Online Interface Fan
-- Online Interface Superfan
-- Neutral if difference is between 0 and 1
-- Calculate the Percent of Total customers in each category, rounded to 1 decimal place

with cte as (
select customer_id,
split_part(pivot_columns,'___',1) as device,
split_part(pivot_columns,'___',2) as factor,
avg(value) as avg_value
from pd2023_wk06_dsb_customer_survey
unpivot (value for pivot_columns in (MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING))
where factor != 'OVERALL_RATING'
group by 1,2,3
),
cte2 as(
select customer_id,
avg("'MOBILE_APP'") as avg_mobile,
avg("'ONLINE_INTERFACE'") as avg_online,
round(avg_mobile - avg_online,2) as difference
from cte
pivot (avg(avg_value) for device in ('MOBILE_APP', 'ONLINE_INTERFACE'))
group by customer_id
)
select
case
when difference >= 2 THEN 'Mobile App Superfans'
when difference >= 1 THEN 'Mobile App Fans'
when difference <= -2 THEN 'Online Interface Superfans'
when difference <= -1 THEN 'Online Interface Fans'
else 'Neutral'
end as bucket,
round(count(distinct customer_id)/(select count(distinct customer_id) from pd2023_wk06_dsb_customer_survey)*100,1) as percenttotal
from cte2
group by bucket