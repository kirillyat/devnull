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