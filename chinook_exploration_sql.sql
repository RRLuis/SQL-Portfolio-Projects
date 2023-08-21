/*
Chinook Database 

This sample music store database provides a realistic environment for exploring
and practicing SQL. With interconnected tables representing artists, albums, tracks,
customers, invoices, and employees, you can sharpen your SQL skills by querying and
manipulating data in this simulated music store scenario.

*/

-- Songs and their albums
select t.Name as song, ab.Title as album_title
from project_chinook.Track t 
inner join project_chinook.Album ab on t.AlbumId = ab.AlbumId
order by album_title asc;

-- Calculate the total number of songs sold by genre, ordered from highest to lowest.
select g.Name, g.genreid, SUM(iv.quantity) as total_sales
from project_chinook.genre g
join project_chinook.track t on g.genreid = t.genreid
join project_chinook.invoiceline iv on t.trackid = iv.trackid 
group by g.genreid
order by total_sales desc;

-- Get a list of all employees with their respective subordinates (if they have any).
select e.employeeid , e.firstname, e.title, e2.firstname as subordinate
from project_chinook.employee e 
left join project_chinook.employee e2 on e.employeeid = e2.reportsto 
order by e.firstname asc;

-- Shows a list of customers with their respective assigned support employee.
select concat(c.firstname, ' ', c.lastname) as customer_name, e.firstname as support_employer_name
from project_chinook.customer c
join project_chinook.employee e on c.supportrepid  = e.employeeid 

-- Get the title of each album along with the total duration of all the songs in minutes.
select a.title, SUM(t.milliseconds)/60000 as total_duration_minutes
from project_chinook.album a 
join project_chinook.track t on a.albumid = t.albumid
group by a.albumid;

-- Get the title and length of the third longest songs in the database
select t.Name as song, (t.milliseconds / 1000) as duration_seconds
from project_chinook.track t 
order by duration_seconds desc
limit 1 offset 2;

-- Calculates the total spend for each customer and displays the customer's name along
-- with the total amount spent.
select  concat(c.firstname, ' ', c.lastname) as customer_name, sum(i.total) as total_spent
from project_chinook.customer c 
join project_chinook.invoice i on c.customerid = i.customerid 
group by c.customerid
order by total_spent desc
limit 5;

-- Get the title of each song along with the name of the artist and the name of the album it belongs to.
select ar.name as artist_name, a.title as album_name, t.Name as song_name 
from project_chinook.track t 
join project_chinook.album a on t.albumid = a.albumid 
join project_chinook.artist ar on a.artistid = ar.artistid 
order by artist_name, album_name asc;

-- It shows the name of each customer along with the number of invoices they have made.
select concat(c.firstname, ' ', c.lastname) as customer_name, count(i.invoiceid) as num_invoices
from project_chinook.customer c 
join project_chinook.invoice i on c.customerid = i.customerid 
group by c.customerid;

-- Calculates the total sales by country and displays the country along with the total
-- amount of sales, ordered from highest to lowest.

select c.country, round(sum(i.total),2) as total_sales
from project_chinook.customer c
join project_chinook.invoice i on c.customerid = i.customerid 
group by c.country 
order by total_sales desc;

-- Displays the title of songs that are not associated with any album.
select t.name as song_name
from project_chinook.track t 
left join project_chinook.album a on t.albumid = a.albumid 
where a.albumid is null;

-- Find the name of artists who have no albums in the database.

select Name as artist_name
from project_chinook.artist  
where artistid not in (select distinct artistid from project_chinook.album)

-- Find album titles that have songs longer than 5 minutes in length.
-- Option A
select distinct(a.title)
from project_chinook.album a
where a.albumid in (
	select t.albumid
	from project_chinook.track t 
	where (t.milliseconds > 300000)
);
-- Option B
select distinct a.title 
from project_chinook.album a
join project_chinook.track t on a.albumid = t.albumid 
where t.milliseconds > 300000;


-- Shows the title of the songs that have more than 20 characters.
select t.name as song_name
from project_chinook.track t 
where length(t.name) > 20;

-- Get a list of all employees with their hire date formatted as "MM/DD/YYYY".
select e.firstname || ' ' || e.lastname as employee_name, to_char(e.hiredate,'MM/DD/YY') as hire_date  
from project_chinook.employee e 

