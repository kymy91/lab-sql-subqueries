/*Lab | SQL Subqueries
In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

Instructions
1. How many copies of the film Hunchback Impossible exist in the inventory system?*/
USE sakila;

#join
Select * FROM sakila.inventory AS i
JOIN sakila.film AS f
on f.film_id = i.film_id;

#subquery
SELECT count(inventory_id) AS countfilms FROM sakila.inventory
	WHERE film_id IN (SELECT film_id FROM sakila.film 
    WHERE title = 'Hunchback Impossible');
#Answer 6


#WIth title
select title, count(i.inventory_id) AS nr_of_copies 
from inventory i
	join film f on i.film_id = f.film_id 
where i.film_id in (
	select film_id 
    from film
    where title='Hunchback Impossible'
    );
	

#2. List all films whose length is longer than the average of all the films.
SELECT title, length  from film
where length > (SELECT avg(length) from film)
order by length ASC;
  
#3. Use subqueries to display all actors who appear in the film Alone Trip.
select a.actor_id, a.first_name, a.last_name
from sakila.actor as a
    join sakila.film_actor as fa
    on fa.actor_id = a.actor_id
	join sakila.film as f
    on f.film_id = fa.film_id 
where f.title in (
	select title
    from sakila.film
    where title='Alone Trip'
    );
#8

#4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
#Identify all movies categorized as family films.

select title as Family_Movies
from film
where film_id in (
		select film_id
		from film_category
		where category_id in (
				select category_id
				from category
				where name = "Family"
                order by name DESC));

# return 69 

#5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
#Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
#that will help you get the relevant information.

select c.first_name, c.last_name, c.email from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'Canada';

#Subquery:

SELECT CONCAT(first_name, ' ' ,last_name) As Cust_Name , email
FROM customer
WHERE address_id IN (
	SELECT address_id
    FROM address
    WHERE city_id IN (
		SELECT city_id
        FROM city
        WHERE country_id IN (
			SELECT country_id
            FROM country
            WHERE country = "Canada")));




#6. Which are films starred by the most prolific actor? 
#Most prolific actor is defined as the actor that has acted in the most number of films. 
#First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


select count(film_id), actor_id from film_actor
group by actor_id
order by count(film_id) DESC
Limit 1;  

-- 1st option 
SELECT fa.film_id, f.title as title, fa.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name
FROM film_actor as fa 
Join film as f
on fa.film_id = f.film_id
Join actor as a on a.actor_id=fa.actor_id
having actor_id = "107";

-- 2nd option
Select title from film where film_id in (select film_id from film_actor f join (select actor_id, count(film_id) as no_movies from film_actor
group by actor_id
order by count(film_id) DESC
limit 1) as sub on f.actor_id = sub.actor_id);



#7. Films rented by most profitable customer. 
#You can use the customer table and payment table to find the most profitable 
#customer ie the customer that has made the largest sum of payments

SELECT sum(amount), customer_id
FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC;

SELECT film_id
FROM inventory
WHERE inventory_id IN (
	SELECT inventory_id
    FROM rental
    WHERE rental_id IN (
		SELECT rental_id
        FROM payment
        WHERE customer_id = "526"));

# 8 customers who spent more than the average payments.

select first_name, last_name 
from customer 
where customer_id in
(select customer_id from payment where amount > (SELECT avg(amount)
FROM payment ))
group by customer_id;
