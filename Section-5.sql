-- Section 5: Subqueries
-- Example 1, using subqueries in the WHERE clause
SELECT e.department
FROM employees e
WHERE e.department NOT IN
    (SELECT d.department
     FROM departments d)
GROUP BY e.department;

-- Example 2, using subqueries in the FROM clause
SELECT first_name,
       salary
FROM
  (SELECT *
   FROM employees
   WHERE salary > 150000) AS a;

SELECT a.first_name,
       a.salary
FROM
  (SELECT *
   FROM employees
   WHERE salary > 150000) AS a;
-- Subqueries in the FROM clause need an allias

-- Example 3, using subqueries in the SELECT clause
-- Subqueries in the SELECT clause can only return 1 row
-- Compare examples below.
SELECT first_name,
       last_name,
       salary,
       (SELECT first_name
        FROM employees LIMIT 1)
FROM employees;

SELECT first_name, 
       last_name, 
       salary,
        (SELECT first_name
        FROM employees LIMIT 2)
FROM employees;
-- subquery must also return only one column. See 
SELECT first_name, 
       last_name,
       salary,
      (SELECT first_name,
              last_name
       FROM employees LIMIT 1)
FROM employees

-- Exercises
SELECT *
FROM employees
WHERE department IN
    (SELECT department
     FROM departments
     WHERE division = 'Electronics');

SELECT *
FROM employees
WHERE salary > 130000
  AND region_id IN
    (SELECT region_id
     FROM regions
     WHERE country IN ('Asia',
                       'Canada'));

SELECT first_name,
       last_name, 
       ((SELECT MAX(salary) FROM employees) - salary)
FROM employees
WHERE region_id IN
    (SELECT region_id
     FROM regions
     WHERE country IN ('Asia', 'Canada'));

-- SUBQUERIES WITH ANY/ALL
SELECT *
FROM employees
WHERE region_id IN
    (SELECT region_id
     FROM regions
     WHERE country IN ('United States'));
--But what if I want to find the employees that region_id is > than any of the regions of the Unisted States?
SELECT *
FROM employees
WHERE region_id >
    (SELECT region_id
     FROM regions
     WHERE country IN ('United States'));
-- The code above will not work because > is used to compare a single value 
-- Since my query results multiple values I need to use ANY or ALL
SELECT *
FROM employees
WHERE region_id > ANY
    (SELECT region_id
     FROM regions
     WHERE country IN ('United States'));

SELECT *
FROM employees
WHERE region_id > ALL
    (SELECT region_id
     FROM regions
     WHERE country IN ('United States'));

-- ALL the condition need to be meet to ALL values in the set 
-- ANY the value needs to meet the condition for any value in the set 

-- Exercises
SELECT *
FROM employees
WHERE department = ANY
    (SELECT department
     FROM departments
     WHERE division = 'Kids')
  AND hire_date > ALL
    (SELECT hire_date
     FROM employees
     WHERE department = 'Maintenance');

SELECT salary
FROM
  (SELECT salary,
          count(*)
   FROM employees
   GROUP BY salary
   ORDER BY count(*) DESC, 
            salary DESC
   LIMIT 1 ) AS a;

SELECT salary
FROM employees
GROUP BY salary HAVING count(*) >= ALL
  (SELECT count(*)
   FROM employees
   GROUP BY salary)
ORDER BY salary DESC LIMIT 1;


-- 24. [EXERCISES]: More Practice with Subqueries

CREATE TABLE dupes (id integer, name varchar(10));

INSERT INTO dupes VALUES (1, 'FRANK');
INSERT INTO dupes VALUES (2, 'FRANK');
INSERT INTO dupes VALUES (3, 'ROBERT');
INSERT INTO dupes VALUES (4, 'ROBERT');
INSERT INTO dupes VALUES (5, 'SAM');
INSERT INTO dupes VALUES (6, 'FRANK');
INSERT INTO dupes VALUES (7, 'PETER');

SELECT min(id),
       name
FROM dupes
GROUP BY name;

SELECT *
FROM dupes
WHERE id IN
    (SELECT min(id)
     FROM dupes
     GROUP BY name );
-- How to delete the duplicates using the code above.
-- Contrast to code above
DELETE
FROM dupes
WHERE id NOT IN
    (SELECT min(id)
     FROM dupes
     GROUP BY name );

SELECT * FROM dupes 

DROP TABLE dupes 

-- Calculate the average salary excluding the MIN and MAX salary
SELECT ROUND(AVG(salary))
FROM employees;

-- First attemp by brute force 
SELECT ((SUM(salary)- MIN(salary)- MAX(salary)) / (COUNT(salary)-2)), 
ROUND(AVG(salary))
FROM employees;

-- Using suqueries
SELECT ROUND(AVG(salary))
FROM employees
WHERE salary NOT IN (
    (SELECT MIN(salary) FROM employees),
    (SELECT MAX(salary)FROM employees)
    );

-- Assignment 5: Subqueries
-- Q1 Is the students table directly related to the courses table? Why or why not?
    -- No, because they do not share a common identifier.

-- Q2 Using subqueries only, write a SQL statement that returns the names of those 
-- students that are taking the courses  Physics and US History. 
SELECT student_name
FROM students
WHERE student_no IN
    (SELECT student_no
     FROM student_enrollment
     WHERE course_no IN
         (SELECT course_no
          FROM courses
          WHERE course_title IN('Physics',
                                'US History')
          )
      );

-- Q3 Using subqueries only, write a query that returns the name of the student that
-- is taking the highest number of courses. 

    -- Select from student enrollment the student that is taking most courses.
    -- First try
SELECT student_no,
       COUNT(*) AS num_courses
FROM student_enrollment
GROUP BY student_no
ORDER BY num_courses DESC LIMIT 1;

-- Second try with with just the student number
SELECT student_no
FROM student_enrollment
GROUP BY student_no
ORDER BY COUNT(*) DESC 
LIMIT 1;
    -- Plug this query in the students table
SELECT student_name
FROM students
WHERE student_no =
    (SELECT student_no
     FROM student_enrollment
     GROUP BY student_no
     ORDER BY COUNT(*) DESC 
     LIMIT 1)
;

-- Course answer
FROM students 
WHERE student_no 
IN (
    SELECT student_no FROM (
        SELECT student_no, COUNT(course_no) course_cnt
        FROM STUDENT_ENROLLMENT
        GROUP BY student_no
        ORDER BY course_cnt desc
        LIMIT 1
    )a
);

-- Q4 Answer TRUE or FALSE for the following statement:
-- Subqueries can be used in the FROM clause and the WHERE clause but cannot be used in the SELECT Clause. 
    -- Answer: FALSE
    -- Course: FALSE. Subqueries can be used in the FROM, WHERE, SELECT and even the HAVING clause.
    
-- Q5 Write a query to find the student that is the oldest. 
-- You are not allowed to use LIMIT or the ORDER BY clause to solve this problem.
SELECT student_name,
       age
FROM students
WHERE age =
    (SELECT MAX(age)
     FROM students);