-- Get a list of all employees with their age calculated from their date of birth.
SELECT 
    e.firstname AS employee_name, 
    EXTRACT(YEAR FROM e.birthdate) AS birth_year,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.birthdate)) AS age
FROM 
    project_chinook.employee e;

-- Shows the name of each genre along with the number of songs associated with it.
select g.name as genre, count(t.trackid) as num_songs
from project_chinook.genre g 
join project_chinook.track t on g.genreid = t.genreid 
group by g.genreid
order by num_songs desc;

-- Find albums that have more than 25 songs:
select ar.name , a.Title as album_name, count(t.trackid) as total_tracks
from project_chinook.artist ar 
join project_chinook.album a on ar.artistid = a.artistid 
join project_chinook.track t on a.albumid = t.albumid 
group by ar.name , a.albumid, a.title
having count(t.trackid) >= 25; 

-- Find customers who have made more than three purchases and whose total spend on all purchases is more than $45:
select c.customerid, concat(c.FirstName, ' ', c.lastname) as customer_name, count(i.invoiceid) as num_purchases, sum(i.total) as total_spent
from project_chinook.customer c 
join project_chinook.invoice i on c.customerid = i.customerid 
group by c.customerid, customer_name
having count(i.invoiceid) > 3 and sum(i.total) > 45.0
order by c.customerid asc, total_spent desc;

-- Displays each customer's name along with a list of all the songs they've purchased,
-- sorted by purchase date in descending order.

WITH CustomerPurchases AS (
  SELECT
    project_chinook.customer.firstname as customer_name,
    project_chinook.invoiceline.unitprice, project_chinook.track."name" as song,
    ROW_NUMBER() OVER (PARTITION BY project_chinook.customer.CustomerId ORDER BY project_chinook.invoice.invoicedate DESC) AS PurchaseRank
  FROM
    project_chinook.customer
    JOIN project_chinook.invoice ON project_chinook.customer.CustomerId = project_chinook.invoice.CustomerId
    JOIN project_chinook.invoiceline ON project_chinook.invoice.InvoiceId = project_chinook.invoiceline.InvoiceId
    JOIN project_chinook.track ON project_chinook.invoiceline.TrackId = project_chinook.track.TrackId
)

SELECT customer_name, song, UnitPrice, PurchaseRank
FROM CustomerPurchases;


-- Calculates the total sales by employee and year, showing the name of the employee, 
-- the year and the total amount of sales.

WITH employee_sales AS (
    select e.employeeid, e.firstname, EXTRACT(YEAR FROM i.invoicedate) AS year, SUM(i.total) AS total_amount
    	from project_chinook.employee e
        JOIN project_chinook.customer c ON e.employeeid = c.supportrepid
        JOIN project_chinook.invoice i ON c.customerid = i.customerid
    GROUP by e.employeeid, e.firstname, year
)
select firstname, year, total_amount
from employee_sales
ORDER by firstname, year;


-- It shows the title of each song along with the number of times it has been purchased and its
-- popularity position in terms of number of purchases.

with SongPopularity as (
	select t.trackid, t.Name as song_name, count(i.invoicelineid) as num_purchases,
	RANK() over (order by count(i.invoicelineid) desc) as popularity_rank
	from project_chinook.track t 
	left join project_chinook.invoiceline i on t.trackid = i.trackid 
	group by t.trackid
)

select trackid, song_name, num_purchases, popularity_rank
from SongPopularity
order by popularity_rank;

-- It displays the title of each song along with its average rating based on customer ratings.

WITH SongRatings AS (
  SELECT t.Name AS Song, AVG(i.UnitPrice) AS AverageRating
  FROM project_chinook.track t 
  LEFT JOIN project_chinook.invoiceline i ON t.TrackId = i.TrackId
  GROUP BY t.TrackId
)
SELECT Song, AverageRating
FROM SongRatings;

-- Calculates each customer's cumulative spend over time and displays the customer's name along with the cumulative spend.

with cumulative_s as (
	select concat(c.firstname, ' ', c.lastname) as customer_name, i.invoicedate, 
	sum(i.total) over (partition by c.customerid order by i.invoicedate) as cumulative_spend
	from project_chinook.customer c 
	left join project_chinook.invoice i on c.customerid = i.customerid 
)

