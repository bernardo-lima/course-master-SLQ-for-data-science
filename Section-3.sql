-- SUBSTRING()

SELECT first_name,
       SUBSTRING(first_name
                 FROM 1
                 FOR 3) sub_test
FROM employees;

-- FROM  in SUBSTRING function is optional. It can be sustituted by commas

SELECT first_name,
       SUBSTRING(first_name, 1, 3) sub_test
FROM employees;

 -- Replace needs 3 arguements: REPLACE (where, 'target', 'result')

SELECT department,
       REPLACE(department, 'Clothing', 'Attire') modified_data
FROM departments;

 -- Little exercise to add department after each department name in the department colum

SELECT department,
       department || ' department' AS "Complete Department Name"
FROM departments;

 -- POSITION()

SELECT email,
       POSITION('@' IN email)
FROM employees
WHERE email IS NOT NULL;


SELECT email,
       SUBSTRING(email, POSITION('@' IN email))
FROM employees
WHERE email IS NOT NULL;


SELECT email,
       POSITION('@' IN email) AS a,
       POSITION('.' IN email) AS b,
       (POSITION('.' IN email) - POSITION('@' IN email)) AS c,
       SUBSTRING(email, POSITION('@' IN email)),
       SUBSTRING(email, (POSITION('@' IN email)+1), (POSITION('.' IN email) - POSITION('@' IN email)-1))
FROM employees
WHERE email IS NOT NULL;

 -- COALESCE()

SELECT email,
       COALESCE(email, 'NONE') AS email_modif
FROM employees;

-- Assignment 3: Practice with Functions, Conditional Expressions and Concatenation

-- Q1: Write a query against the professors table that can output the following in the result: "Chong works in the Science department"
SELECT 'Chong works in the Science department'
FROM professors 
WHERE last_name = 'Chong';

-- Course answer. I misunderstood the question 
SELECT last_name || ' ' || 'works in the '|| department || ' department'
FROM professors;

-- Q2: Write a SQL query against the professors table that would return the following result: 
SELECT last_name,
       salary,
       CASE
           WHEN salary < 95000 THEN 'It is false that professor ' || last_name || ' is highly paid'
           ELSE 'It is true that professor ' || last_name || ' is highly paid'
       END AS question2
FROM professors;

-- Course answer
SELECT 'It is ' || (salary > 95000) || ' that professor ' || last_name || ' is highly paid'
FROM professors;

-- Question 3: Write a query that returns all of the records and columns from the professors table but 
-- shortens the department names to only the first three characters in upper case.
SELECT UPPER(SUBSTRING(department,1,3)) AS department,
       salary,
       hire_date
FROM professors;

-- Question 4: Write a query that returns the highest and lowest salary from the professors table excluding the professor named 'Wilson'
SELECT MIN(salary) AS lowest_sal,
       MAX(salary) AS highest_sal
FROM professors
WHERE last_name != 'Wilson';

-- Question 5: Write a query that will display the hire date of the professor that has been teaching the longest.
SELECT hire_date
FROM professors
ORDER BY hire_date DESC 
LIMIT 1;

-- OR
SELECT MIN(hire_date) 
FROM professors;

