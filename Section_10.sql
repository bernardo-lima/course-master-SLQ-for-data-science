-- Assignment 8
-- 1. Write a query that finds students who do not take CS180.
SELECT student_no,
       student_name
FROM students
WHERE student_no NOT IN (
-- Studnets that take CS180
SELECT s.student_no
FROM students s 
JOIN student_enrollment se 
    ON s.student_no = se.student_no
WHERE course_no = 'CS180'
);

-- 2. Write a query to find students who take CS110 or CS107 but not both.

-- Students who take CS110 OR CS107
SELECT s.student_no, student_name
FROM students s 
JOIN student_enrollment se 
    ON s.student_no = se.student_no
WHERE course_no = 'CS110' OR course_no = 'CS107';

-- Students who take CS110 AND CS107
SELECT student_no, student_name 
FROM students
WHERE student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS110')
AND student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS107');
-- Combining both
SELECT s.student_no, student_name
FROM students s 
JOIN student_enrollment se 
    ON s.student_no = se.student_no
WHERE course_no = 'CS110' OR course_no = 'CS107'
EXCEPT
SELECT student_no, student_name 
FROM students
WHERE student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS110')
AND student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS107');

-- Another test 
-- Studnets who take 'CS110' OR 'CS210'
SELECT course_no, s.student_no, student_name
FROM students s 
JOIN student_enrollment se 
    ON s.student_no = se.student_no
WHERE course_no = 'CS210' OR course_no = 'CS110'
ORDER BY course_no, student_no;

-- Studnets who take 'CS110' and 'CS210' (two different approachs)
SELECT a.student_no 
FROM( 
    SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
        ON s.student_no = se.student_no
    WHERE course_no = 'CS210'
    ) a
INNER JOIN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
        ON s.student_no = se.student_no
    WHERE course_no = 'CS110') b
ON a.student_no = b.student_no

SELECT student_no, student_name 
FROM students
WHERE student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS210')
AND student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS110');
    
-- Combining both
SELECT s.student_no, student_name
FROM students s 
JOIN student_enrollment se 
    ON s.student_no = se.student_no
WHERE course_no IN ('CS210', 'CS110')
EXCEPT
SELECT student_no, student_name 
FROM students
WHERE student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS210')
AND student_no IN
    (SELECT s.student_no
    FROM students s 
    JOIN student_enrollment se 
    ON s.student_no = se.student_no
    WHERE course_no = 'CS110');

-- 3. Write a query to find students who take CS220 and no other courses.
SELECT student_name, student_no FROM
(SELECT s.student_no, student_name, course_no,
COUNT (course_no) OVER (PARTITION BY s.student_no) AS course_count
FROM students s 
JOIN student_enrollment se 
ON s.student_no = se.student_no) AS a
WHERE course_no = 'CS220'
AND course_count = 1

-- 4. Write a query that finds those students who take at most 2 courses. 
-- Your query should exclude students that don't take any courses as well as those  that take more than 2 course. 
SELECT student_name, student_no FROM
(SELECT s.student_no, student_name, course_no,
COUNT (course_no) OVER (PARTITION BY s.student_no) AS course_count
FROM students s 
JOIN student_enrollment se 
ON s.student_no = se.student_no) AS a
WHERE course_count <=2
GROUP BY student_name, student_no

-- 5. Write a query to find students who are older than at most two other students.
SELECT student_no, student_name, age
FROM
(SELECT *,
(SELECT COUNT(*) FROM students e1 WHERE e1.age < e2.age) count_younger
FROM students e2) a
WHERE count_younger <=2
ORDER BY age;


-----------------------------------------------------------------------------
-- INSTRUCTOR'S ANSWERS AND EXPLANATION
-- 1. Write a query that finds students who do not take CS180.
-- You may have thought about the following query at first, but this is not correct: 
SELECT * FROM students
WHERE student_no IN (SELECT student_no
                     FROM student_enrollment
                     WHERE course_no != 'CS180')
                    ORDER BY student_name

/* The above query is incorrect because it does not answer the question "Who does not take CS180?". 
Instead, it answers the question "Who takes a course that is not CS180?" The correct result should include
students who take no courses as well as students who take courses but none of them CS180.*/

