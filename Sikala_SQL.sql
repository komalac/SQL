use sakila;

/******1. Query First & Last name from actor table*******/

select first_name, last_name 
from actor;

select concat(first_name, ' ', last_name) 
as 'Actor Name' 
from actor;



/*************2. Query with Where condition**************/
select actor_id, first_name, last_name 
from actor
where first_name = "Joe";

select * 
from actor
where last_name	like ('%GEN%');

select * 
from actor
where last_name	like ('%LI%')
order by last_name, first_name;

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');




/*************3. Alter table actor to add column & then delete the column**************/
Alter table actor
add column description blob;

Alter table actor
drop column description;



/*************4. Query & change actor names**************/
#list last names and number of actors with same last name
select last_name, count(last_name) as 'Number of actors'
from actor
group by last_name;

#list last names and number of actors with same last name, for the ones occuring twice or more
select last_name, count(last_name) as 'Number of actors'
from actor
group by last_name
having count(last_name) > 1;

#Updating firstname column
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";

#toggle SAFE update to update only with first_name (non key column)
SET SQL_SAFE_UPDATES = 0;

#updating firstname
update actor 
set first_name = "GROUHCO" 
where first_name =  "HARPO";

#toggle SAFE update back to default
SET SQL_SAFE_UPDATES = 1;




/*************5. Schema of 'address' table**************/

#Schema of address table
describe address;



/*************6. Using Joins**************/

#join staff & address to display name & address
select first_name, last_name, address
from staff
inner join address
on staff.address_id = address.address_id;

#join staff & payment staff name & total amount for 8th month of 2005
select first_name, last_name, sum(amount)
from staff
inner join payment
on staff.staff_id = payment.staff_id
where month(payment_date) = 8 and year(payment_date) = 2005
group by first_name, last_name;


#list all film and actors in that film
select f.title, count(fa.actor_id) as 'Number of Actors'
from film as f
inner join film_actor as fa
on f.film_id = fa.film_id
group by f.title;

#list number of copies of film 'Hunchback Impossible'
select count(inventory_id) as 'Number of Copies'
from inventory
where film_id = (
				select film_id 
                from film 
                where title = 'Hunchback Impossible'
                );

#list all customers in ASEC of First Name and total amount paid
select first_name, last_name, sum(amount)
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by first_name, last_name
order by last_name;


/*************7. Sub Query**************/

#list all movies starting with K & Q and language English
select title 
from film
where title like 'K%' or title like 'Q%'
and language_id = (
					select language_id 
                    from language 
                    where name = 'English'
                    );
                    

#list all actors in film Alone Trip
select first_name, last_name
from actor
where actor_id IN (
					select actor_id 
                    from film_actor 
                    where film_id = (
									select film_id 
									from film 
                                    where title = 'Alone Trip'
                                    )
					);
                    

#list name & email of all Canadian customers
select first_name, last_name, email from customer
where address_id IN (
					select address_id 
                    from address
                    inner join city
                    on address.city_id = city.city_id 
                    where city.country_id = (
											select country_id 
                                            from country 
                                            where country = 'Canada'
                                            )
					);
                    


#list all movies categorized as Family movies
select title 
from film
where film_id IN (
					select film_id 
                    from film_category 
                    where category_id = (
										select category_id 
                                        from category 
                                        where name = 'Family'
                                        )
					);
                    

#list most frequently rented movies in desc
select title, count(rental_id)
from film
where film_id in select(
