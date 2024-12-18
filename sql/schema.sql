-- Schema for Transport Accessibility Project

-- Table for storing information about public transport stops
CREATE TABLE stops (
    stop_id SERIAL PRIMARY KEY,
    stop_name VARCHAR(255) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL
);

-- Table for storing routes and connections between stops
CREATE TABLE routes (
    route_id SERIAL PRIMARY KEY,
    route_name VARCHAR(255) NOT NULL,
    start_stop_id INT REFERENCES stops(stop_id),
    end_stop_id INT REFERENCES stops(stop_id),
    distance_km DECIMAL(5, 2) NOT NULL
);

-- Table for storing schedules for each stop on a route
CREATE TABLE schedules (
    schedule_id SERIAL PRIMARY KEY,
    route_id INT REFERENCES routes(route_id),
    stop_id INT REFERENCES stops(stop_id),
    arrival_time TIME NOT NULL,
    departure_time TIME NOT NULL
);
