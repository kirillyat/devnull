--TRIP SQL BILDER

--CLEAR CURRENT DATABASE FOR NEW TABLES AND TYPES
DROP TABLE IF EXISTS trip_movement;
DROP TABLE IF EXISTS trip_client;
DROP TABLE IF EXISTS trip_hotel;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS movements;
DROP TABLE IF EXISTS clients_documents;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS hotels;

DROP TYPE IF EXISTS SEX_ENUM;

-- CREATE TYPES

CREATE TYPE SEX_ENUM AS ENUM('male', 'female');

-- DESCRIPTION OF NEW TABLES

CREATE TABLE trips (
    trip_id SERIAL,
    cost integer CHECK (cost > 0),
    begin_date date,
    end_date date CHECK (end_date >= begin_date),

    PRIMARY KEY(trip_id)
);

CREATE TABLE clients (
    client_id SERIAL,
    full_name text NOT NULL,
    sex sex_enum NOT NULL,
    email varchar(50) CHECK(email LIKE '%_@__%.__%' AND email NOT LIKE '%[!@#$%^&*(){};:?/%~§±+=]%') NOT NULL,
    phone varchar(12) CHECK (phone not like '%[^0-9]%'),

    PRIMARY KEY(client_id)
);

CREATE TABLE clients_documents (
    client_id integer,
    nationality varchar(3) DEFAULT 'RUS',
    international_passport integer,
    local_passport text,
    birth_certificate text,

    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

CREATE TABLE trip_client (
    client_id integer,
    trip_id integer,

    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (trip_id) REFERENCES trips(trip_id)
);

CREATE TABLE movements (
    movement_id SERIAL,
    departure_time timestamp NOT NULL,
    departure_address text NOT NULL,

    PRIMARY KEY(movement_id)
);

CREATE TABLE trip_movement (
    trip_id integer,
    movement_id integer,

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (movement_id) REFERENCES movements(movement_id)
);


CREATE TABLE hotels (
    hotel_id SERIAL,
    name text,
    address text,
    email varchar(50) CHECK(email LIKE '%_@__%.__%' AND email NOT LIKE '%[!@#$%^&*(){};:?/%~§±+=]%'),
    phone varchar(12) CHECK (phone not like '%[^0-9]%'),

    PRIMARY KEY(hotel_id)
);


CREATE TABLE trip_hotel (
    trip_id integer,
    hotel_id integer,
    begin_date date,
    end_date date CHECK (end_date >= begin_date),

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
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
    (2, '771233112', NULL, NULL),
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
	('casino & hotel', 'Las-Vagas, USA', 'money@here.us', '+11881231212')--7
;

INSERT INTO
	trips(cost, begin_date, end_date)
VALUES
	(10000, '2020-11-14', '2021-12-15'),--1
	(1000, '2020-10-01', '2020-10-10'),--2
	(900, '2020-12-12', '2020-12-22'),--3
	(2200, '2022-02-12', '2022-02-20'),--4
	(6000, '2021-06-01', '2021-07-01')--5
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
    movements(departure_time, departure_address)
VALUES
    ('2020-11-14 09:00:00 +3', 'seremetevo moscow russia'),
    ('2021-01-01 21:00:00 +0', 'hitrow london UK'),
    ('2021-12-15 08:30:00 +1', 'orsa paris france'),
    ('2020-10-01 18:30:00 +7', 'omsk airport russia'),
    ('2020-10-10 06:30:00 +3', 'seremetevo moscow russia'),
    ('2020-12-12 08:30:00 +1', 'pulkovo sankt piterburg'),
    ('2020-12-18 20:30:00 +5', 'sochi adler airport russia'),
    ('2020-12-22 20:00:00 +9', 'railway cantrale Madrid, SPAIN'),
    ('2022-02-12 10:30:00 +6', 'san-francisco center bus station usa'),
    ('2022-02-20 18:10:00 +4', 'las-vegas shattel bus stop#12 usa'),
    ('2021-06-01 08:10:00 +3', 'orsa paris france'),
    ('2021-06-21 23:50:00 +4', 'antaliya center railway'),
    ('2021-07-01 18:10:00 +4', 'vnukovo airport russia')
;

INSERT INTO
    trip_movement(trip_id, movement_id)
VALUES
    (1, 1), (1, 2), (1,3),
    (2, 4), (2, 5),
    (3, 6), (3, 7), (3, 8),
    (4, 9), (4, 10),
    (5, 11), (5, 12), (5, 13)
;
