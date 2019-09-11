--------------- PRACTICAL: 3 ------------------
/*
AIM : Write and Execute PARTITIONING TECHNIQUES.
*/

/*
NAME: SARTHAK BAISWAR
BATCH : B3
ROLL NO: 76
*/

-- QUERY 1
/*
Write a query to create range portioned table:
1. Creates a table named- Sales consisting of four partitions, one for each quarter of sales.
 The columns sale_year, sale_month, and sale_day are the partitioning columns,
 while their values constitute the partitioning key of a specific row.
2. Each partition is given a name (sales_q1, sales_q2, ...), and each partition is
contained in a separate tablespace (tsa, tsb, ...)
3. The columns for table must be prod_id, cust_id, promo_id, quantify sold,
 amount_sold – all in number format and time_id.
*/

CREATE TABLESPACE TSA DATAFILE 'C:\temp\tsa.dbf' SIZE 10M;

CREATE TABLESPACE TSB DATAFILE 'C:\temp\tsb.dbf' SIZE 10M;

CREATE TABLESPACE TSC DATAFILE 'C:\temp\tsc.dbf' SIZE 10M;

CREATE TABLESPACE TSD DATAFILE 'C:\temp\tsd.dbf' SIZE 10M;

CREATE TABLE SALES
	(PROD_ID NUMBER(6),
	CUST_ID NUMBER(6),
	TIME_ID DATE,
	PROMO_ID NUMBER(6),
	QTY_SOLD NUMBER(6),
	AMT_SOLD NUMBER(4,2)
	)
	PARTITION BY RANGE(TIME_ID)
	(PARTITION SALES_Q1 VALUES LESS THAN ('01-APR-2018') TABLESPACE TSA,
	PARTITION SALES_Q2 VALUES LESS THAN ('01-JUL-2018') TABLESPACE TSB,
	PARTITION SALES_Q3 VALUES LESS THAN ('01-OCT-2018') TABLESPACE TSC,
	PARTITION SALES_Q4 VALUES LESS THAN ('01-JAN-2019') TABLESPACE TSD
	);

  INSERT INTO SALES VALUES ('122','1111','01-JAN-2018','11',23,44.5);

  INSERT INTO SALES VALUES ('123','1111','15-DEC-2018','22',23,44.5);

  INSERT INTO SALES VALUES ('125','1111','29-APR-2018','33',23,44.5);

  INSERT INTO SALES VALUES ('197','1111','23-SEP-2018','44',23,44.5);


-- GATHER STATISTICS FOR PARTITIONS
	exec dbms_stats.gather_table_stats('SARTHAK','SALES');

  SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES';

/*
TABLE_NAME                     TABLESPACE_NAME                HIGH_VALUE
                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES                          TSA                            TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES                          TSB                            TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES                          TSC                            TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES                          TSD                            TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1

*/

SELECT * FROM SALES PARTITION(SALES_Q1);

/*
PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
    122       1111 01-JAN-18         11         23       44.5
*/
SELECT * FROM SALES PARTITION(SALES_Q2);

/*

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       125       1111 29-APR-18         33         23       44.5
*/

SELECT * FROM SALES PARTITION(SALES_Q3);

/*
PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
    197       1111 23-SEP-18         44         23       44.5
*/

SELECT * FROM SALES PARTITION(SALES_Q4);
/*
PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
    123       1111 15-DEC-18         22         23       44.5
*/

-- QUERY 2
/*
Create the same table as in Q1. With a different name with ENABLE ROW MOVEMENT
*/
CREATE TABLE SALES1
	(PROD_ID NUMBER(6),
	CUST_ID NUMBER(6),
	TIME_ID DATE,
	PROMO_ID NUMBER(6),
	QTY_SOLD NUMBER(6),
	AMT_SOLD NUMBER(4,2)
	)
	PARTITION BY RANGE(TIME_ID)
	(PARTITION SALES_Q1 VALUES LESS THAN ('01-APR-2018') TABLESPACE TSA,
	PARTITION SALES_Q2 VALUES LESS THAN ('01-JUL-2018') TABLESPACE TSB,
	PARTITION SALES_Q3 VALUES LESS THAN ('01-OCT-2018') TABLESPACE TSC,
	PARTITION SALES_Q4 VALUES LESS THAN ('01-JAN-2019') TABLESPACE TSD
	)
  ENABLE ROW MOVEMENT;

  -- ENABLE ROW MOVEMENT: IF DATA IN PARTITION CHANGE TO SOME OTHER

  INSERT INTO SALES1 VALUES ('122','1111','01-JAN-2018','11',23,44.5);

  INSERT INTO SALES1 VALUES ('123','1111','15-DEC-2018','22',23,44.5);

  INSERT INTO SALES1 VALUES ('125','1111','29-APR-2018','33',23,44.5);

  INSERT INTO SALES1 VALUES ('197','1111','23-SEP-2018','44',23,44.5);


  SELECT * FROM SALES1 PARTITION(SALES_Q1);

	SELECT * FROM SALES1 PARTITION(SALES_Q2);

	SELECT * FROM SALES1 PARTITION(SALES_Q3);

	SELECT * FROM SALES1 PARTITION(SALES_Q4);
/*
  SQL> SELECT * FROM SALES1 PARTITION(SALES_Q1);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       122       1111 01-JAN-18         11         23       44.5

SQL>
SQL> SELECT * FROM SALES1 PARTITION(SALES_Q2);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       125       1111 29-APR-18         33         23       44.5

SQL>
SQL> SELECT * FROM SALES1 PARTITION(SALES_Q3);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       197       1111 23-SEP-18         44         23       44.5

SQL>
SQL> SELECT * FROM SALES1 PARTITION(SALES_Q4);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       123       1111 15-DEC-18         22         23       44.5
       */


	UPDATE SALES1 SET TIME_ID='14-APR-2018' WHERE PROD_ID='122';

  /*
  SQL> SELECT * FROM SALES1 PARTITION(SALES_Q1);

  no rows selected

  SQL>
  SQL> SELECT * FROM SALES1 PARTITION(SALES_Q2);

     PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
  ---------- ---------- --------- ---------- ---------- ----------
         125       1111 29-APR-18         33         23       44.5
         122       1111 14-APR-18         11         23       44.5

  SQL>
  SQL> SELECT * FROM SALES1 PARTITION(SALES_Q3);

     PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
  ---------- ---------- --------- ---------- ---------- ----------
         197       1111 23-SEP-18         44         23       44.5

  SQL>
  SQL> SELECT * FROM SALES1 PARTITION(SALES_Q4);

     PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
  ---------- ---------- --------- ---------- ---------- ----------
         123       1111 15-DEC-18         22         23       44.5
  */

  exec dbms_stats.gather_table_stats('SARTHAK','SALES1');

  SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES1';

  /*
  SQL> exec dbms_stats.gather_table_stats('SARTHAK','SALES1');

  PL/SQL procedure successfully completed.

  SQL>
  SQL> SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES1';

  TABLE_NAME                     TABLESPACE_NAME                HIGH_VALUE                                                                         NUM_ROWS
  ------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
  SALES1                         TSA                            TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
  SALES1                         TSB                            TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          2
  SALES1                         TSC                            TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
  SALES1                         TSD                            TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
  */

