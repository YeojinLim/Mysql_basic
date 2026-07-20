-- < 집합 쿼리(Set Query) >
-- 두 개 이상의 SELECT 결과를 하나의 결과로 합치는 쿼리
-- 각 SELECT문의 컬럼 개수와 데이터 타입이 서로 호환되어야 한다.(컬럼의 이름이 같지 않아도 데이터 타입만 호환되면 연산이 된다. 결과셋의 컬럼 이름은 첫번째 테이블의 이름으로 조회된다)

select count(*) FROM actor; -- 200
select count(*) FROM customer; -- 599

-- 1. UNION ALL : 중복까지 모두 출력
select count(*) from
(SELECT first_name
FROM actor
UNION ALL
SELECT first_name
FROM customer) t; -- 799

-- 2. UNION : 중복을 제거하여 결합
select count(*) from
(SELECT first_name
FROM actor
UNION 
SELECT first_name
FROM customer) t; -- 647

-- 3. INTERSECT : 두 결과에 모두 존재하는 데이터만 조회
SELECT first_name
FROM actor
INTERSECT
SELECT first_name
FROM customer; -- 배우와 고객 모두에 존재하는 이름만 출력

-- 4. EXCEPT : 첫 번째 결과에는 있지만 두 번째 결과에는 없는 데이터만 조회
SELECT first_name
FROM actor
EXCEPT
SELECT first_name
FROM customer; -- 배우 이름 중 고객 이름에는 없는 데이터만 출력

-- 컬럼명이 달라도 컬럼 개수와 타입만 맞으면 된다.
SELECT first_name
FROM actor
UNION
SELECT city
FROM city;

-- 컬럼 개수가 다르면 오류
-- Error Code: 1222. The used SELECT statements have a different number of columns
SELECT first_name, last_name
FROM actor
UNION
SELECT first_name
FROM customer;

-- 데이터 타입이 다르면 MySQL은 가능한 경우 자동 형변환을 수행한다.
SELECT actor_id
FROM actor
UNION
SELECT first_name
FROM customer;

-- 응용 예제
select t.name
from
(SELECT first_name as name FROM actor
union
SELECT first_name as name FROM customer) t
where t.name like '%ab%'; 

select t.name
from
(SELECT first_name as name FROM actor 
union
SELECT last_name as name FROM customer) t
where t.name like '%ac%'; 