/* IN */

SELECT COUNT(*)
FROM employees
WHERE department = 'Sports'
  OR department = 'Toys'
  OR department = 'Garden';


SELECT COUNT(*)
FROM employees
WHERE department IN ('Sports' ,
                     'Toys',
                     'Garden');


/* BETWEEN */
/* BETWEEN clause is inclusive*/
SELECT COUNT(*)
FROM employees
WHERE salary BETWEEN 20664 AND 25840;
/* returns 35 */

SELECT COUNT(*)
FROM employees
WHERE salary >= 20664
  AND salary <= 25840;
/* 35 */

SELECT COUNT(*)
FROM employees
WHERE salary > 20664
  AND salary < 25840;
/* 33 */

/* Lesson 14 - Exercises */

SELECT first_name,
       email
FROM employees
WHERE department = 'Tools'
  AND gender = 'F'
  AND salary > 110000;

SELECT first_name,
       hire_date
FROM employees
WHERE salary > 165000
  OR (department = 'Sports'
      AND gender = 'M');

SELECT first_name,
       hire_date
FROM employees
WHERE hire_date BETWEEN '2002-01-01' AND '2004-01-01';

SELECT *
FROM employees
WHERE (gender = 'M'
       AND salary > 40000
       AND salary < 100000
       AND department = 'Automotive')
  OR (gender = 'F'
      AND department = 'Toys');
-- Two dashes '--' is also used to commnet in SQL. It ignores the line 

-- ORDER BY, DISTINCT, LIMIT, FETCH FIRST ROWS ONLY

SELECT DISTINCT(department)
FROM employees 
LIMIT 10;

-- Assignment2: Practice Writing Basic Queries

-- Q1: Write a query to display the names of those students that are between the ages of 18 and 20.

SELECT student_name
FROM students
WHERE age BETWEEN 18 AND 20;

 -- Q2: Write a query to display all of those students that contain the letters "ch" in their name or their name ends with the letters  "nd".

SELECT student_name
FROM students
WHERE student_name LIKE '%ch%'
  OR student_name LIKE '%nd';

 -- Q3: Write a query to display the name of those students that have the letters "ae" or "ph" in their name and are NOT 19 years old.

SELECT student_name
FROM students
WHERE (student_name LIKE '%ae%'
       OR student_name LIKE '%ph%')
  AND age != 19;

 -- Q4: Write a query that lists the names of students sorted by their age from largest to smallest.

SELECT student_name
FROM students
ORDER BY age DESC;

 -- Q5: Write a query that displays the names and ages of the top 4 oldest students.

SELECT student_name,
       age
FROM students
ORDER BY age DESC
LIMIT 4;

-- ADVANCED:
-- Q6: Write a query that returns students based on the following criteria:
-- The student must not be older than age 20 if their student_no is either between 3 and 5 or their student_no is 7.
-- Your query should also return students older than age 20 but in that case they must have a student_no that is at least 4.

SELECT *
FROM students
WHERE (student_no BETWEEN 3 AND 5
       OR student_no = 7)
  AND age <=20
  OR (age > 20
      AND student_no >=4);

-- Course answer

SELECT *
FROM students
WHERE AGE <= 20
  AND (student_no BETWEEN 3 AND 5
       OR student_no = 7)
  OR (AGE > 20
      AND student_no >= 4);