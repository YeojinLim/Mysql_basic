-- WITH 문
-- 1) 가독성이 좋아진다.
-- 2) 같은 결과를 여러 번 사용할 수 있다.
-- 3) 복잡한 SQL을 단계별로 작성할 수 있다.

select title, length -- select의 결과 : 테이블
from film
limit 10;

select f2.제목, f2.시간
from
	(select title 제목, length 시간
	from film
    limit 10) as f2
where f2.시간 between 50 and 100;

with f2 as(
	select title 제목, length 시간
	from film
	limit 10
)
select f2.제목, f2.시간
from f2
where f2.시간 between 50 and 100;

select *
from actor
where upper(first_name) like '%Z%';

select * from actor
where upper(concat(first_name, last_name)) like '%Z%';

with a_n as(
	select upper(concat(first_name, last_name)) fullname
    from actor
)
select fullname from a_n
where fullname like '%Z%';