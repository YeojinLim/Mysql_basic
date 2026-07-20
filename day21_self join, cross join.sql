-- 1. SELF JOIN
-- 샘플 데이터 생성
CREATE TABLE employee (
    emp_id INT PRIMARY KEY, -- 직원번호(PK)
    emp_name VARCHAR(30), -- 직원명 
    manager_id INT -- 관리자 직원번호(FK)
);

-- 데이터 입력
INSERT INTO employee VALUES
(1, '김부장', NULL),
(2, '이과장', 1),
(3, '박대리', 2),
(4, '최사원', 2),
(5, '정사원', 3),
(6, '한인턴', 4);

select * from employee;

-- SELF LEFT JOIN
select 
	e1.emp_id, e1.emp_name, 
    ifnull(e2.emp_name, '없음') "관리자"
from employee e1 left join employee e2
on e1.manager_id = e2.emp_id;


-- 2. CROSS JOIN
-- 학생 테이블 생성
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(30)
);

-- 과목 테이블 생성
CREATE TABLE subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(30)
);

-- 학생 데이터 입력
INSERT INTO student VALUES
(1, '홍길동'),
(2, '김철수'),
(3, '이영희');

-- 과목 데이터 입력
INSERT INTO subject VALUES
(101, 'SQL'),
(102, 'Python'),
(103, 'Power BI');

select * from student;
select * from subject;

-- 과목당 성적표를 우편으로 배송한다고 할때, 과목당 출석부는 몇개 전송해야하는가?
-- 경우의 수 n개, m개 → n * m
select *
from student cross join subject;

-- self cross join
select *
from student s1 cross join student s2
where s1.student_name <> s2.student_name;


-- <join 의 종류>
-- 1) inner join : 양쪽 테이블 모두에 공통으로 존재하는(조건이 일치하는) 데이터만 가져온다.
-- 2) outer join : 한쪽 또는 양쪽 테이블의 모든 데이터를 유지하면서, 매칭되는 상대 테이블의 데이터를 붙입니다. 조건에 일치하지 않는 부분은 NULL로 채운다.
-- 				(left : 기준이 왼쪽 테이블, right: 기준이 오른쪽 테이블, full: 양쪽 테이블의 모든 데이터를 합침)
-- 3) cross join : 두 테이블의 가능한 모든 조합 만들어냄
-- 4) self join : 자기 자신(한 테이블)과 자기 자신을 조인한다. 동일한 테이블을 두 번 불러오기 때문에 구분을 위한 테이블 별칭(Alias) 설정이 필수

-- 원하는 데이터가 여러 테이블에 흩어져 있을 경우, 1.조인, 2.집합, 3.서브쿼리를 사용하여 조립한다.