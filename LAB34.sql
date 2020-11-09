SET LC_MONETARY = "en_US.UTF-8";

-- LAB 3.4


select begin_date, client_feedback, owner_feedback from bookings where owner_feedback->>'stars' = '5' and client_feedback->>'stars' = '5';
select * from clients where contact->>'email' like '%yandex.com';

select to_tsvector('Java — строго типизированный объектно-ориентированный язык программирования, разработанный компанией Sun Microsystems.');
select to_tsquery('Привет & гуляю');

select * from apartaments where to_tsvector(description)@@to_tsquery('язык');
select * from apartaments where to_tsvector(description)@@to_tsquery('язык & Python');
select * from apartaments where to_tsvector(description)@@to_tsquery('язык & Python | разработанный & компанией');
select * from apartaments where to_tsvector('russian',description)@@to_tsquery('russian','язык <-> программирования');

select begin_date, client_feedback, owner_feedback from bookings
where to_tsvector(owner_feedback->>'review')@@to_tsquery('язык & Python') and to_tsvector(client_feedback->>'review')@@to_tsquery('язык & Python');

--drop index if exists index_text_description;
create index index_text_description on apartaments USING GIN (to_tsvector('russian',description));

--------------------




create index abc on apartaments using btree (numeric(cost_per_day));



---------------------PART 2------------------------