select customer_name, invoicedate, cumulative_spend
from cumulative_s
order by cumulative_spend desc;


-- Shows the name of each artist along with the title of their best-selling song, based on the number of purchases.
with artist_top_songs as (
	select A."name" as artist, T."name" as song,
	ROW_NUMBER() OVER (PARTITION BY a.artistid  ORDER BY COUNT(i.invoicelineid) DESC) AS SongRank
	from project_chinook.artist a
	join project_chinook.album a2 on A.artistid = A2.artistid 
	join project_chinook.track t on A2.albumid = T.albumid 
	join project_chinook.invoiceline i on T.trackid = I.trackid 
	group by a.artistid, t.trackid 
	)

select artist, song
from artist_top_songs
where SongRank = 1;

-- clients and their spending per year

with total_spending as (
	select c.customerid, c.firstname as customer_name, extract(year from i.invoicedate) as year, sum(i.total) as total
	from project_chinook.customer c 
	left join project_chinook.invoice i on c.customerid = i.customerid 
	group by c.customerid, customer_name, year
)
select customerid, customer_name, year, total
from total_spending
order by customerid, year;

-- songs and their classification by rating

with song_rating as (
	select t.Name as song, avg(i.unitprice) as avg_rating
	from project_chinook.track t 
	left join project_chinook.invoiceline i on t.trackid = i.trackid
	group by t.trackid
),

song_classification as (
	select song, avg_rating,
		case
			when avg_rating >= 4.5 then 'Alta'
            when avg_rating >= 3.5 then 'Media' 
            else 'Baja'
		end as classification
	from song_rating
)

select song, avg_rating, classification
from song_classification;

-- Invoice consultation and sales distribution by month

with monthly_sales as (
	select i.invoiceid, date_part('month', i.invoicedate) as SalesMonth, i.total 
	from project_chinook.invoice i
)
SELECT invoiceid,
       SUM(CASE WHEN SalesMonth = '1' THEN Total ELSE 0 END) AS JanuarySales,
       SUM(CASE WHEN SalesMonth = '2' THEN Total ELSE 0 END) AS FebruarySales,
       SUM(CASE WHEN SalesMonth = '3' THEN Total ELSE 0 END) AS MarchSales,
       SUM(CASE WHEN SalesMonth = '4' THEN Total ELSE 0 END) AS AprilSales,
       SUM(CASE WHEN SalesMonth = '5' THEN Total ELSE 0 END) AS MaySales,
       SUM(CASE WHEN SalesMonth = '6' THEN Total ELSE 0 END) AS JuneSales,
       SUM(CASE WHEN SalesMonth = '7' THEN Total ELSE 0 END) AS JulySales,
       SUM(CASE WHEN SalesMonth = '8' THEN Total ELSE 0 END) AS AugustSales,
       SUM(CASE WHEN SalesMonth = '9' THEN Total ELSE 0 END) AS SeptemberSales,
       SUM(CASE WHEN SalesMonth = '10' THEN Total ELSE 0 END) AS OctoberSales,
       SUM(CASE WHEN SalesMonth = '11' THEN Total ELSE 0 END) AS NovemberSales,
       SUM(CASE WHEN SalesMonth = '12' THEN Total ELSE 0 END) AS DecemberSales
FROM monthly_sales
GROUP BY InvoiceId
order by InvoiceId;

select * from project_chinook.invoice i 
where i.invoiceid = '7'

-- employees and their average seniority by position

with employeeAvgtenure as (
	select e.title, avg(extract(year from age(now(), E.hiredate ))) as AvgTenure
	from project_chinook.employee e 
	group by e.title 
)
select title, round(AvgTenure::numeric, 2) as AverageTenure
from employeeAvgtenure;


--- Find the names of unique customers who have made purchases and the names of unique employees.

select c.firstname || ' ' || c.lastname as name, 'Customer' as type
from project_chinook.customer c 
union
select e.firstname || ' ' || e.lastname, 'Employee' 
from project_chinook.employee e 
order by type;

-- Find song titles that are priced above the average price for their genre.
select t."name" as song_title
from project_chinook.track t 
where t.unitprice > (
	select AVG(unitprice)
	from project_chinook.track as t2 
	where t2.genreid  = t.genreid 
);







