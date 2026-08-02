-- 1. Employee fraud: The data was altered that Employee 1 processed five payments as zero.
UPDATE payment
SET amount = 0.0
WHERE staff_id = 1 AND amount > 0
LIMIT 5;


-- 2.Delinquency: The data was altered to show that Customer 1 had rented a movie a year earlier (2005-01-01) and had not yet returned it.
UPDATE rental
SET return_date = NULL, rental_date = '2005-01-01'
WHERE customer_id = 1
LIMIT 5;


-- 3. Employee-Customer Relationship: The data was modified that Employee 1 (Mike Hillyer) processed the transaction of Customer 1 (MIKE HILLYER), who shares the same last name.
UPDATE rental
SET staff_id = 1
WHERE customer_id = 524
LIMIT 1;

-- 4. The data was modified that Customer 5 only rented expensive movies and did not return them.
SET SQL_SAFE_UPDATES = 0;

UPDATE rental
SET customer_id = 5, return_date = Null, staff_id = 2
WHERE rental_id BETWEEN 100 AND 104;

UPDATE film 
SET replacement_cost = 25.00 
WHERE film_id IN (
    SELECT film_id 
    FROM inventory 
    WHERE inventory_id IN (
        SELECT inventory_id 
        FROM rental 
        WHERE rental_id BETWEEN 100 AND 104
    )
);
SET SQL_SAFE_UPDATES = 1;
