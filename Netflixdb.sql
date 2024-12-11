-- Information_schema: Información sobre la estructura y metadatos de la BD etc.
-- information_schema.columns
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'netflix_udemy' AND table_name = 'series';

-- information_schema.tables
SELECT 
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'netflix_udemy' AND table_name = 'series';


-- ¿Quien es el actor o actriz que ha participado en la mayor cantidad de series?
select a.actor_id , count(a.serie_id) as numero_series
from netflix_udemy.actuaciones a
group by a.actor_id
order by numero_series DESC

-- ¿Cual es la serie con mejor rating promedio segun imdb?
select e.serie_id, AVG(e.rating_imdb) as promedio_rating
from netflix_udemy.episodios e 
group by e.serie_id
order by promedio_rating DESC
limit 1;

-- ¿Cual es el episodio con la duración más larga?
select e.titulo, MAX(e.duracion) as duracion_max
from netflix_udemy.episodios e 
group by e.titulo
order by duracion_max desc
limit 1

-- Series con promedio de rating (imdb) mayor a 8
SELECT s.titulo, AVG(e.rating_imdb) AS promedio_rating
FROM netflix_udemy.episodios e
LEFT JOIN netflix_udemy.series s 
ON e.serie_id = s.serie_id 
GROUP BY s.titulo
HAVING AVG(e.rating_imdb) > 8;


-- JOINS
-- Inner Join
-- Consulta SQL que seleccione todos los campos de las tablas Series y Episodios donde el serie_id coincida entre ambas
select * from netflix_udemy.series s 
inner join netflix_udemy.episodios e 
on s.serie_id = e.serie_id 

-- consulta SQL que permita obtener el título de la serie, el título de cada episodio y su duración de la serie 'Stranger Things'.
select s.titulo as titulo_serie, e.titulo as titulo_episodio, e.duracion 
from netflix_udemy.series s 
inner join netflix_udemy.episodios e 
on s.serie_id = e.serie_id 
where s.titulo like 'Stranger Things'

-- Left join 
-- Consulta SQL que devuelva, para cada serie, su título, el título de cada episodio asociado (si hay alguno), y el rating de IMDb.
select s.titulo as titulo_serie, e.titulo as titulo_episodio, e.rating_imdb 
from netflix_udemy.series s 
left join netflix_udemy.episodios e 
on s.serie_id = e.serie_id 

-- ¿Qué géneros son más prevalentes en la base de datos NetflixDB? 
-- Genera una lista de los distintos géneros y la cantidad de series por cada uno.
select s.genero, count(*) as total_series
from netflix_udemy.series s 
group by s.genero
order by total_series desc

-- ¿Cuáles son las tres series con mayor promedio rating IMDB y cuántos episodios tienen? 
select s.titulo, AVG(e.rating_imdb) as rating_IMDB, count(e.episodio_id) as total_episodios
from netflix_udemy.series s 
left join netflix_udemy.episodios e 
on s.serie_id = e.serie_id 
group by s.serie_id 
order by rating_IMDB desc 
limit 3;

-- ¿Cuál es la duración total de todos los episodios para la serie "Stranger Things"? 
select SUM(e.duracion) as total_duracion 
from netflix_udemy.episodios e 
left join netflix_udemy.series s 
on e.serie_id = s.serie_id 
group by s.serie_id 
having s.titulo like 'Stranger Things'


-- SUBCONSULTAS
-- Consulta SQL que genera una lista de titulo de series cuyos episodios tienen un rating de IMDb superior a 8. 
select s.titulo 
from netflix_udemy.series s
where s.serie_id in
(select e.serie_id  from netflix_udemy.episodios e
where e.rating_imdb > 8)

-- Identificar 3 generos mas populares (en función de la cantidad de series). Para cada genero identificar: titulo, año, rating
select 
    s.titulo, 
    s.año_lanzamiento, 
    e.rating_imdb
from netflix_udemy.series s
left join netflix_udemy.episodios e
on s.serie_id = e.serie_id
WHERE 
    s.genero In (
        select genero
        from netflix_udemy.series
        group by genero
        order by COUNT(*) DESC
        Limit 3
    );
   

-- CONDICIONAL CASE. 
select e.titulo,
		e.rating_imdb, 
		case
			when e.rating_imdb >= 8 then 'Alto'
			else 'Bajo'
		End as categoria_rating
from netflix_udemy.episodios e 

/*
Consulta que seleccione el titulo de todas las series de la tabla Series junto con una nueva columna denominada 'Antigüedad'.
Esta columna debe mostrar 'Antigua' para las series lanzadas antes del año 2010 y 'Reciente' para las series lanzadas en 2010 o después
*/

select s.titulo,
	case
		when s.año_lanzamiento < 2010 then 'Antigua'
		else 'Reciente'
	end as Antigüedad
from netflix_udemy.series s 

--  Seleccione el titulo de todas las series y una nueva columna llamada 'Categoría de Género'
select s.titulo,
	case
		when s.genero = 'Drama' then 'Dramático'
		when s.genero = 'Comedia' then 'Divertido'
		else 'Otro'
	end as "Categoría de Género"
from netflix_udemy.series s 



-- CAST 
-- Consulta SQL para seleccionar el título de las series y el año de lanzamiento. 
select 
	s.titulo, 
	CAST(S.año_lanzamiento as Text)
from netflix_udemy.series s 



-- CTE (WITH)
with ListaEpisodios as (
    select e.serie_id, e.episodio_id, e.titulo
    from netflix_udemy.episodios e
),

