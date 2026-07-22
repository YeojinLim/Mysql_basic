-- EXISTS연산자 vs JOIN

-- 1. = (같다) : 서브쿼리가 하나의 값만 반환할 때 사용
-- 예) 평균 대여료와 같은 영화 조회
SELECT title, rental_rate
FROM film
WHERE rental_rate =
(
    SELECT AVG(rental_rate)
    FROM film -- 단일 결과값 : 2.98
);

-- 2. >, <, >=, <= : 서브쿼리가 하나의 값만 반환할 때 사용
-- 예) 평균보다 대여료가 높은 영화
SELECT title, rental_rate
FROM film
WHERE rental_rate >
(
    SELECT AVG(rental_rate)
    FROM film
);

-- 3. IN : 서브쿼리가 여러 개의 값을 반환할 때 사용
-- 예) Action 또는 Comedy 장르 조회
SELECT film_id, category_id
FROM film_category
WHERE category_id IN
(
    SELECT category_id
    FROM category
    WHERE name IN ('Action', 'Comedy') -- 서브쿼리의 결과셋이 2행 이상
);

-- 4. NOT IN : 서브쿼리 결과에 없는 데이터 조회
-- 예) Action을 제외한 장르 조회
SELECT name
FROM category
WHERE category_id NOT IN
(
    SELECT category_id
    FROM category
    WHERE name = 'Action'
);

-- 5. EXISTS : 메인쿼리와 서브쿼리간 INNER JOIN 과 비슷
-- 서브쿼리 결과가 하나라도 존재하면 TRUE(메인쿼리와 조인 발생)
-- 예) 영화가 하나 이상 등록된 장르만 조회
SELECT name
FROM category c -- 메인 쿼리
WHERE EXISTS
(
    SELECT *
    FROM film_category fc -- 서브 쿼리
    WHERE fc.category_id = c.category_id -- 메인 서브 조인조건
);

-- 6. NOT EXISTS : 메인쿼리와 서브쿼리간 LEFT JOIN - INNER JOIN(차집합: EXCEPT)과 비슷
-- 서브쿼리 결과가 없으면 TRUE
-- 예) 영화가 하나도 없는 장르 조회
SELECT name
FROM category c
WHERE NOT EXISTS
(
    SELECT *
    FROM film_category fc
    WHERE fc.category_id = c.category_id
);

-- 7. INNER JOIN의 목적 : 관련된 데이터를 함께 조회하는 것
-- 예를 들어 영화와 장르를 함께 출력하려면 JOIN이 필요하다. -> 영화 제목과 장르 이름을 모두 출력해야 하므로 JOIN을 사용한다.
SELECT f.title, c.name
FROM film f
INNER JOIN film_category fc
    ON f.film_id = fc.film_id
INNER JOIN category c
    ON fc.category_id = c.category_id;
    
-- 8. EXISTS의 목적 : 메인쿼리와 서브쿼리간에 조인 발생. 관련 데이터가 존재하는지만 확인하는 것
-- 예를 들어 영화가 하나라도 등록된 장르만 조회한다. -> 영화 제목은 필요 없다.
SELECT c.name
FROM category c
WHERE EXISTS (
    SELECT *
    FROM film_category fc
    WHERE fc.category_id = c.category_id
);

-- 9. 같은 결과가 나오는 경우
-- 1) inner join
SELECT DISTINCT c.name -- JOIN은 중복이 생기므로 DISTINCT를 추가해야 한다.
FROM category c
INNER JOIN film_category fc
ON c.category_id = fc.category_id;

-- 2) exists
SELECT c.name
FROM category c
WHERE EXISTS (
    SELECT *
    FROM film_category fc
    WHERE fc.category_id = c.category_id
);

-- 10. NOT EXISTS 와 JOIN
-- 영화가 하나도 등록되어 있지 않은 카테고리 찾기
-- 1) left join + is null
SELECT c.name
FROM category c
LEFT JOIN film_category fc
ON c.category_id = fc.category_id
WHERE fc.category_id IS NULL;

-- 2) not exists
SELECT c.name
FROM category c
WHERE NOT EXISTS (
    SELECT *
    FROM film_category fc
    WHERE fc.category_id = c.category_id
);

-- INNER JOIN: 두 테이블에서 조건이 맞는 모든 데이터(열 + 행)를 합쳐서 가져오고 싶을 때 사용
-- EXISTS: 다른 테이블에 조건에 맞는 데이터가 "있는지 없는지(참/거짓)" 확인만 하고 싶을 때 사용
-- LEFT JOIN + IS NULL: 오른쪽 테이블에 매칭되는 데이터가 없는 경우(차집합)만 골라내고 싶을 때 사용
-- NOT EXISTS : 관련 데이터가 없는 경우를 찾을 때 사용