/*

Salary data Exploration
data source: https://www.kaggle.com/datasets/mohithsairamreddy/salary-data

Skills used: Aggregate functions, With clause, Subqueries, Unions, Case, Self-Join etc.

*/

select * 
from proyectos.salary;


--  Average salary by Education Level
select education_level, round(AVG(Salary),2) as average_salary
from proyectos.salary
group by education_level;

-- Max/Min Salary per gender
select gender, Max(Salary) max_salary, Min(Salary) as min_salary
from proyectos.salary 
group by gender;

-- jobs with more than 5 employees
select job_title, education_level, count(job_title) as num_empleados
from proyectos.salary 
group by job_title, education_level
having count(job_title) > 5;  


-- Average salary difference between men and women
WITH salary_average AS (
  SELECT gender, AVG(salary) AS average_salary
  FROM proyectos.salary 
  GROUP BY gender
)
SELECT 
  round(
  	ABS(
    	AVG(CASE WHEN gender = 'Male' THEN average_salary ELSE 0 END) - 
    	AVG(CASE WHEN gender = 'Female' THEN average_salary ELSE 0 END)
  ),
  2
  )	AS salary_difference
FROM salary_average;


-- Average Years of experience depending job title
select job_title, round(AVG(years_of_experience),3) as average_experience_years
from proyectos.salary 
group by job_title
having job_title like 'Software Developer' or job_title like 'Director of Data Science';


-- Average salary without including Max and Min salaries

select AVG(salary) as average_salary
from proyectos.salary 
where salary not in (
	select Max(Salary) from proyectos.salary
	union
	select Min(Salary) from proyectos.salary
)


-- Highest salary per education_level, just those which are above the AVG

select education_level, Max(salary) as highest_salary
from proyectos.salary
group by education_level
having Max(salary) > (select AVG(salary) from proyectos.salary)


-- Employees who have a salary above the average for their respective job position

SELECT ps.*
FROM proyectos.salary ps
JOIN (
  SELECT Job_Title, AVG(Salary) AS avg_salary
  FROM proyectos.salary
  GROUP BY Job_Title
) AS avg_ps
ON ps.Job_Title = avg_ps.Job_Title AND ps.Salary > avg_ps.avg_salary;


