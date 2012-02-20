-- Run like this:
-- psql -At -Uwdb wdb < create_norwegian_load_list.sql | grep -v SELECT > destination.file.txt

SELECT wci.begin('wdb', 88,456,88);

SELECT 
       placeid INTO TEMP TABLE place 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
      placename::int >= 1000 AND 
      placename::int <= 2000;



SELECT wci.begin('wdb', 88, 123, 88);

SELECT 
       placename 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
      placeid in (SELECT placeid FROM place);
