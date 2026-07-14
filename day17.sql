-- 1. product 테이블 생성 SQL 쿼리

CREATE DATABASE test;
CREATE TABLE product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30),
    price INT
);

-- 2. 조회, 입력, 수정, 삭제 SQL 쿼리
-- DML : INSERT, UPDATE, DELETE, SELECT

-- 추가
INSERT INTO product(name, price)
VALUES ('키보드', 50000);

INSERT INTO product(name, price)
VALUES ('마우스', 30000);

-- 조회
SELECT * FROM product;

-- 수정
UPDATE product
SET price = 35000
WHERE id = 2;

-- 다시 조회
SELECT * FROM product;

-- 삭제
DELETE FROM product
WHERE id = 1;

-- 최종 조회
SELECT * FROM product;

-- TRUNCATE문으로도 데이터를 삭제할 수 있다
TRUNCATE product;

-- delete : rollback 가능
-- truncate : rollback 불가능

-- 3. NULL vs NOT NULL

CREATE TABLE product2 (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 기본키는 자동으로 NOT NULL
    name VARCHAR(30), -- NOT NULL 옵션이 없으면 NULL값 허용
    price INT NOT NULL -- price는 NULL 값을 허용하지 않는다
);

-- product1
INSERT INTO product(name)
VALUES('모니터');
INSERT INTO product(name, price)
VALUES('카메라', NULL);
-- 둘 다 정상적으로 price값은 NULL로 저장된다.

-- product2
INSERT INTO product2(name) 
VALUES('모니터'); -- ERROR : Field 'price' doesn't have a default value

INSERT INTO product2(name, price)
VALUES('마우스', NULL); -- ERROR : Column 'price' cannot be null
​