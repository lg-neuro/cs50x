-- Write a SQL query to list the names of all people
-- who starred in a movie released in 2004, ordered
-- by birth year. Your query should output a table
-- with a single column for the name of each person.
-- People with the same birth year may be listed in
-- any order. No need to worry about people who have
-- no birth year listed, so long as those who do have
-- a birth year are listed in order. If a person
-- appeared in more than one movie in 2004, they should
-- only appear in your results once.

--SELECT DISTINCT ON (id) name FROM people WHERE id IN
-- (SELECT person_id FROM stars WHERE movie_id IN
--  (SELECT id FROM movies WHERE year = 2004))
--   ORDER BY birth ASC;

-- SELECT DISTINCT p.name FROM people p
-- JOIN stars s ON p.id = s.person_id
-- JOIN movies m ON s.movie_id = m.id
-- WHERE m.year = 2004
-- ORDER BY p.birth;

SELECT name FROM people WHERE id IN (
 SELECT person_id FROM stars WHERE movie_id IN (
  SELECT id FROM movies WHERE year = 2004))
   GROUP BY id, name ORDER BY birth;
