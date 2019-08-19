AUTHOR  : HASHIR SHEIKH
ROLL NO : 57 [6B]
DATE    : 06-April-2019

/*Query 01*/
--*******************************************************************************
1. Write a query to create range portioned table:
   Creates a table named- Sales consisting of four partitions, one for each quarter
of sales. The columns sale_year, sale_month, and sale_day are the partitioning
columns, while their values constitute the partitioning key of a specific row.
   Each partition is given a name (sales_q1, sales_q2, ...), and each partition is
contained in a separate tablespace (tsa, tsb, ...)
    The columns for table must be prod_id, cust_id, promo_id, quantify sold,
amount_sold – all in number format and time_id.
--*******************************************************************************

CREATE TABLESPACE hf1 DATAFILE 'C:\Users\hashir57\hf1.dbf' SIZE 10M;
    Tablespace created.
CREATE TABLESPACE hf2 DATAFILE 'C:\Users\hashir57\hf2.dbf' SIZE 10M;
    Tablespace created.
CREATE TABLESPACE hf3 DATAFILE 'C:\Users\hashir57\hf3.dbf' SIZE 10M; 
    Tablespace created.
CREATE TABLESPACE hf4 DATAFILE 'C:\Users\hashir57\hf4.dbf' SIZE 10M;
    Tablespace created.

Create table  sales(
    prod_id NUMBER(6),
    cust_id NUMBER,
    time_id DATE,
    channel_id CHAR (1),
    promo_id NUMBER(6),
    quantity_sold NUMBER(3),
    amount_sold NUMBER(10,2)
    )
   PARTITION BY RANGE (time_id)(
   PARTITION p0 VALUES LESS THAN (TO_DATE('1-4-2001','DD-MM-YYYY')) TABLESPACE hf1,
   PARTITION p1 VALUES LESS THAN (TO_DATE('1-7-2001','DD-MM-YYYY')) TABLESPACE hf2,
   PARTITION p2 VALUES LESS THAN (TO_DATE('1-10-2001','DD-MM-YYYY')) TABLESPACE hf3,
   PARTITION p3 VALUES LESS THAN (TO_DATE('1-1-2002','DD-MM-YYYY')) TABLESPACE hf4);

Table created.

INSERT INTO sales VALUES (111,222,TO_DATE('2-3-2001','DD-MM-YYYY'),'A',333,200,500.20);
INSERT INTO sales VALUES (112,223,TO_DATE('2-5-2001','DD-MM-YYYY'),'B',333,100,200.10);
INSERT INTO sales VALUES (113,224,TO_DATE('2-6-2001','DD-MM-YYYY'),'A',333,300,300.40);
INSERT INTO sales VALUES (114,225,TO_DATE('2-11-2001','DD-MM-YYYY'),'D',333,400,400.50);

SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS 
FROM USER_TAB_PARTITIONS 
WHERE TABLE_NAME = 'SALES';

exec dbms_stats.gather_table_stats('hashir57','sales');

PL/SQL procedure successfully completed.

/*Query 02*/
--*******************************************************************************
2. Create the same table as in Q1. With a different name with ENABLE ROW
MOVEMENT
--*******************************************************************************

create table  sales1(
    prod_id NUMBER(6),
    cust_id NUMBER,
    time_id DATE,
    channel_id CHAR (1),
    promo_id NUMBER(6),
    quantity_sold NUMBER(3),
    amount_sold NUMBER(10,2)
    )
   PARTITION BY RANGE (time_id)(
   PARTITION t0 VALUES LESS THAN (TO_DATE('1-4-2001','DD-MM-YYYY')) TABLESPACE hf1,
   PARTITION t1 VALUES LESS THAN (TO_DATE('1-7-2001','DD-MM-YYYY')) TABLESPACE hf2,
   PARTITION t2 VALUES LESS THAN (TO_DATE('1-10-2001','DD-MM-YYYY')) TABLESPACE hf3,
   PARTITION t3 VALUES LESS THAN (TO_DATE('1-1-2002','DD-MM-YYYY')) TABLESPACE hf4)
   ENABLE ROW MOVEMENT;

Table created.

INSERT INTO sales1 VALUES (111,222,TO_DATE('2-3-2001','DD-MM-YYYY'),'A',333,200,500.20);
  1 row created.
INSERT INTO sales1 VALUES (112,223,TO_DATE('2-5-2001','DD-MM-YYYY'),'B',333,100,200.10);
  1 row created.
INSERT INTO sales1 VALUES (113,224,TO_DATE('2-6-2001','DD-MM-YYYY'),'A',333,300,300.40);
  1 row created.
INSERT INTO sales1 VALUES (114,225,TO_DATE('2-11-2001','DD-MM-YYYY'),'D',333,400,400.50);
  1 row created.
UPDATE SALES1 SET time_id = TO_DATE('2-3-2001','DD-MM-YYYY') WHERE time_id = TO_DATE('2-11-2001','DD-MM-YYYY');
  1 row updated.

/*Query 03*/
--*******************************************************************************
3. Create a table with list partition as follows:
Table having columns deptno, deptname, quarterly_sales and state.
Create partition on state:
      Northwest on OR and WA
      Southwest on AZ, UT and NM
      northeast on NY, VM and NJ
      southeast on FL and GA
      northcentral on SD and WI
      southcentral on OK and TX
