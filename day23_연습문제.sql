-- 1. action 최대러닝타임의 영화보다 러닝타임이 긴 영화들 조회
-- CTE(Common Table Expression)
with f3join as
(SELECT c.name name, f.title title, f.length length
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id)
select title, length, 
	(select max(length) from f3join where name = 'Children') "Children MAX"
from film
where length >	(select max(length)
				from f3join
				where name = 'Children')
order by length desc;

-- 2. Action 영화 중 평균 길이보다 긴 영화, Comedy 영화중 rating이 'NC-17'인 영화 조회
SELECT f.title,
       c.name AS category,
       f.length,
       f.rating
FROM film f
INNER JOIN film_category fc
    ON f.film_id = fc.film_id
INNER JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Action'
  AND f.length >
      (SELECT AVG(length) FROM film) -- 서브쿼리 러닝타임이 평균 이상인 Action 영화
      
UNION -- 집합쿼리 두쿼리의 결과를 UNION

SELECT f.title,
       c.name,
       f.length,
       f.rating
FROM film f
INNER JOIN film_category fc
    ON f.film_id = fc.film_id
INNER JOIN category c
    ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.rating = 'NC-17' -- 17세 이상 등급 Comedy 영화
  
ORDER BY category, title; -- UNION결과를 정렬(마지막에 실행)

-- 3. 'Action','Comedy', 'Drama', 'Music', 'Sports' 카테고리의 영화 중에서 평균 영화 길이(전체 영화 평균)보다 긴 영화만 대상으로 한다. 
-- 카테고리별 영화 수와 평균 상영시간을 구하고, 영화가 30편 이상인 카테고리만 조회한다.
-- 결과는 평균 상영시간이 긴 순으로 출력한다.
WITH
avg_length AS
(
    SELECT AVG(length) avg_len
    FROM film
),

target_films AS
(
    SELECT
        fc.film_id,
        c.name
    FROM category c
    JOIN film_category fc
      ON c.category_id = fc.category_id
    WHERE c.name IN ('Action','Comedy', 'Drama', 'Music', 'Sports')
)

SELECT
    t.name,
    COUNT(*) movie_count,
    ROUND(AVG(f.length),2) avg_length
FROM target_films t INNER JOIN film f
    ON t.film_id=f.film_id
WHERE f.length > (SELECT avg_len
                        FROM avg_length)
GROUP BY t.name
HAVING COUNT(*)>=30
ORDER BY avg_length DESC;

-- 4. 하나의 영화도 존재하지 않는 카테고리의 개수와 영화가 존재하는 카테고리의 개수
SELECT
    SUM(CASE WHEN movie_count = 0 THEN 1 ELSE 0 END) AS no_movie_category,
    SUM(CASE WHEN movie_count > 0 THEN 1 ELSE 0 END) AS has_movie_category
FROM
(
    SELECT
        c.category_id,
        COUNT(fc.film_id) AS movie_count
    FROM category c
    LEFT JOIN film_category fc
        ON c.category_id = fc.category_id
    GROUP BY c.category_id
) t;