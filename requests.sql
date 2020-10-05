--LAB #3
--ошибочный запрос
UPDATE clients SET email = 'notemail' WHERE client_id=1;

-- Смена пасспорта//вставка пасспорта
WITH id AS (
    SELECT client_id FROM clients WHERE full_name='COLUMB CRICTOFOR11'
)
INSERT INTO clients_documents(client_id, international_passport)
SELECT *, 771255552 FROM id
ON CONFLICT (client_id) DO UPDATE SET international_passport=771255552;


--ПОЛНОЕ УДАЛЕНИЕ ПОЕЗДКИ (CANCELING)
--сработали on delete cascade
DELETE FROM trips WHERE trip_id=1;



-- ROAD MAP ДЛЯ КОНКРЕТНОГО ТУРИСТА(КЛИЕНТА)

WITH CLIENTs_TRIPS as (
    SELECT trip_id FROM trip_client WHERE client_id=2
), TRANSPORT as (
    SELECT * FROM CLIENTs_TRIPS left join movements USING(trip_id)
), APARTAMENT as (
    SELECT * FROM CLIENTs_TRIPS left join trip_hotel USING(trip_id)
), AP as (
    SELECT * FROM APARTAMENT INNER JOIN hotels USING(hotel_id)
)
select * from
(
select date(departure_time) as START, NULL as END,  departure_address AS COMMENT from TRANSPORT
UNION ALL
select begin_date as START, end_date as END, name AS COMMENT from AP
) AS notsorted  ORDER BY DATE(START);





-- ТОП
WITH cltrip as (
    SELECT * FROM clients left join trip_client USING(client_id)
), full_data as (
    SELECT * FROM cltrip inner join trips USING(trip_id)
)
SELECT client_id, full_name, count(*) as count FROM full_data GROUP BY client_id, full_name ORDER BY count DESC LIMIT 5;


--Новый пользователь
INSERT INTO
    clients(FULL_NAME, SEX, EMAIL, PHONE)
VALUES
    ('ROTEN ILYA EGOVITCH', 'male', 'rot@life.ru', '+79993334455')
RETURNING *;

insert into clients_documents(client_id) values (currval('clients_client_id_seq'));



-- У КОГО НЕТ ДОКОВ?
TABLE clients_documents;

SELECT * FROM clients_documents
WHERE international_passport is NULL AND local_passport is NULL AND birth_certificate is NULL;

INSERT INTO trips(cost, begin_date, end_date) VALUES
	(100000, '2020-10-06', '2022-12-15')
RETURNING *; --7

INSERT INTO trip_client(client_id, trip_id) VALUES (12, 7);

INSERT INTO trip_hotel(trip_id, hotel_id, begin_date, end_date) VALUES
    (7, 3, '2020-10-06', '2022-05-01'),
	(7, 1, '2021-05-01', '2022-12-15');


INSERT INTO movements(trip_id, departure_time, departure_address) VALUES
    (7,'2020-10-06 19:00:00 +3', 'seremetevo moscow russia'),
    (7,'2021-05-01 11:00:00 +0', 'london heatrow'),
	(7,'2022-12-15 13:00:00 +0', 'adler russia')
	RETURNING *;

--удаляем завтрашнюю поездку клиентов у которых нет паспорта
WITH ids as (
    SELECT client_id FROM clients_documents
    WHERE international_passport is NULL
      AND local_passport is NULL
      AND birth_certificate is NULL
), contacs as (
    SELECT ids.client_id, full_name, phone, email
    FROM ids NATURAL left join clients
), risk_trips as (
    select * from contacs NATURAL left join trip_client
), failed_trips as (
     select trip_id from risk_trips natural inner join trips WHERE trips.begin_date =  CURRENT_DATE+1
)
--table contacs;
--table failed_trips;
DELETE FROM trips WHERE(trip_id IN (SELECT trip_id FROM failed_trips)) RETURNING *;