Add the following entries into the table and make conclusion to which partition the entry maps:
      (10, 'accounting', 100, 'WA')
      (20, 'R&D', 150, 'OR')
      (30, 'sales', 100, 'FL')
      (40, 'HR', 10, 'TX')
      (50, 'systems engineering', 10, 'CA')
      
--*******************************************************************************

Create table dept(
  2  deptno NUMBER(3),
  3  deptname VARCHAR2(20),
  4  quarterly_sales NUMBER(4),
  5  states VARCHAR2(2)
  6  )
  7  PARTITION BY LIST (states)
  8  (
  9  PARTITION NORTHWEST VALUES ('OR','WA'),
 10  PARTITION SOUTHWEST VALUES ('AZ','UT','NM'),
 11  PARTITION NORTHEAST VALUES ('NY','VM','NJ'),
 12  PARTITION SOUTHEAST VALUES ('FL','GA'),
 13  PARTITION NORTHCENTRAL VALUES ('SD','WI'),
 14  PARTITION SOUTHCENTRAL VALUES ('OK','TX'));

Table created.

INSERT INTO DEPT VALUES(10,'accounting',100,'WA');
    1 row created.
INSERT INTO DEPT VALUES(20,'R AND D',150,'OR');
    1 row created.
INSERT INTO DEPT VALUES(30,'Sales',100,'FL');
    1 row created.
INSERT INTO DEPT VALUES(40,'HR',10,'TX');
    1 row created.
INSERT INTO DEPT VALUES(50,'System engineering',10,'CA');
INSERT INTO DEPT VALUES(50,'System engineering',10,'CA')
    ERROR at line 1:
    ORA-14400: inserted partition key does not map to any partition



alter table dept add partition def values(default);
    Table altered.

SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS
  2  FROM USER_TAB_PARTITIONS
  3  WHERE TABLE_NAME = 'DEPT';
/*
PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
NORTHWEST                      USERS                                   2
SOUTHWEST                      USERS                                   0
NORTHEAST                      USERS                                   0
SOUTHEAST                      USERS                                   1
NORTHCENTRAL                   USERS                                   0
SOUTHCENTRAL                   USERS                                   1
DEF                            USERS                                   0

7 rows selected.

*/

INSERT INTO DEPT VALUES(50,'System engineering',10,'CA');
    1 row created.

SELECT PARTITION_NAME,TABLESPACE_NAME,NUM_ROWS 
FROM USER_TAB_PARTITIONS 
WHERE TABLE_NAME = 'DEPT';
/*
PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
NORTHWEST                      USERS                                   2
SOUTHWEST                      USERS                                   0
NORTHEAST                      USERS                                   0
SOUTHEAST                      USERS                                   1
NORTHCENTRAL                   USERS                                   0
SOUTHCENTRAL                   USERS                                   1
DEF                            USERS                                   1

7 rows selected.
*/

/*Query 04*/
--*******************************************************************************
4. Create a table with hash partition as follows:
   Create table Emp with attributes empno, job, sal, deptno and perform hash
    partitioning on empno. Number of Partitions should be 5. Demonstarte
    using system defined and user defined partition concepts.
--*******************************************************************************
 
CREATE TABLE EMPLOYEE1(
  EMP_NO NUMBER(2),
  JOB NUMBER(2),
  SALARY NUMBER(2),
  DEPT_NO NUMBER(2)
  )
  PARTITION BY HASH(EMP_NO)
  PARTITIONS 5;
  
Table created.

INSERT INTO EMPLOYEE1 values('1','12','50','10');
    1 row created.
INSERT INTO EMPLOYEE1 values('2','22','54','18');
    1 row created.
INSERT INTO EMPLOYEE1 values('4','42','70','12');
    1 row created.
INSERT INTO EMPLOYEE1 values('3','52','10','70');
    1 row created.
exec dbms_stats.gather_table_stats('hashir57','EMPLOYEE1');
    PL/SQL procedure successfully completed.

select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='EMPLOYEE1';
/*
    PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SYS_P41                        USERS                                   0
SYS_P42                        USERS                                   0
SYS_P43                        USERS                                   1
SYS_P44                        USERS                                   3
SYS_P45                        USERS                                   0
*/

/*Query 05*/
--*******************************************************************************
5. Create a multi-column range partitioned table as directed:
 Create a table with the actual DATE information in three separate
    columns: year, month, and day. Also amount_ sold.
 Create following partitions:
    o Before 2001: Less than jan 2001
    o Less than april 2001
    o Less than july 2001
    o Les than oct 2001
    o Less than jan 2002
    o Future with max incoming value
 Insert values into table and show to which partition does the value belong.
    o (2001,3,17, 2000);
    o (2001,11,1, 5000);
    o (2002,1,1, 4000);
Make conclusion for each result.
--*******************************************************************************
Create table date_data
  2     (date_year number(4),
  3     date_month number (2),
  4     date_day number(2),
  5     amount_sold number(20)
  6     )
  7     partition by range(date_year,date_month)(
  8    partition  p1 values less than(2001,01),
  9     partition  p2 values less than(2001,04),
 10     partition  p3 values less than(2001,07),
 11     partition  p4 values less than(2001,10),
 12     partition  p5 values less than(2002,01),
 13     partition  p6 values less than(maxvalue,maxvalue)
 14    );

Table created.

insert into date_data values(2001,3,17, 2000);
    1 row created.
insert into date_data values(2001,11,1, 5000);
    1 row created.
insert into date_data values(2002,1,1, 4000);
    1 row created.

exec dbms_stats.gather_table_stats('hashir57','date_data');
    PL/SQL procedure successfully completed.

