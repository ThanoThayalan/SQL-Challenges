-- For the Transaction Path table:
-- Make sure field naming convention matches the other tables
-- i.e. instead of Account_From it should be Account From
-- Filter out the cancelled transactions
-- Split the flow into incoming and outgoing transactions 
-- Bring the data together with the Balance as of 31st Jan 
-- Work out the order that transactions occur for each account
-- Hint: where multiple transactions happen on the same day, assume the highest value transactions happen first
-- Use a running sum to calculate the Balance for each account on each day 
-- The Transaction Value should be null for 31st Jan, as this is the starting balance

with cte as (
select account_to as accountid,
transaction_date,
value,
balance
from pd2023_wk07_transaction_path as tp
join pd2023_wk07_transaction_detail as td on td.transaction_id=tp.transaction_id
join pd2023_wk07_account_information as ai on ai.account_number=tp.account_to
where cancelled_ = 'N'
and balance_date = '2023-01-31'

union all

select account_from as accountid,
transaction_date,
value*-1 as value,
balance
from pd2023_wk07_transaction_path as tp
join pd2023_wk07_transaction_detail as td on td.transaction_id=tp.transaction_id
join pd2023_wk07_account_information as ai on ai.account_number=tp.account_from
where cancelled_ = 'N'
and balance_date = '2023-01-31'

union all

select account_number as accountid,
balance_date as transaction_date,
null as value,
balance
from pd2023_wk07_account_information
)

select
accountid,
transaction_date,
value,
balance,
sum(coalesce(value,0)) over (partition by accountid order by transaction_date, value desc) + balance as balance_runningsum
from cte
