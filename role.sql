-- LAB 3.2

--ПРЕДСТАВЛЕНИЯ
CREATE OR REPLACE VIEW city_client AS
    WITH cliets_bookings AS (
        SELECT client_id, fullname, apartament_id
        FROM
            clients inner join bookings
        USING (client_id)
    ), pre_rez AS (
        SELECT client_id, fullname, city
        FROM cliets_bookings
                 inner join apartaments USING (apartament_id)
    ) SELECT client_id, fullname, city, count(*) FROM pre_rez GROUP BY client_id, fullname, city;


CREATE  MATERIALIZED VIEW city_client_2 AS
    WITH bookings_city AS (
        SELECT client_id, city
        FROM
            bookings inner join apartaments
                using(apartament_id)

    ), pre_rez AS (
        SELECT client_id, fullname, city
        FROM bookings_city inner join clients USING (client_id)
    ) SELECT client_id, fullname, city, count(*) FROM pre_rez GROUP BY client_id, fullname, city;

table city_client_2; -- 25 s 353 ms

CREATE OR REPLACE VIEW city_n AS
    WITH bookings_city AS (
       SELECT bookind_id, city
        FROM
            bookings inner join apartaments
                using(apartament_id)
    ) SELECT city, count(*) FROM bookings_city group by bookind_id, city;

table city_n; -- 1 m 6 s 118 ms



CREATE OR REPLACE VIEW city_apartament AS
    SELECT city, apartament_id FROM apartaments;

table city_apartament;



--РОЛИ
REASSIGN OWNED BY test to kirillyat;
drop owned by test;
drop role test;

CREATE ROLE test LOGIN;

ALTER USER test WITH PASSWORD 't'; -- Сменить пароль для пользователя.

GRANT SELECT ON clients, owners TO test;
GRANT SELECT, UPDATE ON apartaments TO test;
GRANT SELECT, INSERT, UPDATE ON bookings TO test;


CREATE ROLE manager; -- 2ая роль
GRANT UPDATE(contact) on owners, clients TO manager;

-- Получили следущие привилегии
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE (table_name='owners' or table_name='clients')  and grantee='test';
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name='apartaments' and grantee='test';
SELECT grantee, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name='bookings' and grantee='test';


GRANT SELECT on city_apartament TO test;
GRANT manager to test;






-- текущая бд
SELECT current_database();

-- Все роли и их права
TABLE pg_roles;

-- Текущая роль
SELECT current_role;

-- Суперпользователи
SELECT rolname FROM pg_roles WHERE rolsuper;