-- QUERY 3
/*
CREATE TABLE WIH LIST PARITIONING.
*/

CREATE TABLE SALES_BY_LIST
      (DEPTNO NUMBER,
       DEPTNAME VARCHAR2(20),
       QUARTERLY_SALES NUMBER(10, 2),
       STATE VARCHAR2(2))
   PARTITION BY LIST (STATE)
      (PARTITION Q1_NORTHWEST VALUES ('OR', 'WA'),
       PARTITION Q1_SOUTHWEST VALUES ('AZ', 'UT', 'NM'),
       PARTITION Q1_NORTHEAST VALUES  ('NY', 'VM', 'NJ'),
	     PARTITION Q1_SOUTHEAST VALUES  ('FL','GA'),
	     PARTITION Q1_NORTHCENTRAL VALUES('SD','WI'),
       PARTITION Q1_SOUTHCENTRAL VALUES ('OK', 'TX'));

       INSERT INTO SALES_BY_LIST VALUES (10, 'ACCOUNTING', 100, 'WA');
       INSERT INTO SALES_BY_LIST VALUES (20, 'RND', 150, 'OR');
       INSERT INTO SALES_BY_LIST VALUES (30, 'SALES', 100, 'FL');
       INSERT INTO SALES_BY_LIST VALUES (40, 'HR', 10, 'TX');

       INSERT INTO SALES_BY_LIST VALUES (50, 'SYSTEMS_ENG', 10, 'CA'); -- CA NOT THERE

   /*
   SQL>        INSERT INTO SALES_BY_LIST VALUES (40, 'HR', 10, 'TX');

   1 row created.

   SQL> INSERT INTO SALES_BY_LIST VALUES (50, 'SYSTEMS_ENG', 10, 'CA');
   INSERT INTO SALES_BY_LIST VALUES (50, 'SYSTEMS_ENG', 10, 'CA')
               *
   ERROR at line 1:
   ORA-14400: inserted partition key does not map to any partition
   */

ALTER TABLE SALES_BY_LIST ADD PARTITION Q1_NEW_DEF VALUES(DEFAULT);--IF ANYOTHER VALUE THEN THIS PARTIOTN TAKES IT

INSERT INTO SALES_BY_LIST VALUES (50, 'SYSTEMS_ENG', 10, 'CA');

exec dbms_stats.gather_table_stats('SARTHAK','SALES_BY_LIST');

SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES_BY_LIST';

/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','SALES_BY_LIST');

PL/SQL procedure successfully completed.

SQL>
SQL> SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES_BY_LIST';

TABLE_NAME                     TABLESPACE_NAME                HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES_BY_LIST                  USERS                          'OR', 'WA'                                                                                2
SALES_BY_LIST                  USERS                          'AZ', 'UT', 'NM'                                                                          0
SALES_BY_LIST                  USERS                          'NY', 'VM', 'NJ'                                                                          0
SALES_BY_LIST                  USERS                          'FL', 'GA'                                                                                1
SALES_BY_LIST                  USERS                          'SD', 'WI'                                                                                0
SALES_BY_LIST                  USERS                          'OK', 'TX'                                                                                1
SALES_BY_LIST                  USERS                          DEFAULT                                                                                   1

7 rows selected.
*/

-- QUERY 4:
/*
CREATE TABLE WITH HASH PARTITIONS, NO OF PARTITIONS SHOULD BE 5. DEMONSTRATE USING SYSTEM AND USER DEFINED PARTITIONS.
*/
CREATE TABLE EMPLOYEE_HASH
 (EMP_NO NUMBER(6),
 EMP_JOB VARCHAR(2),
 EMP_SAL NUMBER(6),
 EMP_DEPTNO NUMBER(6))
 PARTITION BY HASH(EMP_NO) -- HASH ON EMP_NO
 PARTITIONS 5; -- NO. OF PARTITIONS

 INSERT INTO EMPLOYEE_HASH VALUES(1116,'AB',1,11);
 INSERT INTO EMPLOYEE_HASH VALUES(1212,'AX',1,12);
 INSERT INTO EMPLOYEE_HASH VALUES(1390,'AC',1,13);
 INSERT INTO EMPLOYEE_HASH VALUES(1413,'AD',1,14);
 INSERT INTO EMPLOYEE_HASH VALUES(1582,'AE',1,15);

 exec dbms_stats.gather_table_stats('SARTHAK','EMPLOYEE_HASH');

SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='EMPLOYEE_HASH';

-- SYSTEM DEFINED PARTITIONS USING HASH
/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','EMPLOYEE_HASH');

PL/SQL procedure successfully completed.

SQL>
SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='EMPLOYEE_HASH';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
EMPLOYEE_HASH                  SYS_P21                                                                                                                  2
EMPLOYEE_HASH                  SYS_P22                                                                                                                  2
EMPLOYEE_HASH                  SYS_P23                                                                                                                  1
EMPLOYEE_HASH                  SYS_P24                                                                                                                  0
EMPLOYEE_HASH                  SYS_P25                                                                                                                  0
*/

