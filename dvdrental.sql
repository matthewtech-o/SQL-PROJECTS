-- Show me actor's first_name, last_name that have Nick, Ed and Jennifer as their firstnames.

select first_name, last_name from actor
where first_name in ('Nick', 'Ed', 'Jennifer')

-- Show me only last_name of actor whose first names are Ed, Nick and Jennifer
select last_name from actor
where first_name in ('Nick', 'Ed', 'Jennifer')

-- Show me all the details of the address table
select * from address

-- I want to see district & phone in descending order that are in the address table
select district, phone from address
order by district desc, phone desc

-- From fiilm table, show me title, film_id. from Inventory table, show me inventory_id. Do this when film_id on film table match film_id on the inventory table.
select f.title, f.film_id, i.inventory_id from film f
join inventory i
on i.film_id = f.film_id

-- show me first_name, last_name of actors whose first_name (Ed, Nick and Jennifer) are distinct
select first_name, last_name from actor
where first_name in (select distinct first_name from actor where first_name in ('Ed', 'Nick', 'Jennifer'))

-- show me top 5 rows from inventory table and rental table.
select * from inventory i
join rental r
on i.inventory_id = r.inventory_id
limit 5

-- From the rental and payment table, show me just 10 rows of rental_id, rental_date, payment_id and ordedered by amount in descending order.
select r.rental_id, r.rental_date, p.payment_id, p.amount
from rental r
join payment p
on r.rental_id = p.rental_id
order by amount desc
limit 10

-- from film_category table, film and film_actor table, I want to see 5 rows of film_id, category_id, title, rental_rate  from the three tables.
select fc.film_id, fc.category_id, f.film_id, f.title, f.rental_rate, fa.film_id
from film f join film_category fc
on f.film_id = fc.film_id
join film_actor fa
on f.film_id = fa.film_id
limit 5

-- Show me all the other details in the actor table where actor_id is empty
select * from actor
where actor_id is null

-- Show me all the other details in the actor table where actor_id is not empty
select * from actor
where actor_id is not null

-- I want to see number of non-empty rows in film table
select count(*) from film

--I want to see number of film_id in film table
select count(film_id) from film

-- Unlike count, sum can only be used for numeric columns. I want to see the sum of amount from the payment table, let the output title be sum_amt.
select sum(amount) "sum_amt"
from payment

-- I want to see both Maximum and minimun amount in the payment table
select max(amount) as max_amt, min(amount) as min_amt
from payment

-- calculate the average amount by using the COUNT and SUM command. Show the maximun and minimun amount
select (sum(amount)/count(amount)) as avg_amt, max(amount) as max_amt, min(amount) as min_amt
from payment

-- show the sum of payment made by each payment_id
select payment_id, sum(amount) "sum_amt" from payment
group by payment_id
order by payment_id

-- from the actor table, show me unique first and last names. PS, DISTINCT can only be used with SELECT
select distinct first_name, last_name from actor

-- show the sum of amount by each payment id that is greater then 5.99
select payment_id, sum(amount) from payment
group by payment_id
having amount > 5.99

--show the sum of rental_rate of films by month
select date_trunc('month', last_update), sum(rental_rate) from film
group by date_trunc('month', last_update)

--show the sum of rental_rate of films by day of the week
select date_trunc('day', last_update), sum(rental_rate) from film
group by date_trunc('day', last_update)

select to_char(last_update,'Mon') as "month",
       extract(year from last_update) as "year",
       sum(rental_rate) as rental
from film
group by 1,2

select extract(month from last_update) as "month",
       extract(year from last_update) as "year",
       sum(rental_rate) as rental
from film
group by 1,2

-- Show me film.id, film.title, film.description and film_length. categorize film.length into yes(film.length is less than 86) or no (film.length is greater than 86)
select film_id, title, description, "length",
case 
    when "length" < 86 then 'yes'
    else 'no'
end as "less than 86 mins"
from film

-- Show me the COUNT of the two categories above.
select case 
    when "length" < 86 then 'yes'
    else 'no'
end as "less than 86 mins", count(*) either
from film
group by "less than 86 mins"

-- SHow me film.id, film.title, film.description and film_length. categorize film.length into 4 categories(over 100, 86-100, 72-86 and under 72)
select film_id, title, description, "length",
case 
    when "length" < 72 then 'under 72'
	when "length" >= 72 and "length" <= 86 then '2nd'
	when "length" >= 86 and "length" <= 100 then '3rd'
    else '4th'
end as "categories"
from film

-- Show me the COUNT of the four categories above. 
select case 
    when "length" < 72 then 'under 72'
	when "length" >= 72 and "length" <= 86 then '2nd'
	when "length" >= 86 and "length" <= 100 then '3rd'
    else '4th'
