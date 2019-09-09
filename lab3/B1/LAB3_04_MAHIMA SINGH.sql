																																NAME:MAHIMA SINGH
																																ROLL NO:04
																																BATCH:B1
===============================================================================================================================================================
PRACTICAL NO 3:
AIM: TO EXECUTE QUERIES BASED ON PARTITIONING
===============================================================================================================================================================
QUERY NO 1:
1. Write a query to create range portioned table:
   Creates a table named- Sales consisting of four partitions, one for each quarter of sales. 
   The columns sale_year, sale_month, and sale_day are the partitioning columns, while their values constitute the partitioning key of a specific row. 
   Each partition is given a name (sales_q1, sales_q2, ...), and each partition is contained in a separate tablespace (tsa, tsb, ...) 
   The columns for table must be prod_id, cust_id, promo_id, quantify sold, amount_sold – all in number format and time_id.

SQL> create tablespace tbl1
  2  datafile 'C:\Users\mahima04\tbl1.dbf'
  3  size 40m;
Tablespace created.

SQL> create tablespace tbl2
    datafile 'C:\Users\mahima04\tbl2.dbf'
    size 40m;
Tablespace created.

SQL> create tablespace tbl3
    datafile 'C:\Users\mahima04\tbl3.dbf'
    size 40m;
Tablespace created.

SQL> create tablespace tbl4
    datafile 'C:\Users\mahima04\tbl4.dbf'
    size 40m;
Tablespace created.


SQL> CREATE TABLE sales
    (prod_id  NUMBER(5),
    cust_id  NUMBER(5),
    promo_id  NUMBER(5),
    quantity_sold NUMBER(10),
    amount_sold NUMBER(10),
    time_id DATE)
    PARTITION BY RANGE(time_id)
    (
   PARTITION sales_q1 VALUES LESS THAN(TO_DATE('01/03/2000','DD/MM/YYYY')) TABLESPACE tbl1,
   PARTITION sales_q2 VALUES LESS THAN(TO_DATE('01/07/2000','DD/MM/YYYY')) TABLESPACE tbl2,
   PARTITION sales_q3 VALUES LESS THAN(TO_DATE('01/10/2000','DD/MM/YYYY')) TABLESPACE tbl3,
   PARTITION sales_q4 VALUES LESS THAN(TO_DATE('01/01/2001','DD/MM/YYYY')) TABLESPACE tbl4
   );
SQL> INSERT INTO SALES VALUES(101,111,121,10,500,'01/FEB/2000');

1 row created.

SQL> INSERT INTO SALES VALUES(101,111,121,10,500,'02/MAY/2000');

1 row created.

SQL> INSERT INTO SALES VALUES(101,111,121,10,500,'04/SEP/2000');

1 row created.
SQL> INSERT INTO SALES VALUES(101,111,121,10,500,'01/JAN/2001');
INSERT INTO SALES VALUES(101,111,121,10,500,'01/JAN/2001')
            *
ERROR at line 1:
ORA-14400: inserted partition key does not map to any partition


SQL> INSERT INTO SALES VALUES(101,111,121,10,500,'30/DEC/2000');

1 row created.
====================================================================================================
QUERY NO 2:
Create the same table as in Q1. With a different name with ENABLE ROW MOVEMENT

SQL> CREATE TABLE sales1
  2      (prod_id  NUMBER(5),
  3      cust_id  NUMBER(5),
  4      promo_id  NUMBER(5),
  5      quantity_sold NUMBER(10),
  6      amount_sold NUMBER(10),
  7      time_id DATE)
  8      PARTITION BY RANGE(time_id)
  9      (
 10     PARTITION sales_q1 VALUES LESS THAN(TO_DATE('01/03/2000','DD/MM/YYYY')) TABLESPACE tbl1,
 11     PARTITION sales_q2 VALUES LESS THAN(TO_DATE('01/07/2000','DD/MM/YYYY')) TABLESPACE tbl2,
 12     PARTITION sales_q3 VALUES LESS THAN(TO_DATE('01/10/2000','DD/MM/YYYY')) TABLESPACE tbl3,
 13     PARTITION sales_q4 VALUES LESS THAN(TO_DATE('01/01/2001','DD/MM/YYYY')) TABLESPACE tbl4
 14     );

