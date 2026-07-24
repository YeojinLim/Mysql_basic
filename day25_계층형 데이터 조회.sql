-- < Recursive CTE(WITH 테이블)를 사용한 계층형 데이터 조회 >

/* Recursive CTE 기본 문법

- WITH RECURSIVE는 자기 자신을 참조하는 CTE를 만든다.
- Anchor Query(시작 데이터)와 Recursive Query(반복 조회)를 UNION ALL로 연결한다.
- 재귀는 새로운 행이 더 이상 생성되지 않으면 자동 종료된다.
- 계층 구조뿐 아니라 숫자 생성, 날짜 생성, 누락 데이터 보완 등 다양한 반복 처리에도 활용할 수 있다.

WITH RECURSIVE CTE이름 AS
(
    -- 시작 데이터 (Anchor)
    UNION ALL
    -- 재귀 조회 (Recursive)
)
SELECT *
FROM CTE이름; 
*/

-- 1) 계층형 데이터 만들기 - DDL 
CREATE TABLE emp (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(30) NOT NULL,
    manager_id INT NULL,
    FOREIGN KEY (manager_id) REFERENCES emp(emp_id)
);

-- 2) 데이터를 계층적으로 입력
INSERT INTO emp VALUES
(1, 'CEO', NULL),

(2, '영업본부장', 1),
(3, '개발본부장', 1),
(4, '관리본부장', 1),

(5, '영업팀장', 2),
(6, '해외영업팀장', 2),

(7, '백엔드팀장', 3),
(8, '프론트팀장', 3),

(9, '인사팀장', 4),

(10, '신입사원A', 7),
(11, '신입사원B', 8);

-- 3) CEO부터 모든 직원 조회
WITH RECURSIVE emp_tree AS
(
    -- 시작점
    SELECT
        emp_id,
        emp_name,
        manager_id,
        1 AS level -- 시작 행(ROOT)의 레벨값은 1
    FROM emp
    WHERE manager_id IS NULL -- 시작 행(ROOT)의 조건

    UNION ALL

    -- 하위 직원 계속 찾기, 끝날때 까지 재귀(자기 자신을 이용해서 같은 작업을 반복) 호출
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        t.level + 1
    FROM emp e INNER JOIN emp_tree t
         ON e.manager_id = t.emp_id
)

SELECT *
FROM emp_tree;

-- 4) 조직도 형태로 조회
WITH RECURSIVE emp_tree AS
(
    SELECT
        emp_id,
        emp_name,
        manager_id,
        1 level
    FROM emp
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        t.level + 1
    FROM emp e
    JOIN emp_tree t
      ON e.manager_id=t.emp_id
)

SELECT
    CONCAT(REPEAT('    ', level-1), emp_name) AS organization
FROM emp_tree;

-- 5) 전체 계층 경로(Path)를 같이 조회
WITH RECURSIVE emp_tree AS
(
    SELECT
        emp_id,
        emp_name,
        manager_id,
        emp_name AS path
    FROM emp
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        CONCAT(t.path,' > ',e.emp_name)
    FROM emp e
    JOIN emp_tree t
      ON e.manager_id=t.emp_id
)

SELECT *
FROM emp_tree;

-- 6) 특정 직원의 모든 부하직원 조회
WITH RECURSIVE emp_tree AS
(
    SELECT *
    FROM emp
    WHERE emp_name='개발본부장'

    UNION ALL

    SELECT e.*
    FROM emp e
    JOIN emp_tree t
      ON e.manager_id=t.emp_id
)

SELECT *
FROM emp_tree;

-- 7) 1~10까지 숫자 생성
WITH RECURSIVE numbers AS
(
    SELECT 1 AS num

    UNION ALL

    SELECT num+1
    FROM numbers
    WHERE num<10
)

SELECT *
FROM numbers;

-- 8) 날짜 생성
WITH RECURSIVE dates AS
(
    SELECT DATE('2026-07-01') dt

    UNION ALL

    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM dates
    WHERE dt<'2026-07-10'
)

SELECT *
FROM dates;

--  추가문제) 토/일 공휴일 제외한 26년 10월 달력 조회
with recursive m10 as(
	select date('2026-10-01') October
    union all
    select date_add(October, interval 1 day)
    from m10
    where October < '2026-10-31'
),
-- 공휴일
holiday as(
	select date('2026-10-05') October, '개천절 대체공휴일' title
    union all
    select date('2026-10-09') October, '한글날' title
),
-- 근무 일자
work_m10 as(
select October, 
	   case weekday(October) 
			when 0 then '월'
            when 1 then '화'
            when 2 then '수'
            when 3 then '목'
            when 4 then '금'
		end 요일
from m10
where weekday(October) < 5

except

select October, 
	   case weekday(October) 
			when 0 then '월'
            when 1 then '화'
            when 2 then '수'
            when 3 then '목'
            when 4 then '금'
		end 요일
from holiday
)

select *, 
	   concat(count(*) over(),'일') 10월_총_근무일
from work_m10;