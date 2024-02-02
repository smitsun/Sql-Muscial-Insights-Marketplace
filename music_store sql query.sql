create database	music_store;
show databases;
use music_store;
show tables;
#1. Who is the senior most employee based on job title?

select *  from employee;
select concat(first_name,last_name) from employee 
order by levels desc limit 1;
#2 Which countries have the most Invoices?

select* from invoice;
select  count(*) as D  ,billing_country from invoice 
group by billing_country 
order by D desc limit 1;

#3 What are top 3 values of total invoice?
select * from invoice;
select total from invoice 
order by total desc 
limit 3;

#4  Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals

select	* from  invoice;
select sum(total) as total_sales,billing_city from invoice
group by billing_city
order by total_sales desc
limit 1;

# 5 Who is the best customer? The customer who has spent the most money will be 
#declared the best customer. Write a query that returns the person who has spent the 
#most money

select *from customer;
select * from invoice;
select customer.customer_id,concat(customer.first_name,' ',customer.last_name), sum(invoice.total) as total from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc limit 1;


#  6 .Write query to return the email, first name, last name, & Genre of all Rock Music 
#listeners. Return your list ordered alphabetically by email starting with A

select * from customer;
select * from genre;
select * from track;
select distinct customer.first_name,customer.last_name,customer.email from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id
where genre.name = 'Rock'
order by customer.email asc;

#7.Let's invite the artists who have written the most rock music in our dataset. Write a 
#query that returns the Artist name and total track count of the top 10 rock bands

select *from artist;
select * from track;
select artist.name ,count(artist.artist_id) as total_track from track
join album on track.album_id=album.album_id
join artist on album.artist_id=artist.artist_id
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
group by artist.artist_id
order by total_track desc
;

#8.Return all the track names that have a song length longer than the average song length. 
#Return the Name and Milliseconds for each track. Order by the song length with the 
#longest songs listed first

select *from track;
SELECT  Name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

#9. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

select concat(customer.first_name,' ',customer.last_name) as customer_name,artist.name as artist_name,sum(invoice_line.unit_price * invoice_line.quantity )as total,sum(total) from customer
join invoice on  customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track  on invoice_line.track_id=track.track_id
join album on track.album_id =album.album_id 
join artist on album.artist_id=artist.artist_id
group by customer.first_name,customer.last_name;

#10.We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query 
#that returns each country along with the top Genre. For countries where the maximum 
#number of purchases is shared return all Genres

WITH popular_genre 
AS (SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC)
SELECT * FROM popular_genre WHERE RowNo <= 1;

#11Write a query that determines the customer that has spent the most on music for each 
#country. Write a query that returns the country along with the top customer and how
#much they spent. For countries where the top amount spent is shared, provide all 
#customers who spent this amount


WITH Customter_with_country 
AS (SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;
