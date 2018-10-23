use sakila;

/******Query First & Last name from actor table*******/

select first_name, last_name 
from actor;

select concat(first_name, ' ', last_name) 
as 'Actor Name' 
from actor;


/*************Query with Where condition**************/
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

/*************Query with Where condition**************/