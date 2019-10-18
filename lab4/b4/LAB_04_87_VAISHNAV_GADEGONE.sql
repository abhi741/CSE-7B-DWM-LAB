----------------------------------------QUERY-1-----------------------------------------------
/*Q1. Create individual b-tree indexes on the following columns of the table: customers_copy_btree  
(a)	cust_gender
(b)	cust_year_of_birth
(c)	cust_last_name
(d)	cust_street_address

How long does it take to create the indexes?
*/

SET TIMTNGS ON;
CREATE TABLE CUSTOMER_COPY_BTREE AS SELECT * FROM SH.CUSTOMERS;

CREATE INDEX CUST_GENDER_IDX ON CUSTOMER_COPY_BTREE(CUST_GENDER);
Index created.
Elapsed: 00:00:00.20

CREATE INDEX CUST_YEAR_OF_BIRTH_IDX ON CUSTOMER_COPY_BTREE(CUST_YEAR_OF_BIRTH);
Index created.
Elapsed: 00:00:00.07

CREATE INDEX CUST_LAST_NAME_IDX ON CUSTOMER_COPY_BTREE(CUST_LAST_NAME);
Index created.
Elapsed: 00:00:00.07

CREATE INDEX CUST_STREET_ADDRESS_IDX ON CUSTOMER_COPY_BTREE(CUST_STREET_ADDRESS);
Index created.
Elapsed: 00:00:00.12

----------------------------------------QUERY-2-----------------------------------------------
/*Q2. Create bitmap indexes on the above columns. How long does it take to create bitmap indexes? 
Compare it with the results of btree index creation.
*/
CREATE TABLE CUSTOMER_COPY_BITMAP AS SELECT * FROM SH.CUSTOMERS;

CREATE BITMAP INDEX CUST_GENDER_BP_IDX ON CUSTOMER_COPY_BITMAP(CUST_GENDER);
Index created.
Elapsed: 00:00:00.14

CREATE BITMAP INDEX CUST_YEAR_OF_BIRTH_BP_IDX ON CUSTOMER_COPY_BITMAP(CUST_YEAR_OF_BIRTH);
Index created.
Elapsed: 00:00:00.04

CREATE BITMAP INDEX CUST_LAST_NAME_BP_IDX ON CUSTOMER_COPY_BITMAP(CUST_LAST_NAME);
Index created.
Elapsed: 00:00:00.04

CREATE BITMAP INDEX CUST_STREET_ADDRESS_BP_IDX ON CUSTOMER_COPY_BITMAP(CUST_STREET_ADDRESS);
Index created.
Elapsed: 00:00:00.23

CREATE TABLE TEMP(C1 NUMBER(8),C2 NUMBER(3));

BEGIN 
	FOR I IN 1..2000000
	LOOP 
		INSERT INTO TEMP VALUES(I,MOD(I,2));
	END LOOP;
END;
/
CREATE INDEX TEMP_IDX ON TEMP(C2);
Index created.
Elapsed: 00:00:01.89

CREATE TABLE TEMP_BITMAP AS SELECT * FROM TEMP;
CREATE BITMAP INDEX TEMP_BMP_IDX ON TEMP_BITMAP(C2);	
Index created.
Elapsed: 00:00:00.59

----------------------------------------QUERY-3-----------------------------------------------
/*Q3. Do as directed:
(a)	Find the size of each segment: customers_copy_bitmap and customers_copy_btree
(b)	The b-tree index range for high and low cardinality address index.
(c)	The bitmap index range for high and low cardinality address index.
*/

SELECT SEGMENT_NAME, BYTES/1024/1024 "SIZE(MB)"
	FROM USER_SEGMENTS
	WHERE SEGMENT_NAME LIKE 'CUSTOMER_COPY%';
	
SEGMENT_NAME                     SIZE(MB)
------------------------------ ----------
CUSTOMER_COPY_BITMAP                   12
CUSTOMER_COPY_BTREE                    12

SELECT SEGMENT_NAME, BYTES/1024/1024 "SIZE(MB)"
	FROM USER_SEGMENTS
	WHERE SEGMENT_NAME LIKE '%IDX';
	
