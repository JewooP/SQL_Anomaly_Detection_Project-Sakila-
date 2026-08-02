-- Query to find the employee in store #1 who has handled at least one free rental.
SELECT s.staff_id, s.first_name, s.last_name, COUNT(p.payment_id) AS zero_payment_count
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE s.store_id = 1 AND p.amount = 0.0
GROUP BY s.staff_id
HAVING zero_payment_count > 0;


-- Query to check the movies and total loss amount that have not been returned for more than 90 days at store 1.
SELECT f.title, COUNT(rv.rental_id) AS lost_count, SUM(f.replacement_cost) AS total_loss
FROM store1_rental_view rv  
JOIN inventory i ON rv.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE rv.return_date IS NULL AND rv.rental_date < '2005-09-01'
GROUP BY f.film_id
ORDER BY lost_count DESC
LIMIT 10;


-- Query to inspect transactions where the employee and customer last names are the same.
SELECT s.first_name AS staff_first_name, s.last_name AS staff_last_name, c.first_name AS customer_first_name, c.last_name AS customer_last_name, r.rental_date
FROM rental r
JOIN staff s ON r.staff_id = s.staff_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE s.last_name = c.last_name; 


-- Query that retrieves customers with long-term delinquency of 90 days or more who have not yet been registered on the delinquency list.
SELECT c.customer_id, c.first_name, c.last_name, c.email, SUM(f.replacement_cost) AS total_to_collect
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NULL AND r.rental_date < '2005-09-01' AND NOT EXISTS (
        SELECT 1 
        FROM overdue_accounts oa
        WHERE oa.customer_id = c.customer_id
    )
GROUP BY c.customer_id;


-- Query to look up customers who have not returned more than three movies that are more expensive than average.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS unreturned_count, SUM(f.replacement_cost) AS total_debt        
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date IS NULL                         
  AND f.replacement_cost > (                        
      SELECT AVG(replacement_cost) 
      FROM film
  )
GROUP BY c.customer_id, c.first_name, c.last_name   
HAVING unreturned_count >= 3                        
ORDER BY total_debt DESC;                         