select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='DATE_DATA';

/*
PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
P1                             USERS                                   0
P2                             USERS                                   1
P3                             USERS                                   0
P4                             USERS                                   0
P5                             USERS                                   1
P6                             USERS                                   1

6 rows selected.
*/

/*Query 06*/
--*******************************************************************************
6. Create a multicolumn partitioned table as directed:
 Table supplier_parts, storing the information about which suppliers deliver
    which parts. To distribute the data in equal-sized partitions, it is not sufficient
    to partition the table based on the supplier_id, because some suppliers might
    provide hundreds of thousands of parts, while others provide only a few
    specialty parts. Instead, you partition the table on (supplier_id, partnum) to
    manually enforce equal-sized partitions.
 Insert the following values
    (5,5, 1000);
    (5,150, 1000);
    (10,100, 1000);
--*******************************************************************************


Create table supplier_parts
  2    (
  3    supplier_id number(4),
  4    part_num number (4),
  5    amount number(10))
  6    partition by range(supplier_id,part_num)(
  7    partition  p1 values less than(10,100),
  8    partition  p2 values less than(20,200),
  9    partition  p3 values less than(30,300),
 10    partition  p4 values less than(40,400),
 11    partition  p5 values less than(maxvalue,maxvalue)
 12    );
Table created.\

insert into supplier_parts values(5,5, 1000);
1 row created.
insert into supplier_parts values(5,150, 1000);
1 row created.
insert into supplier_parts values(10,100, 1000);
1 row created.

exec dbms_stats.gather_table_stats('hashir57','supplier_parts');
PL/SQL procedure successfully completed.

select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SUPPLIER_PARTS';
/*
PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
P1                             USERS                                   2
P2                             USERS                                   1
P3                             USERS                                   0
P4                             USERS                                   0
P5                             USERS                                   0
-- --------------------------------------------------------------
*/

/*Query 07*/
--*******************************************************************************
7. Create interval partitioned table as directed:
 Creates a table named- Sales consisting of four partitions, one for each quarter
    of sales. Each partition is given a name (sales_q1, sales_q2, ...)
 The columns for table must be prod_id, cust_id, promo_id, quantify sold,
    amount_sold – all in number format and month in number format
 Perform interval partitioning on month and take interval of 01 months.
--*******************************************************************************

CREATE TABLE sales_interval
  (product_id                NUMBER,
    customer_id                NUMBER,
    time_id                    DATE,
    channel_info               CHAR(1),
    promo_id                   NUMBER,
    qty_sold                   NUMBER,
    amt_sold                   NUMBER
    )
   PARTITION BY RANGE (time_id)
   INTERVAL(NUMTOYMINTERVAL(1, 'MONTH'))
   (PARTITION sales_q1 VALUES LESS THAN (TO_DATE('1-4-2001','DD-MM-YYYY')),
   PARTITION sales_q2 VALUES LESS THAN (TO_DATE('1-7-2001','DD-MM-YYYY')),
   PARTITION sales_q3 VALUES LESS THAN (TO_DATE('1-10-2001','DD-MM-YYYY'))
   );
   
   
INSERT INTO sales_interval VALUES (111,222,TO_DATE('2-3-2001','DD-MM-YYYY'),'A',333,200,500.20);
INSERT INTO sales_interval VALUES (112,223,TO_DATE('2-5-2001','DD-MM-YYYY'),'B',333,100,200.10);
INSERT INTO sales_interval VALUES (113,224,TO_DATE('2-6-2001','DD-MM-YYYY'),'A',333,300,300.40);
INSERT INTO sales_interval VALUES (114,225,TO_DATE('2-11-2001','DD-MM-YYYY'),'D',333,400,400.50);


--To get partition name for last quarter
select table_name, partition_name
  2  from user_tab_partitions
  3  ;
/*
TABLE_NAME                     PARTITION_NAME
------------------------------ ------------------------------
SALES                          P0
SALES                          P1
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q2
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q3
SALES_INTERVAL                 SALES_Q1
SALES                          P2
SALES                          P3
SALES1                         T0
SALES1                         T1
SALES1                         T2
SALES1                         T3
SALES_INTERVAL                 SALES_Q2
SALES_INTERVAL                 SALES_Q3
SALES_INTERVAL                 SYS_P66
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q1

15 rows selected.
*/

select * from sales_interval partition(sales_q1);

/*
PRODUCT_ID CUSTOMER_ID TIME_ID   C   PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ----------- --------- - ---------- ---------- ----------
       111         222 02-MAR-01 A        333        200      500.2
*/

select * from sales_interval partition(sales_q2);
/*
PRODUCT_ID CUSTOMER_ID TIME_ID   C   PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ----------- --------- - ---------- ---------- ----------
       112         223 02-MAY-01 B        333        100      200.1
       113         224 02-JUN-01 A        333        300      300.4
*/
select * from sales_interval partition(sales_q3);

--no rows selected.

 select * from sales_interval partition(SYS_P66);

PRODUCT_ID CUSTOMER_ID TIME_ID   C   PROMO_ID   QTY_SOLD   AMT_SOLD
---------- ----------- --------- - ---------- ---------- ----------
       114         225 02-NOV-01 D        333        400      400.5

	   
--------------------------------------------------------------------------------------------
/*Query 08*/
--*******************************************************************************
8. Demonstrate reference partitioning as directed:
 Create parent table Orders with the attributes order_id, order_date,
      customer_id, shipper_id.
 Perform Range partitioning on Order Date. Take Range of 03 Months i.e. 01
      quarter
 Create child table order_items with attributes order_id, product_id, price and
      quantity.
 Perform Reference partitioning on child table.
 Delete the created partitions.
