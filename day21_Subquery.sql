-- < 서브쿼리(Subquery) >
-- 하나의 SQL문 안에 포함된 또 다른 SELECT문. 메인 쿼리의 조건이나 데이터로 사용
-- 사용되는 위치에 따라 스칼라 서브쿼리, 인라인 뷰, 서브 쿼리 3가지로 나눈다.
/* 1) 스칼라 서브쿼리
SELECT ...(SELECT ...)
FROM ...
-- 2) 인라인 뷰
SELECT ...
FROM ...(SELECT ...)
-- 3) 서브 쿼리
SELECT ...
FROM ...
WHERE 컬럼 = (SELECT ...) */

select count(*) from film;
select avg(length) from film;
select sum(length) from film;
select max(length) from film;
select min(length) from film;

-- 1. 스칼라 서브쿼리 (Scalar Subquery) : SELECT절에 사용하는 서브쿼리
-- 1행 1열의 값만 반환 , 주로 SELECT절이나 WHERE절에서 사용 
SELECT title,
       rental_rate,
       (SELECT AVG(rental_rate) FROM film) AS avg_rate
FROM film;

select 
	title, 
    length, 
    (select round(avg(length)) from film) 전체평균 
from film;

select 
	title, 
    length, 
    (select round(avg(length)), sum(length) from film) -- 오류발생 : 단일값만 반환가능
from film;

select 
	title, 
    length, 
    (select title from film) -- 오류발생 : 단일값만 반환가능
from film;

-- 2. 인라인 뷰 (Inline View) : FROM절에 사용하는 서브쿼리
-- 실행 결과를 임시 테이블(View)처럼 사용 
SELECT *
FROM (
    SELECT title, rental_rate
    FROM film
) AS f
WHERE rental_rate >= 4.99;

SELECT t.title
FROM (SELECT * FROM film where length > 120) t
WHERE t.title like 'b%';

-- 3. 서브쿼리 (WHERE절 서브쿼리) : WHERE절에서 조건값으로 사용 
-- 단일행 또는 다중행 결과를 반환할 수 있다.

SELECT title, length
FROM film
WHERE length > (
    SELECT AVG(length)
    FROM film
);

select title, length
from film
where length > (select avg(length) from film);
