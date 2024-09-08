--Let's check the total passengers and the average fares (Group by yr,cities. Order by yr and passengers)
SELECT 
    Year,
    city1, 
    city2, 
    SUM(passengers) AS total_passengers,
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
GROUP BY 
    Year,
    city1, 
    city2
ORDER BY 
    Year ASC, 
    total_passengers DESC;


--Let's check which airlines fly which route most
SELECT 
    city1,
    city2,
    carrier_lg AS airline,
    SUM(passengers) AS total_passengers
FROM 
    dbo.US_domestic_flights
GROUP BY 
    city1, 
    city2, 
    carrier_lg
ORDER BY 
    city1 ASC, 
    city2 ASC, 
    total_passengers DESC;


--Which airline is the leader according to the specific routes mentioned.
WITH RoutePassengers AS (
    SELECT 
        city1,
        city2,
        carrier_lg AS airline,
        SUM(passengers) AS total_passengers
    FROM 
        dbo.US_domestic_flights
    WHERE 
        (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'San Francisco, CA (Metropolitan Area)')
        OR (city1 = 'Miami, FL (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'Chicago, IL' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'New York City, NY (Metropolitan Area)' AND city2 = 'Orlando, FL')
    GROUP BY 
        city1,
        city2,
        carrier_lg
),
TotalRoutePassengers AS (
    SELECT 
        city1,
        city2,
        SUM(total_passengers) AS total_passengers_per_route
    FROM 
        RoutePassengers
    GROUP BY 
        city1,
        city2
)
SELECT 
    rp.city1,
    rp.city2,
    rp.airline,
    rp.total_passengers,
    ROUND((rp.total_passengers / trp.total_passengers_per_route) * 100, 2) AS percentage_of_total_passengers
FROM 
    RoutePassengers rp
JOIN 
    TotalRoutePassengers trp
    ON rp.city1 = trp.city1 AND rp.city2 = trp.city2
ORDER BY 
    rp.city1, 
    rp.city2, 
    rp.total_passengers DESC;

--Which route are the most popular (airports) in specific routes
WITH AirportRoutePassengers AS (
    SELECT 
        city1,
        city2,
        airport_1 AS origin_airport,
        airport_2 AS destination_airport,
        SUM(passengers) AS total_passengers
    FROM 
        dbo.US_domestic_flights
    WHERE 
        (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'San Francisco, CA (Metropolitan Area)')
        OR (city1 = 'Miami, FL (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'Chicago, IL' AND city2 = 'New York City, NY (Metropolitan Area)')
        OR (city1 = 'New York City, NY (Metropolitan Area)' AND city2 = 'Orlando, FL')
    GROUP BY 
        city1,
        city2,
        airport_1,
        airport_2
)
SELECT 
    city1,
    city2,
    origin_airport,
    destination_airport,
    total_passengers
FROM 
    AirportRoutePassengers
ORDER BY 
    city1, 
    city2, 
    total_passengers DESC;

--Let's check the fare price change over time.
SELECT 
    Year,
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
GROUP BY 
    Year
ORDER BY 
    Year ASC;


--Let's see the relationship between distance and fare
SELECT 
    nsmiles AS distance, 
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
GROUP BY 
    nsmiles
ORDER BY 
    distance ASC;


--Let's check the fares according to year and quarter
SELECT 
    Year,
    quarter,
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
GROUP BY 
    Year, 
    quarter
ORDER BY 
    Year ASC, 
    quarter ASC;


--Let's compare the airline companies and their fares
SELECT 
    carrier_lg AS airline,
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
GROUP BY 
    carrier_lg
ORDER BY 
    avg_fare ASC;


--Let's find the market share of airlines 
WITH TotalPassengers AS (
    SELECT 
        SUM(passengers) AS total_passengers
    FROM 
        dbo.US_domestic_flights
),
CarrierPassengers AS (
    SELECT 
        carrier_lg,
        SUM(passengers) AS carrier_passengers
    FROM 
        dbo.US_domestic_flights
    GROUP BY 
        carrier_lg
)
SELECT 
    cp.carrier_lg AS airline,
    cp.carrier_passengers,
    ROUND((cp.carrier_passengers / tp.total_passengers) * 100, 2) AS market_share_percentage
FROM 
    CarrierPassengers cp
CROSS JOIN 
    TotalPassengers tp
ORDER BY 
    market_share_percentage DESC;


--Let's check the average fare prices for specific routes and specific airlines
SELECT 
    city1, 
    city2, 
    carrier_lg AS airline, 
    AVG(fare) AS avg_fare
FROM 
    dbo.US_domestic_flights
WHERE 
    (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'San Francisco, CA (Metropolitan Area)')
    OR (city1 = 'Miami, FL (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
    OR (city1 = 'Los Angeles, CA (Metropolitan Area)' AND city2 = 'New York City, NY (Metropolitan Area)')
    OR (city1 = 'New York City, NY (Metropolitan Area)' AND city2 = 'Orlando, FL')
    OR (city1 = 'Chicago, IL' AND city2 = 'New York City, NY (Metropolitan Area)')
    AND carrier_lg IN ('WN', 'AA', 'UA', 'DL', 'B6', 'AS')
GROUP BY 
    city1, 
    city2, 
    carrier_lg
ORDER BY 
    city1, 
    city2, 
    avg_fare DESC;


-- I want to see average fare prices for all rouets
SELECT 
	city1,
	city2,
	AVG(fare) AS avg_fare
FROM
	DBO.US_domestic_flights
GROUP BY
	city1,
	city2
ORDER BY 
	avg_fare DESC

