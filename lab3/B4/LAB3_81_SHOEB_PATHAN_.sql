SQL> connect shoeb80
Enter password:
Connected.
SQL> create table sales(
  2      prod_id number(6),
  3      cust_id number,
  4      time_id date,s
  5      promo_id number(6),
  6      quantitiy_sold number(6),
  7      amount_sold number(10,2))
  8      partition by range (time_id)
  9      (
 10      partition  sales_q1 values less than(to_date('01-APR-2018','DD-MON-YYYY')) TABLESPACE tsa,
 11      partition sales_q2 values less than(to_date('01-JUL-2018','DD-MON-YYYY')) TABLESPACE tsa1,
 12      partition sales_q3 values less than(to_date('01-OCT-2018','DD-MON-YYYY')) TABLESPACE tsa2,
 13      partition sales_q4 values less than (to_date('01-JAN-2019','DD-MON-YYYY')) TABLESPACE tsa3
 14     )
 15     enable row movement;
    promo_id number(6),
             *
ERROR at line 5:
ORA-00907: missing right parenthesis


SQL> create table sales(
  2      prod_id number(6),
  3      cust_id number,
  4      time_id date,
  5      promo_id number(6),
  6      quantitiy_sold number(6),
  7      amount_sold number(10,2))
  8      partition by range (time_id)
  9      (
 10      partition  sales_q1 values less than(to_date('01-APR-2018','DD-MON-YYYY')) TABLESPACE tsa,
 11      partition sales_q2 values less than(to_date('01-JUL-2018','DD-MON-YYYY')) TABLESPACE tsa1,
 12      partition sales_q3 values less than(to_date('01-OCT-2018','DD-MON-YYYY')) TABLESPACE tsa2,
 13      partition sales_q4 values less than (to_date('01-JAN-2019','DD-MON-YYYY')) TABLESPACE tsa3
 14     )
 15     enable row movement;

Table created.

SQL> select * from tab;

TNAME                          TABTYPE  CLUSTERID
------------------------------ ------- ----------
SALES                          TABLE

SQL> insert into sales values (100,1,'12-OCT-2018',1111,10,10.2);

1 row created.

SQL> insert into sales values (101,2,'12-JAN-2018',1111,10,10.2);

1 row created.

SQL> insert into sales values (102,3,'12-MAY-2018',1111,10,10.2);

1 row created.

SQL>  insert into sales values (103,4,'12-AUG-2018',1111,10,10.2);

1 row created.

SQL> select * from sales;

   PROD_ID    CUST_ID TIME_ID     PROMO_ID QUANTITIY_SOLD AMOUNT_SOLD
---------- ---------- --------- ---------- -------------- -----------
       101          2 12-JAN-18       1111             10        10.2
       102          3 12-MAY-18       1111             10        10.2
       103          4 12-AUG-18       1111             10        10.2
       100          1 12-OCT-18       1111             10        10.2

SQL> SELECT * FROM SALES PARTITION (SALES_Q1);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID QUANTITIY_SOLD AMOUNT_SOLD
---------- ---------- --------- ---------- -------------- -----------
       101          2 12-JAN-18       1111             10        10.2

SQL> SELECT * FROM SALES PARTITION (SALES_Q2);

   PROD_ID    CUST_ID TIME_ID     PROMO_ID QUANTITIY_SOLD AMOUNT_SOLD
---------- ---------- --------- ---------- -------------- -----------
       102          3 12-MAY-18       1111             10        10.2

SQL> exec dbms_stats.gather_table_stats('SHOEB80','SALES');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SALES';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       TSA                                     1
SALES_Q2                       TSA1                                    1
SALES_Q3                       TSA2                                    1
SALES_Q4                       TSA3                                    1

SQL> UPDATE SALES SET TIME_ID='12-AUG-2018' WHERE PROD_ID = 100;

1 row updated.

SQL> exec dbms_stats.gather_table_stats('SHOEB','SALES');
BEGIN dbms_stats.gather_table_stats('SHOEB','SALES'); END;

*
ERROR at line 1:
ORA-20000: Unable to analyze TABLE "SHOEB"."SALES", insufficient
privileges or does not exist
ORA-06512: at "SYS.DBMS_STATS", line 20327
ORA-06512: at "SYS.DBMS_STATS", line 20360
ORA-06512: at line 1


