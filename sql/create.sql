--  Table for managing customers overdue by more than 90 days and overdue costs
CREATE TABLE overdue_accounts (
    overdue_id INT PRIMARY KEY,
    customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,      
    total_overdue_cost FLOAT NOT NULL,          
    status VARCHAR(30) NOT NULL,        
    date_added DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Table for recording when abnormal activity is detected
CREATE TABLE incident_reports (
    incident_id INT PRIMARY KEY,
    incident_type VARCHAR(30) NOT NULL,  
    incident_date DATE NOT NULL,
    description VARCHAR(300) NOT NULL, 
    status VARCHAR(30) NOT NULL,    
    reported_staff_id TINYINT UNSIGNED NOT NULL,
    related_staff_id TINYINT UNSIGNED,
    related_customer_id SMALLINT UNSIGNED,
    FOREIGN KEY (reported_staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (related_staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (related_customer_id) REFERENCES customer(customer_id)
);

-- Create a view that collects only the rental records of store 1
CREATE VIEW  store1_rental_view AS 
SELECT *
FROM rental
WHERE staff_id = 1;