-- USER DEFINED
CREATE TABLE EMPLOYEE_HASH_USER
			(EMP_NO NUMBER(6),
			EMP_JOB VARCHAR(2),
			EMP_SAL NUMBER(6),
			EMP_DEPTNO NUMBER(6))
			PARTITION BY HASH(EMP_NO)
			(PARTITION P1,
			PARTITION P2,
			PARTITION P3,
			PARTITION P4,
			PARTITION P5
			);


			INSERT INTO EMPLOYEE_HASH_USER VALUES(1116,'AB',1,11);
			INSERT INTO EMPLOYEE_HASH_USER VALUES(1212,'AX',1,12);
			INSERT INTO EMPLOYEE_HASH_USER VALUES(1390,'AC',1,13);
			INSERT INTO EMPLOYEE_HASH_USER VALUES(1413,'AD',1,14);
			INSERT INTO EMPLOYEE_HASH_USER VALUES(1582,'AE',1,15);

			 exec dbms_stats.gather_table_stats('SARTHAK','EMPLOYEE_HASH_USER');

		SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='EMPLOYEE_HASH_USER';

/*
SQL>  exec dbms_stats.gather_table_stats('SARTHAK','EMPLOYEE_HASH_USER');

PL/SQL procedure successfully completed.

SQL>
SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='EMPLOYEE_HASH_USER';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
EMPLOYEE_HASH_USER             P1                                                                                                                       2
EMPLOYEE_HASH_USER             P2                                                                                                                       2
EMPLOYEE_HASH_USER             P3                                                                                                                       1
EMPLOYEE_HASH_USER             P4                                                                                                                       0
EMPLOYEE_HASH_USER             P5                                                                                                                       0
*/

-- QUERY 5:
/*
CREATE MULTI- COLUMN RANGE PARTTIONED TABLE
1. DATE WITH MONTH, YEAR, DAY AND AMOUNT SOLD
2. INSERT THE NECESSARY AND GIVEN VALUES AND PROVIDE CONCLUSION OVER IT
*/

CREATE TABLE DATE_TABLE
(
	YEAR NUMBER(4),
	MONTH NUMBER(2),
	DAY NUMBER(2),
	AMT_SOLD NUMBER(5)
)
PARTITION BY RANGE(YEAR,MONTH)  -- KEEP YEAR MONTH ELSE PARTITIONS WILL HAVE GAP
(
	PARTITION P1 VALUES LESS THAN (2001,1),
	PARTITION P2 VALUES LESS THAN (2001,4),
	PARTITION P3 VALUES LESS THAN (2001,7),
	PARTITION P4 VALUES LESS THAN (2001,10),
	PARTITION P5 VALUES LESS THAN (2002,1),
	PARTITION P6 VALUES LESS THAN (MAXVALUE,MAXVALUE)
);

INSERT INTO DATE_TABLE VALUES(2001,3,17,11);

INSERT INTO DATE_TABLE VALUES(2001,11,1,33);

INSERT INTO DATE_TABLE VALUES(2021,3,17,11); -- MAXVALUE

INSERT INTO DATE_TABLE VALUES(2002,1,1,11); -- UPPER BOUND WILL ALSO GO TO MAXVALUE

INSERT INTO DATE_TABLE VALUES(2001,3,17,2000);

INSERT INTO DATE_TABLE VALUES(2001,11,1,5000);

INSERT INTO DATE_TABLE VALUES(2002,1,1,4000);
 exec dbms_stats.gather_table_stats('SARTHAK','DATE_TABLE');

		SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='DATE_TABLE';


/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','DATE_TABLE');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='DATE_TABLE';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
DATE_TABLE                     P1                             2001, 1                                                                                   0
DATE_TABLE                     P2                             2001, 4                                                                                   2
DATE_TABLE                     P3                             2001, 7                                                                                   0
DATE_TABLE                     P4                             2001, 10                                                                                  0
DATE_TABLE                     P5                             2002, 1                                                                                   2
DATE_TABLE                     P6                             MAXVALUE, MAXVALUE                                                                        3

6 rows selected.
*/

SELECT * FROM DATE_TABLE PARTITION(P1);

SELECT * FROM DATE_TABLE PARTITION(P2);

SELECT * FROM DATE_TABLE PARTITION(P3);

SELECT * FROM DATE_TABLE PARTITION(P4);

SELECT * FROM DATE_TABLE PARTITION(P5);

SELECT * FROM DATE_TABLE PARTITION(P6);

/*
SQL> SELECT * FROM DATE_TABLE PARTITION(P1);

no rows selected

SQL>
SQL> SELECT * FROM DATE_TABLE PARTITION(P2);

      YEAR      MONTH        DAY   AMT_SOLD
---------- ---------- ---------- ----------
      2001          3         17         11
      2001          3         17       2000

SQL>
SQL> SELECT * FROM DATE_TABLE PARTITION(P3);

no rows selected

SQL>
SQL> SELECT * FROM DATE_TABLE PARTITION(P4);

no rows selected

SQL>
SQL> SELECT * FROM DATE_TABLE PARTITION(P5);

      YEAR      MONTH        DAY   AMT_SOLD
---------- ---------- ---------- ----------
      2001         11          1         33
      2001         11          1       5000

SQL>
SQL> SELECT * FROM DATE_TABLE PARTITION(P6);

      YEAR      MONTH        DAY   AMT_SOLD
---------- ---------- ---------- ----------
      2021          3         17         11
      2002          1          1         11
      2002          1          1       4000
*/

-- QUERY 6:
/*
CREATE MULTI COLUMN PARTITIONED INDEX SUCH THAT ALL PARTITIONS ARE EQUAL SIZED
*/

CREATE TABLE SUPPLIER
(
  SUP_ID NUMBER(6),
  P_NUM NUMBER(6),
  AMT_SOLD NUMBER(6)
)
PARTITION BY RANGE(SUP_ID,P_NUM)
(
  PARTITION P1 VALUES LESS THAN (5,100),
  PARTITION P2 VALUES LESS THAN (5,200),
  PARTITION P3 VALUES LESS THAN (10,50),
  PARTITION P4 VALUES LESS THAN (10,200),
  PARTITION P5_DEF VALUES LESS THAN (MAXVALUE,MAXVALUE)
);

INSERT INTO SUPPLIER VALUES (5,5,1000);

INSERT INTO SUPPLIER VALUES (5,150,1000);

INSERT INTO SUPPLIER VALUES (10,100,1000);


SELECT * FROM SUPPLIER PARTITION (P1);

SELECT * FROM SUPPLIER PARTITION (P2);

SELECT * FROM SUPPLIER PARTITION (P3);

SELECT * FROM SUPPLIER PARTITION (P4);

SELECT * FROM SUPPLIER PARTITION (P5_DEF);