SEGMENT_NAME                     SIZE(MB)
------------------------------ ----------
CUST_GENDER_BP_IDX                  .0625
CUST_GENDER_IDX                      .875
CUST_LAST_NAME_BP_IDX                .125
CUST_LAST_NAME_IDX                      2
CUST_STREET_ADDRESS_BP_IDX              3
CUST_STREET_ADDRESS_IDX                 3
CUST_YEAR_OF_BIRTH_BP_IDX           .1875
CUST_YEAR_OF_BIRTH_IDX                  1
TEMP_BMP_IDX                          .75
TEMP_IDX                               30

----------------------------------------QUERY-4-----------------------------------------------
/*Q4. Use year of birth, which had 75 different values in our test data as filter column. 
Also show the execution indexes. plan for both indexes- btree and bitmap. 
Compare the cost of the execution plan for b-tree and bitmap 
*/

SET AUTOTRACE TRACEONLY;
SELECT * 
	FROM CUSTOMER_COPY_BTREE
	WHERE CUST_YEAR_OF_BIRTH = 1967;

956 rows selected.

Elapsed: 00:00:00.06

Execution Plan
----------------------------------------------------------
Plan hash value: 3274197328

-----------------------------------------------------------------------------------------
| Id  | Operation         | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                     |   956 |   278K|   406   (1)| 00:00:05 |
|*  1 |  TABLE ACCESS FULL| CUSTOMER_COPY_BTREE |   956 |   278K|   406   (1)| 00:00:05 |
-----------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter("CUST_YEAR_OF_BIRTH"=1967)

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
          0  recursive calls
          0  db block gets
       1519  consistent gets
          0  physical reads
          0  redo size
     145691  bytes sent via SQL*Net to client
       1043  bytes received via SQL*Net from client
         65  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
        956  rows processed
	
SELECT * 
	FROM CUSTOMER_COPY_BITMAP
	WHERE CUST_YEAR_OF_BIRTH = 1967;

956 rows selected.
Elapsed: 00:00:00.04

Execution Plan
----------------------------------------------------------
Plan hash value: 105116452

----------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name                      | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                           |   956 |   278K|   115   (0)| 00:00:02 |
|   1 |  TABLE ACCESS BY INDEX ROWID | CUSTOMER_COPY_BITMAP      |   956 |   278K|   115   (0)| 00:00:02 |
|   2 |   BITMAP CONVERSION TO ROWIDS|                           |       |       |            |          |
|*  3 |    BITMAP INDEX SINGLE VALUE | CUST_YEAR_OF_BIRTH_BP_IDX |       |       |            |          |
----------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   3 - access("CUST_YEAR_OF_BIRTH"=1967)

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
          0  recursive calls
          0  db block gets
        805  consistent gets
          0  physical reads
          0  redo size
     145691  bytes sent via SQL*Net to client
       1043  bytes received via SQL*Net from client
         65  SQL*Net roundtrips to/from client
          0  sorts (memory)
          0  sorts (disk)
        956  rows processed

----------------------------------------QUERY-5-----------------------------------------------
/*Q5. Show that update to the bitmap indexed column takes a bit longer than the b-tree indexed column. 
(a)	Create new indexes on cust_id column of btree and bitmap table.
(b)	Set the timing on
(c)	Write a PL/SQL procedure for each table as directed:
	i.	Create new columns-  upd_cust_id and cust_yob_value with number format.
	ii.	In loop of 5000 allot random values to both columns
	iii.set cust_year_of_birth = cust_yob_value and consider cust_id = upd_cust_id
(d)	What is the size of the indexes  compared to the size as before the updates took place.
*/

CREATE INDEX CUST_ID_IDX ON CUSTOMER_COPY_BTREE(CUST_ID);
Index created.
Elapsed: 00:00:00.09

CREATE BITMAP INDEX CUST_ID_BP_IDX ON CUSTOMER_COPY_BITMAP(CUST_ID);
Index created.
Elapsed: 00:00:00.20

DECLARE 
	CUST_YOB NUMBER(4);
	UDT_ID NUMBER(5);
BEGIN
	FOR I IN 1..5000
	LOOP
		UDT_ID := DBMS_RANDOM.VALUE(1,55000);
		CUST_YOB := DBMS_RANDOM.VALUE(1900,2000);
		UPDATE CUSTOMER_COPY_BTREE
			SET CUST_YEAR_OF_BIRTH = CUST_YOB
			WHERE CUST_ID = UDT_ID;
	END LOOP;
END;
/
PL/SQL procedure successfully completed.
Elapsed: 00:00:00.51

