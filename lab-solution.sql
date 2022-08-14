USE sakila;
-- 1.How many copies of the film Hunchback Impossible exist in the inventory system?
  
    SELECT  count(inventory_id) as copy_num 
    from sakila.inventory
    where film_id in (
      SELECT film_id
      FROM sakila.film
      WHERE title = 'Hunchback Impossible'
    ) ;
 



  SELECT * FROM bank.trans
  WHERE k_symbol IN (
    SELECT k_symbol AS symbol FROM (
      SELECT avg(amount) AS Average, k_symbol
      FROM bank.order
      WHERE k_symbol <> ' '
      GROUP by k_symbol
      HAVING Average > 3000
      ORDER BY Average DESC
    ) sub1
  );

-- 2.List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film
WHERE length > (
  SELECT avg(length)
  FROM sakila.film
);

-- 3.Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.actor
where actor_id  in (
select actor_id from sakila.film_actor
where film_id in (
select film_id from sakila.film
where title = 'Alone Trip'
) 
) ;

select * from sakila.film;
select * from sakila.film_actor
;
-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select * from sakila.film
where film_id in (
select film_id from sakila.film_category
where category_id in (
select category_id from sakila.category
where name = 'Family'
)
);

-- 5.Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select first_name,last_name,email from sakila.customer
where address_id in (
select address_id from sakila.address
where city_id in(
select city_id from sakila.city
where country_id in (
select country_id from sakila.country
where country = 'Canada'
)
)
);


-- 6.Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
SELECT a.actor_id,a.first_name,a.last_name, count(fa.actor_id) AS total_amount
FROM sakila.film_actor as fa
LEFT JOIN sakila.actor as a
ON fa.actor_id = a.actor_id
group by a.first_name
order by total_amount desc
limit 1;

select title from sakila.film
where film_id in(
select film_id from sakila.film_actor
where actor_id = 88);
-- I cannot select the most prolific actor in the subquery since we cannot use limit in the subquery,So what I’ve done is just just to subquery seperatly.
-- By first subquery we know that the actor id of the most prolofic actor is 88,then we use it directly in the second subquery.


-- 7.Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select customer_id,sum(amount) from sakila.payment
group by customer_id
order by sum(amount) desc
limit 1;
-- the most profitable customer number is 526
SELECT title FROM film
WHERE film_id IN (
	SELECT film_id FROM inventory
    WHERE store_id IN(
		SELECT store_id  FROM customer
        WHERE customer_id=526));
-- we select the film which is rented by this customer by fix the customer_id

-- 8.Customers who spent more than the average payments.
select customer_id ,avg(amount) from sakila.payment; 
-- the average payment is around 4.20
SELECT customer_id, first_name, last_name FROM customer
WHERE customer_id IN (
	SELECT customer_id FROM payment
    WHERE amount > 4.20);

