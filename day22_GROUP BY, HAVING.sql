-- ※ select 실행 순서 
select actor_id, first_name -- 3
from actor -- 1
where actor_id % 2= 0  -- 2
order by actor_id desc -- 4
limit 10; -- 5

-- 1. GROUP BY
-- test 폴더에 새로운 테이블 생성
create table person(
	id int primary key,
	name varchar(50),
	gender char(1)
);

-- 데이터 입력
INSERT INTO person (id, name, gender) VALUES
(1, '김민수', 'M'),
(2, '이영희', 'F'),
(3, '박지훈', 'M'),
(4, '최수진', 'F'),
(5, '정우성', 'M'),
(6, '한지민', 'F'),
(7, '오세훈', 'M'),
(8, '윤아름', 'F'),
(9, '강동원', 'M'),
(10, '송지은', 'F');

-- group  by
select *
from person
group by gender; 
-- error 발생 : GROUP BY를 거치면 개별 데이터가 아닌 '계산(집계)용 그룹'으로 바뀌기 때문에 개별 행(*) 조회 불가능

select gender, count(*) -- 필요한 그룹 컬럼과 집계함수만 정확히 SELECT 해야한다.
from person
group by gender;

-- 2. GROUP BY 에서 많이 사용되는 집계 함수
-- sakila 로 이동
select rating, count(*), sum(length), avg(length), max(length), min(length)
from film
group by rating;

select *
from
(	select rating, 
	count(*) c, 
    sum(length) s, 
    avg(length) a, 
    max(length) max, 
    min(length) min
	from film
	group by rating) t
where t.s > 25000;

select count(*), avg(length) "전체 러닝타임 평균"
from film; -- 전체를 하나의 계산셋으로 생성후 집계하겠다 group by null이 생략된 형태

-- 3. GROUP BY 여러 컬럼
-- from(조인)절이 먼저 실행 되므로 조인 후 그룹바이 실행 
SELECT c.name,
       f.rating,
       COUNT(*)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name, f.rating;

-- action 영화의 러닝타임 조회
with f3join as(
	select c.name name, f.title title, f.length length
	from category c
	join film_category fc
	on c.category_id = fc.category_id
	join film f
	on fc.film_id = f.film_id
)

select *
from f3join
where name = 'Action';

-- 어린이 영화의 최대러닝타임보다 긴 영화들 조회
-- CTE(Common Table Expression)
with f3join as(
	select c.name name, f.title title, f.length length
	from category c
	join film_category fc
	on c.category_id = fc.category_id
	join film f
	on fc.film_id = f.film_id
)
select title, length, (select max(length) from f3join where name = 'Children') Child_max
from film
where length > (select max(length)
			   from f3join
			   where name = 'Children')
order by length desc;
			
-- R, G 영화만 그룹화
-- from -> where -> group by 순

SELECT rating r,
       COUNT(*) c
FROM film -- 결과셋1
WHERE rating IN ('R', 'G') -- 결과셋2
GROUP BY rating; -- 계산셋 R/G 2개 생성

-- 4. HAVING : 그룹을 만든 후 그룹(계산셋)에서 집계함수 결과값을 필터링한다. 

-- WHERE : 그룹을 만들기 전에 행을 필터링
-- HAVING : 그룹을 만든 후 그룹의 집계함수결과를 필터링

SELECT rating,
       COUNT(*) AS cnt
FROM film
GROUP BY rating
HAVING COUNT(*) >= 200;

SELECT rating,
       AVG(length) AS avg_length
FROM film
WHERE rating <> 'R'
GROUP BY rating
HAVING AVG(length) >= 120;

SELECT rating,
       AVG(length) AS avg_length
FROM film
GROUP BY rating
ORDER BY avg_length DESC;

-- 5. 연습

-- 영화가 200편 이상인 등급
SELECT rating,
       COUNT(*) AS cnt
FROM film
GROUP BY rating
HAVING COUNT(*) >= 200;

-- 카테고리별 영화 수
SELECT c.name,
       COUNT(*) AS 영화수
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY 영화수 DESC;

-- 카테고리별 평균 영화 길이
SELECT c.name,
       AVG(f.length) AS 평균길이
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY 평균길이 DESC;

-- 영화가 60편 이상인 카테고리
SELECT c.name,
       COUNT(*) AS 영화수
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING COUNT(*) >= 60
ORDER BY 영화수 DESC;

/*
① FROM
      ↓
② WHERE
      ↓
③ GROUP BY - 행을 그룹으로 묶음
      ↓
④ 집계함수(그룹컬럼명, COUNT, AVG...) - 그룹별 계산 수행
      ↓
⑤ HAVING
      ↓
⑥ SELECT
      ↓
⑦ ORDER BY 
*/