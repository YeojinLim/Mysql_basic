-- 1. 별칭 : AS는 컬럼이나 테이블에 별칭(Alias, 별명)을 지정하는 키워드이다.
-- 컬럼명 별칭

SELECT
    first_name AS 이름,
    last_name AS 성
FROM customer;

-- AS는 생략 가능
SELECT
    first_name 이름
FROM customer;

-- 테이블 별칭
SELECT
    c.customer_id,
    c.first_name
FROM customer AS c; -- AS생략가능 FROM customer c

select
	first_name, now() as 오늘, 10+7 as 계산결과,
    customer_id%2 as "짝수 홀수", '미국' as 국적
from customer
order by customer_id
limit 10