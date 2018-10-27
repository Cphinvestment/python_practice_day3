use sakila;

	

select first_name, last_name from actor
SET first_name=UPPER(first_name)
SET last_name=UPPER(last_name)

UPDATE actor

SELECT CONCAT(first_name,' ', last_name) AS "Actor Name" FROM `actor`

select actor_id, first_name, last_name
from actor
where actor_id in 
(
	select actor_id
	from actor
	where first_name in ('JOE')
    );

select actor_id, first_name, last_name
from actor
where actor_id in 
(
	select actor_id
	from actor
	where last_name like ('%GEN%')
    );
    
select last_name, first_name, actor_id
from actor
where actor_id in 
(
	select actor_id
	from actor
	where last_name like ('%LI%')
	ORDER BY last_name
    );


select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

alter table actor
	add description blob;
    
ALTER TABLE actor DROP COLUMN description;

select last_name, count(*)
from actor
group by last_name;

select last_name, count(*)
from actor
group by last_name
having count(*)>1;

UPDATE 
    actor
SET 
    first_name = REPLACE(first_name,'GROUCHO','HARPO')
    where last_name like 'WILLIAMS';
    
UPDATE 
    actor
SET 
    first_name = REPLACE(first_name,'HARPO','GROUCHO')
    where last_name like 'WILLIAMS';
    
show create table address;

select staff.first_name, staff.last_name, address.address
from staff
join address on staff.address_id=address.address_id;

select staff.staff_id, payment.totalamount
from staff
join (
select staff_id, sum(amount) as totalamount
from payment
group by staff_id
) as payment on staff.staff_id=payment.staff_id;

-- (6c)
SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS `Number of Actors`
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.title;

-- (6d)
SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id
) AS 'Number of Copies'
FROM film
WHERE title = "Hunchback Impossible";

SELECT customer.first_name, customer.last_name, sum(payment.amount) AS `Total Paid`
FROM customer 
JOIN payment  
ON customer.customer_id= payment.customer_id
GROUP BY customer.last_name;

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
Select actor_id
FROM film_actor
WHERE film_id IN 
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

SELECT * FROM genre_revenue;

DROP VIEW genre_revenue;