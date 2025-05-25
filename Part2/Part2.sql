INSERT IGNORE INTO wh_project.dim_date (full_date, day_name, month_name, year, quarter)
SELECT DISTINCT
    DATE(p.payment_date),
    DAYNAME(p.payment_date),
    MONTHNAME(p.payment_date),
    YEAR(p.payment_date),
    CONCAT('Q', QUARTER(p.payment_date))
FROM tst.payment p
WHERE p.payment_date IS NOT NULL;


INSERT IGNORE INTO wh_project.dim_staff (staff_name, email, store_location)
SELECT DISTINCT
    CONCAT(s.first_name, ' ', s.last_name),
    COALESCE(s.email, 'not_provided@example.com'),
    a.address
FROM tst.staff s
JOIN tst.address a ON s.address_id = a.address_id;


INSERT IGNORE INTO wh_project.dim_rent (rental_info, rental_duration, return_status)
SELECT DISTINCT
    CONCAT('Film: ', f.title, ' | Customer: ', c.first_name, ' ', c.last_name),
    CONCAT(DATEDIFF(r.return_date, r.rental_date), ' days'),
    CASE 
        WHEN r.return_date IS NULL THEN 'Not Returned'
        ELSE 'Returned'
    END
FROM tst.rental r
JOIN tst.inventory i ON r.inventory_id = i.inventory_id
JOIN tst.film f ON i.film_id = f.film_id
JOIN tst.customer c ON r.customer_id = c.customer_id;



INSERT INTO wh_project.fact_monthly_payment (payment_amount, staff_name, rent_details, month_name, year)
SELECT 
    SUM(p.amount),
    CONCAT(s.first_name, ' ', s.last_name),
    CONCAT('Film: ', f.title, ' | Customer: ', c.first_name, ' ', c.last_name),
    MONTHNAME(p.payment_date),
    YEAR(p.payment_date)
FROM tst.payment p
JOIN tst.staff s ON p.staff_id = s.staff_id
JOIN tst.rental r ON p.rental_id = r.rental_id
JOIN tst.inventory i ON r.inventory_id = i.inventory_id
JOIN tst.film f ON i.film_id = f.film_id
JOIN tst.customer c ON r.customer_id = c.customer_id
GROUP BY s.staff_id, r.rental_id, MONTH(p.payment_date), YEAR(p.payment_date);



