-- CASE in SELECT 
SELECT first_name,
       salary,
       CASE
           WHEN salary < 100000 THEN 'UNDER PAID'
           WHEN salary > 100000 THEN 'PAID WELL'
           ELSE 'UNPAID'
       END
FROM employees
ORDER BY salary DESC;

-- To label a Table or Column after CASE, insert allias (i.e. AS) after END
SELECT first_name,
       salary,
       CASE
           WHEN salary < 100000 THEN 'UNDER PAID'
           WHEN salary > 100000
                AND salary < 160000 THEN 'PAID WELL'
           ELSE 'EXECUTIVE'
       END AS sal_category
FROM employees
ORDER BY salary DESC;

SELECT a.sal_category, 
       COUNT(*)
FROM(
    SELECT
       first_name,
       salary,
       CASE
           WHEN salary < 100000 THEN 'UNDER PAID'
           WHEN salary > 100000
                AND salary < 160000 THEN 'PAID WELL'
           ELSE 'EXECUTIVE'
       END AS sal_category
    FROM employees
    ORDER BY salary DESC
    ) AS a
GROUP BY a.sal_category;

-- How to tranpose the results above from 2 columns and 3 rows to 3 columns and 1 row 
SELECT SUM(CASE WHEN salary < 100000 THEN 1 ELSE 0 END) AS under_paid,
       SUM(CASE WHEN salary > 100000
           AND salary < 160000 THEN 1 ELSE 0 END) AS paid_well,
       SUM(CASE WHEN salary > 160000 THEN 1 ELSE 0 END) AS executive
FROM employees;

-- Practice trasposing. Transpose table resulting from Query below
SELECT department,
       COUNT(*)
FROM employees
WHERE department IN ('Sports',
                     'Tools',
                     'Clothing',
                     'Computers')
GROUP BY department;


SELECT SUM(CASE WHEN department = 'Sports' THEN 1 ELSE 0 END) AS sports_emp,
       SUM(CASE WHEN department = 'Tools' THEN 1 ELSE 0 END) AS tools_emp,
       SUM(CASE WHEN department = 'Clothing' THEN 1 ELSE 0 END) AS clothing_emp,
       SUM(CASE WHEN department = 'Computers' THEN 1 ELSE 0 END) AS computers_emp
FROM employees;

-- Second exercises
SELECT first_name,
       CASE
           WHEN region_id = 1 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 1)
       END AS region_1,
       CASE
           WHEN region_id = 2 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 2)
       END AS region_2,
       CASE
           WHEN region_id = 3 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 3)
       END AS region_3,
       CASE
           WHEN region_id = 4 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 4)
       END AS region_4,
       CASE
           WHEN region_id = 5 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 5)
       END AS region_5,
       CASE
           WHEN region_id = 6 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 6)
       END AS region_6,
       CASE
           WHEN region_id = 7 THEN
                  (SELECT country
                   FROM regions
                   WHERE region_id = 7)
       END AS region_7
FROM employees;

-- Grouping per regions
SELECT COUNT(a.region_1) + COUNT(a.region_2) + COUNT(a.region_3) AS united_states,
       COUNT(a.region_4) + COUNT(a.region_5) AS asia,
       COUNT(a.region_6) + COUNT(a.region_7) AS canada
FROM
  (SELECT first_name,
          CASE
              WHEN region_id = 1 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 1)
          END AS region_1,
          CASE
              WHEN region_id = 2 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 2)
          END AS region_2,
          CASE
              WHEN region_id = 3 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 3)
          END AS region_3,
          CASE
              WHEN region_id = 4 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 4)
          END AS region_4,
          CASE
              WHEN region_id = 5 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 5)
          END AS region_5,
          CASE
              WHEN region_id = 6 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 6)
          END AS region_6,
          CASE
              WHEN region_id = 7 THEN
                     (SELECT country
                      FROM regions
                      WHERE region_id = 7)
          END AS region_7
   FROM employees) AS a;

-- Checking if result adds to 1000 
SELECT united_states + asia + canada
FROM
  (SELECT COUNT(a.region_1) + COUNT(a.region_2) + COUNT(a.region_3) AS united_states,
          COUNT(a.region_4) + COUNT(a.region_5) AS asia,
          COUNT(a.region_6) + COUNT(a.region_7) AS canada
   FROM
     (SELECT first_name,
             CASE WHEN region_id = 1 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 1) END AS region_1,
                                     CASE WHEN region_id = 2 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 2) END AS region_2,
                                     CASE WHEN region_id = 3 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 3) END AS region_3,
                                     CASE WHEN region_id = 4 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 4) END AS region_4,
                                     CASE WHEN region_id = 5 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 5) END AS region_5,
                                     CASE WHEN region_id = 6 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 6) END AS region_6,
                                     CASE WHEN region_id = 7 THEN
        (SELECT country
         FROM regions
         WHERE region_id = 7) END AS region_7
      FROM employees) AS a) AS b;

-- Assigment 6
-- Q1 
SELECT name,
       supply,
       CASE
           WHEN supply < 20000 THEN 'low'
           WHEN supply BETWEEN 20000 AND 50000 THEN 'enough'
           ELSE 'full'
       END AS supply_category
FROM fruit_imports;

-- Correct asnwer 
SELECT name,
       total_supply,
       CASE
           WHEN total_supply < 20000 THEN 'LOW'
           WHEN total_supply >= 20000
                AND total_supply <= 50000 THEN 'ENOUGH'
           WHEN total_supply > 50000 THEN 'FULL'
       END AS category
FROM
  (SELECT name,
          sum(supply) total_supply
   FROM fruit_imports
   GROUP BY name ) a;

--Q2
SELECT SUM(CASE WHEN a.season = 'Winter' THEN a.total_cost ELSE 0 END) AS "Winter",
       SUM(CASE WHEN a.season = 'Summer' THEN a.total_cost ELSE 0 END) AS "Summer",
       SUM(CASE WHEN a.season = 'All Year' THEN a.total_cost ELSE 0 END) AS "All Year",
       SUM(CASE WHEN a.season = 'Spring' THEN a.total_cost ELSE 0 END) AS "Spring",
       SUM(CASE WHEN a.season = 'Fall' THEN a.total_cost ELSE 0 END) AS "Fall"
FROM
  (SELECT season,
          SUM(supply * cost_per_unit) AS total_cost
   FROM fruit_imports
   GROUP BY season) AS a;

-- Correct answer 
SELECT SUM(CASE WHEN season = 'Winter' THEN total_cost END) AS Winter_total,
       SUM(CASE WHEN season = 'Summer' THEN total_cost END) AS Summer_total,
       SUM(CASE WHEN season = 'Spring' THEN total_cost END) AS Spring_total,
       SUM(CASE WHEN season = 'Fall' THEN total_cost END) AS Spring_total,
       SUM(CASE WHEN season = 'All Year' THEN total_cost END) AS Spring_total
FROM
  (SELECT season,
          sum(supply * cost_per_unit) total_cost
   FROM fruit_imports
   GROUP BY season ) a;