/*
SQL> SELECT * FROM SUPPLIER PARTITION (P1);

    SUP_ID      P_NUM   AMT_SOLD
---------- ---------- ----------
         5          5       1000

SQL>
SQL> SELECT * FROM SUPPLIER PARTITION (P2);

    SUP_ID      P_NUM   AMT_SOLD
---------- ---------- ----------
         5        150       1000

SQL>
SQL> SELECT * FROM SUPPLIER PARTITION (P3);

no rows selected

SQL>
SQL> SELECT * FROM SUPPLIER PARTITION (P4);

    SUP_ID      P_NUM   AMT_SOLD
---------- ---------- ----------
        10        100       1000

SQL>
SQL> SELECT * FROM SUPPLIER PARTITION (P5_DEF);

no rows selected
*/

exec dbms_stats.gather_table_stats('SARTHAK','SUPPLIER');

  SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SUPPLIER';

/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','SUPPLIER');

PL/SQL procedure successfully completed.

SQL>
SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SUPPLIER';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SUPPLIER                       P1                             5, 100                                                                                    1
SUPPLIER                       P2                             5, 200                                                                                    1
SUPPLIER                       P3                             10, 50                                                                                    0
SUPPLIER                       P4                             10, 200                                                                                   1
SUPPLIER                       P5_DEF                         MAXVALUE, MAXVALUE                                                                        0
*/

-- QUERY 07:
/*
CREATE INTERVAL PARTITIONED TABLE. PERFORM PARTITION WITH THE INTERVAL OF 1 MONTHS
*/
CREATE TABLE SALES1
	(PROD_ID NUMBER(6),
	CUST_ID NUMBER(6),
	TIME_ID DATE,
	PROMO_ID NUMBER(6),
	QTY_SOLD NUMBER(6),
	AMT_SOLD NUMBER(4,2)
	)
	PARTITION BY RANGE(TIME_ID)
	INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
	(PARTITION SALES_Q1 VALUES LESS THAN ('01-APR-2018'),
	PARTITION SALES_Q2 VALUES LESS THAN ('01-JUL-2018'),
	PARTITION SALES_Q3 VALUES LESS THAN ('01-OCT-2018'),
	PARTITION SALES_Q4 VALUES LESS THAN ('01-JAN-2019')
	);


  INSERT INTO SALES1 VALUES ('122','1111','01-JAN-2018','11',23,44.5);

  INSERT INTO SALES1 VALUES ('123','1111','15-DEC-2018','22',23,44.5);

  INSERT INTO SALES1 VALUES ('125','1111','29-APR-2018','33',23,44.5);

  INSERT INTO SALES1 VALUES ('197','1111','23-SEP-2018','44',23,44.5);


  INSERT INTO SALES1 VALUES ('197','1111','23-FEB-2019','44',23,44.5);

  /*
  SQL>   INSERT INTO SALES1 VALUES ('197','1111','23-FEB-2019','44',23,44.5);

1 row created.
  */

  exec dbms_stats.gather_table_stats('SARTHAK','SALES1');

		SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES1';

/*
TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE
                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES1                         SALES_Q1                       TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES1                         SALES_Q2                       TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES1                         SALES_Q3                       TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES1                         SALES_Q4                       TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES1                         SYS_P61                        TO_DATE(' 2019-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
*/

SELECT * FROM SALES1 PARTITION(SYS_P61);

/*
SQL> SELECT * FROM SALES1 PARTITION(SYS_P61);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       197       1111 23-FEB-19         44         23       44.5
*/

INSERT INTO SALES1 VALUES ('198','1111','23-MAR-2019','44',23,44.5);

/*
TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE
         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES1                         SALES_Q1                       TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1
SALES1                         SALES_Q2                       TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1
SALES1                         SALES_Q3                       TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1
SALES1                         SALES_Q4                       TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1
SALES1                         SYS_P61                        TO_DATE(' 2019-03-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1
SALES1                         SYS_P62                        TO_DATE(' 2019-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
1

6 rows selected.


SQL> SELECT * FROM SALES1 PARTITION(SYS_P62);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ---------- --------- ---------- ---------- ----------
       198       1111 23-MAR-19         44         23       44.5
*/

INSERT INTO SALES1 VALUES ('199','1111','25-MAR-2019','44',23,44.5);

-- QUERY 08:
/*
PERFORM AND DEMONSTRATE ALL CASES OF DELETION IN REFRENCED AND CHILD TABLE
*/

CREATE TABLE ORDERS(
	ORDER_ID NUMBER(6) PRIMARY KEY,
	ORDER_DATE DATE NOT NULL,
	CUST_ID NUMBER(6),
	SHIPPER_ID NUMBER(6)
)
PARTITION BY RANGE(ORDER_DATE)
	(
	PARTITION ORDERS_Q1 VALUES LESS THAN ('01-APR-2018'),
	PARTITION ORDERS_Q2 VALUES LESS THAN ('01-JUL-2018'),
	PARTITION ORDERS_Q3 VALUES LESS THAN ('01-OCT-2018'),
	PARTITION ORDERS_Q4 VALUES LESS THAN ('01-JAN-2019')
	);

-- CHILD ORDER_ITEMS
CREATE TABLE ORDER_ITEMS(
	ITEM_ID NUMBER(6) PRIMARY KEY,
	ORDER_ID NUMBER(6) NOT NULL, -- SHOULD BE NOT NULL TO WORK WITH FOREIGN KEY
	PROD_ID NUMBER(6),
	PRICE NUMBER(6),
	QUANTITY NUMBER(6),
	CONSTRAINT FK_ORDER_ITEMS_ORDER_ID FOREIGN KEY(ORDER_ID) REFERENCES ORDERS
)
PARTITION BY REFERENCE (FK_ORDER_ITEMS_ORDER_ID);

/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','ORDERS');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='ORDERS';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ORDERS                         ORDERS_Q1                      TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q2                      TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q3                      TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q4                      TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
*/

/*
SQL> exec dbms_stats.gather_table_stats('SARTHAK','ORDER_ITEMS');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='ORDER_ITEMS';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ORDER_ITEMS                    ORDERS_Q1                                                                                                                0
ORDER_ITEMS                    ORDERS_Q2                                                                                                                0
ORDER_ITEMS                    ORDERS_Q3                                                                                                                0
ORDER_ITEMS                    ORDERS_Q4                                                                                                                0
*/