Table created.

SQL> INSERT INTO SALES1 VALUES(101,111,121,10,500,'01/FEB/2000');

1 row created.

SQL> INSERT INTO SALES1 VALUES(102,112,122,10,500,'02/MAY/2000');

1 row created.

SQL> INSERT INTO SALES1 VALUES(103,113,123,10,500,'04/SEP/2000');

1 row created.

SQL> INSERT INTO SALES1 VALUES(104,114,124,10,500,'30/DEC/2000');

1 row created.

SQL> select * from sales1;

   PROD_ID    CUST_ID   PROMO_ID QUANTITY_SOLD AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ------------- ----------- ---------
       101        111        121            10         500 01-FEB-00
       102        112        122            10         500 02-MAY-00
       103        113        123            10         500 04-SEP-00
       104        114        124            10         500 30-DEC-00
	   

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','SALES1');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2   FROM USER_TAB_PARTITIONS
  3   WHERE TABLE_NAME='SALES1';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       TBL1                                     1
SALES_Q2                       TBL2                                     1
SALES_Q3                       TBL3                                     1
SALES_Q4                       TBL4                                     1

SQL> UPDATE SALES1 SET TIME_ID='02-SEP-2000'
  2  WHERE PROD_ID=104;
UPDATE SALES1 SET TIME_ID='02-SEP-2000'
       *
ERROR at line 1:
ORA-14402: updating partition key column would cause a partition change

SQL> alter table sales1 ENABLE ROW MOVEMENT;

Table altered.

SQL> UPDATE SALES1 SET TIME_ID='02-SEP-2000'
  2  WHERE PROD_ID=104;

1 row updated.

SQL> SELECT * FROM SALES1;

   PROD_ID    CUST_ID   PROMO_ID QUANTITY_SOLD AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ------------- ----------- ---------
       101        111        121            10         500 01-FEB-00
       102        112        122            10         500 02-MAY-00
       103        113        123            10         500 04-SEP-00
       104        114        124            10         500 02-SEP-00

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','SALES1');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2  FROM USER_TAB_PARTITIONS
  3   WHERE TABLE_NAME='SALES1';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       TBL1                                     1
SALES_Q2                       TBL2                                     1
SALES_Q3                       TBL3                                     2
SALES_Q4                       TBL4                                     0
====================================================================================================
QUERY NO 3:
Create a table with list partition as follows: 
 Table having columns deptno, deptname, quarterly_sales and state. 
 Create partition on state: 
	 Northwest on OR and WA 
	 Southwest on AZ, UT and NM 
	 northeast on NY, VM and NJ 
	 southeast on FL and GA 
	 northcentral on SD and WI  southcentral on OK and TX 
 Add the following entries into the table and make conclusion to which partition the entry maps: 
	 (10, 'accounting', 100, 'WA') 
	 (20, 'R&D', 150, 'OR') 
	 (30, 'sales', 100, 'FL') 
	 (40, 'HR', 10, 'TX') 
	 (50, 'systems engineering', 10, 'CA')
	
SQL> CREATE TABLE SALES2
  2        (deptno number,
  3         deptname varchar2(20),
  4         quarterly_sales number(10, 2),
  5         state varchar2(2))
  6     PARTITION BY LIST (state)
  7        (PARTITION q1_northwest VALUES ('OR', 'WA'),
  8         PARTITION q1_southwest VALUES ('AZ', 'UT', 'NM'),
  9         PARTITION q1_northeast VALUES  ('NY', 'VM', 'NJ'),
 10         PARTITION q1_southeast VALUES ('FL', 'GA'),
 11         PARTITION q1_northcentral VALUES ('SD', 'WI'),
 12         PARTITION q1_southcentral VALUES ('OK', 'TX'));

Table created.

SQL> INSERT INTO SALES2 VALUES (10, 'ACCOUNTING', 100, 'WA');

1 row created.

SQL> INSERT INTO SALES2 VALUES (20, 'R&D', 150, 'OR');

1 row created.

SQL> INSERT INTO SALES2 VALUES (30, 'SALES', 100, 'FL');

1 row created.

SQL> INSERT INTO SALES2 VALUES (40, 'HR', 10, 'TX');

1 row created.

