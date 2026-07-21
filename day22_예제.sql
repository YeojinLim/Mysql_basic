select *
from category
where category_id = (
	select category_id from category -- 1. 전체 카테고리에서
	except -- 3. 제외
	select distinct category_id from film_category -- 2. 영화가 존재하는 카테고리
    );

-- 예제) 카테고리에 영화가 존재하는 / 존재하지 않는 카테고리 갯수 구하기
-- left join : category 와 film_category 연결
select 
	sum(case when t.cnt > 0 then 1 else 0 end) "영화가 존재하는 카테고리",
	sum(case when t.cnt = 0 then 1 else 0 end) "영화가 존재하지 않는 카테고리"
from
	(select c.category_id id, count(fc.film_id) cnt -- count(*): null도 count함
	from category c left join film_category fc
	on c.category_id = fc.category_id
	group by c.category_id) t;