INSERT INTO ORDERS VALUES(123, '23-JAN-2018', 111, 991);
INSERT INTO ORDERS VALUES(125, '23-OCT-2018', 112, 992);


INSERT INTO ORDER_ITEMS VALUES(100, 123, 445, 50, 7);
INSERT INTO ORDER_ITEMS VALUES(101, 125, 445, 50, 7);

SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME IN ('ORDERS','ORDER_ITEMS');

QL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME IN ('ORDERS','ORDER_ITEMS');

/*
TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ORDERS                         ORDERS_Q1                      TO_DATE(' 2018-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
ORDERS                         ORDERS_Q2                      TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q3                      TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q4                      TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
ORDER_ITEMS                    ORDERS_Q1                                                                                                                1
ORDER_ITEMS                    ORDERS_Q2                                                                                                                0
ORDER_ITEMS                    ORDERS_Q3                                                                                                                0
ORDER_ITEMS                    ORDERS_Q4                                                                                                                1

8 rows selected.
*/


ALTER TABLE ORDERS DROP PARTITION ORDERS_Q1;

/*
SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME IN ('ORDERS','ORDER_ITEMS');

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ORDERS                         ORDERS_Q2                      TO_DATE(' 2018-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q3                      TO_DATE(' 2018-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ORDERS                         ORDERS_Q4                      TO_DATE(' 2019-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
ORDER_ITEMS                    ORDERS_Q2                                                                                                                0
ORDER_ITEMS                    ORDERS_Q3                                                                                                                0
ORDER_ITEMS                    ORDERS_Q4                                                                                                                1

6 rows selected.
*/

-- QUERY 09:
/*
IMPLEMENT VIRTUAL COLUMN BASED PARTITIONING
*/

CREATE TABLE EMPLOYEE(
	EMP_ID NUMBER(6) PRIMARY KEY,
	EMP_NAME VARCHAR2(10),
	FIX_SAL NUMBER(6),
	VAR_SAL NUMBER(6),
	TOT_SAL NUMBER(6)
		GENERATED ALWAYS AS(
			FIX_SAL + VAR_SAL
		) VIRTUAL
)
PARTITION BY RANGE(TOT_SAL)
(
	PARTITION P1 VALUES LESS THAN (25000),
	PARTITION P2 VALUES LESS THAN (50000),
	PARTITION P3 VALUES LESS THAN (75000),
	PARTITION P4 VALUES LESS THAN (MAXVALUE)
);


INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, FIX_SAL, VAR_SAL) VALUES(111, 'SARTHAK', 50000, 20000); --REMEMBER TO WRITE THE COLUMN NAME

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, FIX_SAL, VAR_SAL) VALUES(112, 'RAKSHIT', 20000, 30000);

SELECT * FROM EMPLOYEE;

/*


SQL> SELECT * FROM EMPLOYEE;

    EMP_ID EMP_NAME      FIX_SAL    VAR_SAL    TOT_SAL
---------- ---------- ---------- ---------- ----------
       111 SARTHAK         50000      20000      70000
       112 RAKSHIT         20000      30000      50000
*/

-- QUERY 10:
/*
DEMONSTRATE COMPOSITE PARTITIONING WITH ALL POSSIBLE SCENERIOS
*/
CREATE TABLE CUSTOMER(
	CUST_ID NUMBER(6) PRIMARY KEY,
	CUST_NAME VARCHAR2(10),
	CUST_STATE VARCHAR2(10),
	TIME_ID DATE
)
PARTITION BY RANGE(TIME_ID)
	SUBPARTITION BY LIST(CUST_STATE)
		SUBPARTITION TEMPLATE
		(
			SUBPARTITION WEST VALUES ('MH', 'GJ'),
			SUBPARTITION SOUTH VALUES ('TN', 'AP'),
			SUBPARTITION NORTH VALUES ('UP', 'HP'),
			SUBPARTITION EAST VALUES (DEFAULT)
		)
	(
		PARTITION C_TIME1 VALUES LESS THAN ('01-JAN-2005'),
		PARTITION C_TIME2 VALUES LESS THAN ('01-JAN-2010'),
		PARTITION C_TIME3 VALUES LESS THAN ('01-JAN-2015'),
		PARTITION C_TIME4 VALUES LESS THAN (MAXVALUE)
	);

SELECT TABLE_NAME, PARTITION_NAME, COMPOSITE, HIGH_VALUE, NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = 'CUSTOMER';


INSERT INTO CUSTOMER VALUES(123, 'SAR', 'MH', '01-JAN-2010');
INSERT INTO CUSTOMER VALUES(124, 'SUS', 'UP', '01-JAN-2014');
INSERT INTO CUSTOMER VALUES(125, 'ROY', 'TN', '01-JAN-2006');

SELECT TABLE_NAME, PARTITION_NAME, COMPOSITE, HIGH_VALUE, NUM_ROWS FROM ALL_TAB_PARTITIONS WHERE TABLE_NAME = 'CUSTOMER';

exec dbms_stats.gather_table_stats('SARTHAK','CUSTOMER');

		SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER';

/*
SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
CUSTOMER                       C_TIME1                        TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
CUSTOMER                       C_TIME2                        TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
CUSTOMER                       C_TIME3                        TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          2
CUSTOMER                       C_TIME4                        MAXVALUE                                                                                  0                                                                              1
*/

SELECT TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,NUM_ROWS FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER';

/*

SQL> SELECT TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME,NUM_ROWS FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER';

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER                       C_TIME1                        C_TIME1_WEST                            0
CUSTOMER                       C_TIME1                        C_TIME1_SOUTH                           0
CUSTOMER                       C_TIME1                        C_TIME1_NORTH                           0
CUSTOMER                       C_TIME1                        C_TIME1_EAST                            0
CUSTOMER                       C_TIME2                        C_TIME2_WEST                            0
CUSTOMER                       C_TIME2                        C_TIME2_SOUTH                           1
CUSTOMER                       C_TIME2                        C_TIME2_NORTH                           0
CUSTOMER                       C_TIME2                        C_TIME2_EAST                            0
CUSTOMER                       C_TIME3                        C_TIME3_WEST                            1
CUSTOMER                       C_TIME3                        C_TIME3_SOUTH                           0
CUSTOMER                       C_TIME3                        C_TIME3_NORTH                           1

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER                       C_TIME3                        C_TIME3_EAST                            0
CUSTOMER                       C_TIME4                        C_TIME4_WEST                            0
CUSTOMER                       C_TIME4                        C_TIME4_SOUTH                           0
CUSTOMER                       C_TIME4                        C_TIME4_NORTH                           0
CUSTOMER                       C_TIME4                        C_TIME4_EAST                            0

16 rows selected.
*/