SQL> INSERT INTO SALES2 VALUES (50, 'SYSTEM ENGINEERING', 10, 'CA');
     INSERT INTO SALES2 VALUES (50, 'SYSTEM ENGINEERING', 10, 'CA')
                     *
ERROR at line 1:
ORA-14400: inserted partition key does not map to any partition

QL> SELECT * FROM SALES2 PARTITION (Q1_NORTHWEST);

	DEPTNO DEPTNAME             QUARTERLY_SALES ST
---------- -------------------- --------------- --
        10 ACCOUNTING                       100 WA
		20 R&D                              150 OR

SQL> SELECT * FROM SALES2 PARTITION (Q1_SOUTHWEST);

no rows selected

SQL> SELECT * FROM SALES2 PARTITION (Q1_NORTHEAST);

no rows selected

SQL> SELECT * FROM SALES2 PARTITION (Q1_SOUTHEAST);

    DEPTNO DEPTNAME             QUARTERLY_SALES ST
---------- -------------------- --------------- --
        30 SALES                            100 FL

SQL>     SELECT * FROM SALES2 PARTITION (Q1_NORTHCENTRAL);

no rows selected

SQL>     SELECT * FROM SALES2 PARTITION (Q1_SOUTHCENTRAL);

    DEPTNO DEPTNAME             QUARTERLY_SALES ST
---------- -------------------- --------------- --
        40 HR                                10 TX

SQL>  exec dbms_stats.gather_table_stats('MAHIMA04','SALES2');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,TABLESPACE_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SALES2';

TABLE_NAME         TABLESPACE_NAME                     HIGH_VALUE                                                                    NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES2                  USERS                          'OR', 'WA'                                                                        2
SALES2                  USERS                          'AZ', 'UT', 'NM'                                                                  0
SALES2                  USERS                          'NY', 'VM', 'NJ'                                                                  0
SALES2                  USERS                          'FL', 'GA'                                                                        1
SALES2                  USERS                          'SD', 'WI'                                                                        0
SALES2                  USERS                          'OK', 'TX'                                                                        1
SALES2                  USERS                          DEFAULT                                                                           1

7 rows selected.
============================================================================================================================================================
QUERY NO 4:
Create a table with hash partition as follows: 
	 Create table Emp with attributes empno, job, sal, deptno and perform hash partitioning on empno. 
Number of Partitions should be 5. Demonstarte using system defined and user defined partition concepts.

SQL>     CREATE TABLE EMP
  2             (EMP_NO NUMBER(6),
  3             EMP_JOB VARCHAR(10),
  4             EMP_SAL NUMBER(6),
  5             EMP_DEPTNO NUMBER(3))
  6             PARTITION BY HASH(EMP_NO)
  7             PARTITIONS 5;

Table created.

SQL> INSERT INTO EMP VALUES(1000,'QA',10000,101);
1 row created.

SQL>INSERT INTO EMP VALUES(1010,'BA',15000,102);
1 row created.

SQL>INSERT INTO EMP VALUES(1500,'SE',24000,103);
1 row created.

SQL>INSERT INTO EMP VALUES(1582,'HR',35000,104);
1 row created.

SQL>INSERT INTO EMP VALUES(1900,'DEVELOPER',50000,105);
1 row created.

SQL> exec dbms_stats.gather_table_stats('MAHIMA04','EMP');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='EMP';

TABLE_NAME         PARTITION_NAME                 HIGH_VALUE                                                                      NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
EMP                  SYS_P11                                                                                                          2
EMP                  SYS_P12                                                                                                          2
EMP                  SYS_P13                                                                                                          1
EMP                  SYS_P14                                                                                                          0
EMP                  SYS_P15                                                                                                          0
==============================================================================================================================================================
QUERY NO 5:
Create a multi-column range partitioned table as directed: 
	 Create a table with the actual DATE information in three separate columns: year, month, and day. Also amount_ sold. 
	 Create following partitions: 
		o Before 2001: Less than jan 2001 
		o Less than april 2001 
		o Less than july 2001 
		o Less than oct 2001 
		o Less than jan 2002 
		o Future with max incoming value 
	 Insert values into table and show to which partition does the value belong. 
		o (2001,3,17, 2000); 
		o (2001,11,1, 5000);
		o (2002,1,1, 4000);
Make conclusion for each result.

