-- select, 단일행함수 연습문제
-- - 결과행이 10행 이상이면  Top10까지만 조회

/* ​1. film 테이블 - WHERE + LIKE + ORDER BY
영화 제목(title)이 'A'로 시작하는 영화를 조회하시오.
영화 제목과 상영시간(length)을 출력하고, 상영시간이 긴 순으로 정렬하시오. */
select title, length
from film
where title like 'A%'
order by length desc
limit 10;

/* 2. film 테이블 - 영화 러닝타임(숫자 함수)
영화 제목(title)과 상영시간(length)을 조회하고, 상영시간을 시간(hour) 단위로 반올림하여(ROUND(length / 60, 1)) 함께 출력하시오.*/
select title, length, round(length/60, 1) as hours
from film
limit 10;

/* 3. actor 테이블 - 문자열 함수
배우의 이름과 성을 하나의 문자열로 합쳐(CONCAT) 배우 이름(full_name) 으로 출력하시오. */
select concat(first_name, ' ', last_name) as full_name
from actor
limit 10;

/* 4. actor 테이블 - WHERE + LIKE + ORDER BY
이름(first_name)이 'A'로 시작하는 배우를 조회하시오.
이름과 성을 출력하고 성(last_name) 오름차순으로 정렬하시오. */
select first_name, last_name
from actor
where first_name like 'A%'
order by last_name asc
limit 10;

/* 5. country 테이블 - WHERE + LIKE + ORDER BY
국가명(country)에 'an' 이 포함된 국가를 조회하시오.
국가명을 출력하고 국가명 오름차순으로 정렬하시오. */
select country
from country
where country like '%an%'
order by country asc
limit 10;

/* 6. country 테이블 - 단일행 함수
국가명(country)과 국가명의 글자 수(LENGTH) 를 함께 출력하시오. */
select country, length(country)
from country
limit 10;

/* 7. customer 테이블 - WHERE + LIKE + ORDER BY
이름(first_name)이 'M'으로 시작하는 고객을 조회하시오.
이름, 성, 이메일을 출력하고 이름 오름차순으로 정렬하시오. */
select first_name, last_name, email
from customer
where first_name like 'M%'
order by first_name asc
limit 10;

/* 8. customer 테이블 - 단일행 함수
고객의 이름과 성을 연결하여(CONCAT) 전체 이름(full_name) 을 출력하고, 가입일(create_date)은 YYYY-MM-DD 형식(DATE_FORMAT) 으로 출력하시오. */
select
	concat(first_name, ' ', last_name) as full_name,
	DATE_FORMAT(create_date, '%Y-%m-%d') as join_date
from customer
limit 10;

/* 9. category 테이블 - WHERE + LIKE + ORDER BY
카테고리명(name)이 'C'로 시작하는 카테고리를 조회하시오.
카테고리명을 출력하고 이름 오름차순으로 정렬하시오. */
select name
from category
where name like 'C%'
order by name asc;

/* 10. city 테이블 - 단일행 함수
도시명(city)과 도시명의 글자 수(LENGTH) 를 함께 출력하시오. */
select city, length(city)
from city
limit 10;

/* 11. sakila film 테이블
영화 제목과 상영시간을 조회하고, 상영시간이 120분 이상이면 "장편", 아니면 "일반"을 출력하시오. */
select
	title,
	length,
    if(length >= 120, '장편', '일반') as length_type
from film
limit 10;

/* 12.영화 제목과 대여요금을 조회하고,
0.99 → "저가"
2.99 → "중가"
4.99 → "고가" 로 출력하시오. */
select title, rental_rate,
	case 
		when rental_rate = 0.99 then '저가'
        when rental_rate = 2.99 then '중가'
        when rental_rate = 4.99 then '고가'
		else '기타'
	end as price_level
from film
limit 10;

/* 13. 영화 제목과 등급(rating)을 조회하고,
G → "전체관람가"
PG → "부모지도"
PG-13 → "13세 이상"
R → "청소년 제한"
NC-17 → "17세 이상" 으로 출력하시오.*/
select title, rating,
	case rating
        WHEN 'G' THEN '전체관람가'
        WHEN 'PG' THEN '부모지도'
        WHEN 'PG-13' THEN '13세 이상'
        WHEN 'R' THEN '청소년 제한'
        WHEN 'NC-17' THEN '17세 이상'
        ELSE '기타'
	end as rating_level
from film
limit 10;

/* 14. original_language_id가 NULL이면 0으로 출력하고, NULL이 아니면 원래 값을 출력하시오.*/
select title, ifnull(original_language_id, 0)
from film
limit 10;

/* 15. 영화 제목과 대여기간을 조회하고,
7일 이상 → "매우 김"
5~6일 → "보통"
4일 이하 → "짧음" 으로 출력하시오.*/
select title, rental_duration,
	case
		when rental_duration >=7 then '매우 김'
        when rental_duration >=5 then '보통'
        else '짧음'
	end as duration_type
from film
limit 10;

/* 16. 120분 이상인 영화는 먼저 출력하고, 나머지는 뒤에 출력하시오.*/
select title, length
from film
order by case when length >= 120 then 1 else 2 end
limit 10;

/* 17. (ORDER BY절에 CASE) rating이 G인 영화는 제목순, 나머지는 상영시간 내림차순으로 조회하시오.*/
select title, rating, length
from film
order by
	case when rating = 'G' then title end asc,
	case when rating != 'G' then length end desc
limit 10;

/* 18. (IFNULL()함수) original_language_id가 NULL인 영화만 조회하시오.*/
SELECT title, original_language_id
FROM film
WHERE original_language_id IS NULL
limit 10;

/* 19. (NULLIF()함수) rental_rate가 4.99인 영화만 조회하시오.*/
SELECT title, rental_rate
FROM film
WHERE NULLIF(rental_rate, 4.99) IS NULL
LIMIT 10;

/* 20. G 등급은 90분 이상, 나머지는 120분 이상인 영화만 조회하시오.*/
-- 1) IF() 사용
SELECT title, rating, length
FROM film
WHERE length >= IF(rating = 'G', 90, 120)
LIMIT 10;

-- 2) CASE 사용
SELECT title, rating, length
FROM film
WHERE length >= CASE 
                    WHEN rating = 'G' THEN 90 
                    ELSE 120 
                END
LIMIT 10;