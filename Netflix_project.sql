CREATE DATABASE netflix_db;
USE netflix_db;

CREATE TABLE netflix (
    show_id      VARCHAR(10) PRIMARY KEY,  -- The ID tag (like 's1')
    type         VARCHAR(20),              -- Movie or TV Show?
    title        VARCHAR(255),             -- The Name
    director     VARCHAR(255),             -- Who made it?
    cast         TEXT,                     -- The Actors
    country      VARCHAR(255),             -- Where it's from
    date_added   VARCHAR(50),              -- When Netflix added it
    release_year INT,                      -- When it came out
    rating       VARCHAR(20),              -- PG-13, R, etc.
    duration     VARCHAR(50),              -- How long is it?
    listed_in    VARCHAR(255),             -- Genre (Comedy, Action)
    description  TEXT                      -- What is it about?
);

CREATE TABLE netflix_content_costs (
    show_id                       VARCHAR(10), -- Matches Shelf #1
    type                          VARCHAR(20),
    production_cost_million_usd   INT,         -- Cost to make
    marketing_cost_million_usd    INT,         -- Cost to advertise
    estimated_revenue_million_usd INT,         -- Money earned
    FOREIGN KEY (show_id) REFERENCES netflix(show_id)
);

CREATE TABLE netflix_viewership (
    show_id                 VARCHAR(10), -- Matches Shelf #1
    type                    VARCHAR(20),
    release_year            INT,
    total_views_millions    INT,         -- How many views?
    avg_watch_time_minutes  INT,         -- How long they watched
    peak_region             VARCHAR(100),-- Where is it most popular?
    FOREIGN KEY (show_id) REFERENCES netflix(show_id)
);


-- Q1 --
SELECT type, COUNT(*) as total_content
FROM netflix
GROUP BY type;


-- Q2 --
SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*) as count,
    RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rnk
    FROM netflix
    GROUP BY type, rating
) as t1
WHERE rnk = 1;



-- Q3 -- 
SELECT * FROM netflix
WHERE type = 'Movie' AND release_year = 2020;

-- Q4 --
-- Simple version (Counts distinct strings)
SELECT country, COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

-- Q5 --
SELECT * FROM netflix
WHERE type = 'Movie'
ORDER BY CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) DESC
LIMIT 1;

-- Q6 --
SELECT * FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= (SELECT MAX(STR_TO_DATE(date_added, '%M %d, %Y')) FROM netflix_ready_for_sql) - INTERVAL 5 YEAR;

-- Q7 -- 
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- Q8 -- 
SELECT * FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- Q9 --
-- MySQL does not split strings easily, so we usually Group By the full list
SELECT listed_in, COUNT(*) as total_content
FROM netflix
GROUP BY listed_in
ORDER BY total_content DESC;

-- Q10 --
SELECT release_year, COUNT(*) as total_release
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY total_release DESC
LIMIT 5;

-- Q11 --
SELECT * FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';

-- Q12 --
SELECT * FROM netflix
WHERE director IS NULL OR director = '';

-- Q13 --
SELECT * FROM netflix
WHERE cast LIKE '%Salman Khan%'
AND release_year > 2011; -- Assuming 2021 is current year

-- Q14 --
-- Requires a complex split function in MySQL, or you can use LIKE
SELECT cast, COUNT(*) as count
FROM netflix
WHERE country = 'India'
GROUP BY cast
ORDER BY count DESC
LIMIT 10;

-- Q15 --
SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END as category,
    COUNT(*) as count
FROM netflix
GROUP BY 1;

-- Q16 --
WITH profitability AS (
    SELECT 
        n.type, n.title,
        (c.estimated_revenue_million_usd - (c.production_cost_million_usd + c.marketing_cost_million_usd)) as profit
    FROM netflix n
    JOIN netflix_content_costs c ON n.show_id = c.show_id
    WHERE n.release_year > 2018
)
SELECT * FROM (
    SELECT *, RANK() OVER(PARTITION BY type ORDER BY profit DESC) as rnk
    FROM profitability
) as t
WHERE rnk <= 3;

-- Q17 --
SELECT 
    n.country, 
    SUM(v.total_views_millions) as total_views,
    (
        SELECT n2.title 
        FROM netflix n2 
        JOIN netflix_viewership v2 ON n2.show_id = v2.show_id 
        WHERE n2.country = n.country 
        AND v2.avg_watch_time_minutes > (SELECT AVG(avg_watch_time_minutes) FROM netflix_viewership)
        ORDER BY v2.total_views_millions DESC LIMIT 1
    ) as top_title
FROM netflix n
JOIN netflix_viewership v ON n.show_id = v.show_id
WHERE v.avg_watch_time_minutes > (SELECT AVG(avg_watch_time_minutes) FROM netflix_viewership)
GROUP BY n.country
ORDER BY total_views DESC
LIMIT 1;