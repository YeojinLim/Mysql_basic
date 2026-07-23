-- < 윈도우 함수(분석함수) >
-- from절의 결과셋을 유지하면서 새로운 계산셋 그룹을 만들어 집계나 순위 계산을 수행 후 from절의 결과셋에 추가하는 함수이다.
/*
SELECT 
    컬럼명,
    윈도우_함수() OVER (
        PARTITION BY 그룹화할_컬럼
        ORDER BY 정렬할_컬럼
        ROWS/RANGE 범위_지정
    ) AS 별칭
FROM 테이블명;
*/

-- 1. GROUP BY(집계함수) 와의 차이 
-- GROUP BY(집계함수)는 집계 결과만 출력 가능하지만, 윈도우 함수는 원본 + 집계 결과 함께 출력 가능.

-- group by 사용
SELECT f.title, f.rating, f.length, t.avg_length
FROM film f INNER JOIN (SELECT rating,
					AVG(length) AS avg_length
					FROM film
					GROUP BY rating) t
ON f.rating = t.rating
ORDER BY f.rating;

-- window 함수 사용
SELECT title,
       rating,
       length,
       AVG(length) OVER(PARTITION BY rating) AS avg_length
FROM film;

-- 윈도우 함수를 사용하면 같은 결과를 더 간단한 쿼리로 처리 가능하다.

-- 2. 순위 함수
-- 1) ROW_NUMBER() : 중복 상관없이 무조건 각 행에 1,2,3,.. 연속된 번호 부여
SELECT
    title,
    ROW_NUMBER() OVER(ORDER BY length DESC)
FROM film;

-- 2) RANK() : 동점이면 같은 순위를 주고, 다음 순위는 건너뜀 (예: 1등, 2등, 2등, 4등)
SELECT
    title,
    length,
    RANK() OVER(ORDER BY length DESC)
FROM film;

-- 3) DENSE_RANK() : 동점이면 같은 순위를 주고, 다음 순위를 이어감 (예: 1등, 2등, 2등, 3등)
SELECT
    title,
    length,
    DENSE_RANK() OVER(ORDER BY length DESC)
FROM film;

-- 3. 그룹화 함수
-- 1) NTILE() 그룹 나누기 : 전체 데이터를 지정한 숫자 n개의 그룹으로 나눈다.
SELECT
    title,
    length,
    NTILE(4) OVER(ORDER BY length)
FROM film;

-- 4. 참조 함수
-- 1) LAG() 이전 행 : 현재 행을 기준으로 이전 행의 값을 참조한다.
SELECT
    title,
    length,
    LAG(length) OVER(ORDER BY film_id)
FROM film;

-- 2) LEAD() 다음 행 : 현재 행을 기준으로 다음 행의 값을 참조한다.
SELECT
    title,
    length,
    LEAD(length) OVER(ORDER BY film_id)
FROM film;

-- 5. 비율 및 누적 분포 함수
-- 1) CUME_DIST() 누적 분포 : 데이터가 전체에서 어느 정도 위치에 있는지 누적 비율을 반환
-- 결과는 0초과 1이하의 값
SELECT
    title,
    length,
    CUME_DIST() OVER(ORDER BY length)
FROM film;
-- 예) 0.005 : 이 영화보다 길이가 짧거나 같은 영화는 전체의 0.5%에 해당한다

-- 2) PERCENT_RANK() 백분위 순위 : 현재 행의 상대적 백분위 순위를 반환
-- 결과는 0이상 1이하의 값
SELECT
    title,
    length,
    PERCENT_RANK() OVER(ORDER BY length)
FROM film;
-- 예) 0.005 : 이 영화는 전체에서 상위 0.5%에 있다.(가장짧은 쪽에서)

-- CUME_DIST() : 나 이하의 데이터들이 전체에서 몇 % 지분을 차지하는지
-- PERCENT_RANK() : 0%부터 100%까지 상대적인 트랙을 깔아두고, 내가 그 선상에서 몇 % 위치인지

-- 6. 집계 윈도우 함수
-- 행은 그대로 유지하면서 집계 결과를 함께 표시한다.
SELECT
	title, 
    rating,
	COUNT(length) OVER(PARTITION BY rating), 
	SUM(length) OVER(PARTITION BY rating), 
	AVG(length) OVER(PARTITION BY rating), 
	MIN(length) OVER(PARTITION BY rating), 
	MAX(length) OVER(PARTITION BY rating)
FROM film;