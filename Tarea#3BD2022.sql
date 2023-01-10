-- Juan Pablo García Vega, 000197628--
-- Tarea 3 --
-- Group by III--

-- Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?

select concat(c.first_name, ' ', c.last_name) as nombre_completo, c.email 
from customer c inner join address a using(address_id)
inner join city ciu using(city_id)
inner join country pai using (country_id)
where pai.country = 'Canada';


-- Qué cliente ha rentado más de nuestra sección de adultos?

select concat(c.first_name, ' ', c.last_name) as nombre_completo, count(r.customer_id)
from film f inner join inventory i using(film_id) 
inner join rental r using(inventory_id)
inner join customer c using(customer_id)
where f.rating = 'NC-17' -- or f.rating = 'R' (?) no supe si considerar la R como filmes de adultos porque adolescentes tambien pueden ir a verlas. 
group by c.customer_id 
order by count(r.customer_id) desc limit 1;

-- Qué películas son las más rentadas en todas nuestras stores?
select distinct on (i.store_id) i.store_id, f.title, count(f.film_id)
from film f join inventory i using(film_id)
inner join rental r using(inventory_id)
inner join store s using (store_id)
inner join address a using (address_id)
inner join city c using (city_id)
group by i.store_id, f.film_id 
order by i.store_id, count(f.film_id) desc;

--select i.store_id from inventory i join rental r using(inventory_id);
-- Solo hay 2 stores

-- Cuál es nuestro revenue por store?
select i.store_id, concat('$', sum(p.amount)) as revenue
from inventory i inner join rental r using(inventory_id)
inner join payment p using(rental_id)
group by i.store_id;


