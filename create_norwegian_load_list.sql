-- Run like this:
-- psql -At -Uwdb wdb < create_norwegian_load_list.sql | grep -v SELECT > destination.file.txt

SELECT wci.begin('wdb', 88,4365,88);

SELECT 
       placeid INTO TEMP TABLE place 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
      placename::int >= 1000 AND 
      placename::int <= 2000;



SELECT wci.begin('wdb', 88, 88, 88);

SELECT 
       placename 
FROM 
     wci.getplacepoint(NULL) 
WHERE 
      placeid in (SELECT placeid FROM place);