SQL> CREATE TABLE DATE2(
  2     YEAR NUMBER(4),
  3     MONTH NUMBER(2),
  4     DAY NUMBER(2),
  5     AMT_SOLD NUMBER(5)
  6  )
  7  PARTITION BY RANGE(YEAR,MONTH)
  8  (
  9     PARTITION DP1 VALUES LESS THAN (2001,1),
 10     PARTITION DP2 VALUES LESS THAN (2001,4),
 11     PARTITION DP3 VALUES LESS THAN (2001,7),
 12     PARTITION DP4 VALUES LESS THAN (2001,10),
 13     PARTITION DP5 VALUES LESS THAN (2002,1),
 14     PARTITION DP6 VALUES LESS THAN (MAXVALUE,MAXVALUE)
 15  );

Table created.

SQL> INSERT INTO DATE2 VALUES(2001,3,17,11);

1 row created.

SQL> INSERT INTO DATE2 VALUES(2001,11,1,33);

1 row created.

SQL> INSERT INTO DATE2 VALUES(2002,1,1,11);

1 row created.

SQL>  exec dbms_stats.gather_table_stats('MAHIMA04','DATE2');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='DATE2';

TABLE_NAME             PARTITION_NAME                   HIGH_VALUE                                                                    NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
DATE2                     DP1                             2001, 1                                                                           0
DATE2                     DP2                             2001, 4                                                                           1
DATE2                     DP3                             2001, 7                                                                           0
DATE2                     DP4                             2001, 10                                                                          0
DATE2                     DP5                             2002, 1                                                                           1
DATE2                     DP6                             MAXVALUE, MAXVALUE                                                                1

6 rows selected.
=============================================================================================================================================================
QUERY NO 6:
Create a multicolumn partitioned table as directed:
	 Table supplier_parts, storing the information about which supplier_parts deliver which parts. To distribute the data in equal-sized partitions, 
	it is not sufficient to partition the table based on the supplier_id, because some supplier_parts mightprovide hundreds of thousands of parts, 
	while others provide only a few specialty parts. Instead, you partition the table on (suppplier_id, partnum) to manually enforce equal-sized partitions.
	 Insert the following values
		(5,5, 1000);
		(5,150, 1000);
		(10,100, 1000);
		
SQL> CREATE TABLE SUPPLIER_PARTS(
  2     SUP_ID NUMBER(6),
  3     P_NUM NUMBER(6),
  4     AMT_SOLD NUMBER(6)
  5  )
  6  PARTITION BY RANGE(SUP_ID,P_NUM)(
  7     PARTITION SP1 VALUES LESS THAN (5,100),
  8     PARTITION SP2 VALUES LESS THAN (5,200),
  9     PARTITION SP3 VALUES LESS THAN (10,50),
 10     PARTITION SP4 VALUES LESS THAN (10,200),
 11     PARTITION SP5_DEF VALUES LESS THAN (MAXVALUE,MAXVALUE)
 12  );

Table created.

SQL>    INSERT INTO SUPPLIER_PARTS VALUES (5,5,1000);

1 row created.

SQL>    INSERT INTO SUPPLIER_PARTS VALUES (5,150,1000);

1 row created.

SQL>    INSERT INTO SUPPLIER_PARTS VALUES (10,100,1000);

1 row created.

SQL>    exec dbms_stats.gather_table_stats('MAHIMA04','SUPPLIER_PARTS');

PL/SQL procedure successfully completed.

SQL> SELECT TABLE_NAME,PARTITION_NAME,HIGH_VALUE,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='SUPPLIER_PARTS';

TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SUPPLIER_PARTS                       SP1                             5, 100                                                                            1
SUPPLIER_PARTS                       SP2                             5, 200                                                                            1
SUPPLIER_PARTS                       SP3                             10, 50                                                                            0
SUPPLIER_PARTS                       SP4                             10, 200                                                                           1
SUPPLIER_PARTS                       SP5_DEF                         MAXVALUE, MAXVALUE                                                                0
===============================================================================================================================================================
QUERY 7:
Create interval partitioned table as directed:
	 Creates a table named- Sales consisting of four partitions, one for each quarter of sales. Each partition is given a name (sales_q1, sales_q2, ...)
	 The columns for table must be prod_id, cust_id, promo_id, quantify sold,amount_sold – all in number format and month in number format
	 Perform interval partitioning on month and take interval of 01 months.

