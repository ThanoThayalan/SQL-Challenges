-- Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'
-- Change transaction date to the just be the month of the transaction
-- Total up the transaction values so you have one row for each bank and month combination
-- Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest. 
-- Without losing all of the other data fields, find:
-- The average rank a bank has across all of the months, call this field 'Avg Rank per Bank'
-- The average transaction value per rank, call this field 'Avg Transaction Value per Rank'

with cte as (
select sum(value) as value,
split_part(transaction_code,'-',1) as bank,
monthname(date(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as month,
rank() over(partition by month order by sum(value) desc) as rank
from pd2023_wk01
group by 2,3
order by month
),
avg_rank as (
select bank,
avg(rank) as avg_rank_per_bank
from cte
group by bank
),
avg_transaction_value as (
select rank,
avg(value) as Avg_Transaction_Value_per_Rank
from cte
group by rank
)
select *
from cte
join avg_rank as ar on ar.bank= cte.bank
join avg_transaction_value as atv on atv.rank = cte.rank
