-- Write a SQL query to list the titles of all
-- movies in which both Bradley Cooper and Jennifer
-- Lawrence starred. Your query should output a
-- table with a single column for the title of
-- each movie. You may assume that there is only
-- one person in the database with the name Bradley
-- Cooper. You may assume that there is only one
-- person in the database with the name Jennifer
-- Lawrence.

SELECT title FROM movies WHERE id IN
 (SELECT movie_id FROM stars WHERE person_id IN
  (SELECT id FROM people WHERE name = 'Bradley Cooper')
 INTERSECT
 SELECT movie_id FROM stars WHERE person_id IN
  (SELECT id FROM people WHERE name = 'Jennifer Lawrence'));


-- Alternative approach without using `INTERSECT`:

-- SELECT m.title
-- FROM movies m
-- JOIN stars s1 ON m.id = s1.movie_id
-- JOIN stars s2 ON m.id = s2.movie_id
-- JOIN people p1 ON s1.person_id = p1.id
-- JOIN people p2 ON s2.person_id = p2.id
-- WHERE p1.name = 'Bradley Cooper' AND p2.name = 'Jennifer Lawrence';

-- To understand this, you have to imagine a big
-- table with p1-s1-m-s2-p2 tables joined together
-- and select the only rows that have p1 and p2
-- containing the actors names. The table is joined
-- following the query rules, meaning that the 
