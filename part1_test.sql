-- Database: test

-- DROP DATABASE test;

CREATE DATABASE test
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_Ireland.1252'
    LC_CTYPE = 'English_Ireland.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
CREATE TABLE ads
(
  id INT PRIMARY KEY NOT NULL
  , category_id int
  , region_id int
  , create_ TIMESTAMPTZ
  , publish TIMESTAMPTZ
  , delete_ TIMESTAMPTZ 
);

INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (1,1,1,'2017-06-22 19:10:25-07','2017-06-22 20:10:25-07','2017-06-22 22:10:25-07' );
--select * from ads;
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (2,1,1,'2017-06-21 19:10:25-07','2017-06-21 20:10:25-07','2017-06-22 19:10:25-07');
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (3,1,1,'2017-06-19 19:10:25-07','2017-06-19 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (4,1,1,'2017-06-19 19:10:25-07','2017-06-19 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (5,1,2,'2017-06-15 19:10:25-07','2017-06-15 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (6,1,2,'2017-06-15 19:10:25-07','2017-06-15 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (7,2,2,'2017-06-15 19:10:25-07','2017-06-15 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (8,2,2,'2017-06-14 19:10:25-07','2017-06-14 20:10:25-07','2017-06-16 19:10:25-07');
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (9,2,2,'2017-06-14 19:10:25-07','2017-06-14 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (10,2,2,'2017-06-10 19:10:25-07','2017-06-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (11,1,4,'2016-06-10 19:10:25-07','2016-06-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (12,1,4,'2016-06-10 19:10:25-07','2017-06-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (13,1,5,'2017-06-10 19:10:25-07','2017-06-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (14,2,2,'2017-07-10 19:10:25-07','2017-07-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (15,2,2,'2016-07-10 19:10:25-07','2016-07-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (16,1,5,'2017-07-10 19:10:25-07','2017-07-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (17,1,5,'2016-07-10 19:10:25-07','2016-07-10 20:10:25-07',null);
INSERT INTO ads (id, category_id,region_id,create_, publish, delete_)
VALUES (16,1,5,'2017-07-10 19:10:25-07','2017-07-10 20:10:25-07',null);
select * from ads

CREATE TABLE region
(  
  id INT PRIMARY KEY NOT NULL
  , country VARCHAR (50)
  , province VARCHAR (50)
  , county VARCHAR (50)
  , town VARCHAR (50)
);

INSERT INTO region (id, country,province,county, town)
VALUES (1,'ireland','munster','cork','midleton');
INSERT INTO region (id, country,province,county, town)
VALUES (2,'ireland','munster','waterford','waterford city');
INSERT INTO region (id, country,province,county, town)
VALUES (3,'ireland','munster','limerick','adare');
INSERT INTO region (id, country,province,county, town)
VALUES (4,'ireland','munster','Tipperary','Thurles');
INSERT INTO region (id, country,province,county, town)
VALUES (5,'ireland','munster','Tipperary','Cahir');

CREATE TABLE category
(  
  id INT PRIMARY KEY NOT NULL
  , vertical VARCHAR (50)
  , main_category VARCHAR (50)
  , category VARCHAR (50)
  , subcategory VARCHAR (50)
);
INSERT INTO category (id,vertical,main_category,category,subcategory)
VALUES (1,'farming','farming','livestock','beef cattle');
INSERT INTO category (id,vertical,main_category,category,subcategory)
VALUES (2,'motor','cars','hatchback','honda');


--Determine the number of active ads on the site per day (use generate_series)
select date(d) as Date_ , count(a.id) as number_of_active_ads
from generate_series(
  current_date - interval '10 day', 
  current_date,'1 day'
) d 
left join (select * from ads where delete_ is null) a --not null would mean not active
			on date(a.publish) = d 
			group by Date_ order by Date_ desc;

-- Determine the YoY growth of Beef Cattle ads in county Tipperary from 2016 to 2016 (use lag).
Beef_Cattle_ads_in_county_Tipperary

select
  year_ 
  , ads_count 
  , ads_lastyear
  , 100 * (ads_count - ads_lastyear) / ads_lastyear || '%' as Beef_Cattle_ads_in_county_Tipperary_YOY_Growth
from (
select year_, ads_count, lag(ads_count, 1) over (order by year_) as ads_lastyear
from (
select  extract(year from a.publish) as year_ , count(*) as ads_count
from ads a
	left join category b
	on a.category_id = b.id
	left join region c
	on a.region_id = c.id
	where b.vertical = 'farming'
	and c.county = 'Tipperary'
	group by 1
	order by 1 desc
	)a
	group by 1,2
	order by 1 desc
	)b
;
