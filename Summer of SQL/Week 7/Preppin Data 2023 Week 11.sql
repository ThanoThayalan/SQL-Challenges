-- Append the Branch information to the Customer information
-- Transform the latitude and longitude into radians
-- Find the closest Branch for each Customer
-- Make sure Distance is rounded to 2 decimal places
-- For each Branch, assign a Customer Priority rating, the closest customer having a rating of 1

with cte as (
select 
*
,address_long/(180/PI()) as address_long_rads
,address_lat/(180/PI()) as address_lat_rads
,branch_long/(180/PI()) as branch_long_rads
,branch_lat/(180/PI()) as branch_lat_rads
,branch_long/(180/PI()) - address_long/(180/PI()) as difference_in_long
from pd2023_wk11_dsb_customer_locations
cross join pd2023_wk11_dsb_branches
)
,closestbranch as (
select 
branch
,branch_long
,branch_lat
,round(3963 * acos((sin(address_lat_rads) * sin(branch_lat_rads)) + cos(address_lat_rads) * cos(branch_lat_rads) * cos(difference_in_long)),2) as distance
,row_number() over(partition by customer order by distance asc) as closest_branch
,row_number() over(partition by branch order by distance asc) as customer_priority
,customer
,address_long
,address_lat
from CTE
)
select 
branch
,branch_long
,branch_lat
,distance
,customer_priority
,customer
,address_long
,address_lat
from closestbranch
where closest_branch = 1;