SQL> create table sales11
(
product_id  NUMBER,
    customer_id                NUMBER,
    time_id                    DATE,
    channel_info               CHAR(1),
    promo_id                   NUMBER,
    qty_sold                   NUMBER,
    amt_sold                   NUMBER
    )
PARTITION BY RANGE(time_id)
INTERVAL(NUMTOYMINTERVAL(1,'MONTH'))
(PARTITION SALES_Q1 VALUES LESS THAN (TO_DATE('1-4-2019','DD-MM-YYYY')),
PARTITION SALES_Q2 VALUES LESS THAN (TO_DATE('1-6-2019','DD-MM-YYYY')),
PARTITION SALES_Q3 VALUES LESS THAN (TO_DATE('1-9-2019','DD-MM-YYYY')),
PARTITION SALES_Q4 VALUES LESS THAN (TO_DATE('1-12-2019','DD-MM-YYYY'))
);

SQL> INSERT INTO sales11 VALUES(111,101,'2-JUN-2019','A',121,10,200);

1 row created.

SQL> INSERT INTO sales11 VALUES(112,102,'2-JAN-2020','B',122,10,200);

1 row created.


SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','SALES11');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS
  2  WHERE TABLE_NAME='SALES11';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       USERS                                   0
SALES_Q2                       USERS                                   0
SALES_Q3                       USERS                                   1
SALES_Q4                       USERS                                   0
SYS_P21                        USERS                                   1

SQL> INSERT INTO sales11 VALUES(112,102,'2-FEB-2020','B',122,10,200);

1 row created.

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','SALES11');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS
  2  WHERE TABLE_NAME='SALES11';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       USERS                                   0
SALES_Q2                       USERS                                   0
SALES_Q3                       USERS                                   1
SALES_Q4                       USERS                                   0
SYS_P21                        USERS                                   1
SYS_P22                        USERS                                   1

6 rows selected.

SQL> INSERT INTO sales11 VALUES(112,102,'3-FEB-2020','B',122,10,200);

1 row created.

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','SALES11');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS
  2  WHERE TABLE_NAME='SALES11';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       USERS                                   0
SALES_Q2                       USERS                                   0
SALES_Q3                       USERS                                   1
SALES_Q4                       USERS                                   0
SYS_P21                        USERS                                   1
SYS_P22                        USERS                                   2

6 rows selected.
================================================================================================================================
QUERY 8:
Demonstrate reference partitioning as directed:
	 Create parent table Orders with the attributes order_id, order_date,customer_id, shipper_id.
	 Perform Range partitioning on Order Date. Take Range of 03 Months i.e. 01quarter
	 Create child table order_items with attributes order_id, product_id, price andquantity.
	 Perform Reference partitioning on child table.
	 Delete the created partitions.

SQL> CREATE TABLE ORDERS
(
ORDER_ID NUMBER PRIMARY KEY,
ORDER_DATE DATE NOT NULL,
CUSTOMER_ID NUMBER NOT NULL,
SHIPPER_ID NUMBER
)
PARTITION BY RANGE(ORDER_DATE)
(
PARTITION ORD1 VALUES LESS THAN (TO_DATE('1-4-2019','DD-MM-YYYY')),
PARTITION ORD2 VALUES LESS THAN (TO_DATE('1-6-2019','DD-MM-YYYY')),
PARTITION ORD3 VALUES LESS THAN (TO_DATE('1-9-2019','DD-MM-YYYY')),
PARTITION ORD4 VALUES LESS THAN (TO_DATE('1-12-2019','DD-MM-YYYY'))
);

SQL> CREATE TABLE ORDER_ITEMS
(
ORDER_ID NUMBER NOT NULL,
PRODUCT_ID NUMBER NOT NULL,
PRICE NUMBER,
QUANTITY NUMBER,
CONSTRAINT order_items_fk  FOREIGN KEY (ORDER_ID) REFERENCES ORDERS)
PARTITION BY REFERENCE (order_items_fk);

INSERT INTO ORDERS VALUES(201,'2-JUL-2019',101,301);
INSERT INTO ORDER_ITEMS VALUES(201,101,100,302);


SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','ORDERS');