--*******************************************************************************

CREATE TABLE orders (
  order_id    NUMBER PRIMARY KEY,
  order_date  DATE NOT NULL,
  customer_id NUMBER NOT NULL,
  shipper_id  NUMBER)
PARTITION BY RANGE (order_date) (
  PARTITION q1 VALUES LESS THAN (TO_DATE('1-4-2001', 'DD-MM-YYYY')),
  PARTITION q2 VALUES LESS THAN (TO_DATE('1-7-2001', 'DD-MM-YYYY')),
  PARTITION q3 VALUES LESS THAN (TO_DATE('1-10-2001', 'DD-MM-YYYY')),
  PARTITION q4 VALUES LESS THAN (TO_DATE('1-1-2002', 'DD-MM-YYYY')));

--Table created.  
  

CREATE TABLE order_items (
  order_id    NUMBER NOT NULL,
  product_id  NUMBER NOT NULL,
  price       NUMBER,
  quantity    NUMBER,
  CONSTRAINT order_items_fk FOREIGN KEY (order_id) REFERENCES orders)
PARTITION BY REFERENCE (order_items_fk);

--Table created.


INSERT INTO orders VALUES (111,TO_DATE('2-3-2001','DD-MM-YYYY'),222,333);
INSERT INTO orders VALUES (112,TO_DATE('2-7-2001','DD-MM-YYYY'),223,334);
INSERT INTO orders VALUES (113,TO_DATE('2-11-2001','DD-MM-YYYY'),224,335);
INSERT INTO orders VALUES (114,TO_DATE('2-5-2001','DD-MM-YYYY'),225,336);

INSERT INTO order_items VALUES (111,226,40000,500);
INSERT INTO order_items VALUES (112,223,10000,600);
INSERT INTO order_items VALUES (113,224,50000,200);
INSERT INTO order_items VALUES (114,225,300000,300);

--Deleting partition q4

alter table orders
    drop partition q4;
  
select table_name, partition_name
    from user_tab_partitions;

/*TABLE_NAME                     PARTITION_NAME
------------------------------ ------------------------------
SALES                          P0
SALES                          P1
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q2
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q3
SALES_INTERVAL                 SALES_Q1
SALES                          P2
SALES                          P3
SALES1                         T0
SALES1                         T1
SALES1                         T2
SALES1                         T3
SALES_INTERVAL                 SALES_Q2
SALES_INTERVAL                 SALES_Q3
SALES_INTERVAL                 SYS_P66
BIN$N+S+XXfmSgO6IlIJd0mitg==$0 Y1
BIN$N+S+XXfmSgO6IlIJd0mitg==$0 Y2
BIN$N+S+XXfmSgO6IlIJd0mitg==$0 Y3
BIN$7jXlWEHDQbizhkGcu72OGw==$0 Y1
BIN$Q7JWQYB0Q/mv1x+ajcwO4g==$0 SALES_Q1
BIN$7jXlWEHDQbizhkGcu72OGw==$0 Y3
BIN$7jXlWEHDQbizhkGcu72OGw==$0 Y2
BIN$yqPq5kpxTsO1+tb1OfI2uw==$0 Y1
BIN$yqPq5kpxTsO1+tb1OfI2uw==$0 Y2
BIN$yqPq5kpxTsO1+tb1OfI2uw==$0 Y3
ORDERS                         Q1
ORDERS                         Q2
ORDERS                         Q3
ORDER_ITEMS                    Q1
ORDER_ITEMS                    Q2
ORDER_ITEMS                    Q3

30 rows selected.*/


--------------------------------------------------------------------------------------------
   
/*Query 09*/
--*******************************************************************************
9. Implement virtual column based partitioning as below:
 Create table employee with attributes Emp_id, emp_name, fixed_salary,
    variable_salary. Generate Total salary as virtual colum.
 Perform range partitioning on Total Salary with four partitions as below:
    o Partition P1 stores salary less than 25000
    o Partition P2 stores salary less than 50000
    o Partition P3 stores salary less than 75000
    o Partition P4 stores any salary above and equal to than 75000
--*******************************************************************************
Create table employee(
  emp_id number primary key,
  emp_name varchar(20),
  fixed_salary number,
  variable_salary number,
   total_salary number generated always as (fixed_salary+variable_salary) virtual
)
PARTITION BY RANGE (total_salary) 
       (  
         PARTITION emp_p1 VALUES LESS THAN (25000), 
         PARTITION emp_p2 VALUES LESS THAN (50000), 
         PARTITION emp_p3 VALUES LESS THAN (75000), 
         PARTITION emp_p4 VALUES LESS THAN (MAXVALUE) 
);

insert into employee(emp_id, emp_name, fixed_salary, variable_salary) values(111,'abc', 10000, 20000);
insert into employee(emp_id, emp_name, fixed_salary, variable_salary) values(112,'def', 50000, 30000);
insert into employee(emp_id, emp_name, fixed_salary, variable_salary) values(113,'ghi', 1000, 30000);
insert into employee(emp_id, emp_name, fixed_salary, variable_salary) values(114,'jkl', 1000, 10000);
insert into employee(emp_id, emp_name, fixed_salary, variable_salary) values(115,'mno', 10000, 100000);

--fetching metadata
select table_name, partition_name, high_value
    from user_tab_partitions
    where table_name='EMPLOYEE';
