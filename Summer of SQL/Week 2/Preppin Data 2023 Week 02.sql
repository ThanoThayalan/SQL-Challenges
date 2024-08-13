-- In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string 
-- Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account 
-- Add a field for the Country Code 
-- Hint: all these transactions take place in the UK so the Country Code should be GB
-- Create the IBAN
-- Hint: watch out for trying to combine sting fields with numeric fields - check data types
-- Remove unnecessary fields 

select transaction_id,
'GB' || check_digits || swift_code || replace(sort_code,'-','') || account_number as iban,
from pd2023_wk02_transactions
inner join pd2023_wk02_swift_codes on pd2023_wk02_swift_codes.bank=pd2023_wk02_transactions.bank