PL/SQL procedure successfully completed.

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','ORDER_ITEMS');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2  FROM USER_TAB_PARTITIONS
  3  WHERE TABLE_NAME='ORDERS';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
ORD1                           USERS                                   0
ORD2                           USERS                                   0
ORD3                           USERS                                   1
ORD4                           USERS                                   0

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2  FROM USER_TAB_PARTITIONS
  3  WHERE TABLE_NAME='ORDER_ITEMS';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
ORD1                           USERS                                   0
ORD2                           USERS                                   0
ORD3                           USERS                                   1
ORD4                           USERS                                   0

SQL> ALTER TABLE ORDERS
  2  DROP PARTITION ORD2;

Table altered.

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','ORDERS');

PL/SQL procedure successfully completed.

SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('MAHIMA04','ORDER_ITEMS');

PL/SQL procedure successfully completed.

SQL> SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2  FROM USER_TAB_PARTITIONS
  3  WHERE TABLE_NAME='ORDER_ITEMS';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
ORD1                           USERS                                   0
ORD3                           USERS                                   1
ORD4                           USERS                                   0
===============================================================================================================================
QUERY 9:
Implement virtual column based partitioning as below:
	 Create table employee with attributes Emp_id, emp_name, fixed_salary,variable_salary. Generate Total salary as virtual colum.
	 Perform range partitioning on Total Salary with four partitions as below:
		o Partition P1 stores salary less than 25000
		o Partition P2 stores salary less than 50000
		o Partition P3 stores salary less than 75000
		o Partition P4 stores any salary above and equal to than 75000

SQL> CREATE TABLE EMPLOYEE
(
EMP_ID NUMBER(18) NOT NULL,
EMP_NAME VARCHAR2(30) NOT NULL,
FIXED_SALARY NUMBER(10,2) NOT NULL,
VARIABLE_SALARY NUMBER(10,2) NOT NULL,
TOTAL_SALARY NUMBER(10,2) GENERATED ALWAYS AS
         ( FIXED_SALARY + VARIABLE_SALARY ) VIRTUAL
)
PARTITION BY RANGE (TOTAL_SALARY) 
       (  
         PARTITION p1 VALUES LESS THAN (25000), 
         PARTITION p2 VALUES LESS THAN (50000), 
         PARTITION p3 VALUES LESS THAN (75000), 
         PARTITION p4 VALUES LESS THAN (MAXVALUE) 
       );

SQL> INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,FIXED_SALARY,VARIABLE_SALARY) VALUES(101,'ABC',20000,1200);

1 row created.

SQL> SELECT * FROM EMPLOYEE;

    EMP_ID EMP_NAME                       FIXED_SALARY VARIABLE_SALARY    TOTAL_SALARY
---------- ------------------------------ ------------ ---------------    ------------
       101 ABC                                   20000            1200      21200
==================================================================================================================================
QUERY 10:
Demonstrate Composite partitioning technique as directed
	 Implement range list partitioning for customer table having attributes cust_id, cust_name, cust_state, and time_id
		o Perform range partitioning on time-id and list partitioning on state attributes. 
		  Also create maxvalue and default partition for range and list partition respectively.
		o Partition definitions for range are as below:
	 Partition old should accept values less than 01-Jan-2005
	 Partition acquired should accept values less than 01-Jan-2010
	 Partition recent should accept values less than 01-Jan-2015
	 Partition unknown should accept values greater than 01-Jan-2015
		o Partition definitions for list are as below:
	 Partition west should accept values (‘MH’, ‘GJ’)
	 Partition south should accept values (‘TN’, ‘AP’)
	 Partition north should accept values (‘UP’, ‘HP’)
	 Partition unknown should accept any other state.

SQL> CREATE TABLE CUSTOMER(
CUST_ID NUMBER NOT NULL,
CUST_NAME VARCHAR2(30) NOT NULL,
CUST_STATE VARCHAR2(2) NOT NULL,
TIME_ID DATE NOT NULL
)
PARTITION BY RANGE(TIME_ID)
SUBPARTITION BY LIST(CUST_STATE)
SUBPARTITION TEMPLATE(
SUBPARTITION west VALUES ('MH', 'GJ'),
SUBPARTITION east VALUES ('TN', 'AP'),
SUBPARTITION cent VALUES ('UP', 'HP')) ( 
PARTITION OLD VALUES LESS THAN (TO_DATE('01-01-2005','DD-MM-YYYY')),
PARTITION ACQUIRED VALUES LESS THAN (TO_DATE('01-01-2010','DD-MM-YYYY')),
PARTITION RECENT VALUES LESS THAN (TO_DATE('01-01-2015','DD-MM-YYYY')),
PARTITION UNKNOWN VALUES LESS THAN(MAXVALUE));


