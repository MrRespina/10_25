SELECT * FROM tab;

SELECT * FROM oct_snack;

-- 관계연산자 : and, or, NOT, BETWEEN, IN

SELECT * FROM oct_snack WHERE s_price >= 1000 and s_price < 3000;

-- BETWEEN : 이상/이하 조건 범위 내에서 좋음. 초과 or 미만 일 시 BETWEEN 사용이 애매하다.
SELECT * FROM oct_snack WHERE s_price BETWEEN 1000 AND 3000;

-- IN : 연속되지 않은 값들을 받아오고 싶을 떄 사용.
SELECT * FROM oct_snack WHERE s_price IN(1500,2000,3000);

-- NOT : 결과에 반대되는 결과값을 얻고 싶을 때. (NOT IN)
SELECT * FROM oct_snack WHERE s_price NOT IN(1500,2000,3000);


CREATE TABLE oct25_coffee(
	coffee_num NUMBER(4) primary key,
	coffee_name varchar2(10 char) not null,
	coffee_price NUMBER(5) not null,
	coffee_cal NUMBER(5,1) not null,
	coffee_date date not null
);

CREATE SEQUENCE oct25_coffee_seq;
DROP SEQUENCE oct25_coffee_seq;

SELECT * FROM oct25_coffee;

INSERT INTO oct25_coffee VALUES(oct25_coffee_seq.nextval,'아메리카노',3000,20.1,sysdate);
INSERT INTO oct25_coffee VALUES(oct25_coffee_seq.nextval,'카페라떼',3500,28.7,sysdate);
INSERT INTO oct25_coffee VALUES(oct25_coffee_seq.nextval,'바닐라라떼',4000,101.9,sysdate);
INSERT INTO oct25_coffee VALUES(oct25_coffee_seq.nextval,'카페모카',4800,133.5,sysdate);
INSERT INTO oct25_coffee VALUES(oct25_coffee_seq.nextval,'녹차라떼',5000,128.1,sysdate);

TRUNCATE TABLE oct25_coffee;

-- 데이터 타입, 컬럼 크기, 용량, 원래대로 돌리기, ... : ALTER
--	데이터 타입 변경 시에는 해당 컬럼의 값을 모두 지운 상태여야 변경 가능
--	컬럼의 용량을 줄일 시 , 해당 컬럼의 용량을 조회해서 변경할 길이보다 큰 값이 있는지 확인 > 이후 용량 변경

-- 컬럼 데이터 타입 변경
ALTER TABLE [테이블명] MODIFY [컬럼명] [데이터타입(용량)];
ALTER TABLE oct25_coffee MODIFY coffee_name VARCHAR2(5 char);

-- 컬럼명 변경
ALTER TABLE [테이블명] RENAME column [기존컬럼] to [바꿀컬럼];
ALTER TABLE oct25_coffee RENAME COLUMN coffee_name2 TO coffee_name

-- 컬럼 추가
ALTER TABLE [테이블명] ADD [컬럼명][데이터타입][제약조건(생략가능)];
--	기존에 테이블 속 데이터가 없어야 제약조건에 NOT NULL 넣을 수 있음.
ALTER TABLE oct25_coffee ADD coffee_taste varchar2(10 char) not null;

-- 컬럼 삭제
ALTER TABLE [테이블명] DROP column [컬럼명];
ALTER TABLE oct25_coffee DROP column coffee_taste;

-- 테이블 완전 삭제
DROP TABLE [테이블명] CASCADE CONSTRAINT purge;

-- 테이블 삭제(휴지통 임시 보관)
DROP TABLE [테이블명] CASCADE CONSTRAINT;

-- (휴지통에 있는) 테이블 복원
FLASHBACK TABLE [테이블명] TO BEFORE DROP;

-- 휴지통 비우기
PURGE RECYCLEBIN;


CREATE TABLE oct25_cafe(
	c_name varchar2(10 char) primary key,
	c_location varchar2(20 char) not null,
	c_capacity number(3) not null
);

CREATE TABLE oct25_drink(
	d_name varchar2(10 char) primary key,
	d_c_name varchar2(10 char) not null,
	d_price number(5) not null
);

CREATE TABLE oct25_drink_other(
	d_name varchar2(10 char) primary key,
	d_c_name varchar2(10 char) not null,
	d_price number(5) not null,
	CONSTRAINT cafe_name FOREIGN KEY(d_c_name) REFERENCES oct25_cafe(c_name) ON DELETE CASCADE 
);

DROP TABLE oct25_drink_other cascade constraint purge;
DROP TABLE oct25_drink cascade constraint purge;

