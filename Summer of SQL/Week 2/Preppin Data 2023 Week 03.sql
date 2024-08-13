-- For the transactions file:
-- Filter the transactions to just look at DSB 
-- These will be transactions that contain DSB in the Transaction Code field
-- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
-- Change the date to be the quarter 
-- Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
-- For the targets file:
-- Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter 
--  Rename the fields
-- Remove the 'Q' from the quarter field and make the data type numeric 
-- Join the two datasets together 
-- You may need more than one join clause!
-- Remove unnecessary fields
-- Calculate the Variance to Target for each row 

with cte as (
select sum(value) as value,
case 
when online_or_in_person=1 then 'Online'
when online_or_in_person=2 then 'In-Person'
end as online_in_person,
quarter(date(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as quarter,
from PD2023_WK01
where split_part(transaction_code,'-',1) ='DSB'
group by 2,3
)

select
target,
value - target as variance_to_target,
v.*
from pd2023_wk03_targets as TA
unpivot(target for quarter in (Q1,Q2,Q3,Q4))
inner join cte as V on V.quarter=right(TA.quarter,1) and V.online_in_person=TA.ONLINE_OR_IN_PERSON
