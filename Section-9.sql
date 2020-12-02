SELECT department, COUNT(*)
FROM employees
GROUP BY department

-- If we want to add first_name of employees to this query we would need to add a correlated sub-query
SELECT first_name, department, (SELECT COUNT(*) FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
GROUP BY department, first_name

-- Why the query above returns 999 records
-- Why its showing 999 records instead of 1000, because in Decor department, two employees have same first name
select COUNT(*), first_name, department FROM EMPLOYEES
GROUP BY FIRST_NAME, department
HAVING COUNT(*) > 1

-- Example 1
SELECT first_name, department,
COUNT (*) OVER ()
FROM employees

-- If OVER() is empty it will consider the whole employees table
-- GROUP BY in window frame takes the form of PARTITION BY
SELECT first_name, department,
COUNT (*) OVER (PARTITION BY department)
FROM employees
-- Count if the Function and 'OVER (PARTITION BY department)' is the window in portion

-- Testing. Same data return 
SELECT first_name, department, (SELECT COUNT(*) FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
GROUP BY department, first_name
EXCEPT
SELECT first_name, department,
COUNT (*) OVER (PARTITION BY department)
FROM employees

-- Using two window frames
SELECT first_name, department,
COUNT (*) OVER (PARTITION BY department) dept_count,
COUNT (*) OVER (PARTITION BY region_id) region_count
FROM employees

SELECT first_name, department, region_id,
COUNT (*) OVER (PARTITION BY department) dept_count,
COUNT (*) OVER (PARTITION BY region_id) region_count
FROM employees

-- The window frame function runs in the end of the query. Contrast below
SELECT first_name, department, COUNT (*) OVER ()
FROM employees

SELECT first_name, department, COUNT (*) OVER ()
FROM employees
WHERE region_id = 3

-- That is, the WHERE clause runs before the OVER clause
-- The order of operations are:
-- FROM (and JOINTS)
-- WHERE
-- SELECT (OVER is part of the SELECT clause)

--It's also possible to oder data in the WINDOW (i.e. inside the OVER clause). This is importnat 
-- when orer matters for calculation
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING
    AND CURRENT ROW) AS running_total_of_salaries
FROM employees


-- THE 'RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW'is the defaut in SQL. 
-- Thus, if ommited will give the same result

SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date ) AS running_total_of_salaries
FROM employees

-- With PARTITION BY
SELECT first_name, hire_date, department,salary,
SUM(salary) OVER(PARTITION BY department ORDER BY hire_date ) AS running_total_of_salaries
FROM employees

-- Adding the adjancet salaries 
SELECT first_name, hire_date, department,salary,
SUM(salary) OVER(ORDER BY hire_date ROWS BETWEEN 1 PRECEDING AND CURRENT ROW ) AS running_total_of_salaries
FROM employees

-- RANK function in WINDOW frame
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM employees

-- I need the sub clause because the Window Frame is calcualated in the end of whoele query
-- If I drop the sub clause (i.e. the parenthesis) the query does not run
SELECT * FROM(
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM employees
) a
WHERE RANK = 8

-- Contrast. This query does not run


SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM employees
WHERE RANK = 8

-- It creates 5 brackets for each department
SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department ORDER BY salary DESC) salary_bracket
FROM employees

-- Return the first value of the group
SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) first_value
FROM employees

-- Contrast
SELECT first_name, email, department, salary,
MAX(salary) OVER(PARTITION BY department ORDER BY salary DESC) first_value
FROM employees

SELECT first_name, email, department, salary,
MAX(salary) OVER(PARTITION BY department ORDER BY salary DESC) first_value
FROM employees
EXCEPT
SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) first_value
FROM employees

-- Other example
SELECT first_name, email, department, salary,
MAX(salary) OVER(PARTITION BY department ORDER BY first_name ASC) first_value
FROM employees

-- nth value
SELECT first_name, email, department, salary,
nth_value(salary, 5) OVER(PARTITION BY department ORDER BY first_name ASC) "5th_value"
FROM employees

-- Lead and Lag - Greate lead and lag variables 
SELECT first_name, email, department, salary,
LEAD(salary) OVER() next_salary
FROM employees

SELECT first_name, email, department, salary,
LAG(salary) OVER() previous_salary
FROM employees

SELECT department, last_name, salary,
LAG(salary) OVER(ORDER BY salary DESC) next_higher_salary
FROM employees

SELECT department, last_name, salary,
LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) next_higher_salary
FROM employees

-- Working with Roolups and Cubes

-- Working with Roolups and Cubes

CREATE TABLE sales
(
    continent varchar(20),
    country varchar(20),
    city varchar(20),
    units_sold integer
);

INSERT INTO sales VALUES ('North America', 'Canada', 'Toronto', 10000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Montreal', 5000);
INSERT INTO sales VALUES ('North America', 'Canada', 'Vancouver', 15000);
INSERT INTO sales VALUES ('Asia', 'China', 'Hong Kong', 7000);
INSERT INTO sales VALUES ('Asia', 'China', 'Shanghai', 3000);
INSERT INTO sales VALUES ('Asia', 'Japan', 'Tokyo', 5000);
INSERT INTO sales VALUES ('Europe', 'UK', 'London', 6000);
INSERT INTO sales VALUES ('Europe', 'UK', 'Manchester', 12000);
INSERT INTO sales VALUES ('Europe', 'France', 'Paris', 5000);

SELECT * FROM sales
ORDER BY country, country, city

SELECT continent, SUM(units_sold)
FROM sales
GROUP BY continent

SELECT continent, SUM(units_sold)
FROM sales
GROUP BY country

SELECT continent, SUM(units_sold)
FROM sales
GROUP BY city

-- How to use see all these queries together?
SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY GROUPING SETS(continent, country, city)

SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY GROUPING SETS(continent, country, city)

-- With grand total 
SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY GROUPING SETS(continent, country, city, ())

-- ROLLUP
SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY ROLLUP(continent, country, city)

-- Cube group by all the combinations
-- CUBE
SELECT continent, country, city, SUM(units_sold)
FROM sales
GROUP BY ROLLUP(continent, country, city)