-- QUERY 11:
--RANGE RANGE PARTTIONING
--RANGE TIME_ID
--RANGE CUST_ID

CREATE TABLE CUSTOMER1(
	CUST_ID NUMBER(4) PRIMARY KEY,
	CUST_NAME VARCHAR2(20),
	CUST_STATE VARCHAR2(20),
	TIME_ID DATE
)
PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY RANGE (CUST_ID)
		SUBPARTITION TEMPLATE
			(
			SUBPARTITION CUST_SUB_ID_1 VALUES LESS THAN (124),
			SUBPARTITION CUST_SUB_ID_2 VALUES LESS THAN (126),
			SUBPARTITION CUST_SUB_ID_3 VALUES LESS THAN (128),
			SUBPARTITION CUST_SUB_ID_4 VALUES LESS THAN (MAXVALUE)
			)
	( 		PARTITION CUST_RG_1 VALUES LESS THAN ('01-JAN-2005'),
				PARTITION CUST_RG_2 VALUES LESS THAN ('01-JAN-2010'),
				PARTITION CUST_RG_3 VALUES LESS THAN ('01-JAN-2015'),
				PARTITION CUST_RG_4 VALUES LESS THAN (MAXVALUE)
	)
;

INSERT INTO CUSTOMER1 VALUES(123, 'SAR', 'MH', '01-JAN-2010');
INSERT INTO CUSTOMER1 VALUES(124, 'SUS', 'UP', '01-JAN-2014');
INSERT INTO CUSTOMER1 VALUES(125, 'ROY', 'TN', '01-JAN-2006');

INSERT INTO CUSTOMER1 VALUES (126,'AAAA','UP','01-DEC-2011');
INSERT INTO CUSTOMER1 VALUES (127,'AAAB','UP','01-FEB-2011');
INSERT INTO CUSTOMER1 VALUES (128,'AAC','CK','01-FEB-2015');

exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');

SELECT TABLE_NAME,PARTITION_NAME, COMPOSITE, HIGH_VALUE,NUM_ROWS
  FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER1';

  /*
  TABLE_NAME                     PARTITION_NAME                 COM HIGH_VALUE                                                                       NUM_ROWS
  ------------------------------ ------------------------------ --- -------------------------------------------------------------------------------- ----------
  CUSTOMER1                      CUST_RG_1                      YES TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
  CUSTOMER1                      CUST_RG_2                      YES TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
  CUSTOMER1                      CUST_RG_3                      YES TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          4
  CUSTOMER1                      CUST_RG_4                      YES MAXVALUE                                                                                  1
  */

	exec dbms_stats.gather_schema_stats(USER);
	SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
		FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      CUST_RG_1                      CUST_RG_1_CUST_SUB_ID_1
CUSTOMER1                      CUST_RG_1                      CUST_RG_1_CUST_SUB_ID_2
CUSTOMER1                      CUST_RG_1                      CUST_RG_1_CUST_SUB_ID_3
CUSTOMER1                      CUST_RG_1                      CUST_RG_1_CUST_SUB_ID_4
CUSTOMER1                      CUST_RG_2                      CUST_RG_2_CUST_SUB_ID_1
CUSTOMER1                      CUST_RG_2                      CUST_RG_2_CUST_SUB_ID_2
CUSTOMER1                      CUST_RG_2                      CUST_RG_2_CUST_SUB_ID_3
CUSTOMER1                      CUST_RG_2                      CUST_RG_2_CUST_SUB_ID_4
CUSTOMER1                      CUST_RG_3                      CUST_RG_3_CUST_SUB_ID_1
CUSTOMER1                      CUST_RG_3                      CUST_RG_3_CUST_SUB_ID_2
CUSTOMER1                      CUST_RG_3                      CUST_RG_3_CUST_SUB_ID_3

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      CUST_RG_3                      CUST_RG_3_CUST_SUB_ID_4
CUSTOMER1                      CUST_RG_4                      CUST_RG_4_CUST_SUB_ID_1
CUSTOMER1                      CUST_RG_4                      CUST_RG_4_CUST_SUB_ID_2
CUSTOMER1                      CUST_RG_4                      CUST_RG_4_CUST_SUB_ID_3
CUSTOMER1                      CUST_RG_4                      CUST_RG_4_CUST_SUB_ID_4

16 rows selected.
*/


-- QUERY 12:
--RANGE-HASH PARTTION
-- RANGE TIME_ID
-- HASH CUST_ID
DROP TABLE CUSTOMER1;

CREATE TABLE CUSTOMER1(
	CUST_ID NUMBER(4) PRIMARY KEY,
	CUST_NAME VARCHAR2(10),
	CUST_STATE VARCHAR2(10),
	TIME_ID DATE
)
PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY HASH (CUST_ID)
		SUBPARTITIONS 4
	(
				PARTITION CUST_RG_1 VALUES LESS THAN ('01-JAN-2005'),
				PARTITION CUST_RG_2 VALUES LESS THAN ('01-JAN-2010'),
				PARTITION CUST_RG_3 VALUES LESS THAN ('01-JAN-2015'),
				PARTITION CUST_RG_4 VALUES LESS THAN (MAXVALUE)
	)
;

INSERT INTO CUSTOMER1 VALUES(123, 'SAR', 'MH', '01-JAN-2010');
INSERT INTO CUSTOMER1 VALUES(124, 'SUS', 'UP', '01-JAN-2014');
INSERT INTO CUSTOMER1 VALUES(125, 'ROY', 'TN', '01-JAN-2006');

INSERT INTO CUSTOMER1 VALUES (126,'AAAA','UP','01-DEC-2011');
INSERT INTO CUSTOMER1 VALUES (127,'AAAB','UP','01-FEB-2011');
INSERT INTO CUSTOMER1 VALUES (128,'AAC','CK','01-FEB-2015');

exec dbms_stats.gather_table_stats('SARTHAK','CUSTOMER1');

