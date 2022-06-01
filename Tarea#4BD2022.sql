-- Juan Pablo García Vega 000197628
-- Tarea 4
-- Funciones

--Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?
with promedio_pagos as(
with pagos_clientes as(
select concat(c.first_name, ' ', c.last_name) as cliente, c.customer_id, p.payment_date
from payment p join customer c using (customer_id)
)
-- lag() - el row anterior
select cliente, customer_id, payment_date - lag(payment_date) over(partition by customer_id order by payment_date) as diferencia_pago
from pagos_clientes
)
select cliente, (date_part('day', avg(diferencia_pago))||' días')||' '||(date_part('hour',avg(diferencia_pago))||' horas')||' '|| (date_part('minute',avg(diferencia_pago))||' minutos') as promedioqp
from promedio_pagos
group by cliente
order by promedioqp desc;



--Sigue una distribución normal?

CREATE OR REPLACE FUNCTION histogram(table_name_or_subquery text, column_name text)
RETURNS TABLE(bucket int, "range" numrange, freq bigint, bar text)
AS $func$
BEGIN
RETURN QUERY EXECUTE format('
  WITH
  source AS (
    SELECT * FROM %s
  ),
  min_max AS (
    SELECT min(%s) AS min, max(%s) AS max FROM source
  ),
  histogram AS (
    SELECT
      width_bucket(%s, min_max.min, min_max.max, 20) AS bucket,
      numrange(min(%s)::numeric, max(%s)::numeric, ''[]'') AS "range",
      count(%s) AS freq
    FROM source, min_max
    WHERE %s IS NOT NULL
    GROUP BY bucket
    ORDER BY bucket
  )
  SELECT
    bucket,
    "range",
    freq::bigint,
    repeat(''*'', (freq::float / (max(freq) over() + 1) * 15)::int) AS bar
  FROM histogram',
  table_name_or_subquery,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name,
  column_name
  );
END
$func$ LANGUAGE plpgsql;


create view histograma as(
with promedio_pagos as(
with pagos_clientes as(
select concat(c.first_name, ' ', c.last_name) as cliente, c.customer_id, p.payment_date
from payment p join customer c using (customer_id)
)
select cliente, customer_id, payment_date - lag(payment_date) over(partition by customer_id order by payment_date) as diferencia_pago
from pagos_clientes
)
select cliente, cast(extract(epoch from avg(diferencia_pago)) as integer) as promedioqp
from promedio_pagos
group by cliente
order by promedioqp desc
)

select * from histogram('histograma', 'promedioqp')

-- La relación no sigue una distribución normal porque no se parece a la campana de Gauss. Además, la distribución de
-- datos está sesgada hacia la derecha. 


--Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
-- No difiere nada, es el mismo. 

with promedio_pagos as(
with pagos_clientes as(
select concat(c.first_name, ' ', c.last_name) as cliente, c.customer_id, p.payment_date, r.rental_date
from payment p join customer c using (customer_id) join rental r using (customer_id)
)
select cliente, customer_id, payment_date - lag(payment_date) over(partition by customer_id order by payment_date) as diferencia_pago, r.rental_date - lag(r.rental_date) over(partition by c.customer_id order by c.customer_id, r.rental_date) as diferencia_renta
from pagos_clientes join rental r using (customer_id) join customer c using (customer_id)
)
select cliente, (date_part('day', avg(diferencia_pago))||' días')||' '||(date_part('hour',avg(diferencia_pago))||' horas')||' '|| (date_part('minute',avg(diferencia_pago))||' minutos') as promedioqp, (date_part('day', avg(diferencia_renta))||' días')||' '||(date_part('hour',avg(diferencia_renta))||' horas')||' '|| (date_part('minute',avg(diferencia_renta))||' minutos') as promediorenta
from promedio_pagos
group by cliente
order by promedioqp, promediorenta  desc;




