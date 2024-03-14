CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    dish_name VARCHAR(255) NOT NULL,
    ingredients TEXT[] NOT NULL,
    cuisine VARCHAR(100),
    instructions TEXT NOT NULL,
    date_time TIMESTAMP, 
    user_name VARCHAR(100) NOT NULL,
    dish_type VARCHAR(100),
    cook_time INT NOT NULL,
    occasions VARCHAR(100),
    is_vegan BOOLEAN ,
    rating NUMERIC(2,1),
    is_kosher BOOLEAN
);


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(80) UNIQUE NOT NULL,
    firstname VARCHAR(80) NOT NULL,
    lastname VARCHAR(80) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);
