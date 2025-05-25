CREATE TABLE dim_date (
    full_date DATE,
    day_name VARCHAR(20),
    month_name VARCHAR(20),
    year INT,
    quarter VARCHAR(5)
);


CREATE TABLE dim_staff (
    staff_name VARCHAR(100),
    email VARCHAR(100),
    store_location VARCHAR(100)
);


CREATE TABLE dim_rent (
    rental_info TEXT,
    rental_duration VARCHAR(50),
    return_status VARCHAR(50)
);


CREATE TABLE dim_film (
    film_title VARCHAR(255),
    genre VARCHAR(100),
    language VARCHAR(50),
    length_minutes INT
);


CREATE TABLE dim_store (
    store_location VARCHAR(100),
    store_manager VARCHAR(100),
    store_contact VARCHAR(100)
);




CREATE TABLE fact_monthly_payment (
    payment_amount DECIMAL(10,2),
    staff_name VARCHAR(100),
    rent_details TEXT,
    month_name VARCHAR(20),
    year INT
);


CREATE TABLE fact_daily_inventory (
    inventory_count INT,
    store_location VARCHAR(100),
    film_title VARCHAR(255),
    full_date DATE,
    day_name VARCHAR(20),
    month_name VARCHAR(20),
    year INT
);

