/*

Happiness Index (2018-2019) data Exploration
data source: https://www.kaggle.com/datasets/sougatapramanick/happiness-index-2018-2019

Skills used: Aggregate functions, With clause, Subqueries, Unions, Case, Joins etc.

*/

select * from proyectos.happ_2018 h18
select * from proyectos.happ_2019 h19

-- Obtain the five countries with the highest score in the happiness index in the year 2019.
select country_or_region, score
from proyectos.happ_2019
order by score desc 
limit 5;

-- Obtain the average happiness score by region in 2018.
select country_or_region, AVG(Score) as average_score
from proyectos.happ_2018
group by country_or_region;

-- Get the country with the biggest improvement in happiness score from 2018 to 2019.
Select h19.country_or_region, (h19.score - h18.score) as difference
from proyectos.happ_2019 h19
inner join proyectos.happ_2018 h18 on h19.country_or_region = h18.country_or_region
group by h19.country_or_region, difference
order by difference desc
limit 1;

-- Get the country with the highest GDP per capita score in 2018 and its ranking.
select country_or_region, gdp_per_capita
from proyectos.happ_2018
where gdp_per_capita in (select MAX(gdp_per_capita) from proyectos.happ_2018);

-- Obtain the country with the lowest healthy life expectancy in 2019 and its ranking.
SELECT overall_rank, country_or_region, healthy_life_expectancy
FROM proyectos.happ_2019
WHERE healthy_life_expectancy = (SELECT MIN(healthy_life_expectancy) FROM proyectos.happ_2019);


/* 
Get the average happiness score for each year (2018 and 2019) and show if there was an improvement, 
decrease or stayed the same
*/

WITH average_per_year AS (
    SELECT AVG(h18.score) AS average_2018, AVG(h19.score) AS average_2019
    FROM proyectos.happ_2018 h18
    INNER JOIN proyectos.happ_2019 h19 ON h18.country_or_region = h19.country_or_region
)
SELECT 
    CASE 
        WHEN (average_2019 - average_2018) = 0 THEN 'Stayed same'
        WHEN (average_2019 - average_2018) < 0 THEN 'Decrease'
        ELSE 'Improvement'
    END AS score_change
FROM average_per_year;


-- Get the country with the highest/lowest score in "freedom_to_make_life_choices" in 2018 and its ranking.
select country_or_region, freedom_to_make_life_choices
from proyectos.happ_2018 
where freedom_to_make_life_choices = (select Max(freedom_to_make_life_choices) from proyectos.happ_2018)
union 
select country_or_region, freedom_to_make_life_choices
from proyectos.happ_2018 
where freedom_to_make_life_choices = (select Min(freedom_to_make_life_choices) from proyectos.happ_2018)
order by freedom_to_make_life_choices desc;


-- Average score (2018 & 2019)
select '2018' as year, round(avg(score),2) from proyectos.happ_2018 -- 4740,95
union
select '2019' as year, round(avg(score),2) from proyectos.happ_2019 -- 5407,1


-- Obtain the countries with a happiness score above the average in both years (2018 and 2019).
WITH countries_score AS (
  SELECT h18.country_or_region, h18.score AS country_score_2018, h19.score AS country_score_2019
  FROM proyectos.happ_2018 h18
  INNER JOIN proyectos.happ_2019 h19 ON h18.country_or_region = h19.country_or_region
)
SELECT country_or_region, country_score_2018, country_score_2019
FROM countries_score
WHERE country_score_2018 > (SELECT AVG(h18.score) FROM proyectos.happ_2018 h18) 
	AND country_score_2019 > (SELECT AVG(h19.score) FROM proyectos.happ_2019 h19);


-- Get the country with the largest difference in generosity score between 2018 and 2019.
with generosity_scores as (
	select h18.country_or_region, h18.generosity as generosity_sc2018, h19.generosity as generosity_sc2019
	from proyectos.happ_2018 h18
	INNER JOIN proyectos.happ_2019 h19 ON h18.country_or_region = h19.country_or_region
)
select country_or_region, generosity_sc2018, generosity_sc2019, 
(generosity_sc2019 - generosity_sc2018) as difference_in_score
from generosity_scores
order by difference_in_score desc
limit 1;

/*
Obtain the ranking of countries according to their happiness score in 2018, considering categories based on
intervals.
*/

-- Max & Min. (2018: 7.6 - 6)

WITH scores AS (
  SELECT
    (SELECT MAX(score) FROM proyectos.happ_2018) AS max_score_2018,
    (SELECT MIN(score) FROM proyectos.happ_2018) AS min_score_2018
)
SELECT
  max_score_2018,
  min_score_2018
FROM scores;

/*
INTERVALS
	>= 7.5 ('Very High')
    >= 6.5 AND < 7.5 ('Alta')
    >= 5.5 AND < 6.5 ('Media')
    else 'Baja'
*/

SELECT
  country_or_region,
  score,
  CASE
    WHEN score >= 7.5 THEN 'Muy alta'
    WHEN score >= 6.5 AND score < 7.5 THEN 'Alta'
    WHEN score >= 5.5 AND score < 6.5 THEN 'Media'
    ELSE 'Baja'
  END AS happiness_category
FROM proyectos.happ_2018;
