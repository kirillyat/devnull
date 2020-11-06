-- LAB 3.3
SET LC_MONETARY = "en_US.UTF-8";

-- Функции

--1

CREATE OR REPLACE FUNCTION apartament_average_mark(apart_id apartaments.apartament_id%TYPE) returns numeric AS
    $$
    WITH apart_books AS ( SELECT client_feedback FROM bookings WHERE apartament_id = apart_id)
    SELECT avg(stars) FROM (SELECT int4(client_feedback->>'stars') AS stars FROM apart_books) AS marks;
    $$ language sql;


select apartament_average_mark(1); --4.5 (1 m 29 s 787 ms)

select  int4('1') + 1;


--2

DROP FUNCTION client_average_mark;

CREATE OR REPLACE FUNCTION client_average_mark(id clients.client_id%TYPE) returns numeric AS
    $$
    WITH apart_books AS (
        SELECT owner_feedback FROM bookings WHERE apartament_id = client_id
    )
    SELECT avg(stars) FROM (SELECT int4(owner_feedback->>'stars') AS stars FROM apart_books) AS marks;
    $$ language sql;


select client_average_mark(1);-- 4.25 (1.30m)

--3

drop function  client_most_expensive_holiday(id clients.client_id%TYPE);

CREATE OR REPLACE FUNCTION client_most_expensive_holiday(id clients.client_id%TYPE,
                                                        OUT max_cost numeric,
                                                        OUT book_id bookings.bookind_id%TYPE)
AS
$$
    DECLARE
        r bookings%ROWTYPE;
        cost numeric = 0;
    BEGIN
    max_cost = 0;

    FOR r IN (SELECT * FROM bookings WHERE bookings.client_id = id) LOOP
        cost = (EXTRACT(second from r.duration))*((select cost_per_day::numeric from apartaments where apartament_id = r.apartament_id));
        IF cost > max_cost THEN
            max_cost = cost;
            book_id = r.bookind_id;
        END IF;
    END LOOP;
    RETURN;
    END;
$$ LANGUAGE plpgsql;

SELECT max_cost::money, book_id from client_most_expensive_holiday(3);-- "$1,161.00",36867940 [15s]

--4

CREATE OR REPLACE FUNCTION apart_reviws(id apartaments.apartament_id%TYPE)  RETURNS refcursor AS
$$
DECLARE
    ref refcursor;
BEGIN
    OPEN ref FOR (
      SELECT int4(client_feedback->>'stars') as STARS, client_feedback->>'review' AS REVIEW FROM bookings WHERE bookings.apartament_id = id
    );
    RETURN ref;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION i_rew(i integer, a apartaments.apartament_id%TYPE) returns text as
    $$
    DECLARE
        rez text;
        s integer;
        ref  refcursor;
    BEGIN
        ref = apart_reviws(a);
        FOR index in 0..i loop
            move ref;
        end loop;
        fetch ref into s, rez;
        return rez;
    END;
    $$ language plpgsql;

select i_rew(0,18283); -- Полнотиповое программирование — стиль программирования, отличающийся обширным использованием информации о типах с тем, чтобы механизм проверки согласования типов обеспечил раннее выявление максимального количества всевозможных разновидностей багов.


--5


CREATE OR REPLACE FUNCTION client_all_money(id clients.client_id%TYPE) RETURNS money AS
    $$
    DECLARE
        total numeric = 0;
        book record;
    BEGIN
    FOR book in (SELECT * FROM bookings WHERE client_id = id) LOOP
        total = total + EXTRACT(second from book.duration)*(select cost_per_day::numeric from apartaments where apartament_id = book.apartament_id);
    END LOOP;
    RETURN total::money;
    END;
    $$ LANGUAGE plpgsql;

select client_all_money(1);-- $7,955.00 [15s]



--6

drop function chec_price(a apartaments.apartament_id%TYPE);

CREATE OR REPLACE FUNCTION chec_price(a apartaments.apartament_id%TYPE, out rez numeric) as
$$

    begin
            select cost_per_day::numeric  into STRICT rez FROM apartaments where apartament_id = a;
            EXCEPTION
                when no_data_found THEN
                 raise exception 'NOT FOUNDddddddd';
                when too_many_rows then
                raise exception 'too many rowssss';
    end;
$$language plpgsql;


select chec_price(1);

select chec_price(-1)