SQL> exec dbms_stats.gather_table_stats('SHOEB80','SALES');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SALES';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       TSA                                     1
SALES_Q2                       TSA1                                    1
SALES_Q3                       TSA2                                    2
SALES_Q4                       TSA3                                    0

SQL> CREATE TABLE sales_by_region
  2        (deptno number,
  3         deptname varchar2(20),
  4         quarterly_sales number(10, 2),
  5         state_name varchar2(2))
  6     PARTITION BY LIST (state_name)
  7        (PARTITION NORTHWEST VALUES ('OR', 'WA'),
  8         PARTITION SOUTHWEST VALUES ('AZ', 'UT', 'NM'),
  9         PARTITION NORTHEAST VALUES  ('NY', 'VM', 'NJ'),
 10     PARTITION SOUTHEAST VALUES ('FL', 'GA'),
 11     PARTITION NORTHCENTRAL VALUES ('SD', 'WI'),
 12     PARTITION SOUTHCENTRAL VALUES ('OK', 'TX')
 13    )
 14  enable row movement;

Table created.

SQL> insert into sales_by_region values (10,'accounting',100,'WA');

1 row created.

SQL> insert into sales_by_region values (20,'R and D',150,'OR');

1 row created.

SQL> insert into sales_by_region values (30,'sales',100,'FL');

1 row created.

SQL> insert into sales_by_region values (50,'systems engineering',10,'CA');
insert into sales_by_region values (50,'systems engineering',10,'CA')
            *
ERROR at line 1:
ORA-14400: inserted partition key does not map to any partition


SQL> Alter table sales_by_region add partition defaultregion values(default);

Table altered.

SQL> insert into sales_by_region values (50,'systems engineering',10,'CA');

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','SALES_BY_REGION');
BEGIN dbms_stats.gather_table_stats('SHOEB80','SALES_BY_REGION'); END;

*
ERROR at line 1:
ORA-20000: Unable to analyze TABLE "SHOEB"."SALES_BY_REGION", insufficient
privileges or does not exist
ORA-06512: at "SYS.DBMS_STATS", line 20327
ORA-06512: at "SYS.DBMS_STATS", line 20360
ORA-06512: at line 1


SQL> exec dbms_stats.gather_table_stats('SHOEB80','SALES_BY_REGION');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS,HIGH_VALUE from user_tab_partitions where table_name='SALES_BY_REGION';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
NORTHWEST                      USERS                                   2
'OR', 'WA'

SOUTHWEST                      USERS                                   0
'AZ', 'UT', 'NM'

NORTHEAST                      USERS                                   0
'NY', 'VM', 'NJ'


PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
SOUTHEAST                      USERS                                   1
'FL', 'GA'

NORTHCENTRAL                   USERS                                   0
'SD', 'WI'

SOUTHCENTRAL                   USERS                                   0
'OK', 'TX'


PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
DEFAULTREGION                  USERS                                   1
default


7 rows selected.

SQL> CREATE TABLE EMP (
  2  emp_no number(2),
  3  job varchar (20),
  4  sal number(16),
  5  deptno varchar(20)
  6  )
  7  partition by hash(emp_no)
  8  partitions 5;

Table created.

SQL> insert into EMP values(4,'NIGGA 1',1000,'101');

1 row created.

SQL> insert into EMP values(8,'NIGGA 2',100,'102');

1 row created.

SQL> insert into EMP values(14,'NIGGA 3',1000,'103');

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','EMP');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS,HIGH_VALUE from user_tab_partitions where table_name='EMP';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
SYS_P41                        USERS                                   0


SYS_P42                        USERS                                   0


SYS_P43                        USERS                                   1



PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
SYS_P44                        USERS                                   2


SYS_P45                        USERS                                   0



SQL> Create table date_data(
  2  date_year number(4),
  3  date_month number (2),
  4  date_day number(2),
  5  amount_sold number(20)
  6  )
  7  partition by range (date_year,date_month)(
  8  partition q1 values less than(2001,1),
  9  partition q2 values less than(2001,4),
 10  partition q3 values less than(2001,7),
 11  partition q4 values less than (2001,10),
 12  partition q5 values less than (2002,1),
 13  partition q6 values less than(maxvalue,maxvalue)
 14  )
 15  enable row movement;

