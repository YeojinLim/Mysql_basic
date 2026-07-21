-- test폴더에 새로운 테이블 생성 및 데이터 입력
CREATE TABLE student (
    id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    gender CHAR(1) NOT NULL,
    age INT NOT NULL
);

INSERT INTO student (id, name, gender, age) VALUES
(1, '김민수', 'M', 20),
(2, '이영희', 'F', 22),
(3, '박지훈', 'M', 21),
(4, '최수진', 'F', 23),
(5, '정우성', 'M', 19),
(6, '한지민', 'F', 20),
(7, '오세훈', 'M', 24),
(8, '윤아름', 'F', 21),
(9, '강동원', 'M', 22),
(10, '송지은', 'F', 19);

-- 1. 문자열 집계함수 GROUP_CONCAT()
select gender, count(*), avg(age), max(name), min(name), group_concat(name order by name desc separator '/')
from student
group by gender;

-- 숫자에만 사용가능한 집계함수 : avg, sum
-- 숫자, 문자 모두 사용가능한 집계함수 : count, max, min
-- 문자에만 사용가능한 집계함수 : group_concat() → 문자열값 연결

-- 2. 중복제거 COUNT(DISTINCT)
insert into student(id, name, gender, age)
values(11, '송지은', 'F', 22);

select gender, count(name) 
from student
group by gender;

select gender, count(distinct name) -- distinct : 중복제거
from student
group by gender;

-- 3. VARIANCE() 분산, STDDEV() 표준편차
-- 분산 : 데이터들이 평균에서 얼마나 떨어져 있는지 거리의 제곱을 계산한 값
-- 표준편차: 분산에 제곱근(√)을 씌운 값
select gender, avg(age), variance(age), stddev(age)
from student
group by gender;

-- 4. 응용
-- shakila로 이동

-- 1)영화에 출연한 배우 목록 
-- 영화 및 출연 배우목록
SELECT
    f.title,
    a.first_name
FROM film f JOIN film_actor fa
    ON f.film_id = fa.film_id
JOIN actor a
    ON fa.actor_id = a.actor_id
ORDER BY f.title;

-- 영화별 출연 배우 수 및 명단
SELECT
    f.title,
    count(*),
    group_concat(a.first_name order by a.first_name) 출연배우
FROM film f JOIN film_actor fa
    ON f.film_id = fa.film_id
JOIN actor a
    ON fa.actor_id = a.actor_id
group by f.title;

-- 영화별 출연 배우 목록
SELECT
    f.title,
    GROUP_CONCAT(
        CONCAT(a.first_name, ' ', a.last_name)
        ORDER BY a.last_name
        SEPARATOR ', '
    ) AS actors
FROM film f
INNER JOIN film_actor fa
    ON f.film_id = fa.film_id
INNER JOIN actor a
    ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

-- 카테고리별 영화 목록
SELECT
    c.name,
    GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name;

-- 카테고리별 영화 목록 및 갯수
SELECT
    c.name,
    COUNT(*) AS movie_count,
    GROUP_CONCAT(f.title ORDER BY f.title) AS movies
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name;

-- 영화가 60편 이상인 카테고리만 필터링해서 출력
SELECT
    c.name,
    COUNT(*) AS movie_count,
    GROUP_CONCAT(f.title ORDER BY f.title)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
HAVING COUNT(*) >= 60;

-- 2) 중복제거 COUNT(DISTINCT)
-- 장르별 전체 영화 수와, 그 장르 안의 시청등급 종류 개수 조회
SELECT
    c.name,
    COUNT(*) AS '총 영화갯수',
    COUNT(DISTINCT f.rating) AS 'rating_count 시청등급갯수'
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name;

-- 3) STDDEV() 표준편차, VARIANCE() 분산
-- 장르별 영화 러닝타임의 편차 확인
SELECT
    c.name,
    avg(f.length),
    VARIANCE(f.length) AS "분산(평균과의 거리에 제곱)",
    STDDEV(f.length) AS "표준편차(분산에 제곱근)"
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
GROUP BY c.name
order by STDDEV(f.length) asc;