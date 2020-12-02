-- Section 8 - Working with multiple talbe

SELECT first_name,
       email,
       division
FROM employees,
     departments
WHERE employees.department = departments.department
  AND email IS NOT NULL;

 -- Add countries to query about

SELECT first_name,
       email,
       division,
       country
FROM employees,
     departments,
     regions
WHERE employees.department = departments.department
  AND employees.region_id = regions.region_id
  AND email IS NOT NULL;

 -- Let's add department to the query

SELECT first_name,
       email,
       division,
       country,
       department
FROM employees,
     departments,
     regions
WHERE employees.department = departments.department
  AND employees.region_id = regions.region_id
  AND email IS NOT NULL;

-- ERROR:  column reference "department" is ambiguous
-- LINE 1: SELECT first_name, email, division, country, department
-- this happens because we have depatments in the employees and departments tables
-- So, we need to specify which one we're reffering to

SELECT first_name,
       email,
       division,
       country,
       employees.department
FROM employees,
     departments,
     regions
WHERE employees.department = departments.department
  AND employees.region_id = regions.region_id
  AND email IS NOT NULL;

-- To avoid repeting the tables names we can use alliases for them

SELECT first_name,
       email,
       division,
       country,
       e.department
FROM employees e,
     departments d,
     regions r
WHERE e.department = d.department
  AND e.region_id = r.region_id
  AND email IS NOT NULL;

-- Some exercises for practice

SELECT country,
       COUNT(employee_id)
FROM employees e,
     regions r
WHERE e.region_id = r.region_id
GROUP BY country 

-- A join is source of data. But as we saw before a sub-query can be a source of data. See below.

SELECT country,
       COUNT(employee_id)
FROM employees e,
  (SELECT *
   FROM regions) r
WHERE e.region_id = r.region_id
GROUP BY country 
-- This example is non-correlated sub-query

/* Let's now introduce JOINS more formaly using the propper syntax
 The examples above joined tables in the WHERE clause, but we can also
 use the syntax (INNER, OUTTER, LEFT, RIGHT) JOIN in the FROM clause */
SELECT first_name,
       country
FROM employees AS e,
     regions AS r
WHERE e.region_id = r.region_id;

-- Becomes
SELECT first_name,
       country
FROM employees AS e
INNER JOIN regions AS r ON e.region_id = r.region_id;

SELECT first_name,
       email,
       division
FROM employees
INNER JOIN departments ON employees.department = departments.department
WHERE email IS NOT NULL;

-- How to add another JOIN to the query above?

SELECT first_name,
       email,
       division
FROM employees
INNER JOIN departments ON employees.department = departments.department
INNER JOIN regions ON employees.region_id = regions.region_id
WHERE email IS NOT NULL;

/* It is important to note that second join is joining with the results of the first
join and not the whole original table. That is, the results of first query source of data
( FROM employees INNER JOIN departments
ON employees.department = departments.department)
is jointed with (INNER JOIN regions ON employees.region_id = regions.region_id)*/

SELECT DISTINCT(department)
FROM employees
ORDER BY department;
-- 27 departments

SELECT DISTINCT(department)
FROM departments
ORDER BY department;
-- 24 departments

SELECT first_name,
       email,
       division
FROM employees
INNER JOIN departments ON employees.department = departments.department;

 -- 23 departments

SELECT DISTINCT(employees.department),
       departments.department
FROM employees
LEFT JOIN departments ON employees.department = departments.department;

 -- Brings all the departments in the employees table.
-- And NULL departments.department columsn where there is no match

SELECT DISTINCT(employees.department),
       departments.department
FROM employees
RIGHT JOIN departments ON employees.department = departments.department;

 -- Now focusing on the departments talbe (the table on the right)

SELECT DISTINCT(employees.department),
       departments.department
FROM employees
LEFT JOIN departments ON employees.department = departments.department
WHERE departments.department IS NULL;

 -- Show only the departments that are unique for the employees table

SELECT DISTINCT(employees.department) AS dep_emp,
       departments.department AS dep_dep
FROM employees
FULL JOIN departments ON employees.department = departments.department -- UNION -> used to stack data. Union elimiates duplicates. See below.

SELECT department
FROM employees
UNION
SELECT department
FROM departments;

 -- UNION ALL does not eliminates duplicates