INSERT INTO oct25_cafe VALUES('A','서울',100);
INSERT INTO oct25_cafe VALUES('B','독도',80);

INSERT INTO oct25_drink VALUES('아메리카노','A',2000);
INSERT INTO oct25_drink VALUES('라떼','A',3000);
INSERT INTO oct25_drink VALUES('녹차','A',2500);

INSERT INTO oct25_drink VALUES('홍차','B',2500);
INSERT INTO oct25_drink VALUES('스무디','B',3000);
INSERT INTO oct25_drink VALUES('에스프레소','B',4000);

INSERT INTO oct25_drink_other VALUES('아메리카노','A',2000);
INSERT INTO oct25_drink_other VALUES('라떼','A',3000);
INSERT INTO oct25_drink_other VALUES('녹차','A',2500);

INSERT INTO oct25_drink_other VALUES('홍차','B',2500);
INSERT INTO oct25_drink_other VALUES('스무디','B',3000);
INSERT INTO oct25_drink_other VALUES('에스프레소','B',4000);

SELECT * FROM oct25_drink;
SELECT * FROM oct25_cafe;

-- 전체 음료 평균가보다 비싼 음료의 종류?
SELECT count(d_name) as 갯수,avg(d_price) as 평균가 FROM oct25_drink WHERE d_price > (SELECT avg(d_price) FROM oct25_drink);

-- 제일 싼 음료를 파는 카페의 이름
SELECT d_c_name FROM oct25_drink WHERE d_price = (SELECT min(d_price) FROM oct25_drink);

-- 서울에 있는 카페에서 만든 음료의 평균가
SELECT avg(d_price) as 평균가 FROM oct25_drink WHERE d_c_name = (SELECT c_name FROM oct25_cafe WHERE c_location = '서울');

-- 좌석이 90석 이상인 카페에서 파는 음료의 이름
SELECT d_name FROM oct25_drink WHERE d_c_name = (SELECT c_name FROM oct25_cafe WHERE c_capacity >= 90);

-- 전체 음료 평균가보다 저렴한 음료의 이름
SELECT d_name,d_price FROM oct25_drink WHERE d_price < (SELECT avg(d_price) FROM oct25_drink);

-- 가장 비싼 음료를 파는 카페가 위치한 곳
SELECT c_location FROM oct25_cafe WHERE c_name = (SELECT d_c_name FROM oct25_drink WHERE d_price = (SELECT max(d_price) FROM oct25_drink))

CREATE TABLE oct25_owner(
	o_num number(4) primary key,
	o_name varchar2(10 char) not null,
	o_brith date not null,
	o_gender varchar2(2 char) not null
);

ALTER TABLE oct25_owner RENAME Column o_brith TO o_birth;

CREATE TABLE oct25_menu(
	m_num number(4) primary key,
	m_name varchar2(10 char) not null,
	m_price number(6) not null,
	m_r_num number(4) not null,
	CONSTRAINT rest_number FOREIGN KEY(m_r_num) REFERENCES oct25_restaurant(r_num) ON DELETE CASCADE
	
);

CREATE TABLE oct25_restaurant(
	r_num NUMBER(5) primary key,
	r_name VARCHAR2(20 char) not null,
	r_capacity NUMBER(5) not null,
	r_locale VARCHAR(20 char) not null,
	r_o_num number(4) not null,
	CONSTRAINT owner_number FOREIGN KEY(r_o_num) REFERENCES oct25_owner(o_num) ON DELETE CASCADE
);

CREATE SEQUENCE oct25_owner_seq;
CREATE SEQUENCE oct25_menu_seq;
CREATE SEQUENCE oct25_restaurant_seq;

DROP SEQUENCE oct25_owner_seq;
DROP SEQUENCE oct25_menu_seq;
DROP SEQUENCE oct25_restaurant_seq;

DROP TABLE oct25_owner;
DROP TABLE oct25_restaurant;
DROP TABLE oct25_menu;

INSERT INTO oct25_owner VALUES(oct25_owner_seq.nextval,'홍길동',to_date('1990-03-01','YYYY-MM-DD'),'남자');
INSERT INTO oct25_owner VALUES(oct25_owner_seq.nextval,'김길동',to_date('1992-02-01','YYYY-MM-DD'),'여자');
INSERT INTO oct25_owner VALUES(oct25_owner_seq.nextval,'홍길동',to_date('1991-12-12','YYYY-MM-DD'),'여자');
INSERT INTO oct25_owner VALUES(oct25_owner_seq.nextval,'최길동',to_date('1989-10-25','YYYY-MM-DD'),'남자');

SELECT * FROM oct25_owner;

