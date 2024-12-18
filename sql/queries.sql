-- Sample Queries for Transport Accessibility Project

-- 1. Find all stops within a radius of 5 km from a given point
SELECT stop_id, stop_name, latitude, longitude
FROM stops
WHERE earth_distance(
    ll_to_earth(latitude, longitude),
    ll_to_earth(40.748817, -73.985428) -- Example coordinates
) <= 5000;

-- 2. Calculate the total distance of a route
SELECT route_id, route_name, SUM(distance_km) AS total_distance
FROM routes
GROUP BY route_id, route_name;

-- 3. Find the shortest route between two stops
WITH RECURSIVE route_path AS (
    SELECT
        route_id,
        start_stop_id,
        end_stop_id,
        distance_km,
        ARRAY[start_stop_id, end_stop_id] AS path,
        distance_km AS total_distance
    FROM routes
    WHERE start_stop_id = 1 -- Example start stop

    UNION ALL

    SELECT
        r.route_id,
        r.start_stop_id,
        r.end_stop_id,
        r.distance_km,
        rp.path || r.end_stop_id,
        rp.total_distance + r.distance_km
    FROM routes r
    JOIN route_path rp ON r.start_stop_id = rp.end_stop_id
    WHERE NOT r.end_stop_id = ANY(rp.path)
)
SELECT path, total_distance
FROM route_path
WHERE end_stop_id = 5 -- Example destination stop
ORDER BY total_distance
LIMIT 1;

-- 4. List all stops and their schedule for a specific route
SELECT s.stop_name, sc.arrival_time, sc.departure_time
FROM schedules sc
JOIN stops s ON sc.stop_id = s.stop_id
WHERE sc.route_id = 1 -- Example route id
ORDER BY sc.arrival_time;
