/*

Happiness Index (2018-2019) data Exploration
data source: https://www.kaggle.com/datasets/sougatapramanick/happiness-index-2018-2019

Skills used: Aggregate functions, With clause, Subqueries, Unions, Case, Self-Join etc.

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

-- Get the country with the highest score in "freedom_to_make_life_choices" in 2018 and its ranking.