-- 2 CORRECT ANSWERS BELOW:
-- Answer A:
SELECT * FROM students
WHERE student_no NOT IN (
    SELECT student_no
    FROM student_enrollment
    WHERE course_no = 'CS180'
    );

-- Answer B: Bonus points if you can understand the below solution.
SELECT s.student_no, s.student_name, s.age
FROM students s LEFT JOIN student_enrollment se 
    ON s.student_no = se.student_no
GROUP BY s.student_no, s.student_name, s.age
HAVING MAX(CASE WHEN se.course_no = 'CS180'
           THEN 1 ELSE 0 END) = 0


-- 2. Write a query to find students who take CS110 or CS107 but not both.
-- The following query looks promising as a solution but returns the wrong result!
SELECT * 
FROM students
WHERE student_no IN (SELECT student_no
                     FROM student_enrollment
                     WHERE course_no != 'CS110' 
                     AND course_no != 'CS107')

-- 2 CORRECT ANSWERS BELOW:
-- Solution A:
SELECT s.*
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
AND se.course_no IN ('CS110', 'CS107')
AND s.student_no NOT IN ( SELECT a.student_no
                          FROM student_enrollment a, student_enrollment b
                          WHERE a.student_no = b.student_no
                          AND a.course_no = 'CS110'
                          AND b.course_no = 'CS107')
/* Solution A uses a self join on the student_enrollment table so that those students are narrowed 
   down that take both CS110 and CS107 in the subquery. The outer query filters for those student_no 
   that are not the ones retrieved from the subquery.*/

--Solution B:
SELECT s.student_no, s.student_name, s.age
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
GROUP BY s.student_no, s.student_name, s.age
HAVING SUM(CASE WHEN se.course_no IN ('CS110', 'CS107')
           THEN 1 ELSE 0 END ) = 1

-- In solution B, a CASE expression is used with the aggregate SUM function to find students who take 
-- either CS110 or CS107, but not both. 

-- 3. Write a query to find students who take CS220 and no other courses.
-- You may have thought about the below query to solve this problem but this will not give you the correct result:
SELECT s.*
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
AND se.course_no = 'CS220'

/* We want to see those students who only take CS220 and no other course. The above query returns students who take CS220 
   but these students could also be taking other courses and that is why this query doesn't work. */

-- 2 CORRECT ANSWERS BELOW:
-- Solution A:
SELECT s.*
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
AND s.student_no NOT IN ( SELECT student_no
                          FROM student_enrollment
                          WHERE course_no != 'CS220')
/* In Solution A, the subquery returns all students that take a course other than CS220. The outer query gets all students 
regardless of what course they take. In essence, the subquery finds all students who take a course that is not CS220. 
The outer query returns all student who are not amongst those that take a course other than CS220. 
At this point, the only available students are those who actually take CS220 or take nothing at all. */

-- Solution B:

SELECT s.*
FROM students s, student_enrollment se1,
     (SELECT student_no FROM student_enrollment
      GROUP BY student_no
      HAVING count(*) = 1) se2
WHERE s.student_no = se1.student_no
AND se1.student_no = se2.student_no
AND se1.course_no = 'CS220'
/* Solution B uses subquery to get those students who take only a single course and since it's in the from clause,
 it's considered a source of data just like a table. This is also called an inline view if you recall. 
 So the student_no from the inline view is joined with the outer query and we filter for only those students that take the course CS220. 
 So this query returns that one student that takes CS220 and no other course. */

-- 4 Write a query that finds those students who take at most 2 courses. 
-- Your query should exclude students that don't take any courses as well as those  that take more than 2 course. 

-- SOLUTION:

SELECT s.student_no, s.student_name, s.age
FROM students s, student_enrollment se
WHERE s.student_no = se.student_no
GROUP BY s.student_no, s.student_name, s.age
HAVING COUNT(*) <= 2
-- Use the COUNT function to determine which students take no more than 2 courses. 
-- Students that don't take any courses are being excluded anyway because of the join. 

-- 5.Write a query to find students who are older than at most two other students.

-- SOLUTION:

SELECT s1.*
FROM students s1
WHERE 2 >= (SELECT count(*)
            FROM students s2
            WHERE s2.age < s1.age)
/* Using the aggregate function COUNT and a correlated subquery as shown in the solution above, 
you can retrieve the students who are older than zero, one or two other students. */
