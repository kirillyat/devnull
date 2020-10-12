SELECT locktype, relation::regclass, mode, granted from pg_locks;

--взаимо блокировка
--1
--begin;
--SELECT pg_advisory_lock(13);
--SELECT pg_advisory_lock(42);
--commit;
--2
--begin;
--SELECT pg_advisory_lock(42);
--SELECT pg_advisory_lock(13);
--commit;

 -- SERIALIZE (ERROR: could not serialize access due to concurrent update)

update clients set sex = 'male' where full_name = 'ROTEN ILYA EGOVITCH';

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    update clients set sex = 'female' where full_name = 'ROTEN ILYA EGOVITCH';
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SELECT * FROM clients WHERE sex = 'female';
    SELECT * FROM clients WHERE sex = 'female';
COMMIT;



-- REPEATABLE READ
update clients set sex = 'male' where full_name = 'ROTEN ILYA EGOVITCH';

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    update clients set sex = 'female' where full_name = 'ROTEN ILYA EGOVITCH';
COMMIT;



BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT * FROM clients WHERE full_name = 'ROTEN ILYA EGOVITCH';
    SELECT * FROM clients WHERE sex = 'female';
SELECT * FROM clients WHERE sex = 'female';
    SELECT * FROM clients WHERE full_name = 'ROTEN ILYA EGOVITCH';
COMMIT;



--READ (UN)COMMITTED
DELETE from clients WHERE full_name = 'ERSHOVA IRINA ALEXANDROVA';
--
update clients set sex = 'male' where full_name = 'ROTEN ILYA EGOVITCH';

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    update clients set sex = 'female' where full_name = 'ROTEN ILYA EGOVITCH';
COMMIT;



BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT * FROM clients WHERE full_name = 'ROTEN ILYA EGOVITCH';
    SELECT * FROM clients WHERE sex = 'female';
SELECT * FROM clients WHERE sex = 'female';
    SELECT * FROM clients WHERE full_name = 'ROTEN ILYA EGOVITCH';
COMMIT;

--

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    TABLE clients;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    INSERT INTO clients(full_name, sex, email, phone)
    VALUES ('ERSHOVA IRINA ALEXANDROVA', 'female', 'auul@yaaaa.ruu', '+00001112233') returning *;
ROLLBACK ;