SQL> insert into CUSTOMER values(1,'MAHIMA','UP','2-FEB-2010');

1 row created.


SQL> SELECT TABLE_NAME,PARTITION_NAME,SUBPARTITION_NAME
  2  FROM USER_TAB_SUBPARTITIONS
  3  WHERE TABLE_NAME='CUSTOMER';

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME
------------------------------ ------------------------------ ------------------------------
CUSTOMER                       OLD                            OLD_WEST
CUSTOMER                       OLD                            OLD_EAST
CUSTOMER                       OLD                            OLD_CENT
CUSTOMER                       ACQUIRED                       ACQUIRED_WEST
CUSTOMER                       ACQUIRED                       ACQUIRED_EAST
CUSTOMER                       ACQUIRED                       ACQUIRED_CENT
CUSTOMER                       RECENT                         RECENT_WEST
CUSTOMER                       RECENT                         RECENT_EAST
CUSTOMER                       RECENT                         RECENT_CENT
CUSTOMER                       UNKNOWN                        UNKNOWN_WEST
CUSTOMER                       UNKNOWN                        UNKNOWN_EAST

TABLE_NAME                     PARTITION_NAME                 SUBPARTITION_NAME
------------------------------ ------------------------------ ------------------------------
CUSTOMER                       UNKNOWN                        UNKNOWN_CENT

12 rows selected.

SQL> SELECT * FROM CUSTOMER SUBPARTITION (RECENT_WEST);

no rows selected

SQL> SELECT * FROM CUSTOMER SUBPARTITION (RECENT_CENT);
  
  CUST_ID CUST_NAME                      CU TIME_ID
---------- ------------------------------ -- ---------
         1 MAHIMA                         UP 02-FEB-10

==================================================================================================================================================
QUERY NO 11:(RANGE-HASH)

create table CUSTOMER_RH
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by range(time_id)
	subpartition by hash(cust_id)
	subpartition template(
		subpartition s1,
		subpartition s2)
( 
partition old values less than(TO_DATE('01-jan-2005', 'DD-MON-YYYY')),
partition acquired values less than(TO_DATE('01-jan-2010', 'DD-MON-YYYY')),
partition recent values less than(TO_DATE('01-jan-2015', 'DD-MON-YYYY')), 
partition p1 values less than(maxvalue));

SQL> insert into CUSTOMER_RH values(1,'MAHIMA','UP',110,'10-JAN-2014');

1 row created

SQL> exec dbms_stats.gather_table_stats('MAHIMA04','CUSTOMER_RH');

PL/SQL procedure successfully completed.

SQL> select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER_RH';

PARTITION_NAME                 TABLESPACE_NAME                   NUM_ROWS
------------------------------ ------------------------------  ----------
ACQUIRED                       USERS                                    1
OLD                            USERS                                    0
P1                             USERS                                    0
RECENT                         USERS                                    0

SQL> select * from CUSTOMER_RH subpartition(recent_s1);

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 MAHIMA     UP                110 10-JAN-2014
		 
==========================================================================================================================
QUERY NO 12:(RANGE-RANGE)

create table CUSTOMER_RR
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date )
PARTITION BY RANGE (time_id)
        SUBPARTITION BY RANGE (cust_id)
          (PARTITION old VALUES LESS THAN (TO_DATE('01-JAN-2005','DD-MON-YYYY'))
             (subpartition old1 values less than(10),
			  subpartition old2 values less than(20),
		      subpartition old3 values less than(maxvalue)
            ),
          PARTITION acquired VALUES LESS THAN ( TO_DATE('01-JAN-2010','DD-MON-YYYY'))
            (subpartition acquired1 values less than(10),
			  subpartition acquired2 values less than(20),
		      subpartition acquired3 values less than(maxvalue)
            ),
          PARTITION recent VALUES LESS THAN (TO_DATE('01-JAN-2015','DD-MON-YYYY'))
            (subpartition recent1 values less than(10),
			  subpartition recent2 values less than(20),
		      subpartition recent3 values less than(maxvalue)
            ),
          PARTITION p VALUES LESS THAN (maxvalue)
            (subpartition sp1 values less than(10),
			  subpartition sp2 values less than(20),
		      subpartition sp3 values less than(maxvalue)
            )
         );
		 
