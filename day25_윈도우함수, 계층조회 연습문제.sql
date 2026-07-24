-- 문제 1. 고객별 최근 3번 결제금액 합계
-- 고객별(customer_id)로 결제일(payment_date) 순서대로 정렬하여 현재 결제를 포함한 최근 3번의 결제금액 합계를 조회하시오.

select customer_id,
	   payment_date,
       amount,
       sum(amount) over(
			partition by customer_id
            order by payment_date
            rows between 2 preceding and current row) as sum
from payment;

-- 문제 2. 영화 길이의 누적 평균
-- 카테고리별(category)로 영화 길이(length)를 짧은 순으로 정렬하여 현재 영화까지의 평균 상영시간을 조회하시오.
select c.name, f.title, f.length,
	   avg(f.length) over(
			partition by c.category_id
            order by f.length asc
            rows between unbounded preceding and current row) as 누적평균
from category c inner join film_category fc
	on c.category_id = fc.category_id
    inner join film f
		on fc.film_id = f.film_id;

-- 문제 3. 직원별 최근 5일 평균 매출
-- 직원별 하루 매출을 먼저 집계한 후, 직원별(staff_id) 날짜순으로 최근 5일의 평균 매출을 조회하시오.
with t1 as(
	select p.staff_id, date(p.payment_date) as pay_date, sum(p.amount) daily_amount
	from payment p
	group by p.staff_id, date(p.payment_date)
)

select staff_id, pay_date as 날짜, daily_amount as 하루_매출,
	   -- 하루총매출액 평균, 스탭아이디, 날짜오름차순, 최근 5일
       avg(daily_amount) over(
			partition by staff_id
            order by pay_date
            rows between 4 preceding and current row) as 최근_5일_평균_매출
from t1
order by staff_id, pay_date;

-- 5일 평균이 가장 큰값
with t1 as(
	select p.staff_id, date(p.payment_date) as pay_date, sum(p.amount) daily_amount
	from payment p
	group by p.staff_id, date(p.payment_date)
),
t2 as(
	select staff_id, pay_date as 날짜, daily_amount as 하루_매출,
	   -- 하루총매출액 평균, 스탭아이디, 날짜오름차순, 최근 5일
       avg(daily_amount) over(
			partition by staff_id
            order by pay_date
            rows between 4 preceding and current row) as 최근_5일_평균_매출
	from t1
)
select *
from(
	select*,
	row_number() over(
		partition by staff_id
		order by 최근_5일_평균_매출 desc) rn
	from t2) as t3
where t3.rn = 1;

-- 문제 4. 고객별 누적 대여 횟수
-- 고객별(customer_id)로 대여일(rental_date) 순으로 정렬하여 현재 대여까지의 누적 대여 횟수를 조회하시오.
SELECT 
    customer_id,
    rental_date,
    -- 고객별, 날짜순 정렬 후 첫 행부터 현재 행까지 누적 개수
    COUNT(*) OVER(
        PARTITION BY customer_id
        ORDER BY rental_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_rental_count
FROM rental
ORDER BY customer_id, rental_date;

-- 문제 5. 카테고리별 최근 3편 영화의 평균 길이
-- 카테고리별로 영화 길이를 긴 순으로 정렬하여 현재 영화를 포함한 최근 3편의 평균 상영시간을 조회하시오
SELECT 
    c.name AS category_name,
    f.title,
    f.length,
    -- 카테고리별, 상영시간 긴 순(DESC) 정렬 후 이전 2편 + 현재 1편 평균
    AVG(f.length) OVER(
        PARTITION BY c.category_id
        ORDER BY f.length DESC
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS recent_3_avg_length

FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c       ON fc.category_id = c.category_id
ORDER BY category_name, f.length DESC;
