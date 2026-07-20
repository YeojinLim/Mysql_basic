select * from country; -- 부모
select * from city; -- 자식

insert into country(country)
values('New Land');

-- 1. INNER JOIN : 양쪽 테이블에 모두 존재하는 데이터만 조회
select *
from country co left outer join city ci
on ci.country_id = co.country_id
where co.country = 'New Land'; -- New Land는 조회되지 않는다.

-- 2. LEFT OUTER JOIN
select *
from country co left outer join city ci -- outer는 생략가능
on ci.country_id = co.country_id;-- 도시가 없는 city 컬럼은 NULL로 조회된다.

-- LEFT JOIN을 사용하여 도시가 배정되지 않은 나라 찾기
select co.country, ci.country_id
from country co left join city ci 
on ci.country_id = co.country_id
where ci.country_id is null;

-- 3. 3개의 테이블 연결
select * from category;
select * from film;
select * from film_category; -- film과 category를 연결하는 중간 테이블
    
insert into category(name)
values('KContents'); -- 한류 장르 추가

-- INNER JOIN 사용할 경우, KContents는 조회되지 않는다. KContents는 film_category 테이블에 연결된 데이터가 없기 때문.
select f.title, c.name 
from film_category fc inner join category c
	on fc.category_id = c.category_id
inner join film f
	on fc.film_id = f.film_id
where f.title is null;

-- LEFT OUTER JOIN 조회
select c.name, f.title
from category c left join film_category fc
	on c.category_id = fc.category_id
left join film f
	on fc.film_id = f.film_id
where f.title is null;

-- LEFT JOIN 은 "기준이 되는 테이블의 데이터는 모두 보고 싶을 때" 사용한다.