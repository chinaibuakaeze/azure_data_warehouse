IF OBJECT_ID('dbo.payment') IS NOT NULL
BEGIN
    DROP TABLE payment
END

GO

IF OBJECT_ID('dbo.account') IS NOT NULL
BEGIN
    DROP TABLE account
END

GO;


IF OBJECT_ID('dbo.station') IS NOT NULL
BEGIN
    DROP TABLE station
END

GO;


IF OBJECT_ID('dbo.rider') IS NOT NULL
BEGIN
    DROP TABLE rider
END

GO;


IF OBJECT_ID('dbo.trip') IS NOT NULL
BEGIN
    DROP TABLE trip
END

GO;


CREATE TABLE payment (
	[payment_id] INT,
	[payment_date] DATE,
	[amount] FLOAT,
	[account_number] INT
	)
	
GO;

CREATE TABLE account(
    [account_number] INT,
    [member] BIT,
    [start_date] DATE,
    [end_date] DATE
)
GO;

CREATE TABLE station(
    [station_id] varchar(100),
    [name] varchar(100),
    [latitude] float,
    [longitude] float
)
GO;

CREATE TABLE rider(
    [rider_id] INT,
    [first_name] varchar(100),
    [last_name] varchar(100),
    [address] varchar(100),
    [birthday] DATE
)
GO;

CREATE TABLE trip(
    [trip_id] varchar(100),
    [rideable_type] varchar(100),
    [started_at] date,
    [ended_at] date,
    [start_station] varchar(100),
    [end_station] varchar(100),
    [station_id] varchar(100),
    [rider_id] INT,
    [account_number] INT,
    [payment_id] INT
)
GO;



INSERT INTO payment(payment_id, payment_date, amount, account_number)
SELECT C1, TRY_CONVERT(DATE, LEFT(C2, 10)) AS payment_date, C3, C4 FROM staging_payment

GO

INSERT INTO account(account_number, member, start_date, end_date)
SELECT C1, C8, TRY_CONVERT(Date, LEFT(C6, 10)) AS start_date, TRY_CONVERT(DATE, LEFT(C7, 10)) AS end_date FROM staging_rider

GO


INSERT INTO station(station_id, name, latitude, longitude)
SELECT C1, C2,  C3, C4 FROM staging_station

GO

INSERT INTO rider(rider_id, first_name, last_name, address, birthday)
SELECT C1, C2,  C3, C4, TRY_CONVERT(DATE, LEFT(C5, 10)) AS birthday FROM staging_rider
GO

INSERT INTO trip(trip_id, rideable_type, started_at, ended_at, start_station, end_station, station_id, rider_id, account_number, payment_id)
SELECT tr.C1, tr.C2, TRY_CONVERT(DATE, LEFT(tr.C3, 10)) AS started_at, TRY_CONVERT(DATE, LEFT(tr.C4, 10)) AS ended_at, 
tr.C5, tr.C6, tr.C5, tr.C7, r.C1, p.C1 
FROM staging_rider r 
INNER JOIN staging_payment p ON r.C1 = p.C4
INNER JOIN staging_trip tr ON tr.C7 = r.C1


GO;

SELECT TOP 5 * FROM trip
GO