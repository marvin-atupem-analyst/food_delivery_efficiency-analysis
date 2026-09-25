-- Creating the database that will contain the table
CREATE DATABASE project04;

USE project04;

-- Creating the table and each columns heading and then doing a fast import to import the data.alter
CREATE TABLE food_delivery_route_efficiency 
(
order_id INT,
distance_km FLOAT,
delivery_time_min FLOAT,
traffic_level VARCHAR(10),
route_length_km FLOAT,
delivery_mode VARCHAR(20),
weather VARCHAR(20),
order_time VARCHAR(20),
restaurant_zone VARCHAR(20),
customer_zone VARCHAR(20)
);

SELECT *
FROM food_delivery_route_efficiency;

SET GLOBAL LOCAL_INFILE=1;

LOAD DATA LOCAL INFILE "D:/My Data Analysis Journey/Food_Delivery_Route_Efficiency_Dataset.csv"
INTO TABLE food_delivery_route_efficiency
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- DATA CLEANING

-- I'll create two new columns called order_time and order_date and seperate the dates from the time,

ALTER TABLE food_delivery_route_efficiency
ADD COLUMN order_timee TIME,
ADD COLUMN order_date DATE;

-- Now, i'll update the two new columns
UPDATE food_delivery_route_efficiency
SET
	order_timee=TIME(STR_TO_DATE(order_time,'%d/%m/%Y %H:%i')),
    order_date=DATE(STR_TO_DATE(order_time,'%d/%m/%Y %H:%i'));
    
-- Temporarily disable safe updates
SET SQL_SAFE_UPDATES = 0;

-- Deleting the old order_time and renaming order_timee to order_time

ALTER TABLE food_delivery_route_efficiency
DROP COLUMN order_time;

ALTER TABLE food_delivery_route_efficiency
RENAME COLUMN order_timee TO order_time;

-- DATA EXPLORATION

-- 1. What is the total number of orders the business has had?
SELECT COUNT(*) AS total_delivery_orders
FROM food_delivery_route_efficiency;

-- 2. What is the average delivery time? 
SELECT ROUND(AVG(delivery_time_min),2)
FROM food_delivery_route_efficiency;

-- 3. Which delivery mode is used most frequently? 
SELECT delivery_mode, COUNT(*) AS frequestly_used
FROM food_delivery_route_efficiency
GROUP BY delivery_mode
ORDER BY frequestly_used DESC;

-- 4. Which weather condition has the highest average delivery time? 
SELECT weather, ROUND(AVG(delivery_time_min),2) AS average_delivery_time
FROM food_delivery_route_efficiency
GROUP BY weather
ORDER BY average_delivery_time DESC;

-- 5. Which restaurant or customer zone has the most deliveries?
SELECT restaurant_zone, COUNT(*) AS total_deliveries
FROM food_delivery_route_efficiency
GROUP BY restaurant_zone
ORDER BY total_deliveries DESC;

SELECT customer_zone, COUNT(*) AS total_deliveries
FROM food_delivery_route_efficiency
GROUP BY customer_zone
ORDER BY total_deliveries DESC;

-- 6. Does delivery distance affect delivery time? 
SELECT 
	CASE
		WHEN distance_km <3 THEN '0 to 2km'
		WHEN distance_km <6 THEN '3 to 5km' 
		WHEN distance_km <11 THEN '6 to 10km'
		ELSE '11km+'
	END AS group_distances,
    ROUND(AVG(delivery_time_min),2) AS average_delivery
FROM food_delivery_route_efficiency
GROUP BY 
		CASE
			WHEN distance_km <3 THEN '0 to 2km'
			WHEN distance_km <6 THEN '3 to 5km' 
			WHEN distance_km <11 THEN '6 to 10km'
			ELSE '11km+'
		END
ORDER BY average_delivery DESC;

-- 7. Does route length affect delivery time? 
SELECT 
	CASE
		WHEN route_length_km <=3 THEN '0 to 3km (Very Close)'
		WHEN route_length_km <=6 THEN '3 to 6km (Close)' 
		WHEN route_length_km <=10 THEN '6 to 10km (Medium)'
		ELSE '10 km+ (Far)'
	END AS route_group,
    ROUND(AVG(delivery_time_min),2) AS average_delivery
FROM food_delivery_route_efficiency
GROUP BY 
		CASE
		WHEN route_length_km <=3 THEN '0 to 3km (Very Close)'
		WHEN route_length_km <=6 THEN '3 to 6km (Close)' 
		WHEN route_length_km <=10 THEN '6 to 10km (Medium)'
		ELSE '10 km+ (Far)'
	END
ORDER BY average_delivery DESC;

-- 8. How does traffic level relate to delivery time?   
SELECT traffic_level, ROUND(AVG(delivery_time_min),2) AS average_delivery_time
FROM food_delivery_route_efficiency
GROUP BY traffic_level
ORDER BY average_delivery_time ASC;

-- 9. Which delivery mode has shorter delivery times? 
SELECT delivery_mode, ROUND(AVG(delivery_time_min),2) AS average_delivery_time
FROM food_delivery_route_efficiency
GROUP BY delivery_mode
ORDER BY average_delivery_time ASC
LIMIT 1;

-- 10. Does order time appear to influence delivery time? 
SELECT
	CASE 
		WHEN order_time >= '00:00:00' AND order_time < '06:00:00' THEN 'Midnight/Dawn'
		WHEN order_time >= '06:00:00' AND order_time < '12:00:00' THEN 'Morning' 
		WHEN order_time >= '12:00:00' AND order_time < '18:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END AS time_of_day,
    ROUND(AVG(delivery_time_min),2) AS average_delivery_time
FROM food_delivery_route_efficiency
GROUP BY
		CASE 
		WHEN order_time >= '00:00:00' AND order_time < '06:00:00' THEN 'Midnight/Dawn'
		WHEN order_time >= '06:00:00' AND order_time < '12:00:00' THEN 'Morning' 
		WHEN order_time >= '12:00:00' AND order_time < '18:00:00' THEN 'Afternoon'
		ELSE 'Evening'
	END
ORDER BY average_delivery_time DESC;

-- 11. Are there noticeable differences between zones? 
SELECT 
	CONCAT(restaurant_zone, ' to ', customer_zone) AS delivery_route,
    COUNT(*) AS total_orders,
    ROUND(AVG(delivery_time_min),2) AS average_delivery_time
FROM food_delivery_route_efficiency
GROUP BY delivery_route
ORDER BY average_delivery_time DESC;