DECLARE 
	CUST_YOB NUMBER(4);
	UDT_ID NUMBER(5);
BEGIN
	FOR I IN 1..5000
	LOOP
		UDT_ID := DBMS_RANDOM.VALUE(1,55000);
		CUST_YOB := DBMS_RANDOM.VALUE(1900,2000);
		UPDATE CUSTOMER_COPY_BITMAP
			SET CUST_YEAR_OF_BIRTH = CUST_YOB
			WHERE CUST_ID = UDT_ID;
	END LOOP;
END;
/
PL/SQL procedure successfully completed.
Elapsed: 00:00:01.43

SELECT SEGMENT_NAME, BYTES/1024/1024 "SIZE(MB)"
	FROM USER_SEGMENTS
	WHERE SEGMENT_NAME LIKE 'CUST_ID%IDX';

SEGMENT_NAME                     SIZE(MB)
------------------------------ ----------
CUST_ID_BP_IDX                          2
CUST_ID_IDX                             2

----------------------------------------QUERY-6-----------------------------------------------
/*Q6. Comparison of time for index creation for normal bitmap index and join bitmap index.
Do as directed:
a)	Create table customers_bijx_test_bitmap from customers & sales_bijx_test_bitmap as from sales
b)	create bitmap index sales_bijx_test_bitmap_bix1 on sales_bijx_test_bitmap table and cust_id column, and bitmap index cust_bijx_test_bitmap_bix1 on customers_bijx_test_bitmap table and cust_last_name column.
       What is the elapsed time for each index creation?
c)	Create table customers_bijx_test_bitjoin from customers and Create table sales_bijx_test_bitjoin from customers and add constraint of primary key to cust_id column of  cust_bijx_test_bitjoin table.
d)	(a) create bitmap index named sales_bijx_test_bitjoin_bjx1 using sales_bijx_test_bitjoin & customers_bijx_test_bitjoin.cust_id tables.
	(b) create bitmap index named sales_bijx_test_bitjoin_bjx2 using tables sales_bijx_test_bitjoin and customers_bijx_test_bitjoin.cust_last_name
		Conclude which index creation takes more time.
*/

CREATE TABLE CUSTOMERS_BIJX_TEST_BITMAP AS SELECT * FROM SH.CUSTOMERS;
Table created.
Elapsed: 00:00:00.37

CREATE TABLE SALES_BIJX_TEST_BITMAP AS SELECT * FROM SH.SALES;
Table created.
Elapsed: 00:00:01.81

SELECT COUNT(*) FROM CUSTOMERS_BIJX_TEST_BITMAP;
  COUNT(*)
----------
     55500
	 
SELECT COUNT(*) FROM SALES_BIJX_TEST_BITMAP;
  COUNT(*)
----------
    918843	 

CREATE BITMAP INDEX SALES_BIJX_TEST_BITMAP_BIXL ON SALES_BIJX_TEST_BITMAP(CUST_ID);
Index created.
Elapsed: 00:00:00.57

CREATE BITMAP INDEX CUST_BIJX_TEST_BITMAP_BIXL ON CUSTOMERS_BIJX_TEST_BITMAP(CUST_LAST_NAME);
Index created.
Elapsed: 00:00:00.14

CREATE TABLE CUSTOMERS_BIJX_TEST_BITJOIN AS SELECT * FROM SH.CUSTOMERS;
CREATE TABLE SALES_BIJX_TEST_BITJOIN AS SELECT * FROM SH.SALES;

ALTER TABLE CUSTOMERS_BIJX_TEST_BITJOIN
	ADD CONSTRAINTS CUSTOMERS_BIJX_TEST_BITJOIN_PK PRIMARY KEY (CUST_ID);
	
CREATE BITMAP INDEX SALES_BIJX_TEST_BITMAP_BJXL ON SALES_BIJX_TEST_BITJOIN(CUSTOMERS_BIJX_TEST_BITJOIN.CUST_ID)
	FROM SALES_BIJX_TEST_BITJOIN, CUSTOMERS_BIJX_TEST_BITJOIN
	WHERE SALES_BIJX_TEST_BITJOIN.CUST_ID = CUSTOMERS_BIJX_TEST_BITJOIN.CUST_ID;
Index created.
Elapsed: 00:00:01.89

