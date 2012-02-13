-- Run like this:
-- psql -At -Uwdb wdb < create_foreign_load_list.sql | grep '^[0-9]*$'

CREATE TEMP TABLE foreign_stations (wmo_no text, station text);
COPY foreign_stations FROM '/usr/share/parch_locationforecastLoad/foreign_stations.dat' CSV;

SELECT wci.begin('wdb', 88,4365,88);
SELECT 
       placeid INTO TEMP TABLE place 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
	placename in (
		SELECT wmo_no FROM foreign_stations
	);
	
SELECT wci.begin('wdb', 88, 88, 88);
SELECT 
       placename 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
      placeid in (SELECT placeid FROM place);