ListaSeries as (
	select s.serie_id, s.descripcion from netflix_udemy.series s 
)

SELECT * FROM ListaEpisodios
left join ListaSeries
on ListaEpisodios.serie_id = ListaSeries.serie_id;

/*
Consulta SQL empleando una CTE para determinar la fecha del primer episodio transmitido de cada serie.
Debes seleccionar el título de cada serie y la fecha del primer episodio, presentando estos datos en dos columnas
finales llamadas 'Titulo de la Serie' y 'Fecha del Primer Episodio'
*/

with primer_episodio as (
	select e.serie_id, MIN(e.fecha_estreno) as Primer_Episodio
	from netflix_udemy.episodios e 
	group by e.serie_id 
	order by MIN(e.fecha_estreno) ASC
)

select s.titulo as "Titulo de la Serie", Primer_Episodio as "Fecha del Primer Episodio" from primer_episodio
inner join netflix_udemy.series s 
on primer_episodio.serie_id = s.serie_id 


/*
Consulta SQL que utilice una CTE para seleccionar el número total de series lanzadas por año para un género específico, digamos "Ciencia ficción".
Ordena los resultados por año de lanzamiento
*/

with series_por_anio as (
	select s.año_lanzamiento , count(*) as total_series
	from netflix_udemy.series s 
	group by s.año_lanzamiento, s.genero  
	having s.genero = 'Ciencia ficción'
)

select * from series_por_anio



-- **WINDOWN FUNCTIONS**
-- ROW_NUMBER()
select 
	s.titulo, 
	s.año_lanzamiento,
	row_number () over (order by s.año_lanzamiento Desc) as orden_lanzamiento
from netflix_udemy.series s 

-- Top 3 series más recientes
with orden_series as (
	select 
		s.titulo, 
		s.año_lanzamiento,
		row_number () over (order by s.año_lanzamiento Desc) as orden_lanzamiento
	from netflix_udemy.series s 
)

select * from orden_series
where orden_lanzamiento in (1,2,3)


/*
consulta SQL que seleccione todas las series, incluyendo su titulo y año_lanzamiento y utiliza la función
de ventana ROW_NUMBER() para asignar un número secuencial a cada serie basado en su año de lanzamiento
(ORDER BY año_lanzamiento DESC), de la más reciente a la más antigua, esta última columna debe tener el nombre:
clasificacion_global 
 */

select 
	s.titulo, 
	s.año_lanzamiento,
	row_number () over (order by s.año_lanzamiento desc) as clasificacion_global
from netflix_udemy.series s 

-- ROW_NUMBER() OVER(PARTITION BY...)
select 
	s.titulo, 
	s.genero,
	s.año_lanzamiento,
	row_number () over (partition by s.genero order by s.año_lanzamiento desc) as clasificacion_global
from netflix_udemy.series s 

/*
Escribe una consulta SQL que seleccione la temporada, el título del episodio, la fecha de estreno y utilice
ROW_NUMBER() en combinación con PARTITION BY para asignar un ranking de episodios basado en su fecha de estreno
(de más reciente a más antiguo DESC), está nueva columna deberá tener el nombre: ranking_temporada
*/
select 
	e.temporada, 
	e.titulo, 
	e.fecha_estreno,
	row_number () over(partition by e.temporada order by e.fecha_estreno desc) as ranking_temporada
from netflix_udemy.episodios e 

/*
Consulta de SQL que genere un ranking de episodios para cada temporada de Stranger Things (serie_id = 2) 
basándose en las calificaciones de IMDb, de modo que pueda identificar los episodios mejor valorados dentro de cada temporada.
 */

select 
	e.temporada,
	e.titulo ,
	e.rating_imdb,
	row_number () over (partition by e.temporada order by e.rating_imdb desc) as "Ranking IMDb"
from netflix_udemy.episodios e 
where serie_id = 2;


-- RANK
select 
	e.titulo,
	e.rating_imdb,
	rank() over (order by e.rating_imdb desc) as ranking_imdb
from netflix_udemy.episodios e 

-- DENSE_RANK
select 
	e.titulo,
	e.rating_imdb,
	dense_rank() over (order by e.rating_imdb desc) as ranking_imdb
from netflix_udemy.episodios e 


-- Series más exitosas: Tabla con 3 columnas: Titulo serie, cantidad episodios y rating promedio
select 
	s.titulo,
	count(e.episodio_id),
	avg(e.rating_imdb) as avg_rating,
	row_number () over(order by AVG(e.rating_imdb) DESC) as avg_rating
from netflix_udemy.series s 
left join netflix_udemy.episodios e 
on s.serie_id = e.serie_id 
group by s.serie_id, s.titulo 
order by avg(e.rating_imdb) desc

-- Con CTEs
with episodios_recientes as (
	select 
		e.serie_id,
		count(e.episodio_id) as num_episodios
	from netflix_udemy.episodios e 
	group by e.serie_id 
),

calificaciones as (
	select 
		e.serie_id,
		avg(e.rating_imdb) as promedio_imdb
	from netflix_udemy.episodios e 
	group by e.serie_id 
)

select 
	s.titulo,
	er.num_episodios,
	c.promedio_imdb
from netflix_udemy.series s 
join episodios_recientes er on s.serie_id = er.serie_id
join calificaciones c on s.serie_id = c.serie_id
order by c.promedio_imdb desc, er.num_episodios desc;




