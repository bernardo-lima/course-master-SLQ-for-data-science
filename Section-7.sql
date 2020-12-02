-- Section 7: Advanced Query Techniques using Correlated Subqueries

-- First make a subquery to return the employees that salary is larger than the average
SELECT first_name,
       salary
FROM employees
WHERE salary >
    (SELECT ROUND(AVG(salary))
     FROM employees);

-- Two return the employees that the salary is larger than their department we need a correlated subquery
-- That is, now we want a query that retuns the average salary a given employee department 
-- Such as, if the employees works for Tools we run this query
SELECT ROUND(AVG(salary))
FROM employees
WHERE department = 'Tools';

-- if the employees works for Sports we run this query
SELECT ROUND(AVG(salary))
FROM employees
WHERE department = 'Sports';

-- We address this be correlating the subquery to the department of a given employee
SELECT first_name,
       salary
FROM employees AS e1
WHERE salary >
    (SELECT ROUND(AVG(salary))
     FROM employees AS e2
     WHERE e1.department = e2.department);

-- Lets check if what we did is correct by returning the department average salary for each employee

SELECT ROUND(AVG(salary))
FROM employees
WHERE department = 'Sports';

SELECT first_name,
       department,
       salary,
  (SELECT ROUND(AVG(salary))
   FROM employees AS e2
   WHERE e1.department = e2.department) AS dep_avg_sal
FROM employees AS e1;

-- Exercise 2
SELECT COUNT(*)
FROM employees
WHERE department = 'Tools';

SELECT department,
  (SELECT COUNT(*)
   FROM employees AS e2
   WHERE e1.department = e2.department) AS emp_per_dep
FROM employees AS e1
GROUP BY department;

SELECT department
FROM employees AS e1
WHERE
    (SELECT COUNT(*)
     FROM employees AS e2
     WHERE e1.department = e2.department) > 38
GROUP BY department;

-- Same using the departments table
SELECT department
FROM departments
WHERE
    (SELECT COUNT(*)
     FROM employees AS e
     WHERE departments.department = e.department) > 38;

-- Now getting the hiest salary
SELECT e1.department,
       MAX(salary)
FROM employees AS e1
WHERE
    (SELECT COUNT(*)
     FROM employees AS e2
     WHERE e1.department = e2.department) > 38
GROUP BY department;

SELECT department,
  (SELECT MAX(salary)
   FROM employees
   WHERE department = d.department)
FROM departments AS d
WHERE
    (SELECT COUNT(*)
     FROM employees AS e
     WHERE d.department = e.department) > 38
ORDER BY department;

-- Correlated queries are very slow because they run for each row. 

-- 36. [EXERCISES]: Correlated Subqueries
-- My answer 
SELECT department,
       MAX(salary) AS max_sal,
       MIN(salary) AS min_sal
FROM employees
GROUP BY department;

-- This does not work because I need the first_name of the employees

-- Final try
SELECT department,
       first_name,
       salary
FROM employees AS e1
WHERE salary =
    (SELECT MAX(salary)
     FROM employees AS e2
     WHERE e1.department = e2.department)
  OR salary =
    (SELECT MIN(salary)
     FROM employees AS e2
     WHERE e1.department = e2.department)
ORDER BY department;

-- Final try
SELECT department,
       first_name,
       salary,
       CASE
           WHEN salary =
                  (SELECT MAX(salary)
                   FROM employees AS e2
                   WHERE e1.department = e2.department) THEN 'HIGHEST SALARY'
           WHEN salary =
                  (SELECT MIN(salary)
                   FROM employees AS e2
                   WHERE e1.department = e2.department) THEN 'LOWEST SALARY'
       END AS salary_in_department
FROM employees AS e1
WHERE salary =
    (SELECT MAX(salary)
     FROM employees AS e2
     WHERE e1.department = e2.department)
  OR salary =
    (SELECT MIN(salary)
     FROM employees AS e2
     WHERE e1.department = e2.department)
ORDER BY department;

----------------
-- Course answers in steps
SELECT department,
       MAX(salary) AS max_sal,
       MIN(salary) AS min_sal
FROM employees
GROUP BY department;

-- This does not work because I need the first_name of the employees

-- First step towards the right answer
SELECT department,
       first_name,
       salary,
  (SELECT MAX(salary)
   FROM employees AS e2
   WHERE e1.department = e2.department) AS max_by_department
FROM employees AS e1
ORDER BY department;
-- With correlated queries we're able to include non-agregated columns with aggregated columns 

-- Second step -> add min salary
SELECT department,
       first_name,
       salary,
  (SELECT MAX(salary)
   FROM employees AS e2
   WHERE e1.department = e2.department) AS max_by_department,
  (SELECT MIN(salary)
   FROM employees AS e2
   WHERE e1.department = e2.department) AS min_by_department
FROM employees AS e1
ORDER BY department;

-- This query giver us a table with everything we want
-- Now we can use a query to pick what we want from this return of this query. That is a quere where the query above is the FROM 
SELECT department, first_name, salary 
FROM (
SELECT department, first_name, salary, 
  (SELECT MAX(salary) FROM employees AS e2
   WHERE e1.department = e2.department) AS max_by_department,
  (SELECT MIN(salary) FROM employees AS e2
   WHERE e1.department = e2.department) AS min_by_department
FROM employees AS e1
ORDER BY department
) AS a
WHERE salary = max_by_department 
  OR salary = min_by_department;

-- Now we just need the CASE clause
SELECT department, first_name, salary,
CASE WHEN salary = max_by_department THEN 'HIGHEST SALARY'
   WHEN salary = min_by_department THEN 'LOWEST SALARY'
END AS salary_in_department  
FROM (
SELECT department, first_name, salary, 
  (SELECT MAX(salary) FROM employees AS e2
   WHERE e1.department = e2.department) AS max_by_department,
  (SELECT MIN(salary) FROM employees AS e2
   WHERE e1.department = e2.department) AS min_by_department
FROM employees AS e1
) AS a
WHERE salary = max_by_department 
  OR salary = min_by_department
ORDER BY department;