SQL> insert into CUSTOMER_RR values(1,'MAHIMA','MH',150,'12-feb-2004');

1 row created

SQL> exec dbms_stats.gather_table_stats('MAHIMA04','CUSTOMER_RR');

PL/SQL procedure successfully completed.

SQL> select partition_name,tablespace_name,num_rows from user_tab_partitions where table_name='CUSTOMER_RR';
 
 PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------  ----------
ACQUIRED                       USERS                                 0
OLD                            USERS                                 1
P1                             USERS                                 0
RECENT                         USERS                                 0

SQL> select * from CUSTOMER_RR subpartition(old1);

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 MAHIMA     MH                 150 01-FEB-09
		 

=========================================================================================================================================
QUERY NO 13:(LIST-HASH)

create table CUSTOMER_LH
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by list(cust_state)
subpartition by hash(cust_id)
	subpartition template(
	subpartition sub1,
	subpartition sub2)
( 
	partition old values ('MH','TN'),
	partition acquired values ('GJ','UP'),
	partition recent values (default));
	
SQL> insert into CUSTOMER_LH values(1,'MAHIMA','MP',120,'21-APR-2018');

1 row created

SQL> exec dbms_stats.gather_table_stats('MAHIMA04','CUSTOMER_LH');

PL/SQL procedure successfully completed.

SQL> select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER_LH';

PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ACQUIRED                       USERS                          'GJ', 'UP'                                                                        0
OLD                            USERS                          'MH', 'TN'                                                                        0
RECENT                         USERS                          default                                                                           1

SQL> select * from CUSTOMER_LH subpartition(recent_sub1);

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 MAHIMA     MP                120 21-APR-2018
===============================================================================================================================================
QUERY NO 14:(LIST-LIST)

create table CUSTOMER_LL
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by list(cust_state)
subpartition by list(cust_id)
subpartition template(
	subpartition s1 values ('1','2'),
	subpartition s2 values(default))
( 
	partition old values ('MH','TN'),
	partition acquired values ('GJ','UP'),
	partition recent values (default));
	
SQL> insert into customer5 values(2,'MAHIMA','MH',500,'13-AUG-2019');

1 row created

exec dbms_stats.gather_table_stats('MAHIMA04','CUSTOMER_LL');

PL/SQL procedure completed successfully

SQL> select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER_LL';

PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----
ACQUIRED                       USERS                          'GJ', 'UP'                                                                        0
OLD                            USERS                          'MH', 'TN'                                                                        1
RECENT                         USERS                          default                                                                           0

SQL> select * from customer5 subpartition(old_s1);

 CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
-------- ---------- ---------- ----------- ---------
       1 MAHIMA     MH                500 12-AUG-19
==================================================================================================================================================
QUERY NO 15:(LIST-RANGE)

create table CUSTOMER_LR
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by list(cust_state)
subpartition by range(cust_id)
subpartition template(
	subpartition s1 values less than(5),
	subpartition s2 values less than(maxvalue))
( 
	partition old values ('MH','TN'),
	partition acquired values ('GJ','UP'),
	partition recent values (default));
	
SQL> insert into CUSTOMER_LR values(1,'MAHIMA','UP',250,'16-AUG-2019');

1 row created

SQL> exec dbms_stats.gather_table_stats('MAHIMA04','CUSTOME_LR');

PL/SQL procedure  completed successfully

SQL> select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOME_LR';

PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----
ACQUIRED                       USERS                          'GJ', 'UP'                                                                        1
OLD                            USERS                          'MH', 'TN'                                                                        0
RECENT                         USERS                          default                                                                           0

SQL> select * from CUSTOMER_LR subpartition(accquired_s1);

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 MAHIMA     UP                250 16-AUG-19
=================================================================================================================================================
