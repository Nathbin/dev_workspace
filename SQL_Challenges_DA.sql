/*Question 1:
Level: Simple
Topic: DISTINCT
Task: Create a list of all the different (distinct) replacement costs of the films.
--Question: What's the lowest replacement cost?

Result_1*/
select distinct replacement_cost as Cout_Remplacement 
from film
order by replacement_cost asc

select distinct min(replacement_cost) as Min_cost
from film

/*Question 2:
Level: Moderate
Topic: CASE + GROUP BY
Task: Write a query that gives an overview of how many films have replacements costs in the
following cost ranges: low: 9.99 - 19.99, medium: 20.00 - 24.99, high: 25.00 - 29.99
Question: How many films have a replacement cost in the 'low' group?

Result_2*/

select 	category,
			count (*) as nber_films
From (		
	select
	case
		when replacement_cost between 9.99 and 19.99 then 'Low'
		when replacement_cost between 20.00 and 24.99 then 'Medium'
		when replacement_cost between 25.00 and 29.99 then 'High'
	End as category
	from film )
group by category
order by nber_films desc

/*Question 3:
Level: Moderate
Topic: JOIN
Task: Create a list of the film titles including their title, length, and category name ordered
descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.
Question: In which category is the longest film and how long is it?

Result_3*/

select title, length, name
from film
full outer join category
on film.film_id = category.category_id
--where name in ('Drama', 'Sports')
order by length desc

/*Question 4:
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create an overview of how many movies (titles) there are in each category (name).
Question: Which category (name) is the most common among the films?

Result_4*/

select 	name,
		count(*)
from (
	select 	title, 
			length, 
			name
	from film
	full outer join category
	on film.film_id = category.category_id)
group by name

/*Question 5:
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create an overview of the actors' first and last names and in how many movies they appear
in.
Question: Which actor is part of most movies?

Result_5*/

select first_name, last_name, count(*)
from (
select first_name, last_name, film_id
from actor
full outer join film_actor
on actor.actor_id = film_actor.actor_id)
group by first_name, last_name
order by count (*) desc


/*Question 6:
Level: Moderate
Topic: LEFT JOIN & FILTERING
Task: Create an overview of the addresses that are not associated to any customer.
Question: How many addresses are that?

Result_6*/

select count(*)
from (
select *
from address
Left join customer 
on address.address_id = customer.address_id
where customer.customer_id is null)


/*Question 7:
Level: Moderate
Topic: JOIN & GROUP BY
Task: Create the overview of the sales to determine from which city (we are interested in the city in
which the customer lives, not where the store is) most sales occur.
Question: What city is that and how much is the amount?


Result_7*/

select city, sum(amount) as total_sales
from (
		select *
		from (
			select *
			from customer
			Inner join payment
			On customer.customer_id = payment.customer_id) as tab_1
		Inner join address
		on tab_1.address_id = address.address_id) as tab_2
Inner join city
on tab_2.city_id = city.city_id
group by city
order by total_sales desc
Limit 1

/*Question 8:
Topic: JOIN & GROUP BY
Task: Create an overview of the revenue (sum of amount) grouped by a column in the format
'country, city'.
Question: Which country, city has the least sales?


Result_8*/

select city, sum(amount) as total_sales
from (
		select *
		from (
			select *
			from customer
			Inner join payment
			On customer.customer_id = payment.customer_id) as tab_1
		Inner join address
		on tab_1.address_id = address.address_id) as tab_2
Inner join city
on tab_2.city_id = city.city_id
group by city
order by total_sales desc
Limit 1

select country, city, sum(amount) as total_sales
from (
	select *
	from (
			select *
			from (
				select *
				from customer
				inner join payment
				On customer.customer_id = payment.customer_id) as tab_1
			Inner join address
			on tab_1.address_id = address.address_id) as tab_2
	Inner join city
	on tab_2.city_id = city.city_id) as tab_3
Inner join country
on tab_3.country_id = country.country_id
group by city, country
order by total_sales desc
limit 1

/*Question 9:
Level: Difficult
Topic: Uncorrelated subquery
Task: Create a list with the average of the sales amount each staff_id has per customer.
Question: Which staff_id makes on average more revenue per customer?

Result_9*/

select staff_id, round(avg(sum_sale), 2) as average_sale
from (
		select staff_id, customer_id, sum (amount) as sum_sale
		from payment
		group by staff_id, customer_id) 
group by staff_id
order by average_sale desc
limit 1


/*Question 10:
Level: Difficult to very difficult
Topic: EXTRACT + Uncorrelated subquery
Task: Create a query that shows average daily revenue of all Sundays.
Question: What is the daily average revenue of all Sundays?

Result_10*/

Select sunday, round (avg(amount), 2)
from (
		Select amount, extract(ISODOW from payment_date) as sunday
		from payment)
where sunday = '7'
group by sunday

/*Question 11:
Level: Difficult to very difficult
Topic: Correlated subquery
Task: Create a list of movies - with their length and their replacement cost - that are longer than the
average length in each replacement cost group.
Question: Which two movies are the shortest on that list and how long are they?

Result_11*/
Select film_id, title, length, replacement_cost
from film
where replacement_cost > (Select round (avg(replacement_cost), 2) from film)
order by replacement_cost desc
limit 2