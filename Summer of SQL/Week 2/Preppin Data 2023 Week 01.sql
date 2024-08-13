-- Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction 
-- Rename the new field with the Bank code 'Bank'. 
-- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
-- Change the date to be the day of the week 
-- Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
-- 1. Total Values of Transactions by each bank
-- 2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
-- 3. Total Values by Bank and Customer Code

-- Overall Table
select *, split_part(transaction_code,'-',1) as Bank,
case 
when online_or_in_person=1 then 'Online'
when online_or_in_person=2 then 'In-Person'
end as online_or_in_person,
dayname(date(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as transaction_date,
from PD2023_WK01

-- 1. Total Values of Transactions by each bank
select split_part(transaction_code,'-',1) as Bank,
sum(value) as VALUE,
from pd2023_wk01
group by split_part(transaction_code,'-',1)

-- 2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
select split_part(transaction_code,'-',1) as Bank,
case 
when online_or_in_person=1 then 'Online'
when online_or_in_person=2 then 'In-Person'
end as online_or_in_person,
dayname(date(transaction_date,'dd/MM/yyyy hh24:mi:ss')) as transaction_date,
sum(value) as VALUE,
from PD2023_WK01
group by 1,2,3

-- 3. Total Values by Bank and Customer Code
select split_part(transaction_code,'-',1) as Bank,
customer_code,
sum(value) as VALUE,
from PD2023_WK01
group by 1,2
