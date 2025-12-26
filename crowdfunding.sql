use crowd_fun;

CREATE TABLE projects (
  ID int DEFAULT NULL,
  state text,
  name text,
  country text,
  creator_id int DEFAULT NULL,
  location_id int DEFAULT NULL,
  category_id int DEFAULT NULL,
  created_at datetime DEFAULT NULL,
  deadline datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL,
  state_changed_at datetime DEFAULT NULL,
  successful_at datetime default null,
  launched_at datetime DEFAULT NULL,
  goal int DEFAULT NULL,
  pledged int DEFAULT NULL,
  currency text,
  currency_symbol text,
  usd_pledged int DEFAULT NULL,
  static_usd_rate int DEFAULT NULL,
  backers_count int DEFAULT NULL,
  spotlight text,
  staff_pick text,
  blurb text,
  currency_trailing_code text,
  disable_communication text,
  Goal_Amount int default null

) ;

select * from projects limit 4;
SELECT COUNT(*) FROM projects;


CREATE TABLE  calendar (ID INT, created_at DATETIME,
    Year INT, Month INT, Month_name VARCHAR(20),
    Quarter VARCHAR(10), YearMonth VARCHAR(10),
    Weekday INT, Weekday_name VARCHAR(20),
    Financial_Month VARCHAR(20), Financial_Quarter VARCHAR(10)
    );
select * from calendar limit 4;
SELECT COUNT(*) FROM calendar;
desc projects;

create table creator ( ID int,	name text,	chosen_currency varchar(10));
SELECT COUNT(*) FROM creator;
select * from creator limit 5;

create table category ( ID int,	name varchar(50),	
parent_id int DEFAULT NULL,	position int DEFAULT NULL);
SELECT COUNT(*) FROM category;
select * from category limit 4;

CREATE TABLE location (ID INT , displayable_name VARCHAR(255),
    type VARCHAR(100), name VARCHAR(255),
    state VARCHAR(100), short_name VARCHAR(255),
    is_root BOOLEAN, country VARCHAR(20),
    localized_name VARCHAR(255)
);
SELECT COUNT(*) from location;

  -- Total Number of Projects based on outcome 
SELECT state AS Project_Outcome, COUNT(id) AS Total_Projects
FROM projects GROUP BY state ORDER BY Total_Projects DESC;

-- Total Number of Projects based on Locations
SELECT l.displayable_name AS Location, COUNT(pr.id) AS Total_Projects
FROM projects AS pr JOIN location AS l ON pr.location_id = l.id
GROUP BY l.displayable_name ORDER BY Total_Projects DESC;

 -- Total Number of Projects based on  Category
SELECT c.name AS Category_Name, COUNT(pr.id) AS Total_Projects
FROM projects AS pr JOIN category AS c ON pr.category_id = c.id
GROUP BY c.name ORDER BY Total_Projects DESC;

  -- Total Number of Projects created by Year , Quarter , Month
  SELECT cal.Year, cal.Quarter, cal.Month,
    COUNT(pr.id) AS Total_Projects
FROM projects AS pr JOIN calendar AS cal 
    ON pr.created_at = cal.Created_at
GROUP BY cal.Year, cal.Quarter, cal.Month 
ORDER BY cal.Year, cal.Quarter, cal.Month;

-- 6.  Successful Projects
     -- Amount Raised 
SELECT ROUND(SUM(pledged), 2) AS Total_Amount_Raised
FROM projects
WHERE state = 'successful';

-- Number of Backers
SELECT 
    SUM(backers_count) AS Total_Backers
FROM projects
WHERE state = 'successful';

-- Avg NUmber of Days for successful projects
SELECT 
    ROUND(AVG(DATEDIFF(successful_at, launched_at)), 2) AS Avg_Days_To_Success
FROM projects
WHERE state = 'successful';

-- 7 . Top Successful Projects :
-- Based on Number of Backers
    
SELECT id AS Project_ID,
    name AS Project_Name,
    backers_count AS Number_of_Backers,
    pledged AS Amount_Raised, country
FROM projects
WHERE state = 'successful'
ORDER BY backers_count DESC;
-- LIMIT 10;

-- Based on Amount Raised.
SELECT  id AS Project_ID,
    name AS Project_Name,
    pledged AS Amount_Raised,
    backers_count AS Number_of_Backers,
    country
FROM projects
WHERE state = 'successful'
ORDER BY pledged DESC;
-- LIMIT 10;

-- 8. Percentage of Successful Projects overall

SELECT 
    ROUND(
        (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS Success_Percentage
FROM projects;

-- Percentage of Successful Projects  by Category
SELECT 
    c.name AS Category,
    COUNT(p.id) AS Total_Projects,
    SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) AS Successful_Projects,
    ROUND(
        (SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) / COUNT(p.id)) * 100, 
        2
    ) AS Success_Percentage
FROM projects AS p
JOIN category AS c ON p.category_id = c.id
GROUP BY c.name
ORDER BY Success_Percentage DESC;

 -- Percentage of Successful Projects by Year , Month etc..
SELECT 
    YEAR(created_at) AS Year,
    MONTH(created_at) AS Month,
    COUNT(id) AS Total_Projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS Successful_Projects,
    ROUND(
        (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(id)) * 100, 
        2
    ) AS Success_Percentage
FROM projects
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY Year, Month;

-- Percentage of Successful projects by Goal Range ( decide the range as per your need )
SELECT 
    CASE 
        WHEN goal < 1000 THEN 'Low (< 1K)'
        WHEN goal BETWEEN 1000 AND 10000 THEN 'Medium (1K–10K)'
        WHEN goal BETWEEN 10001 AND 50000 THEN 'High (10K–50K)'
        ELSE 'Very High (>50K)'
    END AS Goal_Range,
    COUNT(id) AS Total_Projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS Successful_Projects,
    ROUND(
        (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(id)) * 100,
        2
    ) AS Success_Percentage
FROM projects
GROUP BY Goal_Range
ORDER BY MIN(goal);





