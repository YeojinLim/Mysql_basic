-- 단일행 함수(Single Row Function)는 한 행의 데이터를 입력받아 한 행의 결과를 반환하는 함수이다.
-- 예를 들어 고객이 599명이면 함수도 599번 실행되어 599개의 결과를 반환한다.

-- 1. 문자 단일행 함수
SELECT
    first_name,
    UPPER(first_name) AS upper_name
FROM customer;

SELECT
    first_name,
    LOWER(first_name) AS lower_name
FROM customer;

SELECT
    first_name,
    LENGTH(first_name) AS length
FROM customer;

SELECT
    email,
    REPLACE(email, '.org', '.com') AS new_email
FROM customer;

SELECT
    first_name,
    LEFT(first_name, 3) AS first3
FROM customer;

SELECT
    last_name,
    RIGHT(last_name, 3) AS last3
FROM customer;

SELECT
    first_name,
    SUBSTRING(first_name, 2, 3) AS sub_name
FROM customer;

-- 고객 이름과 성을 합치고 이름 길이를 함께 출력
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    LENGTH(first_name) AS name_length
FROM customer;

-- 2. 숫자 단일행 함수
-- mod(a,b) : a를 b로 나눴을때의 나머지
SELECT
    customer_id,
    MOD(customer_id, 10) AS remainder 
FROM customer;

-- floor() : 내림, 소수점 버림
SELECT
    customer_id,
    FLOOR(RAND() * 100) + 1 AS coupon_number -- rand() : 0이상 1미만 사이의 랜덤 숫자 / *100 : 0부터 99.9999... 까지의 랜덤숫자 / +1 : 1~100 까지의 랜덤숫자
FROM customer
LIMIT 10;

-- ROUND(a, b) : a를 반올림하여 소수점 b자리까지 남김 
SELECT
    payment_id,
    amount,
    ROUND(amount, 1) AS round_amount 
FROM payment;

SELECT
    payment_id,
    amount,
    TRUNCATE(amount, 1) AS truncate_amount
FROM payment;

-- CEIT : 올림
SELECT
    payment_id,
    amount,
    CEIL(amount) AS ceil_amount
FROM payment;

-- 10% 할인된 금액 구하기. 반올림 소수점 2까지
SELECT
    payment_id,
    amount,
    ROUND(amount * 0.9, 2) AS discount_price
FROM payment
LIMIT 10;

SELECT
    payment_id,
    amount,
    amount * 0.1 AS discount,
    round(amount-(amount * 0.1), 2) AS discount_price
FROM payment
LIMIT 10;

-- 3. 날짜 단일행 함수
SELECT
    NOW(),
    CURDATE(),
    CURTIME(),
    YEAR(NOW()),
    MONTH(NOW()),
    DAY(NOW());

SELECT
    first_name,
    YEAR(create_date) AS join_year,
    YEAR(curdate()) - YEAR(create_date) "가입 후 몇년",
    datediff(curdate(), create_date) "가입 후 며칠"
FROM customer;

SELECT
    first_name,
    create_date,
    DATE_ADD(create_date, INTERVAL 30 DAY) AS after30
FROM customer;

-- 가입 후 며칠이 지났는지
SELECT
    first_name,
    DATEDIFF(CURDATE(), create_date) AS days_after_join
FROM customer;

-- 날짜 형식 변경
SELECT
    first_name,
    DATE_FORMAT(create_date, '%Y년 %m월 %d일') AS join_date
FROM customer;

-- 현재 날짜/시간 관련 함수

SELECT
    NOW() AS current_datetime,
    CURDATE() AS current_date,
    CURTIME() AS current_time;
    
-- 4. where절에서 단일행 함수 - 함수의 반환값을 조건값으로 비교
-- 이름이 'A'로 시작하는 고객
SELECT *
FROM customer
WHERE LEFT(first_name, 1) = 'A';

-- 이름 길이가 5
SELECT *
FROM customer
WHERE LENGTH(first_name) = 5;

-- 대소문자 구분 없이 조회 : 대문자로 변경한 후 대문자로 조회 or 소문자로 변경 후 소문자로 조회
SELECT *
FROM customer
WHERE UPPER(first_name) = 'MARY';

-- .org로 끝나는
SELECT *
FROM customer
WHERE RIGHT(email, 4) = '.org';

SELECT *
FROM payment
WHERE MOD(payment_id, 2) = 0;

-- 반올림 후 결제금액이 5달러
SELECT *
FROM payment
WHERE ROUND(amount) = 5;

-- 2005년에 가입
SELECT *
FROM customer
WHERE YEAR(create_date) = 2005;

-- 2월에 가입
SELECT *
FROM customer
WHERE MONTH(create_date) = 2;

-- 올해 가입한
SELECT * 
FROM customer
WHERE YEAR(create_date) = YEAR(NOW())

SELECT
	first_name,
    LENGTH(first_name) AS name_length
FROM customer
WHERE LENGTH(first_name) >= 6;

-- ※ where 절에 자주사용되는 컬럼은 인덱스(키)를 지정하는게 보통인데, 아래의 경우 create_date 컬럼이 인덱스라면, 인덱스 컬럼에 함수를 사용한 YEAR(create_date)의 결과는 인덱스를 사용하지 못한다.
-- 따라서 인덱스가 있는 컬럼은 가능하면 함수 대신 범위 조건으로 검색하는 것이 성능에 유리하다. 다만 인덱스가 없는 컬럼이라면 함수 사용 여부에 따른 성능 차이는 거의 없다.

SELECT *
FROM customer
WHERE YEAR(create_date) = 2005;

-- 다음처럼 create_date 컬럼의 인덱스를 사용하는 범위 조건으로 작성하는 것이 성능상 더 유리하다.
SELECT *
FROM customer
WHERE create_date >= '2005-01-01'
AND create_date < '2006-01-01';

-- ORDER BY절에서 함수 사용
select * from customer
order by length(first_name) desc, length(last_name) desc;

-- first_name + last_name 출력, email은 왼쪽에서 4자리 + **** 소문자로 출력, 정렬 first_name + last_name의 오름차순
select
	concat(first_name, ' ', last_name) full_name,
    lower(concat(left(email,4), '****')) email 
from customer
order by full_name;


