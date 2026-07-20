/* Action 영화 중 평균 길이보다 긴 영화, Comedy 영화중 rating이 'NC-17'인 영화 조회
- 출력 컬럼
영화 제목(title) 
장르(category) 
러닝타임(length) 
관람등급(rating) 
- 정렬
장르명 오름차순 
영화 제목 오름차순 */

SELECT 
    F.title,
    C.name AS category,
    F.length,
    F.rating
FROM film F
JOIN film_category FC ON F.film_id = FC.film_id
JOIN category C ON FC.category_id = C.category_id
WHERE (C.name = 'Action' AND F.length > (SELECT AVG(length) FROM film))
   OR (C.name = 'Comedy' AND F.rating = 'NC-17')
ORDER BY category ASC, title ASC;

-- 정답
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
      (SELECT AVG(length) FROM film) -- 서브쿼리 평균길이 이상인 Action 영화
      
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