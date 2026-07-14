-- 1. ORDER BY절

SELECT *
FROM customer
ORDER BY customer_id;

SELECT *
FROM customer
ORDER BY customer_id ASC;

SELECT *
FROM customer
ORDER BY customer_id DESC;

SELECT *
FROM customer
ORDER BY first_name;

SELECT *
FROM customer
ORDER BY last_name, first_name;

SELECT *
FROM customer
ORDER BY store_id ASC, customer_id DESC;

-- 최근 등록된 고객 순으로
SELECT *
FROM customer
ORDER BY create_date DESC;

-- 2. LIMIT : 상위 N개의 데이터만 조회, OFFSET 특정 구간의 상위 N개 조회

SELECT *
FROM customer
LIMIT 5;

SELECT *
FROM customer
LIMIT 10;

-- LIMIT절은 항상 ORDER BY절과 함꼐 사용하는 것이 좋다
SELECT *
FROM customer
ORDER BY create_date DESC 
LIMIT 10; -- 제일 마지막에 실행

SELECT *
FROM customer
ORDER BY customer_id
LIMIT 10, 5; -- 0~9행 10개 건너뛰고 5개 출력

-- 같은 표현(OFFSET 키워드 사용)
SELECT *
FROM customer
ORDER BY customer_id
LIMIT 5 OFFSET 10;

SELECT *
FROM customer
WHERE active = 1
ORDER BY customer_id
LIMIT 10;

SELECT *
FROM customer
WHERE first_name LIKE 'A%'
ORDER BY first_name
LIMIT 3;

-- ※ 페이징(Pagination) 예제

-- 1페이지
SELECT *
FROM customer
ORDER BY customer_id
LIMIT 10 OFFSET 0; -- 페이지 사이즈가 10이라면 OFFSET 숫자 패턴은 "(현재페이지 - 1) * 페이지사이즈" / (1-1) * 10 = 0 (0~10번째 데이터)

-- 2페이지
SELECT *
FROM customer
ORDER BY customer_id
LIMIT 10 OFFSET 10; -- (2-1) * 10 = 10 (11~20번째 데이터)

-- 3페이지
SELECT *
FROM customer
ORDER BY customer_id
LIMIT 10 OFFSET 20; -- (3-1) * 10 = 20 (21~30번째 데이터)