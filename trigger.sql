-- Тригер для проверки дат отеля в рамках путешествия

CREATE OR REPLACE FUNCTION assertWrongHotelInterval()
RETURNS TRIGGER AS $$
    BEGIN
        IF  (
            NEW.begin_date > (SELECT begin_date FROM trips WHERE trip_id = NEW.trip_id)
            AND
            NEW.end_date < (SELECT end_date FROM trips WHERE trip_id = NEW.trip_id)
            ) THEN RETURN NEW;
        END IF;
        RETURN OLD;
    END;

$$ LANGUAGE plpgsql;


CREATE TRIGGER check_dates
BEFORE INSERT OR UPDATE on trip_hotel
FOR EACH ROW
EXECUTE PROCEDURE assertWrongHotelInterval();


TABLE trip_hotel;
TABLE trips;

update trip_hotel SET begin_date = '2000-11-14' WHERE trip_id=1 and hotel_id=3 returning *;