/*
TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE
------------------------------ ------------------------------ --------------------------------------------------------------------------------
EMPLOYEE                       EMP_P1                         25000
EMPLOYEE                       EMP_P2                         50000
EMPLOYEE                       EMP_P3                         75000
EMPLOYEE                       EMP_P4                         MAXVALUE
*/
select * from employee;

/*    EMP_ID EMP_NAME             FIXED_SALARY VARIABLE_SALARY TOTAL_SALARY
---------- -------------------- ------------ --------------- ------------
       114 jkl                          1000           10000        11000
       111 abc                         10000           20000        30000
       113 ghi                          1000           30000        31000
       112 def                         50000           30000        80000
       115 mno                         10000          100000       110000
*/

SQL> select * from employee partition(emp_p1);

/*    EMP_ID EMP_NAME             FIXED_SALARY VARIABLE_SALARY TOTAL_SALARY
---------- -------------------- ------------ --------------- ------------
       114 jkl                          1000           10000        11000
*/

SQL> select * from employee partition(emp_p2);
/*
    EMP_ID EMP_NAME             FIXED_SALARY VARIABLE_SALARY TOTAL_SALARY
---------- -------------------- ------------ --------------- ------------
       111 abc                         10000           20000        30000
       113 ghi                          1000           30000        31000
*/
SQL> select * from employee partition(emp_p3);

--no rows selected


SQL> select * from employee partition(emp_p4);
/*
    EMP_ID EMP_NAME             FIXED_SALARY VARIABLE_SALARY TOTAL_SALARY
---------- -------------------- ------------ --------------- ------------
       112 def                         50000           30000        80000
       115 mno                         10000          100000       110000
*/



/*Query 10*/
--*******************************************************************************
10. Demonstrate Composite partitioning technique as directed
 Implement range list partitioning for customer table having attributes
  cust_id, cust_name, cust_state, and time_id
    o Perform range partitioning on time-id and list partitioning on state
      attributes. Also create maxvalue and default partition for range and
      list partition respectively.
    o Partition definitions for range are as below:
         Partition old should accept values less than 01-Jan-2005
         Partition acquired should accept values less than 01-Jan-
        2010
         Partition recent should accept values less than 01-Jan-2015
         Partition unknown should accept values greater than 01-Jan-
        2015
    o Partition definitions for list are as below:
         Partition west should accept values (‘MH’, ‘GJ’)
         Partition south should accept values (‘TN’, ‘AP’)
         Partition north should accept values (‘UP’, ‘HP’)
         Partition unknown should accept any other state.
--*******************************************************************************

CREATE TABLE cust_comp (
	cust_id     NUMBER(10), 
	cust_name   VARCHAR2(25), 
	cust_state  VARCHAR2(2), 
	time_id     DATE)
	PARTITION BY RANGE(time_id) 
		SUBPARTITION BY LIST (cust_state)
		SUBPARTITION TEMPLATE(
		SUBPARTITION west VALUES ('MH', 'GJ'),
		SUBPARTITION south VALUES ('TN', 'AP'),
		SUBPARTITION north VALUES ('UP', 'HP'),
		SUBPARTITION unknown VALUES (DEFAULT)) ( 
			PARTITION old1 VALUES LESS THAN (TO_DATE('01/01/2005','DD/MM/YYYY')),
			PARTITION acquired1 VALUES LESS THAN (TO_DATE('01/01/2010','DD/MM/YYYY')),
			PARTITION recent1 VALUES LESS THAN (TO_DATE('01/01/2015','DD/MM/YYYY')),
			PARTITION unknown VALUES LESS THAN(MAXVALUE)
);

 select table_name, partition_name, high_value
        from user_tab_partitions
        where table_name='CUST_COMP';

/*
TABLE_NAME                     PARTITION_NAME                 HIGH_VALUE
------------------------------ ------------------------------ --------------------------------------------------------------------------------
CUST_COMP                      OLD1                           TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
CUST_COMP                      ACQUIRED1                      TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
CUST_COMP                      RECENT1                        TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
CUST_COMP                      UNKNOWN                        MAXVALUE
*/

--To get metadata of subpartitions
select table_name, subpartition_name from user_tab_subpartitions
  2  where table_name='CUST_COMP';
/*
TABLE_NAME                     SUBPARTITION_NAME
------------------------------ ------------------------------
CUST_COMP                      OLD1_WEST
CUST_COMP                      OLD1_SOUTH
CUST_COMP                      OLD1_NORTH
CUST_COMP                      OLD1_UNKNOWN
CUST_COMP                      ACQUIRED1_WEST
CUST_COMP                      ACQUIRED1_SOUTH
CUST_COMP                      ACQUIRED1_NORTH
CUST_COMP                      ACQUIRED1_UNKNOWN
CUST_COMP                      RECENT1_WEST
CUST_COMP                      RECENT1_SOUTH
CUST_COMP                      RECENT1_NORTH
CUST_COMP                      RECENT1_UNKNOWN
CUST_COMP                      UNKNOWN_WEST
CUST_COMP                      UNKNOWN_SOUTH
CUST_COMP                      UNKNOWN_NORTH
CUST_COMP                      UNKNOWN_UNKNOWN

16 rows selected.
*/

SQL> select * from cust_comp subpartition(old1_south);

--no rows selected