Table created.

SQL> insert into date_data values(2001,3,17, 2000);

1 row created.

SQL> insert into date_data values(2001,11,1, 5000);

1 row created.

SQL> insert into date_data values(2002,1,1, 4000);

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','date_data');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS,HIGH_VALUE from user_tab_partitions where table_name='DATE_DATA';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
Q1                             USERS                                   0
2001, 1

Q2                             USERS                                   1
2001, 4

Q3                             USERS                                   0
2001, 7


PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
Q4                             USERS                                   0
2001, 10

Q5                             USERS                                   1
2002, 1

Q6                             USERS                                   1
MAXVALUE, MAXVALUE


6 rows selected.

SQL> Create table supplier_parts (
  2  supplier_id number(4),
  3  part_num number (4),
  4  amount number(10)
  5  )
  6  partition by range(supplier_id,part_num)(
  7  partition  q1 values less than(10,100),
  8  partition  q2 values less than(20,200),
  9  partition  q3 values less than(30,300),
 10  partition  q4 values less than(40,400),
 11  partition  q5 values less than(maxvalue,maxvalue)
 12  );

Table created.

SQL> insert into supplier_parts values(19,350,1000);

1 row created.

SQL> insert into supplier_parts values(5,5, 1000);

1 row created.

SQL> insert into supplier_parts values(5,150, 1000);

1 row created.

SQL> insert into supplier_parts values(10,100, 1000);

1 row created.

SQL> drop supplier_parts;
drop supplier_parts
     *
ERROR at line 1:
ORA-00950: invalid DROP option


SQL> drop table supplier_parts;

Table dropped.

SQL> Create table supplier_parts (
  2  supplier_id number(4),
  3  part_num number (4),
  4  amount number(10)
  5  )
  6  partition by range(supplier_id,part_num)(
  7  partition  q1 values less than(5,100),
  8  partition  q2 values less than(5,200),
  9  partition  q3 values less than(10,200),
 10  partition  q4 values less than(20,300),
 11  partition  q5 values less than(maxvalue,maxvalue)
 12  );

Table created.

SQL> insert into supplier_parts values(19,350,1000);

1 row created.

SQL> insert into supplier_parts values(5,5, 1000);

1 row created.

SQL> insert into supplier_parts values(5,150, 1000);

1 row created.

SQL> insert into supplier_parts values(10,100, 1000);

1 row created.

SQL> SELECT * FROM supplier_parts partition(q1);

SUPPLIER_ID   PART_NUM     AMOUNT
----------- ---------- ----------
          5          5       1000

SQL> SELECT * FROM supplier_parts partition(q2);

SUPPLIER_ID   PART_NUM     AMOUNT
----------- ---------- ----------
          5        150       1000

SQL> SELECT * FROM supplier_parts partition(q3);

SUPPLIER_ID   PART_NUM     AMOUNT
----------- ---------- ----------
         10        100       1000

SQL> SELECT * FROM supplier_parts partition(q4);

SUPPLIER_ID   PART_NUM     AMOUNT
----------- ---------- ----------
         19        350       1000

SQL> SELECT * FROM supplier_parts partition(q5);

no rows selected

SQL> exec dbms_stats.gather_table_stats('SHOEB80','supplier_parts');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SUPPLIER_PARTS';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
Q1                             USERS                                   1
Q2                             USERS                                   1
Q3                             USERS                                   1
Q4                             USERS                                   1
Q5                             USERS                                   0

SQL> create table sales_1(
  2  prod_id number(6),
  3  cust_id number,
  4  quantitiy_sold number(6),
  5  amount_sold number(10,2),
  6  month number(2)
  7  )
  8  partition by range (month)
  9  interval(3)
 10  (
 11   partition  sales_q1 values less than(3) TABLESPACE tsa
 12  )
 13  enable row movement;

Table created.

SQL> insert into sales_1 values(19,350,1000,100,2);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,4);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,7);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,11);

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','sales_1');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SALES_1';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       TSA                                     1
SYS_P46                        USERS                                   1
SYS_P47                        USERS                                   1
SYS_P48                        USERS                                   1

SQL> drop table sales_1
  2  ;

Table dropped.

