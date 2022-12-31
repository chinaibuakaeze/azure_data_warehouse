import psycopg2, csv

#Update connection string information with host, user, and password
host = "bikedata.postgres.database.azure.com"
user = "china"
password = "bebe1234!"
sslmode = "require"
dbname = "postgres"

#Construct connection string
conn_string = "host={0} user={1} dbname={2} password={3} sslmode={4}".format(host, user, dbname, password, sslmode)
conn = psycopg2.connect(conn_string)
print("Connection established")

#Connect to postgres database
cur = conn.cursor()
conn.set_session(autocommit=True)

#DROP previous tables if they exist
cur.execute("DROP TABLE IF EXISTS rider, payment, station, trip")

#Create new tables
cur.execute("CREATE TABLE IF NOT EXISTS rider(rider_id INTEGER PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(50), \
    address VARCHAR(100), birthday DATE, account_start_date DATE, account_end_date DATE, is_member BOOLEAN)")
cur.execute("CREATE TABLE IF NOT EXISTS payment(payment_id INTEGER PRIMARY KEY, date DATE, amount MONEY, rider_id INTEGER)")
cur.execute("CREATE TABLE IF NOT EXISTS station(station_id VARCHAR(50) PRIMARY KEY, name VARCHAR(75), \
    latitude FLOAT, longitude FLOAT)")
cur.execute("CREATE TABLE IF NOT EXISTS trip(trip_id VARCHAR(50) PRIMARY KEY, rideable_type VARCHAR(75), \
    start_at TIMESTAMP, ended_at TIMESTAMP, start_station_id VARCHAR(50), end_station_id VARCHAR(50), rider_id INTEGER)")

#load data into station table
query = "INSERT INTO station(station_id, name, latitude, longitude) VALUES(%s, %s, %s, %s)"
with open('./data/stations.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile)
    for line in csvreader:
        cur.execute(query, (line[0], line[1], line[2], line[3]))
print("Station table populated")

"""Use copy_from for loading the remaining tables for faster load since the table rows are in millions"""
#load data into rider table
with open ('./data/riders.csv', 'r') as riderfile:
    cur.copy_from(riderfile,'rider', sep=",", null="")
print("Rider table populated")

#load data into payment table
with open('./data/payments.csv', 'r') as payfile:
    cur.copy_from(payfile,'payment', sep=",", null = "")
print("Payment table populated")

#load data into trip table
with open ('./data/trips.csv', 'r') as tripfile:
    cur.copy_from(tripfile,'trip', sep=",", null = "")
print("Trip table populated")

cur.close()
conn.close()