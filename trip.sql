--CLEAR CURRENT DATABASE FOR NEW TABLES AND TYPES
DROP TABLE IF EXISTS trip_movement;
DROP TABLE IF EXISTS trip_client;
DROP TABLE IF EXISTS hotel_trip;
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


CREATE TABLE hotel_trip (
    hotel_id integer,
    trip_id integer,
    begin_date date,
    end_date date CHECK (end_date >= begin_date),

    FOREIGN KEY (trip_id) REFERENCES trips(trip_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)


);


INSERT INTO
	clients(full_name, sex, email, phone)
VALUES
	('VARLAMOV ILYA OLEGOVITCH', 'male', 'varlamov@lifejornal.ru', '+79990009977'),
	('KATZ MAXIM ANATOLIEVITCH', 'male', 'maxkatz@apple.ru', '+79990001100'),
	('IVANOV IVAN IVANOVITCH', 'male', 'ivanov@yandex.ru', '+79991112233'),
	('IVANOVA IRINA ALEXANDROVNA', 'female', 'iraIvanova@mail.ru', '+79991112244'),
	('IVANOV MAXIM IVANOVITCH', 'male', 'maxIVAN@gmail.com', '+79990009988'),
	('LEBEDEV ARTEMIY TATYANICTH', 'male', 'tema@tema.ru', '+77777777777'),
	('COLUMB CRICTOFOR', 'male', 'open@world.es', '+27777777777'),
	('YATSENKO KIRILL SERGEEVITCH', 'male', 'kirillyat@yandex.ru', '+79260093757'),
	('ROBOTIKOV IVAN ALEXANDROVITCH', 'male', 'robot@mail.ru', '+78881231212'),
	('TUTCHEVA IRINA VLADIMIROVNA', 'female', 'tut@tyt.by', '+68881112233')
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
