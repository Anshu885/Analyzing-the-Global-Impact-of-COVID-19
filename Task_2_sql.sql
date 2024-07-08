create database covid;
use covid;

SELECT * FROM corona_virus;
ALTER TABLE corona_virus CHANGE `Country/Region` Country VARCHAR(255);
describe corona_virus;

-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT 
    SUM(CASE
        WHEN Province IS NULL THEN 1
        ELSE 0
    END) AS column1_nulls,
    SUM(CASE
        WHEN Country IS NULL THEN 1
        ELSE 0
    END) AS column2_nulls,
    SUM(CASE
        WHEN Latitude IS NULL THEN 1
        ELSE 0
    END) AS column3_nulls,
    SUM(CASE
        WHEN Longitude IS NULL THEN 1
        ELSE 0
    END) AS column4_nulls,
    SUM(CASE
        WHEN Date IS NULL THEN 1
        ELSE 0
    END) AS column5_nulls,
    SUM(CASE
        WHEN Confirmed IS NULL THEN 1
        ELSE 0
    END) AS column6_nulls,
    SUM(CASE
        WHEN Deaths IS NULL THEN 1
        ELSE 0
    END) AS column7_nulls,
    SUM(CASE
        WHEN Recovered IS NULL THEN 1
        ELSE 0
    END) AS column8_nulls
FROM
    corona_virus;

-- Q2. If NULL values are present, update them with zeros for all columns. 
-- no null values are present

-- Q3. Check total number of rows
SELECT 
    COUNT(*) AS total_no_of_rows
FROM
    corona_virus;

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(date) AS starting_date, MAX(date) AS ending_date
FROM
    corona_virus;

-- Q5. Number of month present in dataset
SELECT 
    COUNT(DISTINCT date_format(date,'%y,%m')) AS no_of_months
FROM
    corona_virus;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
     date_format(date,'%m,%y') AS months,
    ROUND(AVG(Confirmed), 2) AS avg_confirmed,
    ROUND(AVG(Deaths), 2) AS avg_deaths,
    ROUND(AVG(Recovered), 2) AS avg_recovered
FROM
    corona_virus
GROUP BY months;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    months, 'Confirmed' AS category, value, freq
FROM
    (SELECT 
        DATE_FORMAT(date, '%m,%y') AS months,
            Confirmed AS value,
            COUNT(Confirmed) AS freq
    FROM
        corona_virus
    GROUP BY months , Confirmed
    ORDER BY months , freq DESC
    LIMIT 1) AS confirmed_data 
UNION ALL SELECT 
    months, 'Deaths' AS category, value, freq
FROM
    (SELECT 
        DATE_FORMAT(date, '%m,%y') AS months,
            Deaths AS value,
            COUNT(Deaths) AS freq
    FROM
        corona_virus
    GROUP BY months , Deaths
    ORDER BY months , freq DESC
    LIMIT 1) AS deaths_data 
UNION ALL SELECT 
    months, 'Recovered' AS category, value, freq
FROM
    (SELECT 
        DATE_FORMAT(date, '%m,%y') AS months,
            Recovered AS value,
            COUNT(Recovered) AS freq
    FROM
        corona_virus
    GROUP BY months , Recovered
    ORDER BY months , freq DESC
    LIMIT 1) AS recovered_data;
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT year(date) as year,
 MIN(Confirmed) AS min_confirmed,
 MIN(Deaths) AS min_deaths,
 MIN(Recovered) AS min_recovered
FROM corona_virus
group by year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT year(date) as year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM corona_virus group by year;
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT  date_format(date,'%m,%y')as months,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM corona_virus group by months;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    round(SUM(Confirmed),2) AS total_confirmed_cases,
    round(AVG(Confirmed),2) AS average_confirmed_cases,
    round(VARIANCE(Confirmed),2) AS variance_confirmed_cases,
    round(STDDEV(Confirmed),2) AS std_dev_confirmed_cases
FROM
    corona_virus;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    date_format(date,'%m,%y')as months,
    SUM(Deaths) AS total_Death_cases,
    round(AVG(Deaths),0) AS average_Death_cases,
    round(VARIANCE(Deaths),0) AS variance_Death_cases,
    round(STDDEV(Deaths),0) AS std_dev_Death_cases
FROM
    corona_virus
GROUP BY months;

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Recovered) AS total_Recovered_cases,
    round(AVG(Recovered),2) AS average_Recovered_cases,
    round(VARIANCE(Recovered),2) AS variance_Recovered_cases,
    round(STDDEV(Recovered),2) AS std_dev_Recovered_cases
FROM
    corona_virus;

-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    country, SUM(Confirmed)
FROM
    corona_virus
GROUP BY country
ORDER BY SUM(Confirmed) DESC
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
select country from(
SELECT country, SUM(Deaths) AS TotalDeaths,
       RANK() OVER (ORDER BY SUM(Deaths) ASC) AS DeathRank
FROM corona_virus
GROUP BY country
ORDER BY TotalDeaths ASC)as a where Deathrank=1;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
    country, SUM(Recovered)
FROM
    corona_virus
GROUP BY country
ORDER BY SUM(Recovered) DESC
LIMIT 5;
