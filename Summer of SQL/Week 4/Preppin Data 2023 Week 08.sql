-- Input each of the 12 monthly files
-- Create a 'file date' using the month found in the file name
-- The Null value should be replaced as 1
-- Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
-- Remove any rows with 'n/a'
-- Categorise the Purchase Price into groupings
-- 0 to 24,999.99 as 'Low'
-- 25,000 to 49,999.99 as 'Medium'
-- 50,000 to 74,999.99 as 'High'
-- 75,000 to 100,000 as 'Very High'
-- Categorise the Market Cap into groupings
-- Below $100M as 'Small'
-- Between $100M and below $1B as 'Medium'
-- Between $1B and below $100B as 'Large' 
-- $100B and above as 'Huge'
-- Rank the highest 5 purchases per combination of: file date, Purchase Price Categorisation and Market Capitalisation Categorisation.

with cte as(
select 1 as file,* from pd2023_wk08_01

union all 

select 2 as file,* from pd2023_wk08_02

union all 

select 3 as file,* from pd2023_wk08_03

union all 

select 4 as file,* from pd2023_wk08_04

union all 

select 5 as file,* from pd2023_wk08_05

union all 

select 6 as file,* from pd2023_wk08_06

union all 

select 7 as file,* from pd2023_wk08_07

union all 

select 8 as file,* from pd2023_wk08_08

union all 

select 9 as file,* from pd2023_wk08_09

union all 

select 10 as file,* from pd2023_wk08_10

union all 

select 11 as file,* from pd2023_wk08_11

union all 

select 12 as file,* from pd2023_wk08_12
)
,CATEGORIES AS (
select 
date_from_parts(2023,file,1) as filedate,
*,
ltrim(purchase_price, '$') as purchase_price1,
case 
when 0<purchase_price1 and  purchase_price1<24999.99 then 'Low'
when 25000<purchase_price1 and  purchase_price1<49999.99 then 'Medium'
when 50000<purchase_price1 and  purchase_price1<74999.99 then 'High'
when 75000<purchase_price1 then 'Very High'
end as price_category,
case
when 
((substr(market_cap,2,length(market_cap)-2))::float *
(case 
when right(market_cap,1)='B' then 1000000000
when right(market_cap,1)='M' then 1000000
end))<100000000 then 'Small' 
when 
((substr(market_cap,2,length(market_cap)-2))::float *
(case 
when right(market_cap,1)='B' then 1000000000
when right(market_cap,1)='M' then 1000000
end))<1000000000 then 'Medium' 
when 
((substr(market_cap,2,length(market_cap)-2))::float *
(case 
when right(market_cap,1)='B' then 1000000000
when right(market_cap,1)='M' then 1000000
end))<100000000000 then 'Large'
else 'Huge'
end as market_cap_category
from cte
where market_cap != 'n/a'
)
,RANKED as (
select 
rank() over(partition BY filedate, market_cap_category, price_category order by (substr(purchase_price,2,length(purchase_price)))::float desc) as rnk,
*
from CATEGORIES
)
select 
market_cap_category, 
price_category,
filedate,
ticker,
sector,
market,
stock_name,
market_cap,
purchase_price,
rnk as rank
from RANKED 
where rnk <=5