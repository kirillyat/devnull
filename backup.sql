--TRIP SQL BILDER

--CLEAR CURRENT DATABASE FOR NEW TABLES AND TYPES
DROP TABLE IF EXISTS movements;
DROP TABLE IF EXISTS trip_client;
DROP TABLE IF EXISTS trip_hotel;

DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS clients_documents;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS hotels;

DROP TYPE IF EXISTS SEX_ENUM;

-- CREATE TYPES
CREATE TYPE SEX_ENUM AS ENUM('male', 'female');

-- DESCRIPTION OF NEW TABLES
CREATE TABLE trips (
    trip_id SERIAL,
    cost money CHECK (cost::numeric > 0.0),
    begin_date date NOT NULL,
    end_date date CHECK (end_date >= begin_date) NOT NULL,

    PRIMARY KEY(trip_id)
);

CREATE TABLE clients (
    client_id SERIAL,
    full_name text NOT NULL,
    sex sex_enum NOT NULL,
    email varchar(360) NOT NULL,
    phone varchar(20) NOT NULL,

    CONSTRAINT phone_check  CHECK (phone NOT LIKE '%[^0-9]%'),
    CONSTRAINT email_check CHECK(email LIKE '%_@__%.__%' AND email NOT LIKE '%[!@#$%^&*(){};:?/%~§±+=]%'),
    UNIQUE (full_name, email, phone),
    PRIMARY KEY(client_id)
);

CREATE TABLE clients_documents (
    client_id integer,
    nationality varchar(3) DEFAULT 'RUS',
    international_passport integer UNIQUE default NULL,
    local_passport text UNIQUE default NULL,
    birth_certificate text UNIQUE default NULL,

    PRIMARY KEY (client_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE
);

CREATE TABLE trip_client (
    client_id integer,
    trip_id integer,

    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
    PRIMARY KEY (trip_id, client_id)
);

CREATE TABLE movements (
    trip_id integer,
    movement_id SERIAL,
    departure_time timestamp NOT NULL,
    departure_address text NOT NULL,

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
    PRIMARY KEY(movement_id)
);


CREATE TABLE hotels (
    hotel_id SERIAL,
    name text,
    address text,
    email varchar(360) NOT NULL,
    phone varchar(20) NOT NULL,

    CONSTRAINT phone_check  CHECK (phone not like '%[^0-9]%'),
    CONSTRAINT email_check CHECK(email LIKE '%_@__%.__%' AND email NOT LIKE '%[!@#$%^&*(){};:?/%~§±+=]%'),
    UNIQUE (name, email, phone),
    UNIQUE (name, address),
    PRIMARY KEY (hotel_id)
);


CREATE TABLE trip_hotel (
    trip_id integer,
    hotel_id integer,
    begin_date date,
    end_date date CHECK (end_date >= begin_date),

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id) ON DELETE CASCADE,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id),
    PRIMARY KEY (trip_id, hotel_id)
);






INSERT INTO
    clients(full_name, sex, email, phone)
VALUES
    ('VARLAMOV ILYA OLEGOVITCH', 'male', 'varlamov@lifejornal.ru', '+79990009977'),--1
    ('KATZ MAXIM ANATOLIEVITCH', 'male', 'maxkatz@apple.ru', '+79990001100'),--2
    ('IVANOV IVAN IVANOVITCH', 'male', 'ivanov@yandex.ru', '+79991112233'),--3
    ('IVANOVA IRINA ALEXANDROVNA', 'female', 'iraIvanova@mail.ru', '+79991112244'),--4
    ('IVANOV MAXIM IVANOVITCH', 'male', 'maxIVAN@gmail.com', '+79990009988'),--5
    ('LEBEDEV ARTEMIY TATYANICTH', 'male', 'tema@tema.ru', '+77777777777'),--6
    ('COLUMB CRICTOFOR', 'male', 'open@world.es', '+27777777777'),--7
    ('YATSENKO KIRILL SERGEEVITCH', 'male', 'kirillyat@yandex.ru', '+79260093757'),--8
    ('ROBOTIKOV IVAN ALEXANDROVITCH', 'male', 'robot@mail.ru', '+78881231212'),--9
    ('TUTCHEVA IRINA VLADIMIROVNA', 'female', 'tut@tyt.by', '+68881112233')--10
;

INSERT INTO
    clients_documents(client_id, international_passport, local_passport, birth_certificate)
VALUES
    (1, '771233112', '213309AAA', NULL),
    (2, '771233115', NULL, NULL),
    (3, '643987493', '7898 37483', NULL),
    (4, '873928638', '3213 12387', NULL),
    (5, NULL, NULL, 'iwo-82736'),
    (6, '993928479', '3214 49824', NULL),
    (7, '070723407', 'OIO932847', NULL),
    (8, NULL, 'ERY8399Y', NULL),
    (9, '389879870', NULL, NULL),
    (10,'923847609','9387 0392847', NULL)