CREATE BITMAP INDEX SALES_BIJX_TEST_BITMAP_BJXL2 ON SALES_BIJX_TEST_BITJOIN(CUSTOMERS_BIJX_TEST_BITJOIN.CUST_LAST_NAME)
	FROM SALES_BIJX_TEST_BITJOIN, CUSTOMERS_BIJX_TEST_BITJOIN
	WHERE SALES_BIJX_TEST_BITJOIN.CUST_ID = CUSTOMERS_BIJX_TEST_BITJOIN.CUST_ID;
Index created.
Elapsed: 00:00:01.17

----------------------------------------QUERY-7-----------------------------------------------
/*Q7. Compressed Index: 
1. Create table Student(StudId, StudName) 
2. Add 10 Rows 
3. Define Index on StudName(First Name and Last Name) 
4. Get the Statistics of Index 
5. Now add about 10000 rows that will have same last name 
6. Get the Statistics of Index 
7. Drop Index 
8. Create Compressed Index 
9. Get the Statistics of Index 
10. Compare statics and give your comments
*/

CREATE TABLE STUDENT(
	STUDID NUMBER(5),
	STUDNAME VARCHAR2(30));
	
INSERT INTO STUDENT VALUES(1,'Johny Depp');
INSERT INTO STUDENT VALUES(2,'Sarah Pawlin');
INSERT INTO STUDENT VALUES(3,'Christy Martin');
INSERT INTO STUDENT VALUES(4,'Joe Smith');
INSERT INTO STUDENT VALUES(5,'Johny Boy');
INSERT INTO STUDENT VALUES(6,'Greg Toy');
INSERT INTO STUDENT VALUES(7,'Julian Clara');
INSERT INTO STUDENT VALUES(8,'Abid Malik');
INSERT INTO STUDENT VALUES(9,'Anthony Quinn');
INSERT INTO STUDENT VALUES(10,'Jim Craker');

CREATE INDEX STUDENT_IDX ON STUDENT(STUDNAME);
Index created.
Elapsed: 00:00:00.01

SELECT 
  COMPRESSION,
  LEAF_BLOCKS,
  Round(NUM_ROWS/Decode(LEAF_BLOCKS,0,1,LEAF_BLOCKS)) "ROWS PER BLOCK",   DISTINCT_KEYS,
  NUM_ROWS,NUM_ROWS-DISTINCT_KEYS DUP_ROWS 
FROM 
  USER_INDEXES 
WHERE
   INDEX_NAME = 'STUDENT_IDX'; 

COMPRESS LEAF_BLOCKS ROWS PER BLOCK DISTINCT_KEYS   NUM_ROWS   DUP_ROWS
-------- ----------- -------------- ------------- ---------- ----------
DISABLED           1             10            10         10          0
Elapsed: 00:00:00.00


DECLARE 
	v_a NUMBER;
BEGIN 
	v_a := 11;
	WHILE v_a < 10000
	LOOP
	INSERT INTO STUDENT VALUES(v_a,'Smith');
	v_a := v_a + 1;
	END LOOP;
	COMMIT;
END; 
/
PL/SQL procedure successfully completed.
Elapsed: 00:00:00.42

EXEC DBMS_STATS.gather_table_stats('CS1687', 'STUDENT');
SELECT 
  COMPRESSION,
  LEAF_BLOCKS,
  Round(NUM_ROWS/Decode(LEAF_BLOCKS,0,1,LEAF_BLOCKS)) "ROWS PER BLOCK",   DISTINCT_KEYS,
  NUM_ROWS,NUM_ROWS-DISTINCT_KEYS DUP_ROWS 
FROM 
  USER_INDEXES 
WHERE
   INDEX_NAME = 'STUDENT_IDX'; 
   
COMPRESS LEAF_BLOCKS ROWS PER BLOCK DISTINCT_KEYS   NUM_ROWS   DUP_ROWS
-------- ----------- -------------- ------------- ---------- ----------
DISABLED          34            294            11       9999       9988

Elapsed: 00:00:00.00

DROP INDEX STUDENT_IDX;

CREATE INDEX STUDENT_IDX ON STUDENT(STUDNAME) COMPRESS;

SELECT 
  COMPRESSION,
  LEAF_BLOCKS,
  Round(NUM_ROWS/Decode(LEAF_BLOCKS,0,1,LEAF_BLOCKS)) "ROWS PER BLOCK",   DISTINCT_KEYS,
  NUM_ROWS,NUM_ROWS-DISTINCT_KEYS DUP_ROWS 
