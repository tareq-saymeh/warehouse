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
    MONTHNAME(DATE(p.payment_date)) AS month_name,
    YEAR(DATE(p.payment_date)) AS year
FROM tst.payment p
JOIN tst.staff s ON p.staff_id = s.staff_id
JOIN tst.rental r ON p.rental_id = r.rental_id
JOIN tst.inventory i ON r.inventory_id = i.inventory_id
JOIN tst.film f ON i.film_id = f.film_id
JOIN tst.customer c ON r.customer_id = c.customer_id
GROUP BY 
    s.staff_id,
    r.rental_id,
    MONTHNAME(DATE(p.payment_date)),
    YEAR(DATE(p.payment_date));


INSERT INTO wh_project.fact_daily_inventory (
    inventory_count,
    store_location,
    film_title,
    full_date,
    day_name,
    month_name,
    year
)
SELECT 
    COUNT(i.inventory_id) AS inventory_count,
    a.address AS store_location,
    f.title AS film_title,
    DATE(i.last_update) AS full_date,
    DAYNAME(i.last_update) AS day_name,
    MONTHNAME(i.last_update) AS month_name,
    YEAR(i.last_update) AS year
FROM tst.inventory i
JOIN tst.store s ON i.store_id = s.store_id
JOIN tst.address a ON s.address_id = a.address_id
JOIN tst.film f ON i.film_id = f.film_id
WHERE i.last_update IS NOT NULL
GROUP BY 
    store_location,
    film_title,
    full_date,
    day_name,
    month_name,
    year;