SELECT TABLE_NAME,PARTITION_NAME, COMPOSITE, HIGH_VALUE,NUM_ROWS
	FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*
TABLE_NAME                     PARTITION_NAME                 COM HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ --- -------------------------------------------------------------------------------- ----------
CUSTOMER1                      CUST_RG_1                      YES TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
CUSTOMER1                      CUST_RG_2                      YES TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
CUSTOMER1                      CUST_RG_3                      YES TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          4
CUSTOMER1                      CUST_RG_4                      YES MAXVALUE                                                                                  1

*/

SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
	FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*
SQL> SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
  2  FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      CUST_RG_1                      SYS_SUBP42
CUSTOMER1                      CUST_RG_1                      SYS_SUBP43
CUSTOMER1                      CUST_RG_1                      SYS_SUBP44
CUSTOMER1                      CUST_RG_1                      SYS_SUBP45
CUSTOMER1                      CUST_RG_2                      SYS_SUBP46
CUSTOMER1                      CUST_RG_2                      SYS_SUBP47
CUSTOMER1                      CUST_RG_2                      SYS_SUBP48
CUSTOMER1                      CUST_RG_2                      SYS_SUBP49
CUSTOMER1                      CUST_RG_3                      SYS_SUBP50
CUSTOMER1                      CUST_RG_3                      SYS_SUBP51
CUSTOMER1                      CUST_RG_3                      SYS_SUBP52

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      CUST_RG_3                      SYS_SUBP53
CUSTOMER1                      CUST_RG_4                      SYS_SUBP54
CUSTOMER1                      CUST_RG_4                      SYS_SUBP55
CUSTOMER1                      CUST_RG_4                      SYS_SUBP56
CUSTOMER1                      CUST_RG_4                      SYS_SUBP57

16 rows selected.

*/
-- QUERY 13:
-- LIST(CUST_STATE) - HASH(CUST_ID) PARTITION

DROP TABLE CUSTOMER1;

CREATE TABLE CUSTOMER1(
	CUST_ID NUMBER(4) PRIMARY KEY,
	CUST_NAME VARCHAR2(10),
	CUST_STATE VARCHAR2(10),
	TIME_ID DATE
)
PARTITION BY LIST (CUST_STATE)
	SUBPARTITION BY HASH (CUST_ID)
		SUBPARTITIONS 4
	(
			PARTITION WEST VALUES ('MH','GJ'),
			PARTITION SOUTH VALUES ('TN','AP'),
			PARTITION NORTH VALUES ('UP','HP'),
			PARTITION UN_KNOWN VALUES (DEFAULT)
	)
;

INSERT INTO CUSTOMER1 VALUES(123, 'SAR', 'MH', '01-JAN-2010');
INSERT INTO CUSTOMER1 VALUES(124, 'SUS', 'UP', '01-JAN-2014');
INSERT INTO CUSTOMER1 VALUES(125, 'ROY', 'TN', '01-JAN-2006');

INSERT INTO CUSTOMER1 VALUES (126,'AAAA','UP','01-DEC-2011');
INSERT INTO CUSTOMER1 VALUES (127,'AAAB','UP','01-FEB-2011');
INSERT INTO CUSTOMER1 VALUES (128,'AAC','CK','01-FEB-2015');

exec dbms_stats.gather_table_stats('SARTHAK','CUSTOMER1');

SELECT TABLE_NAME,PARTITION_NAME, COMPOSITE, HIGH_VALUE,NUM_ROWS
	FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER1';

	/*
	TABLE_NAME                     PARTITION_NAME                 COM HIGH_VALUE                                                                         NUM_ROWS
	------------------------------ ------------------------------ --- -------------------------------------------------------------------------------- ----------
	CUSTOMER1                      WEST                           YES 'MH', 'GJ'                                                                                1
	CUSTOMER1                      SOUTH                          YES 'TN', 'AP'                                                                                1
	CUSTOMER1                      NORTH                          YES 'UP', 'HP'                                                                                3
	CUSTOMER1                      UN_KNOWN                       YES DEFAULT                                                                                   1
	*/

	exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');
		SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
			FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

	/*
	TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
	------------------------------ ------------------------------ ------------------------------ ----------
	CUSTOMER1                      WEST                           SYS_SUBP58
	CUSTOMER1                      WEST                           SYS_SUBP59
	CUSTOMER1                      WEST                           SYS_SUBP60
	CUSTOMER1                      WEST                           SYS_SUBP61
	CUSTOMER1                      SOUTH                          SYS_SUBP62
	CUSTOMER1                      SOUTH                          SYS_SUBP63
	CUSTOMER1                      SOUTH                          SYS_SUBP64
	CUSTOMER1                      SOUTH                          SYS_SUBP65
	CUSTOMER1                      NORTH                          SYS_SUBP66
	CUSTOMER1                      NORTH                          SYS_SUBP67
	CUSTOMER1                      NORTH                          SYS_SUBP68

	TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
	------------------------------ ------------------------------ ------------------------------ ----------
	CUSTOMER1                      NORTH                          SYS_SUBP69
	CUSTOMER1                      UN_KNOWN                       SYS_SUBP70
	CUSTOMER1                      UN_KNOWN                       SYS_SUBP71
	CUSTOMER1                      UN_KNOWN                       SYS_SUBP72
	CUSTOMER1                      UN_KNOWN                       SYS_SUBP73

	16 rows selected.

	*/
--QUERY 14:
-- LIST CUST_STATE LIST CUST_ID

DROP TABLE CUSTOMER1;

	CREATE TABLE CUSTOMER1(
		CUST_ID NUMBER(4) PRIMARY KEY,
		CUST_NAME VARCHAR2(20),
		CUST_STATE VARCHAR2(20),
		TIME_ID DATE
	)
	PARTITION BY LIST (CUST_STATE)
		SUBPARTITION BY LIST (CUST_ID)
			SUBPARTITION TEMPLATE
		(
			SUBPARTITION P1 VALUES (121,122,123),
			SUBPARTITION P2 VALUES (124,125,126),
			SUBPARTITION P3 VALUES (127,128),
			SUBPARTITION P4 VALUES (DEFAULT)
		)
		(
				PARTITION WEST VALUES ('MH','GJ'),
				PARTITION SOUTH VALUES ('TN','AP'),
				PARTITION NORTH VALUES ('UP','HP'),
				PARTITION UN_KNOWN VALUES (DEFAULT)
		)
	;

	INSERT INTO CUSTOMER1 VALUES(123, 'SAR', 'MH', '01-JAN-2010');
	INSERT INTO CUSTOMER1 VALUES(124, 'SUS', 'UP', '01-JAN-2014');
	INSERT INTO CUSTOMER1 VALUES(125, 'ROY', 'TN', '01-JAN-2006');

	INSERT INTO CUSTOMER1 VALUES (126,'AAAA','UP','01-DEC-2011');
	INSERT INTO CUSTOMER1 VALUES (127,'AAAB','UP','01-FEB-2011');
	INSERT INTO CUSTOMER1 VALUES (128,'AAC','CK','01-FEB-2015');

	exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');

	SELECT TABLE_NAME,PARTITION_NAME, COMPOSITE, HIGH_VALUE,NUM_ROWS
		FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*