SELECT DISTINCT(department)
FROM employees
UNION ALL
SELECT department
FROM departments;

 -- In UNION we should have the same number of columns and data type

SELECT DISTINCT(department)
FROM employees EXCEPT
SELECT department
FROM departments;

 -- EXCEPT works like a subtraction. It gts the first subset and extract all the records of the second subset.
-- Thus leaving us with only the unique records of the firt subset
-- Inder databases uses MINUS instead of EXCEPT

SELECT department,
       COUNT(*)
FROM employees
GROUP BY department
UNION ALL
SELECT 'TOTAL',
       COUNT(*)
FROM employees;

 -- Cartesian produt

SELECT *
FROM employees,
     departments;

 -- this results 24000 rows. It returns all the combiantion between the two table 1000 (emp) x 24 (dep)
-- A CROSS JOIN is a cartesian product

SELECT *
FROM employees
CROSS JOIN department;

 -- EXERCISES Video 33

SELECT first_name,
       department,
       hire_date,
       country
FROM employees e
JOIN regions r ON e.region_id = r.region_id
WHERE hire_date =
    (SELECT MAX(hire_date)
     FROM employees e2)
  OR hire_date =
    (SELECT MIN(hire_date)
     FROM employees e2);


SELECT first_name,
       department,
       hire_date,
       country
FROM employees e
JOIN regions r ON e.region_id = r.region_id
WHERE hire_date =
    (SELECT MAX(hire_date)
     FROM employees e2)
UNION ALL
SELECT first_name,
       department,
       hire_date,
       country
FROM employees e
JOIN regions r ON e.region_id = r.region_id
WHERE hire_date =
    (SELECT MIN(hire_date)
     FROM employees e2);


  (SELECT first_name,
          department,
          hire_date,
          country
   FROM employees e
   JOIN regions r ON e.region_id = r.region_id
   WHERE hire_date =
       (SELECT MAX(hire_date)
        FROM employees e2) LIMIT 1)
UNION ALL
SELECT first_name,
       department,
       hire_date,
       country
FROM employees e
JOIN regions r ON e.region_id = r.region_id
WHERE hire_date =
    (SELECT MIN(hire_date)
     FROM employees e2) -- Next one

  SELECT hire_date,
         salary,

    (SELECT SUM(salary)
     FROM employees e2
     WHERE e2.hire_date BETWEEN e1.hire_date-90 AND e1.hire_date) AS spending_pattern
  FROM employees e1
ORDER BY hire_date;

-- This basically creates 90 between the hiring date and 90 days before
-- Creating views
-- TO create a view just add this to begning to a qury you wnat to save as a view
-- CREATE VIEW v_name_of_view AS
-- QUERY BELLOW

CREATE VIEW v_emp_spending_90days AS
SELECT hire_date,
       salary,

  (SELECT SUM(salary)
   FROM employees e2
   WHERE e2.hire_date BETWEEN e1.hire_date-90 AND e1.hire_date) AS spending_pattern
FROM employees e1
ORDER BY hire_date;

-- You can the views in the views folder inside the schemas folder
-- A in line view is query in the FROM clause. When we have a query in the FROM clause we need a allias


-- Assignment 7:  ADVANCED Problems using Joins, Grouping and Subqueries

-- Q1. Are the tables student_enrollment and professors directly related to each other? Why or why not?
-- No, because they do not share a common identifier (e.g. column)
-- Course Answer
-- They are NOT related directly. The reason is, there is no common column shared amongst them.
-- There cannot be a direct relationship formed between these 2 tables.

-- Q2. Write a query that shows the student's name, the courses the student is taking and the professors that teach that course.

SELECT s.student_no,
       student_name,
       course_title,
       last_name
FROM student_enrollment se
LEFT JOIN students s ON s.student_no = se.student_no
LEFT JOIN courses c ON se.course_no = c.course_no
LEFT JOIN teach t ON t.course_no = c.course_no
ORDER BY student_no,
         course_title;

SELECT student_name,
       se.course_no,
       p.last_name
FROM students s
INNER JOIN student_enrollment se ON s.student_no = se.student_no
INNER JOIN teach t ON se.course_no = t.course_no
INNER JOIN professors p ON t.last_name = p.last_name
ORDER BY student_name;

