-- 1. 하나의 영화도 존재하지 않는 카테고리
select c.name
from category c
left join film_category fc on c.category_id = fc.category_id
where fc.film_id is null;

-- 2. 평균 길이가 120분 이상인 카테고리명, 평균길이를 출력하시오
select 
	c.name as category_name,
	avg(f.length) as avg_length	
from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
group by c.category_id, c.name
having avg(f.length) >= 120
order by avg_length	desc;

/*3. 장르별 영화 수를 구하고
70편 이상 → 많음 
60~69편 → 보통 
60편 미만 → 적음 
으로 조회 */
select 
	c.name as category_name,
    count(fc.film_id) as film_count,
    case
		when count(fc.film_id) >= 70 then '많음'
        when count(fc.film_id) >= 60 then '보통'
        else '적음'
	end amount_status
from category c
join film_category fc on c.category_id = fc.category_id
group by c.category_id, c.name
order by film_count desc;

-- 4. 영화에 30편 이상 출연한 배우의 [배우 이름(이름 + 성), 출연 영화 수] 를 대여 횟수 내림차순으로 출력
select 
	concat(a.first_name, ' ', a.last_name) actor_name,
	count(fa.film_id) film_count
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, actor_name
having film_count >= 30
order by film_count desc;

-- 5. 30회 이상 대여한 고객을 조회
select
	concat(c.first_name, ' ', c.last_name) customer_name,
    count(r.rental_id) rental_count
from customer c
join rental r on c.customer_id = r.customer_id
group by c.customer_id, customer_name
having rental_count >= 30
order by rental_count desc;

-- 6. 평균보다 많이 대여된 영화
select 
	f.title,
	count(r.rental_id) rental_count
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
group by f.film_id, f.title
having count(r.rental_id) >
(
	select count(rental_id) / count(distinct film_id)
    from inventory i2
    join rental r2 on i2.inventory_id = r2.inventory_id
)
order by rental_count desc;
	
-- 7. Action 또는 Comedy 영화 조회 (집합쿼리) : UNION, JOIN 사용 
select f.title, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action'
union
select f.title, c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Comedy';

-- 8. 배우가 10명 이상 출연한 영화
select 
	f.title,
    count(fa.actor_id) actor_count
from film f
join film_actor fa on f.film_id = fa.film_id
group by f.film_id, f.title
having count(fa.actor_id) >= 10
order by actor_count desc;

-- 9. 국가별 고객 수 + 정렬
SELECT co.country,
       COUNT(c.customer_id) AS customer_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY co.country_id, co.country
ORDER BY customer_count DESC;

-- 10. 도시별 고객 수를 구하고 2명 이상인 도시만 출력 + 정렬
SELECT ci.city,
       COUNT(c.customer_id) AS customer_count
FROM city ci
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY ci.city_id, ci.city
HAVING COUNT(c.customer_id) >= 2 
ORDER BY customer_count DESC;

-- 11. 국가별 도시당 평균 고객 수를 구하시오. + 정렬
SELECT co.country,
       ROUND(COUNT(c.customer_id) / COUNT(DISTINCT ci.city_id), 2) AS avg_customers_per_city
FROM country co
JOIN city ci ON co.country_id = ci.country_id
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY co.country_id, co.country
ORDER BY avg_customers_per_city DESC;

-- 12. 국가별 주소 개수 (COUNT) + 정렬
SELECT co.country,
       COUNT(a.address_id) AS address_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
JOIN address a ON ci.city_id = a.city_id
GROUP BY co.country_id, co.country
ORDER BY address_count DESC;

-- 13. 국가별 고객 수 + 도시 수 같이 조회 (다중 집계) + 정렬
SELECT co.country,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       COUNT(DISTINCT ci.city_id) AS city_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY co.country
ORDER BY customer_count DESC;

-- 14. 고객이 가장 많은 국가 TOP 10 + 정렬
SELECT co.country,
       COUNT(c.customer_id) AS customer_count
FROM country co
JOIN city ci ON co.country_id = ci.country_id
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY co.country
ORDER BY customer_count DESC
LIMIT 10;

-- 15. 고객이 2명 이상 존재하는 도시 조회 
SELECT ci.city,
       COUNT(c.customer_id) AS customer_count
FROM city ci
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
GROUP BY ci.city_id, ci.city
HAVING COUNT(c.customer_id) >= 2
ORDER BY customer_count DESC;

-- 16. 영화별 카테고리 조회 (한 영화가 여러 카테고리에 속할 수 있다고 가정하고, 영화별 카테고리 이름을 하나의 문자열로 출력하시오)
SELECT f.title,
       GROUP_CONCAT(c.name ORDER BY c.name SEPARATOR ', ') AS categories
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY f.film_id, f.title;