TABLE_NAME                     PARTITION_NAME                 COM HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ --- -------------------------------------------------------------------------------- ----------
CUSTOMER1                      WEST                           YES 'MH', 'GJ'                                                                                1
CUSTOMER1                      SOUTH                          YES 'TN', 'AP'                                                                                1
CUSTOMER1                      NORTH                          YES 'UP', 'HP'                                                                                3
CUSTOMER1                      UN_KNOWN                       YES DEFAULT                                                                                   1
*/

exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');
	SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
		FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*
TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      WEST                           WEST_P1                                 1
CUSTOMER1                      WEST                           WEST_P2                                 0
CUSTOMER1                      WEST                           WEST_P3                                 0
CUSTOMER1                      WEST                           WEST_P4                                 0
CUSTOMER1                      SOUTH                          SOUTH_P1                                0
CUSTOMER1                      SOUTH                          SOUTH_P2                                1
CUSTOMER1                      SOUTH                          SOUTH_P3                                0
CUSTOMER1                      SOUTH                          SOUTH_P4                                0
CUSTOMER1                      NORTH                          NORTH_P1                                0
CUSTOMER1                      NORTH                          NORTH_P2                                2
CUSTOMER1                      NORTH                          NORTH_P3                                1

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      NORTH                          NORTH_P4                                0
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_P1                             0
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_P2                             0
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_P3                             1
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_P4                             0

16 rows selected.
*/

--QUERY 15:
-- LIST CUST_STATE RANGE CUST_ID

DROP TABLE CUSTOMER1;

	CREATE TABLE CUSTOMER1(
		CUST_ID NUMBER(4) PRIMARY KEY,
		CUST_NAME VARCHAR2(10),
		CUST_STATE VARCHAR2(10),
		TIME_ID DATE
	)
	PARTITION BY LIST (CUST_STATE)
		SUBPARTITION BY RANGE (CUST_ID)
			SUBPARTITION TEMPLATE
		(
				SUBPARTITION CUST_SUB_ID_1 VALUES LESS THAN (125),
				SUBPARTITION CUST_SUB_ID_2 VALUES LESS THAN (127),
				SUBPARTITION CUST_SUB_ID_3 VALUES LESS THAN (129),
				SUBPARTITION CUST_SUB_ID_4 VALUES LESS THAN (MAXVALUE)
		)
		(
				PARTITION WEST VALUES ('MH','GJ'),
				PARTITION SOUTH VALUES ('TN','AP'),
				PARTITION NORTH VALUES ('UP','HP'),
				PARTITION UN_KNOWN VALUES (DEFAULT)
		)
	;

	INSERT INTO CUSTOMER1 VALUES(123, 'SAR', 'MH', '01-JAN-2010');
	INSERT INTO CUSTOMER1 VALUES(124, 'SUS', 'UP', '01-JAN-2014');
	INSERT INTO CUSTOMER1 VALUES(125, 'ROY', 'TN', '01-JAN-2006');

	INSERT INTO CUSTOMER1 VALUES (126,'AAAA','UP','01-DEC-2011');
	INSERT INTO CUSTOMER1 VALUES (127,'AAAB','UP','01-FEB-2011');
	INSERT INTO CUSTOMER1 VALUES (128,'AAC','CK','01-FEB-2015');


	exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');

	SELECT TABLE_NAME,PARTITION_NAME, COMPOSITE, HIGH_VALUE,NUM_ROWS
		FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='CUSTOMER1';
/*
TABLE_NAME                     PARTITION_NAME                 COM HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ --- -------------------------------------------------------------------------------- ----------
CUSTOMER1                      WEST                           YES 'MH', 'GJ'                                                                                1
CUSTOMER1                      SOUTH                          YES 'TN', 'AP'                                                                                1
CUSTOMER1                      NORTH                          YES 'UP', 'HP'                                                                                3
CUSTOMER1                      UN_KNOWN                       YES DEFAULT                                                                                   1

*/

exec dbms_stats.gather_table_stats(USER,'CUSTOMER1');
	SELECT TABLE_NAME,PARTITION_NAME, SUBPARTITION_NAME, NUM_ROWS
		FROM USER_TAB_SUBPARTITIONS WHERE TABLE_NAME='CUSTOMER1';

/*
TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      WEST                           WEST_CUST_SUB_ID_1
CUSTOMER1                      WEST                           WEST_CUST_SUB_ID_2
CUSTOMER1                      WEST                           WEST_CUST_SUB_ID_3
CUSTOMER1                      WEST                           WEST_CUST_SUB_ID_4
CUSTOMER1                      SOUTH                          SOUTH_CUST_SUB_ID_1
CUSTOMER1                      SOUTH                          SOUTH_CUST_SUB_ID_2
CUSTOMER1                      SOUTH                          SOUTH_CUST_SUB_ID_3
CUSTOMER1                      SOUTH                          SOUTH_CUST_SUB_ID_4
CUSTOMER1                      NORTH                          NORTH_CUST_SUB_ID_1
CUSTOMER1                      NORTH                          NORTH_CUST_SUB_ID_2
CUSTOMER1                      NORTH                          NORTH_CUST_SUB_ID_3

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME                NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
CUSTOMER1                      NORTH                          NORTH_CUST_SUB_ID_4
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_CUST_SUB_ID_1
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_CUST_SUB_ID_2
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_CUST_SUB_ID_3
CUSTOMER1                      UN_KNOWN                       UN_KNOWN_CUST_SUB_ID_4

16 rows selected.
*/