EXPLAIN TABLE clients;
-- Seq Scan on clients  (cost=0.00..270253.77 rows=10000477 width=106)
EXPLAIN TABLE clients ORDER BY client_id;
-- Index Scan using clients_pkey on clients  (cost=0.43..429943.59 rows=10000477 width=106)
EXPLAIN SELECT * FROM clients WHERE client_id>100000;
--Seq Scan on clients  (cost=0.00..295254.96 rows=9901267 width=106)
--Filter: (client_id > 100000)
EXPLAIN SELECT * FROM clients WHERE client_id>100000 group by client_id HAVING client_id < 1000000;
--Group  (cost=0.43..45347.83 rows=897973 width=106)
--  Group Key: client_id
--  ->  Index Scan using clients_pkey on clients  (cost=0.43..43102.89 rows=897973 width=106)
--        Index Cond: ((client_id > 100000) AND (client_id < 1000000)
EXPLAIN TABLE apartaments ORDER BY cost_per_day;
--  Workers Planned: 2
--  ->  Sort  (cost=2560279.34..2570696.00 rows=4166667 width=282)
--        Sort Key: cost_per_day
--        ->  Parallel Seq Scan on apartaments  (cost=0.00..435878.67 rows=4166667 width=282)


create index apartaments_index on apartaments(apartament_id);
create index owner_index on apartaments(owner_id);


-------------
explain table apartaments ORDER BY cost_per_day asc; -- 28s | 100ms

/*
Gather Merge  (cost=2561279.36..3533569.54 rows=8333334 width=281)
  Workers Planned: 2
  ->  Sort  (cost=2560279.34..2570696.00 rows=4166667 width=281)
        Sort Key: cost_per_day
        ->  Parallel Seq Scan on apartaments  (cost=0.00..435878.67 rows=4166667 width=281)
-------------

Index Scan using apartaments_cost_index on apartaments  (cost=0.43..1760736.42 rows=10000000 width=281)
*/
DROP INDEX IF EXISTS apartaments_cost_index;
CREATE INDEX apartaments_cost_index on apartaments (cost_per_day ASC);





--------------------


SELECT * FROM clients WHERE fullname = 'Лена Тушкарева';
explain SELECT * FROM clients WHERE fullname = 'Лена Тушкарева';
/*
Gather  (cost=1000.00..223332.43 rows=1 width=106)
  Workers Planned: 2
  ->  Parallel Seq Scan on clients  (cost=0.00..222332.33 rows=1 width=106)
        Filter: ((fullname)::text = 'Лена Тушкарева'::text)
*/

DROP INDEX IF EXISTS clients_name_index;
create index clients_name_index ON clients(fullname); -- 1,5s | 80ms
explain analyse SELECT * FROM clients WHERE fullname = 'Лена Тушкарева';
/*
Index Scan using clients_name_index on clients  (cost=0.56..8.58 rows=1 width=106) (actual time=0.062..0.063 rows=1 loops=1)
  Index Cond: ((fullname)::text = 'Лена Тушкарева'::text)
Planning Time: 0.086 ms
Execution Time: 0.080 ms
*/

explain analyse
    select city, apartament_id, client_id, begin_date
    from bookings b inner join apartaments a using(apartament_id)
    where begin_date>'01.01.2010' and city = 'Грозный';

/*
Gather  (cost=447330.81..3760628.84 rows=18750 width=857) (actual time=875.300..99438.644 rows=18919 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Parallel Hash Join  (cost=446330.81..3757753.84 rows=7812 width=857) (actual time=879.533..99411.331 rows=6306 loops=3)
        Hash Cond: (b.apartament_id = a.apartament_id)
        ->  Parallel Seq Scan on bookings b  (cost=0.00..3288385.83 rows=8776068 width=580) (actual time=0.729..96478.889 rows=6998623 loops=3)
              Filter: (begin_date > '2010-01-01'::date)
              Rows Removed by Filter: 6365718
        ->  Parallel Hash  (cost=446284.46..446284.46 rows=3708 width=281) (actual time=869.543..869.543 rows=3028 loops=3)
              Buckets: 16384  Batches: 1  Memory Usage: 3040kB
              ->  Parallel Seq Scan on apartaments a  (cost=0.00..446284.46 rows=3708 width=281) (actual time=0.463..865.467 rows=3028 loops=3)
                    Filter: ((city)::text = 'Грозный'::text)
                    Rows Removed by Filter: 3330306
Planning Time: 0.269 ms
Execution Time: 99445.138 ms
*/



DROP INDEX IF EXISTS bookings_date_index;
CREATE INDEX bookings_date_index ON "bookings"(begin_date);--2min
DROP INDEX IF EXISTS apart_city_index;
CREATE INDEX apart_city_index ON apartaments USING hash(city) ;--1min

explain  select city, apartament_id, client_id, begin_date
from bookings b inner join apartaments a using(apartament_id)
where city = 'Грозный' and begin_date>'01.01.2015';  -- 4s -> 0.6s

/*
Gather  (cost=32459.74..3345757.76 rows=18750 width=29) (actual time=267.175..90855.522 rows=18919 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Parallel Hash Join  (cost=31459.74..3342882.76 rows=7812 width=29) (actual time=262.396..90837.110 rows=6306 loops=3)
        Hash Cond: (b.apartament_id = a.apartament_id)
        ->  Parallel Seq Scan on bookings b  (cost=0.00..3288385.83 rows=8776068 width=12) (actual time=0.783..88766.119 rows=6998623 loops=3)
              Filter: (begin_date > '2010-01-01'::date)
              Rows Removed by Filter: 6365718
        ->  Parallel Hash  (cost=31413.38..31413.38 rows=3709 width=21) (actual time=256.702..256.703 rows=3028 loops=3)
              Buckets: 16384  Batches: 1  Memory Usage: 672kB
              ->  Parallel Bitmap Heap Scan on apartaments a  (cost=101.43..31413.38 rows=3709 width=21) (actual time=0.991..254.742 rows=3028 loops=3)
                    Recheck Cond: ((city)::text = 'Грозный'::text)
                    Heap Blocks: exact=3098
                    ->  Bitmap Index Scan on apart_city_index  (cost=0.00..99.20 rows=8902 width=0) (actual time=1.494..1.495 rows=9083 loops=1)
                          Index Cond: ((city)::text = 'Грозный'::text)
Planning Time: 1.868 ms
Execution Time: 90860.685 ms
*/


explain select city, apartament_id, o.owner_id
from apartaments inner join owners o on o.owner_id = apartaments.owner_id
where city = 'Арзамас';





explain select city, apartament_id, client_id, begin_date, cost_per_day
from bookings b inner join apartaments a using(apartament_id)
where city = 'Грозный' and begin_date>'01.01.2010'::date ORDER BY cost_per_day asc limit 100;



-- до введения
/*Gather Merge  (cost=3344387.89..3346210.82 rows=15624 width=37) (actual time=82523.519..82528.336 rows=18919 loops=1)
Gather Merge  (cost=3344387.89..3346210.82 rows=15624 width=37) (actual time=82008.771..82016.064 rows=18919 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Sort  (cost=3343387.87..3343407.40 rows=7812 width=37) (actual time=82002.224..82003.430 rows=6306 loops=3)
        Sort Key: a.cost_per_day
        Sort Method: quicksort  Memory: 675kB
        Worker 0:  Sort Method: quicksort  Memory: 688kB
        Worker 1:  Sort Method: quicksort  Memory: 692kB
        ->  Parallel Hash Join  (cost=31459.74..3342882.76 rows=7812 width=37) (actual time=6.093..81986.461 rows=6306 loops=3)
              Hash Cond: (b.apartament_id = a.apartament_id)
              ->  Parallel Seq Scan on bookings b  (cost=0.00..3288385.83 rows=8776068 width=12) (actual time=0.022..80267.552 rows=6998623 loops=3)
                    Filter: (begin_date > '2010-01-01'::date)
                    Rows Removed by Filter: 6365718
              ->  Parallel Hash  (cost=31413.38..31413.38 rows=3709 width=29) (actual time=4.664..4.665 rows=3028 loops=3)
                    Buckets: 16384  Batches: 1  Memory Usage: 768kB
                    ->  Parallel Bitmap Heap Scan on apartaments a  (cost=101.43..31413.38 rows=3709 width=29) (actual time=0.949..4.036 rows=3028 loops=3)
                          Recheck Cond: ((city)::text = 'Грозный'::text)
                          Heap Blocks: exact=8706
                          ->  Bitmap Index Scan on apart_city_index  (cost=0.00..99.20 rows=8902 width=0) (actual time=1.512..1.512 rows=9083 loops=1)
                                Index Cond: ((city)::text = 'Грозный'::text)
Planning Time: 0.161 ms
Execution Time: 82017.372 ms
*/


