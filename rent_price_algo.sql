--Create table
CREATE TABLE HomeData (
    id INT PRIMARY KEY,
    location VARCHAR(100),
    size FLOAT,
    age INT,
    market_conditions FLOAT,
    previous_price FLOAT,
    actual_price FLOAT
);

-- Insert data into HomeData
--placeholder

--Calculate Regression Coefficients
WITH Regression AS (
    SELECT
        AVG(size) AS avg_size,
        AVG(age) AS avg_age,
        AVG(market_conditions) AS avg_market_conditions,
        AVG(previous_price) AS avg_previous_price,
        AVG(actual_price) AS avg_actual_price
    FROM HomeData
),
Sums AS (
    SELECT
        SUM((size - avg_size) * (actual_price - avg_actual_price)) AS sum_xy,
        SUM((size - avg_size) * (size - avg_size)) AS sum_xx,
        SUM((age - avg_age) * (actual_price - avg_actual_price)) AS sum_xy_age,
        SUM((age - avg_age) * (age - avg_age)) AS sum_xx_age,
        SUM((market_conditions - avg_market_conditions) * (actual_price - avg_actual_price)) AS sum_xy_mc,
        SUM((market_conditions - avg_market_conditions) * (market_conditions - avg_market_conditions)) AS sum_xx_mc,
        SUM((previous_price - avg_previous_price) * (actual_price - avg_actual_price)) AS sum_xy_pp,
        SUM((previous_price - avg_previous_price) * (previous_price - avg_previous_price)) AS sum_xx_pp
    FROM HomeData, Regression
)
SELECT
    (sum_xy / sum_xx) AS beta_size,
    (sum_xy_age / sum_xx_age) AS beta_age,
    (sum_xy_mc / sum_xx_mc) AS beta_market_conditions,
    (sum_xy_pp / sum_xx_pp) AS beta_previous_price,
    avg_actual_price - (beta_size * avg_size + beta_age * avg_age + beta_market_conditions * avg_market_conditions + beta_previous_price * avg_previous_price) AS intercept
FROM Sums, Regression;

--Predict Values
WITH Coefficients AS (
    SELECT
        (sum_xy / sum_xx) AS beta_size,
        (sum_xy_age / sum_xx_age) AS beta_age,
        (sum_xy_mc / sum_xx_mc) AS beta_market_conditions,
        (sum_xy_pp / sum_xx_pp) AS beta_previous_price,
        avg_actual_price - (beta_size * avg_size + beta_age * avg_age + beta_market_conditions * avg_market_conditions + beta_previous_price * avg_previous_price) AS intercept
    FROM Sums, Regression
)
SELECT
    id,
    actual_price,
    (intercept + beta_size * size + beta_age * age + beta_market_conditions * market_conditions + beta_previous_price * previous_price) AS predicted_price,
    ABS((actual_price - predicted_price) / actual_price) AS percentage_error
FROM HomeData, Coefficients;
