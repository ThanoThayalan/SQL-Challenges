select *
from crime_scene_report
where city='SQL City' and type='murder' and date='20180115'

-- The first witness lives at the last house on "Northwestern Dr". 
-- The second witness, named Annabel, lives somewhere on "Franklin Ave".

select *
from person
where address_street_name='Northwestern Dr'
order by address_number desc

-- 1st Witness ID = 14887, Morty Schapiro

select *
from person
where name like '%annabel%' and address_street_name='Franklin Ave'

-- 2nd Witness ID = 16371

select *
from interview
where person_id = '14887'

-- 1st Witness Interview: Membership starts with 48Z, gold member, license plate H42W

select *
from interview
where person_id = '16371'

-- 2nd Witness Interview: Jan 9th workout

select *
from get_fit_now_check_in
where membership_id like '48Z%' and check_in_date like '%0109%' 

-- 2 potential members: 48Z7A and 48Z55

select *
from get_fit_now_member
where id ='48Z7A' or id = '48Z55'

-- 28819: Joe Germuska and 67318: Jeremy Bowers respectively

select *
from person
where id ='28819' or id = '67318'

-- JG License ID: 173289 and JB License ID: 423327

select *
from drivers_license
where id ='173289' or id = '423327'

-- JEREMY BOWERS WAS THE MURDERER

select *
from interview
where person_id= '67318'

-- Hired by woman, 5'5 to 5'7, red hair, Tesla Model S, SQL Symphony concert 3 times Dec 2017

select *
from drivers_license
where gender = 'female' and hair_color = 'red' and car_make = 'Tesla' 

-- 3 suspects: License_ID = 202298, 291182, 918773

select *
from person 
join facebook_event_checkin on facebook_event_checkin.person_id = person.id
where license_id = '202298' or license_id = '291182' or license_id = '918773'
limit 100

-- Contractor was Miranda Priestly 