FROM 
  USER_INDEXES 
WHERE
   INDEX_NAME = 'STUDENT_IDX'; 

COMPRESS LEAF_BLOCKS ROWS PER BLOCK DISTINCT_KEYS   NUM_ROWS   DUP_ROWS
-------- ----------- -------------- ------------- ---------- ----------
ENABLED           16            625            11       9999       9988
Elapsed: 00:00:00.00

----------------------------------------QUERY-8-----------------------------------------------
/*Q8.Function Based Indexes: 
1. Create function based index on Employee table of HR schema. Function should be on salary attribute based on commission percentage. Find out list of employees having commission percentage less than 50000. 
2. Create function based index on employee name for Upper and lower function. 
3. Create user table with attributes (UserId, UserName, Gender) 
4. Insert 10000 records in user table 
5. Build regular index on Username 
6. Build function based index on user name based on Upper function 
7. Compare the response time and comment.  
*/

CREATE INDEX EMPLOYEE_FBIDX ON HR.EMPLOYEES(SALARY*COMMISSION_PCT);
Index created.
Elapsed: 00:00:00.01

SELECT EMPLOYEE_ID, FIRST_NAME||' '||LAST_NAME AS "NAME", SALARY*COMMISSION_PCT AS "SALARY"
	FROM HR.EMPLOYEES
	WHERE SALARY*COMMISSION_PCT<50000;

EMPLOYEE_ID NAME                                               SALARY
----------- ---------------------------------------------- ----------
        173 Sundita Kumar                                         610
        167 Amit Banda                                            620
        179 Charles Johnson                                       620
        166 Sundar Ande                                           640
        165 David Lee                                             680
        164 Mattea Marvins                                        720
        155 Oliver Tuvault                                       1050
        178 Kimberely Grant                                      1050
        172 Elizabeth Bates                                      1095
        171 William Smith                                        1110
        163 Danielle Greene                                      1425

EMPLOYEE_ID NAME                                               SALARY
----------- ---------------------------------------------- ----------
        154 Nanette Cambrault                                    1500
        153 Christopher Olsen                                    1600
        177 Jack Livingston                                      1680
        176 Jonathon Taylor                                      1720
        161 Sarath Sewall                                        1750
        170 Tayler Fox                                           1920
        169 Harrison Bloom                                       2000
        149 Eleni Zlotkey                                        2100
        175 Alyssa Hutton                                        2200
        152 Peter Hall                                           2250
        160 Louise Doran                                         2250

EMPLOYEE_ID NAME                                               SALARY
----------- ---------------------------------------------- ----------
        151 David Bernstein                                      2375
        159 Lindsey Smith                                        2400
        162 Clara Vishney                                        2625
        168 Lisa Ozer                                            2875
        150 Peter Tucker                                         3000
        158 Allan McEwen                                         3150
        148 Gerald Cambrault                                     3300
        174 Ellen Abel                                           3300
        157 Patrick Sully                                        3325
        156 Janette King                                         3500
        147 Alberto Errazuriz                                    3600

EMPLOYEE_ID NAME                                               SALARY
----------- ---------------------------------------------- ----------
        146 Karen Partners                                       4050
        145 John Russell                                         5600
35 rows selected.
Elapsed: 00:00:00.01

CREATE INDEX EMPLOYEES_FBI_UPPER ON HR.EMPLOYEES(UPPER(FIRST_NAME),LOWER(LAST_NAME));
Index created.
Elapsed: 00:00:00.00

CREATE TABLE USERS(
	USERID NUMBER(5),
	USERNAME VARCHAR2(30),
	GENDER VARCHAR2(1));

BEGIN 
	FOR I IN 1..10000
	LOOP
		IF(I<5001) THEN
			INSERT INTO USERS VALUES(I,'Vaishnav Gadegone','M');
		ELSE
			INSERT INTO USERS VALUES(I,'Swaroop Prajapati','M');
		END IF;
	END LOOP;
END;
/

CREATE INDEX USERS_IDX ON USER(USERNAME);
Index created.
Elapsed: 00:00:00.03

SELECT COUNT(*) 
	FROM USERS
	WHERE UPPER(USERNAME) LIKE 'VAI%';

CREATE INDEX USERS_FBI_UPPER ON USERS(UPPER(USERNAME));
Index created.
Elapsed: 00:00:00.03