end as "categories", count(*)
from film
group by "categories"

-- Seperate the first three, last 8 number of phone in the address table into another column
select left(phone, 3) as first_3, right(phone, 8) as last_8 
from address

-- view all the columns in city and add two columns to show city as upper and lower case
select *, upper(city), lower(city)
from city

/* STRPOS can be used for comma(,), space( ) and fullstop(.) Split the email to show the name in caps before the fullstop(.)
If you omit -1 in the LEFT command, the result will have fullstop(.) at the end */ 
select strpos(email, '.'), upper(left(email, position('.' in email)-1))
from customer

-- split the street number from the address column
select left(address, charindex(' ', address) - 1) as street_number from address


select substring(address from '^\d+') as street_number, address
from address

SELECT address,
       district,
       city_id,
       STRPOS(address, ' '),
       POSITION(' ' IN address),
       LEFT(address, POSITION(' ' IN address)-1) as strt_number
FROM  address
LIMIT 5;

-- Combine first_name and last_name from the customer table to become full_name. PS: You can use either CONCAT or ||
select concat(first_name, ' ', last_name) as full_name
from customer

select (first_name|| ' '||last_name) as full_name
from customer

-- Do we have actors in the actor table that share the full name and if yes display those shared names
select count(*) as count, first_name, last_name from actor
group by first_name, last_name
having count(first_name||last_name) > 1
-- order by count desc

-- Display the customer names that share the same address (e.g. husband and wife).
select c.first_name, c.last_name from customer c
join address a
on a.address_id = c.address_id
group by first_name, last_name


select c1.first_name, c1.last_name, c2.first_name, c2.last_name
from customer c1
join customer c2
on c1.customer_id <> c2.customer_id and c1.address_id = c2.address_id
join address a
on c1.address_id = a.address_id


select c1.first_name, c1.last_name, c2.first_name, c2.last_name
from customer c1, customer c2
where c1.customer_id <> c2.customer_id and c1.address_id = c2.address_id

-- Display the total amount payed by all customers in the payment table.
select sum(amount) as "total amount" 
from payment

-- Display the total amount payed by each customer in the payment table.
select sum(p.amount) as "total amount", concat(c.first_name, ' ', c.last_name) as "full name"
from payment p
join customer c
on p.customer_id = c.customer_id
group by c.customer_id
order by c.customer_id

-- What is the highest total_payment done.
select sum(p.amount) as "total amount", concat(c.first_name, ' ', c.last_name) as "full name"
from payment p
join customer c
on p.customer_id = c.customer_id
group by c.customer_id
order by 1 desc
limit 1

-- What is the name of the customer who made the highest total payments.
select concat(first_name, ' ', last_name) as "full name"
from customer
where customer_id = (select customer_id
from payment 
group by customer_id
order by sum(amount) desc
limit 1)

-- What is the movie(s) that was rented the most.
select count(i.film_id), f.title
from inventory i
join rental r
on r.inventory_id = i.inventory_id
join film f
on f.film_id = i.film_id
group by f.title
order by count(i.film_id) desc
limit 1

--Which movies have been rented so far.
select distinct f.title
from inventory i
join rental r
on r.inventory_id = i.inventory_id
join film f
on f.film_id = i.film_id

-- Which movies have not been rented so far.
select title
from film
where film_id not in
(select distinct i.film_id
from inventory i
join rental r
on r.inventory_id = i.inventory_id)



select title
from film
where title not in (select distinct f.title
from inventory i
join rental r
on r.inventory_id = i.inventory_id
join film f
on f.film_id = i.film_id)


--Which customers have not rented any movies so far.
select concat(first_name, ' ', last_name) 
from customer
where customer_id
not in (select distinct customer_id
	   from rental)

select first_name,last_name
from customer c
where not exists
(select distinct customer_id
from rental r
where c.customer_id = r.customer_id)


-- Display each movie and the number of times it got rented.
select f.title, count(i.film_id) 
from rental r
join inventory i
on i.inventory_id = r.inventory_id
join film f
on f.film_id = i.film_id
group by f.title
order by count(i.film_id) desc


--Show the number of movies each actor acted in.
select concat(a.first_name, ' ', a.last_name) as "full name", count(f.film_id) as "total films"
from actor a
join film_actor fa
on fa.actor_id = a.actor_id
join film f
on f.film_id = fa.film_id
group by "full name"
order by "total films" desc

--Display the names of the actors that acted in more than 20 movies.
select concat(a.first_name, ' ', a.last_name) as "full name", count(f.film_id) as "total films"
from actor a
join film_actor fa
on fa.actor_id = a.actor_id
join film f
on f.film_id = fa.film_id
group by "full name"
having count(f.film_id) > 20
order by "total films" desc