;

INSERT INTO
    hotels(name, address, email, phone)
VALUES
    ('SPA SOCHI Olypic', 'Sochi, RUSSIA', 'olymp@sochi.ru', '+78881231212'),--1
    ('Paris voyage', 'Paris, FRANCE', 'parV@gmail.com', '+38881231212'),--2
    ('London Sleep', 'London, UK', 'sllep@gmail.com','+58881231212'),--3
    ('Mavzoley', 'Moscow, RUSSIA', 'lenin@communism.su', '+79260001100'),--4
    ('Hot weekend', 'Madrid, SPAIN', 'huh@huhu.es', '+38881231233'),--5
    ('natasha & spa', 'Antalia, TURKISH', 'turto@tur.tr','+21881231212'),--6
    ('casino & hotel', 'Las-Vagas, USA', 'money@here.us', '+11881231212'),--7
    ('milani vibes', 'Milan, Italy', 'vbes@milan.it','+38442786312')--8
;

INSERT INTO
    trips(cost, begin_date, end_date)
VALUES
    (100000, '2020-11-14', '2021-12-15'),--1
    (50000, '2020-10-01', '2020-10-10'),--2
    (90000, '2020-12-12', '2020-12-22'),--3
    (122000, '2022-02-12', '2022-02-20'),--4
    (60000, '2021-06-01', '2021-07-01')--5
;

INSERT INTO
    trip_hotel(trip_id, hotel_id, begin_date, end_date)
VALUES
    (1, 3, '2020-11-14', '2021-01-01'),
    (1, 2, '2021-01-01', '2021-12-15'),
    (2, 4, '2020-10-01', '2020-10-10'),
    (3, 1, '2020-12-12', '2020-12-18'),
    (3, 5, '2020-12-18', '2020-12-22'),
    (4, 7, '2022-02-12', '2022-02-20'),
    (5, 6, '2021-06-01', '2021-06-21'),
    (5, 4, '2021-06-21', '2021-07-01')
;


INSERT INTO
    trip_client(client_id, trip_id)
VALUES
    (1,3),
    (1,4), (2,4),
    (3,1), (4,1), (5,1),
    (3,2), (5,2),
    (7,5)
;

INSERT INTO
    movements(trip_id, departure_time, departure_address)
VALUES
    (1,'2020-11-14 09:00:00 +3', 'seremetevo moscow russia'),
    (1,'2021-01-01 21:00:00 +0', 'hitrow london UK'),
    (1,'2021-12-15 08:30:00 +1', 'orsa paris france'),
    (2,'2020-10-01 18:30:00 +7', 'omsk airport russia'),
    (2,'2020-10-10 06:30:00 +3', 'seremetevo moscow russia'),
    (3,'2020-12-12 08:30:00 +1', 'pulkovo sankt piterburg'),
    (3,'2020-12-18 20:30:00 +5', 'sochi adler airport russia'),
    (3,'2020-12-22 20:00:00 +9', 'railway cantrale Madrid, SPAIN'),
    (4,'2022-02-12 10:30:00 +6', 'san-francisco center bus station usa'),
    (4,'2022-02-20 18:10:00 +4', 'las-vegas shattel bus stop#12 usa'),
    (5,'2021-06-01 08:10:00 +3', 'orsa paris france'),
    (5,'2021-06-21 23:50:00 +4', 'antaliya center railway'),
    (5,'2021-07-01 18:10:00 +4', 'vnukovo airport russia')
;





INSERT INTO clients(full_name, sex, email, phone) VALUES
    ('SIDOROV ALEXANDER VLADIMIROVITCH', 'male', 'sidr@yandex.ru', '+70001231212') RETURNING *;

INSERT INTO clients_documents(client_id, international_passport, local_passport, birth_certificate) VALUES
    (11, '771276612', '218309AAA', NULL); --11

INSERT INTO trips(cost, begin_date, end_date) VALUES
    (100000, '2020-11-14', '2021-12-15')
RETURNING *; --6

INSERT INTO trip_client(client_id, trip_id) VALUES (11, 6);

INSERT INTO trip_hotel(trip_id, hotel_id, begin_date, end_date) VALUES
    (6, 1, '2020-12-01', '2021-07-01'),
    (6, 5, '2021-07-01', '2021-12-15');


INSERT INTO movements(trip_id, departure_time, departure_address) VALUES
    (6,'2020-12-01 19:00:00 +3', 'seremetevo moscow russia'),--14
    (6,'2021-07-01 11:00:00 +0', 'sochi adler russia'),--15
    (6,'2021-12-15 13:00:00 +0', 'madrid spain espania')
    RETURNING *;



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











