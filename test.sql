create database test;
select * from first;
ALTER TABLE first
MODIFY COLUMN date DATE;

select * from second;
select * from third;
ALTER TABLE third
MODIFY COLUMN date DATE;


SELECT COUNT(DISTINCT user_id) AS MAU
FROM first;

SELECT 
    AVG(dau)
FROM (
    SELECT date, COUNT(DISTINCT user_id) AS dau
    FROM first
    GROUP BY date
) t;


WITH nov1 AS (
    SELECT DISTINCT user_id
    FROM first
    WHERE DATE(date) = '2023-11-01'
),
nov2 AS (
    SELECT DISTINCT user_id
    FROM first
    WHERE DATE(date) = '2023-11-02'
)

SELECT 
      ROUND(COUNT(DISTINCT n2.user_id) * 100.0 / COUNT(DISTINCT n1.user_id), 1) as retention_1day_percent
      from nov1 n1
LEFT JOIN nov2 n2 
ON n1.user_id = n2.user_id;

WITH user_views AS (
    SELECT 
        user_id,
        SUM(view_adverts) as total_views
    FROM first
    GROUP BY user_id
)
SELECT 
    ROUND(COUNT(CASE WHEN total_views > 0 THEN 1 END) * 100.0 / COUNT(DISTINCT user_id), 1) as conversion_percent
FROM user_views;

SELECT 
    ROUND(AVG(user_total_views), 1) as avg_views_per_user
FROM (
    SELECT 
        user_id,
        SUM(view_adverts) as user_total_views
    FROM first
    GROUP BY user_id
) as user_stats;


select * from second;

WITH stats AS (
    SELECT 
        experiment_group,
        COUNT(*) as users,
        SUM(revenue) as total_revenue,
        AVG(revenue) as avg_revenue,
        STDDEV(revenue) as std_revenue
    FROM second
    WHERE experiment_num = 1
    GROUP BY experiment_group
)
SELECT * FROM stats;


select * from third;
SELECT 
    ROUND(AVG(revenue), 1) as avg_revenue_per_user
FROM third;

WITH ranked_ages AS (
    SELECT 
        age,
        ROW_NUMBER() OVER (ORDER BY age) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM third
)
SELECT 
    ROUND(AVG(age), 0) as median_age
FROM ranked_ages
WHERE row_num BETWEEN total_count/2 AND total_count/2 + 1;
