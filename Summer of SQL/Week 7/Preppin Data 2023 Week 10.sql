-- Aggregate the data so we have a single balance for each day already in the dataset, for each account
-- Scaffold the data so each account has a row between 31st Jan and 14th Feb
-- Make sure new rows have a null in the Transaction Value field
-- Create a parameter so a particular date can be selected
-- Filter to just this date
set dateparam = '2023-02-01';

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
, week9output as (
select
accountid,
transaction_date,
balance,
sum(coalesce(value,0)) over (partition by accountid order by transaction_date, value desc) + balance as transaction_value
from cte
)
, daytrans as (
select 
accountid,
transaction_date,
sum(transaction_value) as transaction_value
from week9output
group by accountid,
transaction_date
)
,balance_ordered as (
select 
*,
row_number() over(partition BY accountid, transaction_date order by transaction_value asc) as rn
from week9output
)
,summary as (
select 
B.accountid,
B.transaction_date,
T.transaction_value,
balance
from balance_ordered as B
join daytrans as T on T.accountid = B.accountid and T.transaction_date = B.transaction_date
where rn=1
)
,accountnums as (
select distinct 
accountid 
from summary
)
,numbers as (
select '2023-01-31'::date as n,
accountid 
from accountnums

union all

select dateadd('day',1,n),
accountid
from numbers 
where n < '2023-02-14'::date
)
,dailyview as (
select 
N.accountid,
N.n as transaction_date,
D.transaction_value,
D.balance as balance_dontuse,
B.transaction_date as transaction_date2,
B.balance,
datediff('day',B.transaction_date,N.n) as datediff,
row_number() over(partition by N.accountid,N.n order by datediff('day',B.transaction_date,N.n)) as rn
from numbers as N 
left join summary as D on N.accountid = D.accountid and N.n = D.transaction_date
join balance_ordered as B on B.accountid = N.accountid and B.transaction_date <= N.n
order by N.accountid, N.n
)
select 
accountid,
transaction_date,
transaction_value,
balance
from dailyview 
where rn =1
and transaction_date = $dateparam;