/*Query 11-15*/
--******************************************************************************
	   
	CREATE FOUR TABLESPACES PART 1, PART 2 , PART 3 AND PART 4.
	CREATE PARTITIONING ON THE SCHEMA OF PROBLEM NO 10.
	
	PERFORM FOLLOWING PARTITIONING :
		1. RANGE HASH
		2. RANGE RANGE
		3. LIST LIST
		4. LIST RANGE
		5. LIST HASH
*/
	   
CREATE TABLESPACE TSA1 DATAFILE 'C:\Users\admin\Desktop\TSA1.dbf' SIZE 10M;
CREATE TABLESPACE TSB2 DATAFILE 'C:\Users\admin\Desktop\TSB2.dbf' SIZE 10M;
CREATE TABLESPACE TSC3 DATAFILE 'C:\Users\admin\Desktop\TSC3.dbf' SIZE 10M;
CREATE TABLESPACE TSD4 DATAFILE 'C:\Users\admin\Desktop\TSD4.dbf' SIZE 10M;
--******************************************************************************
-----------------------------------------------------------------------
--RANGE -RANGE PARTITIONING :
-----------------------------------------------------------------------

CREATE TABLE COMPOSITE_RANGE (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY RANGE (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION ORIGINAL VALUES LESS THAN(1001)
		TABLESPACE TSA1,
		SUBPARTITION ACQUIRED VALUES LESS THAN(2001)
		TABLESPACE TSB2,
		SUBPARTITION GAIN VALUES LESS THAN(5001)
		TABLESPACE TSC3,
		SUBPARTITION RECENT VALUES LESS THAN(MAXVALUE)
		TABLESPACE TSD4)
		(PARTITION PART1 VALUES LESS THAN (TO_DATE('1/01/2005','DD/MM/YYYY')),
		PARTITION PART2 VALUES LESS THAN (TO_DATE('1/01/2010','DD/MM/YYYY')),
		PARTITION PART3 VALUES LESS THAN (TO_DATE('1/01/2015','DD/MM/YYYY')),
		PARTITION FUTURE VALUES LESS THAN (MAXVALUE));
		
		INSERT INTO COMPOSITE_RANGE VALUES ( 1001, 'hashir', 'MH', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO COMPOSITE_RANGE VALUES ( 1002, 'SUNS', 'MH', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO COMPOSITE_RANGE VALUES ( 1003, 'SHIN', 'AP', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
PART1                          USERS                                   1
PART2                          USERS                                   0
PART3                          USERS                                   2
FUTURE                         USERS                                   0
-----------------------------------------------------------------------
--LIST HASH 
-----------------------------------------------------------------------
CREATE TABLE LIST_HASH (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY LIST (CUST_STATE)
	SUBPARTITION BY HASH (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 TABLESPACE TSA1,
		SUBPARTITION SP2 TABLESPACE TSB2,
		SUBPARTITION SP3 TABLESPACE TSC3,
		SUBPARTITION SP4 TABLESPACE TSD4)
		(PARTITION WEST VALUES ('OR','WA'),
		 PARTITION EAST VALUES ('AZ','UT','NM'),
		 PARTITION NORTH VALUES ('NY','VM','NJ'),
		 PARTITION SOUTH VALUES ('FL','GA'));
		
		
		
		
		INSERT INTO LIST_HASH VALUES ( 1001, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO LIST_HASH VALUES ( 1002, 'SUNS', 'NM', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO LIST_HASH VALUES ( 1003, 'SHIN', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));
		INSERT INTO LIST_HASH VALUES ( 1003, 'BOB', 'WA', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		
SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_HASH';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
WEST                           USERS                                   2
EAST                           USERS                                   1
NORTH                          USERS                                   1
SOUTH                          USERS                                   0


-----------------------------------------------------------------------
--LIST LIST
-----------------------------------------------------------------------
CREATE TABLE LIST_LIST (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY LIST (CUST_STATE)
	SUBPARTITION BY LIST (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 VALUES (1,3,5) TABLESPACE TSA1,
		SUBPARTITION SP2 VALUES (2,4,6) TABLESPACE TSB2,
		SUBPARTITION SP3 VALUES (7,8,9,0) TABLESPACE TSC3)
		(PARTITION WEST VALUES ('OR','WA'),
		 PARTITION EAST VALUES ('AZ','UT','NM'),
		 PARTITION NORTH VALUES ('NY','VM','NJ'),
		 PARTITION SOUTH VALUES ('FL','GA'));
		

INSERT INTO LIST_LIST VALUES ( 1, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 2, 'SUNS', 'NM', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 3, 'SHIN', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 3, 'BOB', 'WA', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_LIST';
		
SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_LIST';


PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
WEST                           USERS                                   2
EAST                           USERS                                   1
NORTH                          USERS                                   1
SOUTH                          USERS                                   0
-----------------------------------------------------------------------
--RANGE HASH
-----------------------------------------------------------------------
CREATE TABLE RANGE_HASH (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(10),
	TIME_ID DATE)
	PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY HASH (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1  TABLESPACE TSA1,
		SUBPARTITION SP2  TABLESPACE TSB2,
		SUBPARTITION SP3  TABLESPACE TSC3,
		SUBPARTITION SP4  TABLESPACE TSD4)
		(PARTITION PART1 VALUES LESS THAN (TO_DATE('1/01/2005','DD/MM/YYYY')),
		PARTITION PART2 VALUES LESS THAN (TO_DATE('1/01/2010','DD/MM/YYYY')),
		PARTITION PART3 VALUES LESS THAN (TO_DATE('1/01/2015','DD/MM/YYYY')),
		PARTITION FUTURE VALUES LESS THAN (MAXVALUE));
		
		
		INSERT INTO RANGE_HASH
		SELECT C.CUST_ID , C.CUST_FIRST_NAME || ' ' || 
		C.CUST_LAST_NAME,
		S.AMOUNT_SOLD, S.TIME_ID 
		FROM SH.SALES S, SH.CUSTOMERS C
		WHERE S.CUST_ID = C.CUST_ID 
		AND ROWNUM < 250001;
		
		
/*QUERY 11-15
	   
	CREATE FOUR TABLESPACES PART 1, PART 2 , PART 3 AND PART 4.
	CREATE PARTITIONING ON THE SCHEMA OF PROBLEM NO 10.
	
	PERFORM FOLLOWING PARTITIONING :
		1. RANGE HASH
		2. RANGE RANGE
		3. LIST LIST
		4. LIST RANGE
		5. LIST HASH
*/
	   
CREATE TABLESPACE TSA1 DATAFILE 'C:\Users\admin\Desktop\TSA1.dbf' SIZE 10M;
CREATE TABLESPACE TSB2 DATAFILE 'C:\Users\admin\Desktop\TSB2.dbf' SIZE 10M;
CREATE TABLESPACE TSC3 DATAFILE 'C:\Users\admin\Desktop\TSC3.dbf' SIZE 10M;
CREATE TABLESPACE TSD4 DATAFILE 'C:\Users\admin\Desktop\TSD4.dbf' SIZE 10M;

-----------------------------------------------------------------------
--RANGE -RANGE PARTITIONING :
-----------------------------------------------------------------------

CREATE TABLE COMPOSITE_RANGE (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY RANGE (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION ORIGINAL VALUES LESS THAN(1001)
		TABLESPACE TSA1,
		SUBPARTITION ACQUIRED VALUES LESS THAN(2001)
		TABLESPACE TSB2,
		SUBPARTITION GAIN VALUES LESS THAN(5001)
		TABLESPACE TSC3,
		SUBPARTITION RECENT VALUES LESS THAN(MAXVALUE)
		TABLESPACE TSD4)
		(PARTITION PART1 VALUES LESS THAN (TO_DATE('1/01/2005','DD/MM/YYYY')),
		PARTITION PART2 VALUES LESS THAN (TO_DATE('1/01/2010','DD/MM/YYYY')),
		PARTITION PART3 VALUES LESS THAN (TO_DATE('1/01/2015','DD/MM/YYYY')),
		PARTITION FUTURE VALUES LESS THAN (MAXVALUE));
		
INSERT INTO COMPOSITE_RANGE VALUES ( 1001, 'hashir', 'MH', TO_DATE('1/04/2014','DD/MM/YYYY'));
INSERT INTO COMPOSITE_RANGE VALUES ( 1002, 'SUNS', 'MH', TO_DATE('1/08/2004','DD/MM/YYYY'));
INSERT INTO COMPOSITE_RANGE VALUES ( 1003, 'SHIN', 'AP', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
PART1                          USERS                                   1
PART2                          USERS                                   0
PART3                          USERS                                   2
FUTURE                         USERS                                   0


-----------------------------------------------------------------------
--LIST HASH 
-----------------------------------------------------------------------
CREATE TABLE LIST_HASH (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY LIST (CUST_STATE)
	SUBPARTITION BY HASH (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 TABLESPACE TSA1,
		SUBPARTITION SP2 TABLESPACE TSB2,
		SUBPARTITION SP3 TABLESPACE TSC3,
		SUBPARTITION SP4 TABLESPACE TSD4)
		(PARTITION WEST VALUES ('OR','WA'),
		 PARTITION EAST VALUES ('AZ','UT','NM'),
		 PARTITION NORTH VALUES ('NY','VM','NJ'),
		 PARTITION SOUTH VALUES ('FL','GA'));	
		
INSERT INTO LIST_HASH VALUES ( 1001, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
INSERT INTO LIST_HASH VALUES ( 1002, 'SUNS', 'NM', TO_DATE('1/08/2004','DD/MM/YYYY'));
INSERT INTO LIST_HASH VALUES ( 1003, 'SHIN', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));
INSERT INTO LIST_HASH VALUES ( 1003, 'BOB', 'WA', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		
SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_HASH';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
WEST                           USERS                                   2
EAST                           USERS                                   1
NORTH                          USERS                                   1
SOUTH                          USERS                                   0
-----------------------------------------------------------------------
--LIST LIST
-----------------------------------------------------------------------
CREATE TABLE LIST_LIST (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY LIST (CUST_STATE)
	SUBPARTITION BY LIST (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 VALUES (1,3,5) TABLESPACE TSA1,
		SUBPARTITION SP2 VALUES (2,4,6) TABLESPACE TSB2,
		SUBPARTITION SP3 VALUES (7,8,9,0) TABLESPACE TSC3)
		(PARTITION WEST VALUES ('OR','WA'),
		 PARTITION EAST VALUES ('AZ','UT','NM'),
		 PARTITION NORTH VALUES ('NY','VM','NJ'),
		 PARTITION SOUTH VALUES ('FL','GA'));
		

INSERT INTO LIST_LIST VALUES ( 1, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 2, 'SUNS', 'NM', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 3, 'SHIN', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));
		INSERT INTO LIST_LIST VALUES ( 3, 'BOB', 'WA', TO_DATE('1/08/2010','DD/MM/YYYY'));
		
		select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_LIST';
		
		SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_LIST';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
WEST                           USERS                                   2
EAST                           USERS                                   1
NORTH                          USERS                                   1
SOUTH                          USERS                                   0
-----------------------------------------------------------------------
--RANGE HASH
-----------------------------------------------------------------------
CREATE TABLE RANGE_HASH (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(10),
	TIME_ID DATE)
	PARTITION BY RANGE (TIME_ID)
	SUBPARTITION BY HASH (CUST_ID) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1  TABLESPACE TSA1,
		SUBPARTITION SP2  TABLESPACE TSB2,
		SUBPARTITION SP3  TABLESPACE TSC3,
		SUBPARTITION SP4  TABLESPACE TSD4)
		(PARTITION PART1 VALUES LESS THAN (TO_DATE('1/01/2005','DD/MM/YYYY')),
		PARTITION PART2 VALUES LESS THAN (TO_DATE('1/01/2010','DD/MM/YYYY')),
		PARTITION PART3 VALUES LESS THAN (TO_DATE('1/01/2015','DD/MM/YYYY')),
		PARTITION FUTURE VALUES LESS THAN (MAXVALUE));
		
		
		INSERT INTO RANGE_HASH
		SELECT C.CUST_ID , C.CUST_FIRST_NAME || ' ' || 
		C.CUST_LAST_NAME,
		S.AMOUNT_SOLD, S.TIME_ID 
		FROM SH.SALES S, SH.CUSTOMERS C
		WHERE S.CUST_ID = C.CUST_ID 
		AND ROWNUM < 250001;
		
		
SQL>  EXEC DBMS_STATS.GATHER_TABLE_STATS('hashir', 'RANGE_HASH');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='RANGE_HASH';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
PART1                          USERS                              	2280
PART2                          USERS                               	1300
PART3                          USERS                               10980
FUTURE                         USERS                               12720
-----------------------------------------------------------------------
--LIST RANGE
-----------------------------------------------------------------------
CREATE TABLE LIST_RANGE (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY RANGE (CUST_ID)
	SUBPARTITION BY LIST (CUST_STATE) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 VALUES ('OR','WA') TABLESPACE TSA1,
		SUBPARTITION SP2 VALUES ('MH','NY')TABLESPACE TSB2,
		SUBPARTITION SP3 VALUES ('FL','GA') TABLESPACE TSC3,
		SUBPARTITION SP4 VALUES ('VM','NJ') TABLESPACE TSD4)
		(PARTITION ORIGINAL VALUES LESS THAN(1001),
		 PARTITION OTHER VALUES LESS THAN(2001),
		 PARTITION RECENT VALUES LESS THAN(3001),
		 PARTITION NEWEST VALUES LESS THAN(4001));

		INSERT INTO LIST_RANGE VALUES ( 1001, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 2002, 'SUNS', 'FL', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 3003, 'SHIN', 'VM', TO_DATE('1/08/2010','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 4000, 'BOB', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));

		
SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('hashir', 'LIST_RANGE');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_RANGE';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
ORIGINAL                       USERS                                   0
OTHER                          USERS                                   1
RECENT                         USERS                                   1
NEWEST                         USERS                                   2

-----------------------------------------------------------------------
-----------------------------------------------------------------------
SQL>  EXEC DBMS_STATS.GATHER_TABLE_STATS('hashir', 'RANGE_HASH');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='RANGE_HASH';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
PART1                          USERS                              	2280
PART2                          USERS                               	1300
PART3                          USERS                               10980
FUTURE                         USERS                               12720
-----------------------------------------------------------------------
--LIST RANGE
-----------------------------------------------------------------------
CREATE TABLE LIST_RANGE (
	CUST_ID NUMBER(10),
	CUST_NAME VARCHAR2(25),
	CUST_STATE VARCHAR2(2),
	TIME_ID DATE)
	PARTITION BY RANGE (CUST_ID)
	SUBPARTITION BY LIST (CUST_STATE) 
	SUBPARTITION TEMPLATE (
		SUBPARTITION SP1 VALUES ('OR','WA') TABLESPACE TSA1,
		SUBPARTITION SP2 VALUES ('MH','NY')TABLESPACE TSB2,
		SUBPARTITION SP3 VALUES ('FL','GA') TABLESPACE TSC3,
		SUBPARTITION SP4 VALUES ('VM','NJ') TABLESPACE TSD4)
		(PARTITION ORIGINAL VALUES LESS THAN(1001),
		 PARTITION OTHER VALUES LESS THAN(2001),
		 PARTITION RECENT VALUES LESS THAN(3001),
		 PARTITION NEWEST VALUES LESS THAN(4001));

		INSERT INTO LIST_RANGE VALUES ( 1001, 'hashir', 'OR', TO_DATE('1/04/2014','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 2002, 'SUNS', 'FL', TO_DATE('1/08/2004','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 3003, 'SHIN', 'VM', TO_DATE('1/08/2010','DD/MM/YYYY'));
		INSERT INTO LIST_RANGE VALUES ( 4000, 'BOB', 'NY', TO_DATE('1/08/2010','DD/MM/YYYY'));

		
SQL> EXEC DBMS_STATS.GATHER_TABLE_STATS('hashir', 'LIST_RANGE');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='LIST_RANGE';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
ORIGINAL                       USERS                                   0
OTHER                          USERS                                   1
RECENT                         USERS                                   1
NEWEST                         USERS                                   2

-----------------------------------------------------------------------
-----------------------------------------------------------------------