INSERT INTO oct25_restaurant VALUES(oct25_restaurant_seq.nextval,'홍콩반점',100,'강남점',1);
INSERT INTO oct25_restaurant VALUES(oct25_restaurant_seq.nextval,'홍콩반점',80,'종로점',2);
INSERT INTO oct25_restaurant VALUES(oct25_restaurant_seq.nextval,'한신포차',150,'강서점',3);
INSERT INTO oct25_restaurant VALUES(oct25_restaurant_seq.nextval,'잠실포차',130,'잠실점',4);

SELECT * FROM oct25_restaurant;

INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'짜장면',5800,1);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'짬뽕',6000,1);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'울면',6800,1);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'차돌짬뽕',7800,1);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'탕수육',15000,1);

SELECT * FROM oct25_menu;

INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'짜장면',5600,2);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'짬뽕',5800,2);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'울면',6600,2);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'차돌짬뽕',7600,2);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'탕수육',14800,2);

INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'오뎅탕',9000,3);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'나가사키백짬뽕',13000,3);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'치즈떢볶이',12000,3);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'해물탕',18000,3);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'먹태',8000,3);

INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'돼지껍데기구이',12000,4);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'불닭발',19000,4);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'명란계란말이',9800,4);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'먹태세트',18000,4);
INSERT INTO oct25_menu VALUES(oct25_menu_seq.nextval,'오징어구이',16000,4);

SELECT * FROM oct25_owner WHERE o_num = (SELECT r_o_num FROM oct25_restaurant WHERE r_capacity = (SELECT max(r_capacity) FROM oct25_restaurant));

SELECT m_name,m_price FROM oct25_menu ORDER BY m_price, m_name DESC;

SELECT o_name,o_birth FROM oct25_owner ORDER BY o_birth ASC;

SELECT count(r_num) FROM oct25_restaurant;

SELECT avg(m_price) AS 평균가격 FROM oct25_menu;


SELECT m_name,m_price FROM oct25_menu WHERE m_price = (SELECT max(m_price) FROM oct25_menu);

SELECT o_name,o_birth FROM oct25_owner WHERE o_birth = (SELECT min(o_birth) FROM oct25_owner);

SELECT r_name,r_locale,r_capacity FROM oct25_restaurant WHERE r_capacity in (SELECT min(r_capacity) FROM oct25_restaurant);

SELECT o_name,o_birth FROM oct25_owner WHERE o_num = (SELECT r_o_num FROM oct25_restaurant WHERE r_name='홍콩반점' AND r_locale = '강남점');

-- 서브쿼리의 답이 단일결과(=를 사용했기 때문에 단일결과가 나와야 한다.)가 아니기 떄문에 오류가 발생함.(조건을 만족하는 것이 2개.)
SELECT r_name,r_locale FROM oct25_restaurant WHERE r_num = (SELECT m_r_num FROM oct25_menu WHERE m_name LIKE '%짜장%');

-- 서브쿼리의 답이 단일결과가 아니지만 in을 사용했기 때문에 다중 결과를 내포할 수 있다.
SELECT r_name,r_locale FROM oct25_restaurant WHERE r_num in (SELECT m_r_num FROM oct25_menu WHERE m_name LIKE '%짜장%');

SELECT m_name,m_price FROM oct25_menu WHERE m_r_num = (SELECT r_o_num FROM oct25_restaurant WHERE r_o_num=(SELECT o_num FROM oct25_owner WHERE o_birth = (SELECT min(o_birth) FROM oct25_owner)));

-- JOIN : 테이블 여러개 엮는다, 테이블 여러개를 붙여 RAM에 잠시 넣는다.

SELECT * FROM oct25_owner,oct25_restaurant WHERE o_num = r_o_num;

SELECT m_name,m_price,r_name,r_locale FROM oct25_menu,oct25_restaurant WHERE m_r_num = r_num; 

SELECT r_name,r_locale,o_name,o_birth FROM oct25_restaurant,oct25_owner WHERE r_o_num = o_num;

SELECT m_name,m_price,r_name,r_locale,r_capacity FROM oct25_menu,oct25_restaurant WHERE m_r_num = r_num AND r_capacity >= 100;

SELECT m_name,m_price,r_name,r_locale,r_capacity FROM oct25_menu,oct25_restaurant WHERE m_r_num = r_num AND r_capacity = (SELECT max(r_capacity) FROM oct25_restaurant);

SELECT m_name,m_price,r_name,r_locale,o_name,o_birth 
	FROM oct25_menu,oct25_restaurant,oct25_owner
	WHERE o_birth = (SELECT min(o_birth) FROM oct25_owner)  
	AND o_num = r_o_num AND r_num = m_r_num
	ORDER BY m_name,r_name;