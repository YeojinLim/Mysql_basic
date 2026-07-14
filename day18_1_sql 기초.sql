-- 1. 테이블의 열정보 확인

show columns from customer;

-- 2. SELECT절
-- 하나의 열 조회

select first_name
from customer
limit 10;

-- 2개이상의 열 조회, 순서는 상관 없다.

select first_name, last_name
from customer
limit 10;

-- 조회 순서는 원본 순서와 상관 없다
select last_name, first_name
from customer
limit 10;

-- 전체 열 조회

select *
from customer
limit 10;

-- DISTINCT : 중복 제거

SELECT DISTINCT store_id
FROM customer;

SELECT distinct store_id, active
FROM customer;
-- from -> where -> select -> distinct -> order by -> limit

SELECT DISTINCT first_name
FROM customer
ORDER BY first_name;

-- 주의 : DISTINCT는 각 컬럼을 따로 중복 제거하는 것이 아니라, SELECT한 컬럼들의 조합 전체를 기준으로 중복을 제거한다.

-- store_id와 active의 조합이 같은 행은 하나만 조회한다.
SELECT DISTINCT store_id, active
FROM customer;

-- 3. WHERE 절
-- (1) 비교 연산
select film_id, title, length
from film
where length <= 50;

select film_id, title, length
from film
where length = 50;

select film_id, title, length
from film
where length <> 50 -- 50보다 작거나 큰 값
limit 10;

-- 같은 연산
select film_id, title, length
from film
where length != 50
limit 10;

-- 문자값도 가능
select film_id, title, length
from film
where length <> 50
limit 10;

-- 같은 연산
select film_id, title, length
from film
where length != 50
limit 10;

select first_name, create_date
from customer
where create_date < '2006-02-14 22:04:37';

-- (2) 논리연산
SELECT *
FROM customer
WHERE active = 1
AND store_id = 1;

SELECT *
FROM customer
WHERE store_id = 1
OR store_id = 2;

SELECT *
FROM customer
WHERE NOT active = 1;

SELECT *
FROM customer
WHERE active <> 1;

SELECT *
FROM customer
WHERE first_name IN ('MARY', 'PATRICIA', 'LINDA');

-- IN 연산자 결과와 동일
SELECT *
FROM customer
WHERE first_name = 'MARY'
OR first_name = 'PATRICIA' 
OR first_name = 'LINDA'

SELECT *
FROM customer
WHERE first_name NOT IN ('mary', 'PATRICIA');
-- 컬럼값의 대소문자를 구별하지 않는다.

SELECT *
FROM customer
WHERE customer_id BETWEEN 10 AND 20; -- 10(포함)~20(포함)

-- BETWEEN 연산자 결과와 동일
SELECT *
FROM customer
WHERE customer_id >= 10 AND customer_id <= 20; 

SELECT *
FROM customer
WHERE customer_id NOT BETWEEN 10 AND 20;

SELECT *
FROM customer
WHERE first_name LIKE 'A%'; -- A로 시작하는

SELECT *
FROM customer
WHERE first_name LIKE '%A'; -- A로 끝나는

SELECT *
FROM customer
WHERE first_name LIKE '%AR%'; -- AR을 포함

SELECT *
FROM customer
WHERE first_name LIKE '_AR_'; -- AR을 포함하되 _ 에 한글자만 올 수 있다. 총 4글자 이름만 출력

SELECT *
FROM customer
WHERE first_name NOT LIKE 'A%'; -- A로 시작하지 않는

SELECT *
FROM customer
WHERE email IS NULL; -- NULL값은 NULL 전용 연산자사용. email에 NULL값이 없으면 빈 결과셋 반환

SELECT *
FROM customer
WHERE email IS NOT NULL;

SELECT *
FROM customer
WHERE store_id = 1
AND (active = 1 OR first_name = 'MARY');

SELECT *
FROM customer
WHERE NOT first_name LIKE 'A%'; -- 이름이 A로 시작하지 않는

SELECT *
FROM customer
WHERE active = 1
AND store_id IN (1, 2)  -- store_id 가 1또는 2인
AND first_name LIKE 'M%' -- 이름이 M으로 시작하는
AND customer_id BETWEEN 100 AND 300; -- customer_id가 100번부터 300번 사이에 있는

-- ※ 연산자 우선순위
-- () (괄호) -> NOT -> AND -> OR
-- AND와 OR를 함께 사용할 때는 괄호 ()를 사용하는 것이 가장 좋은 습관이다.

SELECT *
FROM customer
WHERE active = 1
OR (store_id = 1 AND first_name = 'MARY');