-- < 윈도우범위(ROWS/RANGE)를 사용하는 윈도우 함수 > 
-- 1. ROWS/RANGE의 차이
-- ROWS (행/줄 기준) : 같은 값을 무시하고 한줄씩 계산
SELECT
    title,
    length,
    -- 첫 행부터 현재 줄까지 누적 합계 계산
    SUM(length) OVER(
        ORDER BY length DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS 'row 누적합'
FROM film;

-- 2. RANGE (값 범위 기준) : 같은 값을 가진 데이터들 모두 한 묶음으로 모아서 계산"
SELECT
    title,
    length,
    -- 맨 첫 행부터 '현재 행의 값과 같은 동점자 행들'까지 묶어서 한 번에 누적 계산, 실무에선 잘 사용하지 않는다.
    SUM(length) OVER(
        ORDER BY length DESC 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS range_cumulative_length
FROM film;

-- 2. 윈도우 범위
-- 함수() over() : 데이터 전체를 처음부터 끝까지 함수() 계산
-- 함수() over(partition by A) : A 기준으로 그룹을 나누 뒤 그 그룹의 처음부터 끝까지 함수() 계산
-- 함수() over(order by A) : 데이터 전체를 A순으로 정렬한 뒤, 처음부터 현재행까지 누적 계산
-- 함수() over(partition by A order by B) : A 기준으로 그룹을 나눈 후, B순으로 정렬한 뒤, 처음부터 현재행까지 누적 계산
-- → 직접 ROWS / RANGE를 안 적어도 ORDER BY를 넣는 순간 DB가 자동으로 "처음부터 현재 행까지 누적"으로 범위를 바꾼다

-- 순위함수
select
	title,
    rank() over(order by length desc
				range between unbounded preceding and current row) as length_rank
from film;

select
	title,
    rank() over(order by length desc) as length_rank
from film;
-- 순위함수에서는 RANGE 옵션을 붙여도 무시되고 순수하게 "전체 정렬 순위"만 계산되기 때문에 동일 결과값 출력

-- 집계함수
select
	title,
    length,
    -- 1. RANGE (값 범위): 동점자 묶어서 누적
    sum(length) over(order by length desc
				range between unbounded preceding and current row) 값범위누적,
	-- 2. ROWS (행 범위): 한 줄씩 누적
    sum(length) over(order by length desc
				rows between unbounded preceding and current row) 행범위누적,
	-- 3. UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING: 전체 범위 누적
	sum(length) over(order by length desc
				rows between unbounded preceding and unbounded following) 전체합   
from film;

-- unbounded preceding ~ currunt row : 처음부터 현재까지
-- n prededing ~ currunt row : 이전 n행부터 현재까지
-- n prededing ~ n following : 이전 n행부터 다음 n행까지
-- currunt row ~ unbounded following : 현재부터 마지막까지

-- 3. 예제 
-- 1) 상영시간의 누적합 : 상영시간이 짧은 영화부터 현재 영화까지의 상영시간 합계를 구한다.
SELECT
    title,
    length,
    SUM(length) OVER(
        ORDER BY length
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_length
FROM film;

-- 2) 최근 3개 영화의 평균 상영시간 : 이전 2행 + 현재 (최근 3건 평균)
SELECT
    title,
    length,
    AVG(length) OVER(
        ORDER BY length
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS avg_length
FROM film;

-- 3) 최근 3개 영화의 평균 상영시간 : 이전 1행 + 현재 + 다음 1행
SELECT
    title,
    length,
    AVG(length) OVER(
        ORDER BY length
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS neighbor_avg
FROM film;

-- 4) 현재부터 마지막까지 (남은 데이터 누계)
SELECT
    title,
    length,
    SUM(length) OVER(
        ORDER BY length
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS remaining_length
FROM film;

-- 5) PARTITION BY + ORDER BY + ROWS를 모두 사용
-- 직원(staff)별 일자별 매출
select
	p.staff_id,
    date(p.payment_date) as pay_date,
    sum(p.amount) as daily_amount
from payment p
group by 
	p.staff_id,
    date(p.payment_date); 
    
-- 최근 7일간(일주일)의 누적 매출을 계산
select
	staff_id,
    pay_date,
    daily_amount,
    sum(daily_amount) over(
		partition by staff_id -- 직원별로 데이터를 나눔
        order by pay_date -- 날짜순 정렬
        rows between 6 preceding and current row -- 최근 7행(오늘 포함 7일치 행) 누적합
	) as rolling_7days
from(
	select
		p.staff_id,
		date(p.payment_date) as pay_date,
		sum(p.amount) as daily_amount
	from payment p
	group by 
		p.staff_id,
		date(p.payment_date)
) t
order by rolling_7days desc; -- 누적매출 높은순 정렬

-- with문 사용
with ds as
(
	select
		p.staff_id,
		date(p.payment_date) as pay_date,
		sum(p.amount) as daily_amount
	from payment p
	group by 
		p.staff_id,
		date(p.payment_date)
)

select staff_id, pay_date, daily_amount,
	   -- 이전 6일 + 현재일 = 7일의 매출합계
       sum(daily_amount) over(partition by staff_id order by pay_date
							 rows between 6 preceding and current row) 7days_sum
from ds
-- order by staff_id, pay_date; -- 날짜순 정렬
order by 7days_sum desc; -- 누적합 높은순 정렬

-- 4. 과제 : 스태프별 영업일 기준 7일간 매출이 가장높은 기간과 매출액 구하기
with daily_sales as
(
	select
		p.staff_id,
		date(p.payment_date) as pay_date,
		sum(p.amount) as daily_amount
	from payment p
	group by 
		p.staff_id,
		date(p.payment_date)
),
rolling_sales as -- 7일치 누적합을 구하는 쿼리도 with문으로 만들어준다.
(
	select staff_id, 
		   pay_date, 
           daily_amount,
		   sum(daily_amount) over(partition by staff_id order by pay_date
								 rows between 6 preceding and current row) rolling_7days
	from daily_sales
), 
ranked as
(
	select *, 
		   row_number() over(partition by staff_id order by rolling_7days desc) rn
	from rolling_sales
)

select staff_id, 
	   date_sub(pay_date, interval 6 day) as start_date, 
       pay_date as end_date,
       concat(date_sub(pay_date, interval 6 day), ' ~ ', pay_date) as week_period,
       rolling_7days
from ranked
where rn = 1;