SQL>
SQL> create table sales_1(
  2  prod_id number(6),
  3  cust_id number,
  4  quantitiy_sold number(6),
  5  amount_sold number(10,2),
  6  month number(2)
  7  )
  8  partition by range (month)
  9  interval(1)
 10  (
 11   partition  sales_q1 values less than(3)
 12  partition  sales_q2 values less than(6)
 13  partition  sales_q3 values less than(9)
 14  partition  sales_q4 values less than(12)
 15  )
 16  enable row movement;
partition  sales_q2 values less than(6)
*
ERROR at line 12:
ORA-14020: this physical attribute may not be specified for a table partition


SQL> create table sales_1(
  2  prod_id number(6),
  3  cust_id number,
  4  quantitiy_sold number(6),
  5  amount_sold number(10,2),
  6  month number(2)
  7  )
  8  partition by range (month)
  9  interval(1)
 10  (
 11   partition  sales_q1 values less than(3),
 12  partition  sales_q2 values less than(6),
 13  partition  sales_q3 values less than(9),
 14  partition  sales_q4 values less than(12)
 15  )
 16  enable row movement;

Table created.

SQL> insert into sales_1 values(19,350,1000,100,2);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,4);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,7);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,11);

1 row created.

SQL>
SQL> insert into sales_1 values(19,350,1000,100,12);

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','sales_1');

PL/SQL procedure successfully completed.

SQL> select partition_name,TABLESPACE_NAME,NUM_ROWS from user_tab_partitions where table_name='SALES_1';

PARTITION_NAME                 TABLESPACE_NAME                  NUM_ROWS
------------------------------ ------------------------------ ----------
SALES_Q1                       USERS                                   1
SALES_Q2                       USERS                                   1
SALES_Q3                       USERS                                   1
SALES_Q4                       USERS                                   1
SYS_P49                        USERS                                   1

SQL> SELECT * FROM sales_1 partition(sys_p49);

   PROD_ID    CUST_ID QUANTITIY_SOLD AMOUNT_SOLD      MONTH
---------- ---------- -------------- ----------- ----------
        19        350           1000         100         12

SQL> create table porders(
  2  order_id NUMBER(4),
  3  order_date DATE,
  4  customer_id NUMBER(4),
  5  shipper_id NUMBER(4),
  6  CONSTRAINT ORDER_PK PRIMARY KEY(order_id)
  7  )
  8  PARTITION BY RANGE (order_date)
  9      ( PARTITION q1 VALUES LESS THAN (TO_DATE('1-3-2008', 'DD-MM-YYYY')),
 10        PARTITION q2 VALUES LESS THAN (TO_DATE('1-6-2008', 'DD-MM-YYYY')),
 11        PARTITION q3 VALUES LESS THAN (TO_DATE('1-9-2008', 'DD-MM-YYYY')),
 12        PARTITION q4 VALUES LESS THAN (TO_DATE('1-12-2008', 'DD-MM-YYYY')) );

Table created.

SQL>
SQL>
SQL> create table rorders(
  2  order_id NUMBER(4) NOT NULL,
  3  product_id NUMBER(4),
  4  price NUMBER(4),
  5  qty NUMBER(4),
  6  CONSTRAINT rorders_fk FOREIGN KEY(order_id) REFERENCES porders(order_id)
  7  )
  8  PARTITION BY REFERENCE(rorders_fk);

Table created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','porders');

PL/SQL procedure successfully completed.

SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='PORDERS';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ----------
USERS                          Q1                                      0
USERS                          Q2                                      0
USERS                          Q3                                      0
USERS                          Q4                                      0

SQL> ALTER TABLE rorders DROP PARTITION q2;
ALTER TABLE rorders DROP PARTITION q2
                                   *
ERROR at line 1:
ORA-14255: table is not partitioned by Range, List, Composite Range or
Composite List method


SQL> ALTER TABLE porders DROP PARTITION q2;

Table altered.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','rorders');

PL/SQL procedure successfully completed.

SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='RORDERS';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ----------
USERS                          Q1                                      0
USERS                          Q3                                      0
USERS                          Q4                                      0

