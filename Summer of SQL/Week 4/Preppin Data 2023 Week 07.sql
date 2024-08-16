-- For the Transaction Path table:
-- Make sure field naming convention matches the other tables
-- i.e. instead of Account_From it should be Account From
-- For the Account Information table:
-- Make sure there are no null values in the Account Holder ID
-- Ensure there is one row per Account Holder ID
-- Joint accounts will have 2 Account Holders, we want a row for each of them
-- For the Account Holders table:
-- Make sure the phone numbers start with 07
-- Bring the tables together
-- Filter out cancelled transactions 
-- Filter to transactions greater than £1,000 in value 
-- Filter out Platinum accounts

with ai as (
select account_number,
account_type,
value as account_holder_id,
balance_date,
balance
from pd2023_wk07_account_information,
lateral split_to_table(account_holder_id, ', ')
where account_holder_id is not null
)
select td.transaction_id,
account_to,
transaction_date,
account_number,
account_type,
value,
balance_date,
balance,
name,
date_of_birth,
insert(to_varchar(contact_number),0,1,'0') as contact_number,
first_line_of_address,
from pd2023_wk07_transaction_detail as td 
join pd2023_wk07_transaction_path as tp on tp.transaction_id= td.transaction_id
join ai on ai.account_number=tp.account_from
join pd2023_wk07_account_holders as ah on ah.account_holder_id=ai.account_holder_id
where cancelled_='N'
and value>1000
and account_type !='Platinum'