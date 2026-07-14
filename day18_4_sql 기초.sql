-- 문자 -> 숫자
-- CAST() 함수 사용
SELECT CAST('100' AS float) AS result; -- 컬럼 없이  값이나 계산식을 SELECT로 조회시 FROM절 생략

-- 문자열끼리 더하기 자동 형변환(MySQL에선 +연산이 숫자 연산에만 사용된다)
SELECT '100' + '200' AS result;
SELECT '100' + 50;
SELECT '100원' + '$50' + 50; -- 100 + 0 + 50
SELECT 'xyz' + 50; -- 문자는 0으로 변환

-- 숫자 -> 문자
SELECT CAST(123 AS CHAR);

SELECT CONCAT(CAST(100 AS CHAR), '원'); -- concat : 문자열 병합

SELECT CONCAT(customer_id, '번') 번호, first_name -- AS CHAR 생략가능, 자동 형변환이 이루어짐
FROM customer;

-- 문자 -> 날짜
SELECT CAST('2026-07-13' AS DATE);
SELECT CAST('2026-07-13 09:30:00' AS DATETIME);

-- 날짜 -> 문자
SELECT CONCAT('현재 시간은 ', CAST(NOW() AS CHAR), ' 입니다.');

-- 숫자 -> 날짜
SELECT STR_TO_DATE('20260713', '%Y%m%d');
SELECT STR_TO_DATE('2026-07-13', '%Y-%m-%d');

-- 실수 <-> 정수
SELECT CAST(123.987 AS SIGNED);
SELECT CAST(100 AS DECIMAL(10,2));
SELECT 
	CAST(10/3 AS unsigned),
    CAST(10/3 AS DECIMAL),
    CAST(10/3 AS float), -- 6번째 정밀도
    CAST(10/3 AS double); -- 9번재 정밀도
    


