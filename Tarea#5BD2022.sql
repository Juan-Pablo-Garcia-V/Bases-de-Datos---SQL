-- Juan Pablo García Vega 000197628--
-- Tarea 5--

--Parte de la infraestructura es diseñar contenedores cilíndricos giratorios para facilitar la colocación y extracción de discos por brazos automatizados. Cada cajita de Blu-Ray mide 20cm x 13.5cm x 1.5cm, y para que el brazo pueda manipular adecuadamente cada cajita, debe estar contenida dentro de un arnés que cambia las medidas a 30cm x 21cm x 8cm para un espacio total de 5040 centímetros cúbicos y un peso de 500 gr por película.

--Se nos ha encargado formular la medida de dichos cilindros de manera tal que quepan todas las copias de los Blu-Rays de cada uno de nuestros stores. Las medidas deben ser estándar, es decir, la misma para todas nuestras stores, y en cada store pueden ser instalados más de 1 de estos cilindros. Cada cilindro aguanta un peso máximo de 50kg como máximo. El volúmen de un cilindro se calcula de [ésta forma.](volume of a cylinder)

--Esto no se resuelve con 1 solo query. El problema se debe partir en varios cachos y deben resolver cada uno con SQL.

--La información que no esté dada por el enunciado del problema o el contenido de la BD, podrá ser establecida como supuestos o assumptions, pero deben ser razonables para el problem domain que estamos tratando.


--La altura está dada por la altura de cada película en el cilindro por su altura con el arnés (8 cm de altura).
--Agregué 10 cm porque no creo que las medidas estén justitas.  
-- Si cada cilindro puede almacenar 50kg, podemos poner 100 en cada uno dado que cada película pesa 500 gr.
-- Estamos asumiendo que el arnés pesa casi nada, pues tendríamos que quitar películas si el arnés pesara mucho. 

with altura_cilindro as (
select (100*8) + 10 as altura_cilindro_formula 
),
--El radio tiene que ser lo suficientemente grande para el arnés. Un radio de 20 será suficiente. Es más chico que el lado más largo del arnés para que este pueda sostenerlo. 
radio_cilindro as (
select 25 as radio_cilindro_formula 
)
--Las medidas de los cilindros a hacer están dadas por:
select altura_cilindro_formula, radio_cilindro_formula, pi()*power(radio_cilindro_formula, 2)*altura_cilindro_formula as volumen_cilindro
from altura_cilindro, radio_cilindro


-- Para calcular cuantas necesitamos por tienda

--Reconocemos que solo hay dos tiendas
select s.store_id from store s group by s.store_id;

-- Hay 2311 peliculas para la store 2 y 2270 para la store 1
select s.store_id, count(i.inventory_id) as numero_peliculas_tienda
from inventory i inner join store s using(store_id)
group by s.store_id

with numero_peliculas as(
select s.store_id, count(i.inventory_id) as numero_peliculas_tienda
from inventory i inner join store s using(store_id)
group by s.store_id
),

cilindros_por_tienda as (
-- Si en cada cilindro caben 100, y en cada tienda hay su respectiva cantidad, solo dividimos
select np.store_id as tienda, np.numero_peliculas_tienda/100 as Número_de_cilindros_por_tienda
from numero_peliculas np
order by tienda asc
)
select * from cilindros_por_tienda 





