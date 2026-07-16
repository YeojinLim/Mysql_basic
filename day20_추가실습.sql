--  SQL 실습 
-- 2026년 7월 출결정보 조회 
SELECT *
FROM student s
INNER JOIN attendance a
ON s.id = a.id
WHERE a.attend_date BETWEEN '2026-07-01' AND '2026-07-31';

-- 1) INNER JOIN으로 학생 이름과 출석 조회
SELECT s.name, a.attend_date, a.enter_time, a.leave_time
FROM student s
INNER JOIN attendance a ON s.id = a.id
ORDER BY a.attend_date DESC, s.name ASC;

-- 2) 월별 출석 현황 조회 
SELECT 
    DATE_FORMAT(a.attend_date, '%Y-%m') AS 연월,
    COUNT(*) AS total_attend
FROM attendance a
GROUP BY DATE_FORMAT(a.attend_date, '%Y-%m')
ORDER BY 연월 DESC;

-- 3) 지각 횟수 집계 (enter_time > '09:30:00') 
SELECT 
    s.name,
    COUNT(*) AS 지각횟수
FROM student s
INNER JOIN attendance a ON s.id = a.id
WHERE a.enter_time > '09:30:00'
GROUP BY s.id, s.name;

-- 4) 조퇴 횟수 집계 (leave_time < '18:00:00') 
SELECT 
    s.name,
    COUNT(*) AS 조퇴횟수
FROM student s
INNER JOIN attendance a ON s.id = a.id
WHERE a.leave_time < '18:00:00' 
  AND a.leave_time IS NOT NULL  -- 퇴실 처리가 완료된 데이터 중에서만 비교
GROUP BY s.id, s.name;

-- 5) CASE를 이용한 출석 상태(정상/지각/조퇴/지각+조퇴) 출력
SELECT s.name, a.attend_date, a.enter_time, a.leave_time,
    CASE 
        -- 1. 아직 퇴실 안 한 경우 처리
        WHEN a.leave_time IS NULL THEN '퇴실미처리'
        
        -- 2. 지각이면서 동시에 조퇴인 경우 (9:30 넘고, 18:00 이전 퇴실)
        WHEN a.enter_time > '09:30:00' AND a.leave_time < '18:00:00' THEN '지각+조퇴'
        
        -- 3. 지각만 한 경우
        WHEN a.enter_time > '09:30:00' THEN '지각'
        
        -- 4. 조퇴만 한 경우
        WHEN a.leave_time < '18:00:00' THEN '조퇴'
        
        -- 5. 모두 해당 없는 정상 출석
        ELSE '정상'
    END AS 출석상태
FROM student s
INNER JOIN attendance a ON s.id = a.id
ORDER BY a.attend_date DESC, s.name ASC;

-- 6) 주소지별 지각/조퇴 조회
SELECT 
    s.address,
    SUM(CASE WHEN a.enter_time > '09:30:00' THEN 1 ELSE 0 END) AS 지각_총합,
    SUM(CASE WHEN a.leave_time < '18:00:00' AND a.leave_time IS NOT NULL THEN 1 ELSE 0 END) AS 조퇴_총합
FROM student s
INNER JOIN attendance a ON s.id = a.id
GROUP BY s.address;

-- 7) 결석 조회
SELECT s.id, s.name, if(a.attend_date is null, '결석', '출석') as 출석_여부
FROM student s
-- 학생 테이블을 기준으로 두고 출석부(오늘 날짜만)를 왼쪽에 정렬
LEFT JOIN attendance a 
    ON s.id = a.id 
   AND a.attend_date = '2026-01-12';