-- Q3. If you execute the query from the previous answer, you'll notice the student_name and the course_no is being repeated. Why is this happening?
-- Because some courses are taught by multiple professors. Therefore  student_name & courses are repeated for each professors associated with the course
 /* The combination of student_name and course_no is being repeated for as many professors that are teaching that particular course.
If you ORDER BY the student_name column, you'll clearly be able to see that multiple professors are teaching the same subject.
For example, course CS110 is being taught by both Brown and Wilson. That is why you'll see the combination of the student
Arnold with CS110 twice. Analyze the data and understand what's going on because in the next question you'll need to write a query
to be eliminate this redundancy. */ 

-- Q4. In question 3 you discovered why there is repeating data. How can we eliminate this redundancy?
-- Let's say we only care to see a single professor teaching a course and we don't care for all the other professors
-- that teach the particular course. Write a query that will accomplish this so that every record is distinct.
-- HINT: Using the DISTINCT keyword will not help. :-)

SELECT s.student_no, student_name, se.course_no, course_title,
  (SELECT last_name
   FROM teach t
   WHERE t.course_no = se.course_no LIMIT 1)
FROM student_enrollment se
JOIN students s ON s.student_no = se.student_no
LEFT JOIN courses c ON se.course_no = c.course_no
ORDER BY student_no;

 -- Instructor answer

SELECT student_name,
       course_no,
       min(last_name)
FROM
  (SELECT student_name,
          se.course_no,
          p.last_name
   FROM students s
   INNER JOIN student_enrollment se ON s.student_no = se.student_no
   INNER JOIN teach t ON se.course_no = t.course_no
   INNER JOIN professors p ON t.last_name = p.last_name ) a
GROUP BY student_name,
         course_no
ORDER BY student_name,
         course_no;

 -- Considering student_no

SELECT student_no,
       student_name,
       course_no,
       min(last_name)
FROM
  (SELECT s.student_no,
          student_name,
          se.course_no,
          p.last_name
   FROM students s
   INNER JOIN student_enrollment se ON s.student_no = se.student_no
   INNER JOIN teach t ON se.course_no = t.course_no
   INNER JOIN professors p ON t.last_name = p.last_name ) a
GROUP BY student_no,
         student_name,
         course_no
ORDER BY student_no,
         student_name,
         course_no;

-- Q5. Why are correlated subqueries slower that non-correlated subqueries and joins?
-- Because the correlated subquery is repeated for every single record in the main query.
/* Instructor's answer
A "correlated subquery" (i.e., one in which the where condition depends on values obtained from the rows
of the containing/outer query) will execute once for each row. A non-correlated subquery (one in which the where
condition is independent of the containing query) will execute once at the beginning.
If a subquery needs to run for each row of the outer query, that's going be very slow!
*/ 

-- Q6. In the video lectures, we've been discussing the employees table and the departments table.
-- Considering those tables, write a query that returns employees whose salary is above average for their given department.

SELECT first_name,
       salary
FROM employees AS e1
WHERE salary >
    (SELECT ROUND(AVG(salary))
     FROM employees AS e2
     WHERE e1.department = e2.department);


SELECT first_name
FROM employees outer_emp
WHERE salary >
    ( SELECT AVG(salary)
     FROM employees
     WHERE department = outer_emp.department);

 -- Q7. Write a query that returns ALL of the students as well as any courses they may or may not be taking.

SELECT *
FROM
  (SELECT student_no,
          student_name
   FROM students) AS list_students,
  (SELECT course_no,
          course_title
   FROM courses) AS list_courses;


SELECT s.student_no,
       student_name,
       course_no
FROM students s
LEFT JOIN student_enrollment se ON s.student_no = se.student_no;

 -- FROM students
 Question 2
SELECT student_name,
       course_title,
       last_name
FROM students s
INNER JOIN student_enrollment se ON s.student_no=se.student_no
INNER JOIN courses co ON se.course_no=co.course_no
INNER JOIN teach te ON se.course_no=te.course_no
ORDER BY 1;

 Question4
SELECT student_name,
       course_title,
       min(last_name)
FROM (students s
      INNER JOIN student_enrollment se ON s.student_no=se.student_no
      INNER JOIN courses co ON se.course_no=co.course_no
      INNER JOIN teach te ON se.course_no=te.course_no) a
GROUP BY 1,
         2
ORDER BY 1;