SQL> CREATE TABLE v_emp(
  2       emp_id  VARCHAR2(20),
  3       emp_name VARCHAR2(20),
  4       fixed_salary NUMBER(10),
  5       variable_salary NUMBER(10),
  6       total_salary  NUMBER(20) generated always as (fixed_salary+variable_salary)
  7       virtual)
  8       PARTITION BY RANGE (total_salary)
  9      ( PARTITION q1 VALUES LESS THAN (25000),
 10        PARTITION q2 VALUES LESS THAN (50000),
 11        PARTITION q3 VALUES LESS THAN (75000),
 12        PARTITION q4 VALUES LESS THAN (maxvalue) );

Table created.

SQL> insert into v_emp values(101,'SHOEB',30000,5000);
insert into v_emp values(101,'SHOEB',30000,5000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(102,'shivam',20000,4000);
insert into v_emp values(102,'shivam',20000,4000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(103,'rahul',70000,4000);
insert into v_emp values(103,'rahul',70000,4000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(104,'shreyanshu',100000,5000);
insert into v_emp values(104,'shreyanshu',100000,5000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> drop table v_emp;

Table dropped.

SQL> CREATE TABLE v_emp(
  2       emp_id  VARCHAR2(20),
  3       emp_name VARCHAR2(20),
  4       fixed_salary NUMBER(10),
  5       variable_salary NUMBER(10),
  6       total_salary  NUMBER(20) generated always as (fixed_salary+variable_salary) virtual
  7        )
  8       PARTITION BY RANGE (total_salary)
  9      ( PARTITION q1 VALUES LESS THAN (25000),
 10        PARTITION q2 VALUES LESS THAN (50000),
 11        PARTITION q3 VALUES LESS THAN (75000),
 12        PARTITION q4 VALUES LESS THAN (maxvalue) );

Table created.

SQL> insert into v_emp values(101,'SHOEB',30000,5000);
insert into v_emp values(101,'SHOEB',30000,5000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(102,'shivam',20000,4000);
insert into v_emp values(102,'shivam',20000,4000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(103,'rahul',70000,4000);
insert into v_emp values(103,'rahul',70000,4000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp values(104,'shreyanshu',100000,5000);
insert into v_emp values(104,'shreyanshu',100000,5000)
            *
ERROR at line 1:
ORA-00947: not enough values


SQL> insert into v_emp(emp_id,emp_name,fixed_salary,variable_salary) values(101,'SHOEB',30000,5000);

1 row created.

SQL> insert into v_emp(emp_id,emp_name,fixed_salary,variable_salary) values(102,'shivam',20000,4000);

1 row created.

SQL> insert into v_emp(emp_id,emp_name,fixed_salary,variable_salary) values(103,'rahul',70000,4000);

1 row created.

SQL> insert into v_emp(emp_id,emp_name,fixed_salary,variable_salary) values(104,'shreyanshu',100000,5000);

1 row created.

SQL> exec dbms_stats.gather_table_stats('SHOEB80','v_emp');

PL/SQL procedure successfully completed.

SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='V_EMP';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ----------
USERS                          Q1                                      1
USERS                          Q2                                      1
USERS                          Q3                                      1
USERS                          Q4                                      1

SQL> CREATE TABLE quarterly_regional_sales
  2        (cust_id varchar2(10), cust_name varchar2(20),
  3         time_id date,cust_state varchar2(2))
  4    TABLESPACE ts4
  5    PARTITION BY RANGE (time_id)
  6      SUBPARTITION BY LIST (cust_state)
  7        (PARTITION q1 VALUES LESS THAN (TO_DATE('01-JAN-2005','DD-MON-YYYY'))
  8           (SUBPARTITION q1_west VALUES (MH, GJ),
  9            SUBPARTITION q1_south VALUES (TN, AP),
 10            SUBPARTITION q1_north VALUES (UP, HP),
 11            SUBPARTITION q1_DEFAULT VALUES (default)
 12           ),
 13         PARTITION q2 VALUES LESS THAN ( TO_DATE('01-JAN-2010','DD-MON-YYYY'))
 14           (SUBPARTITION q2_west VALUES (MH, GJ),
 15            SUBPARTITION q2_south VALUES (TN, AP),
 16            SUBPARTITION q2_north VALUES (UP, HP),
 17            SUBPARTITION q2_DEFAULT VALUES (default)
 18           ),
 19         PARTITION q3 VALUES LESS THAN (TO_DATE('01-JAN-2015','DD-MON-YYYY'))
 20           (SUBPARTITION q3_west VALUES (MH, GJ),
 21            SUBPARTITION q3_south VALUES (TN, AP),
 22            SUBPARTITION q3_north VALUES (UP, HP),
 23            SUBPARTITION q3_DEFAULT VALUES (default)
 24           ),
 25         PARTITION q4 VALUES LESS THAN (maxvalue)
 26           (SUBPARTITION q4_west VALUES (MH, GJ),
 27            SUBPARTITION q4_south VALUES (TN, AP),
 28            SUBPARTITION q4_north VALUES (UP, HP),
 29            SUBPARTITION q4_DEFAULT VALUES (default)
 30           )
 31        );
         (SUBPARTITION q1_west VALUES (`MH', `GJ'),
                                       *
ERROR at line 8:
ORA-00911: invalid character


SQL> CREATE TABLE quarterly_regional_sales
  2        (cust_id varchar2(10), cust_name varchar2(20),
  3         time_id date,cust_state varchar2(2))
  4    TABLESPACE ts4
  5    PARTITION BY RANGE (time_id)
  6      SUBPARTITION BY LIST (cust_state)
  7        (PARTITION q1 VALUES LESS THAN (TO_DATE('01-JAN-2005','DD-MON-YYYY'))
  8           (SUBPARTITION q1_west VALUES ('MH', 'GJ'),
  9            SUBPARTITION q1_south VALUES ('TN', 'AP'),
 10            SUBPARTITION q1_north VALUES ('UP', 'HP'),
 11            SUBPARTITION q1_DEFAULT VALUES (default)
 12           ),
 13         PARTITION q2 VALUES LESS THAN ( TO_DATE('01-JAN-2010','DD-MON-YYYY'))
 14           (SUBPARTITION q2_west VALUES ('MH', 'GJ'),
 15            SUBPARTITION q2_south VALUES ('TN', 'AP'),
 16            SUBPARTITION q2_north VALUES ('UP', 'HP'),
 17            SUBPARTITION q2_DEFAULT VALUES (default)
 18           ),
 19         PARTITION q3 VALUES LESS THAN (TO_DATE('01-JAN-2015','DD-MON-YYYY'))
 20           (SUBPARTITION q3_west VALUES ('MH', 'GJ'),
 21            SUBPARTITION q3_south VALUES ('TN', 'AP'),
 22            SUBPARTITION q3_north VALUES ('UP', 'HP'),
 23            SUBPARTITION q3_DEFAULT VALUES (default)
 24           ),
 25         PARTITION q4 VALUES LESS THAN (maxvalue)
 26           (SUBPARTITION q4_west VALUES ('MH', 'GJ'),
 27            SUBPARTITION q4_south VALUES ('TN', 'AP'),
 28            SUBPARTITION q4_north VALUES ('UP', 'HP'),
 29            SUBPARTITION q4_DEFAULT VALUES (default)
 30           )
 31        );
  TABLESPACE ts4
             *
ERROR at line 4:
ORA-00959: tablespace 'TS4' does not exist


SQL> CREATE TABLE quarterly_regional_sales
  2        (cust_id varchar2(10), cust_name varchar2(20),
  3         time_id date,cust_state varchar2(2))
  4    PARTITION BY RANGE (time_id)
  5      SUBPARTITION BY LIST (cust_state)
  6        (PARTITION q1 VALUES LESS THAN (TO_DATE('01-JAN-2005','DD-MON-YYYY'))
  7           (SUBPARTITION q1_west VALUES ('MH', 'GJ'),
  8            SUBPARTITION q1_south VALUES ('TN', 'AP'),
  9            SUBPARTITION q1_north VALUES ('UP', 'HP'),
 10            SUBPARTITION q1_DEFAULT VALUES (default)
 11           ),
 12         PARTITION q2 VALUES LESS THAN ( TO_DATE('01-JAN-2010','DD-MON-YYYY'))
 13           (SUBPARTITION q2_west VALUES ('MH', 'GJ'),
 14            SUBPARTITION q2_south VALUES ('TN', 'AP'),
 15            SUBPARTITION q2_north VALUES ('UP', 'HP'),
 16            SUBPARTITION q2_DEFAULT VALUES (default)
 17           ),
 18         PARTITION q3 VALUES LESS THAN (TO_DATE('01-JAN-2015','DD-MON-YYYY'))
 19           (SUBPARTITION q3_west VALUES ('MH', 'GJ'),
 20            SUBPARTITION q3_south VALUES ('TN', 'AP'),
 21            SUBPARTITION q3_north VALUES ('UP', 'HP'),
 22            SUBPARTITION q3_DEFAULT VALUES (default)
 23           ),
 24         PARTITION q4 VALUES LESS THAN (maxvalue)
 25           (SUBPARTITION q4_west VALUES ('MH', 'GJ'),
 26            SUBPARTITION q4_south VALUES ('TN', 'AP'),
 27            SUBPARTITION q4_north VALUES ('UP', 'HP'),
 28            SUBPARTITION q4_DEFAULT VALUES (default)
 29           )
 30        );

Table created.

SQL>
SQL> INSERT INTO quarterly_regional_sales VALUES(101,'A','01-JAN-2004','MH');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(102,'B','01-JAN-2004','TN');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(103,'C','01-JAN-2004','UP');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(104,'D','01-JAN-2004','KR');

1 row created.

SQL>
SQL> INSERT INTO quarterly_regional_sales VALUES(105,'E','01-JAN-2006','MH');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(106,'F','01-JAN-2006','TN');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(107,'G','01-JAN-2006','UP');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(108,'H','01-JAN-2006','KR');

1 row created.

SQL>
SQL> INSERT INTO quarterly_regional_sales VALUES(109,'I','01-JAN-2011','MH');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(110,'J','01-JAN-2011','TN');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(111,'K','01-JAN-2011','UP');

1 row created.

SQL> INSERT INTO quarterly_regional_sales VALUES(112,'L','01-JAN-2011','KR');

1 row created.

SQL>
SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS,HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
USERS                          Q1
TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA

USERS                          Q2
TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA

USERS                          Q3
TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA


TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ----------
HIGH_VALUE
--------------------------------------------------------------------------------
USERS                          Q4
MAXVALUE


SQL> SELECT TABLESPACE_NAME,SUBPARTITION_NAME,PARTITION_NAME,NUM_ROWS FROM ALL_TAB_SUBPARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES' ORDER BY PARTITION_NAME;

TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q1_NORTH
Q1

USERS                          Q1_SOUTH
Q1

USERS                          Q1_WEST
Q1


TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q1_DEFAULT
Q1

USERS                          Q2_NORTH
Q2

USERS                          Q2_SOUTH
Q2


TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q2_WEST
Q2

USERS                          Q2_DEFAULT
Q2

USERS                          Q3_WEST
Q3


TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q3_SOUTH
Q3

USERS                          Q3_NORTH
Q3

USERS                          Q3_DEFAULT
Q3


TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q4_WEST
Q4

USERS                          Q4_SOUTH
Q4

USERS                          Q4_NORTH
Q4


TABLESPACE_NAME                SUBPARTITION_NAME
------------------------------ ------------------------------
PARTITION_NAME                   NUM_ROWS
------------------------------ ----------
USERS                          Q4_DEFAULT
Q4


16 rows selected.

SQL> set linesize 700;
SQL>
SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS,HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS HIGH_VALUE
------------------------------ ------------------------------ ---------- --------------------------------------------------------------------------------
USERS                          Q1                                        TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q2                                        TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q3                                        TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q4                                        MAXVALUE

SQL> SELECT TABLESPACE_NAME,SUBPARTITION_NAME,PARTITION_NAME,NUM_ROWS FROM ALL_TAB_SUBPARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES' ORDER BY PARTITION_NAME;

TABLESPACE_NAME                SUBPARTITION_NAME              PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
USERS                          Q1_NORTH                       Q1
USERS                          Q1_SOUTH                       Q1
USERS                          Q1_WEST                        Q1
USERS                          Q1_DEFAULT                     Q1
USERS                          Q2_NORTH                       Q2
USERS                          Q2_SOUTH                       Q2
USERS                          Q2_WEST                        Q2
USERS                          Q2_DEFAULT                     Q2
USERS                          Q3_WEST                        Q3
USERS                          Q3_SOUTH                       Q3
USERS                          Q3_NORTH                       Q3

TABLESPACE_NAME                SUBPARTITION_NAME              PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
USERS                          Q3_DEFAULT                     Q3
USERS                          Q4_WEST                        Q4
USERS                          Q4_SOUTH                       Q4
USERS                          Q4_NORTH                       Q4
USERS                          Q4_DEFAULT                     Q4

16 rows selected.

SQL>
SQL> exec dbms_stats.gather_table_stats('SHOEB80','quarterly_regional_sales');

PL/SQL procedure successfully completed.

SQL> SELECT TABLESPACE_NAME,PARTITION_NAME,NUM_ROWS,HIGH_VALUE FROM USER_TAB_PARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES';

TABLESPACE_NAME                PARTITION_NAME                   NUM_ROWS HIGH_VALUE
------------------------------ ------------------------------ ---------- --------------------------------------------------------------------------------
USERS                          Q1                                      4 TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q2                                      4 TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q3                                      4 TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA
USERS                          Q4                                      0 MAXVALUE

SQL> SELECT TABLESPACE_NAME,SUBPARTITION_NAME,PARTITION_NAME,NUM_ROWS FROM ALL_TAB_SUBPARTITIONS WHERE TABLE_NAME='QUARTERLY_REGIONAL_SALES' ORDER BY PARTITION_NAME;

TABLESPACE_NAME                SUBPARTITION_NAME              PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
USERS                          Q1_NORTH                       Q1                                      1
USERS                          Q1_SOUTH                       Q1                                      1
USERS                          Q1_WEST                        Q1                                      1
USERS                          Q1_DEFAULT                     Q1                                      1
USERS                          Q2_NORTH                       Q2                                      1
USERS                          Q2_SOUTH                       Q2                                      1
USERS                          Q2_WEST                        Q2                                      1
USERS                          Q2_DEFAULT                     Q2                                      1
USERS                          Q3_WEST                        Q3                                      1
USERS                          Q3_SOUTH                       Q3                                      1
USERS                          Q3_NORTH                       Q3                                      1

TABLESPACE_NAME                SUBPARTITION_NAME              PARTITION_NAME                   NUM_ROWS
------------------------------ ------------------------------ ------------------------------ ----------
USERS                          Q3_DEFAULT                     Q3                                      1
USERS                          Q4_WEST                        Q4                                      0
USERS                          Q4_SOUTH                       Q4                                      0
USERS                          Q4_NORTH                       Q4                                      0
USERS                          Q4_DEFAULT                     Q4                                      0

16 rows selected.


--Range - Range
create table customer_range_range
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date )
PARTITION BY RANGE (time_id)
        SUBPARTITION BY RANGE (cust_id)
          (PARTITION old VALUES LESS THAN (TO_DATE('01-JAN-2005','DD-MON-YYYY'))
             (subpartition old_s1 values less than(10),
			  subpartition old_s2 values less than(20),
		      subpartition old_other values less than(maxvalue)
            ),
          PARTITION acquired VALUES LESS THAN ( TO_DATE('01-JAN-2010','DD-MON-YYYY'))
            (subpartition acquired_s1 values less than(10),
			  subpartition acquired_s2 values less than(20),
		      subpartition acquired_other values less than(maxvalue)
            ),
          PARTITION recent VALUES LESS THAN (TO_DATE('01-JAN-2015','DD-MON-YYYY'))
            (subpartition recent_s1 values less than(10),
			  subpartition recent_s2 values less than(20),
		      subpartition recent_other values less than(maxvalue)
            ),
          PARTITION p VALUES LESS THAN (maxvalue)
            (subpartition p_s1 values less than(10),
			  subpartition p_s2 values less than(20),
		      subpartition p_other values less than(maxvalue)
            )
         );

insert into customer_range_range values(1,'SHOEB','mh',5,'01-feb-2009');
insert into customer_range_range values(1,'pathan','up',11,'01-feb-2004');
insert into customer_range_range values(1,'bahul','tn',55,'01-feb-2019');
exec dbms_stats.gather_table_stats('SHOEB','CUSTOMER_RANGE_RANGE');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER_RANGE_RANGE';
 
 /*OUTPUT
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                         NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
OLD                            USERS                          TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
ACQUIRED                       USERS                          TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
RECENT                         USERS                          TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
P                              USERS                          MAXVALUE                                                                                  1
*/

select * from customer_range_range subpartition(old_s1);
/*

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 pathan      up                  11 01-FEB-04
		 */
