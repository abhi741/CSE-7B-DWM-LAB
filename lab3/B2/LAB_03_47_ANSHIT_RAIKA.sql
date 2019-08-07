

                           /*Practical 3*/
/* PRACTICAL N0.3
ANSHIT RAIKA
47 B2
DWM LAB PRACTICAL 3
*/

/*1. Write a query to create range portioned table:
  Creates a table named- Sales consisting of four partitions,
 one for each quarter of sales. The columns sale_year, sale_month, 
 and sale_day are the partitioning columns,
 while their values constitute the partitioning key of a specific row. 
  Each partition is given a name (sales_q1, sales_q2, ...),
 and each partition is contained in a separate tablespace (tsa, tsb, ...)
  The columns for table must be prod_id, cust_id, promo_id, quantify sold, 
 amount_sold – all in number format and time_id.*/

create TABLESPACE tsa DATAFILE 'G:\DW/tsa.dbf' SIZE 10M;
create TABLESPACE tsb DATAFILE 'G:\DW/tsb.dbf' SIZE 10M;
create TABLESPACE tsc DATAFILE 'G:\DW/tsc.dbf' SIZE 10M;
create TABLESPACE tsd DATAFILE 'G:\DW/tsd.dbf' SIZE 10M;

CREATE TABLE sales
( prod_id number(6), 
  cust_id number,
  time_id date,
  channel_id char(1),
  promo_id number(3),
  amount_sold number(10,2))
  partition by range(time_id)
  (partition sales_q1 values less than(to_date('01-APR-2006','DD-MON-YYYY'))
   TABLESPACE tsa,
  partition sales_q2 values less than(to_date('01-JUL-2006','DD-MON-YYYY'))
   TABLESPACE tsb,
  partition sales_q3 values less than(to_date('01-OCT-2006','DD-MON-YYYY'))
  TABLESPACE tsc,
  partition sales_q4 values less than(to_date('01-JAN-2007','DD-MON-YYYY'))
 TABLESPACE tsd  );
  
  
 insert into sales values(101,111,'01-JAN-2006','B',654,10);
 insert into sales values(102,121,'01-APR-2006','B',654,10);
 insert into sales values(103,211,'01-JUL-2006','B',654,10);
 insert into sales values(104,151,'01-DEC-2006','B',654,10);
 exec dbms_stats.gather_table_stats('anshit','SALES');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='SALES';
 
 /*output
 PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES_Q1                       TSA                            TO_DATE(' 2006-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES_Q2                       TSB                            TO_DATE(' 2006-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES_Q3                       TSC                            TO_DATE(' 2006-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES_Q4                       TSD                            TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1*/


/*2.Create the same table as in Q1. With a different name with ENABLE ROW MOVEMENT*/

CREATE TABLE sales_row_movement
( prod_id number(6), 
  cust_id number,
  time_id date,
  channel_id char(1),
  promo_id number(3),
  amount_sold number(10,2))
  partition by range(time_id)
  (partition sales_q1 values less than(to_date('01-APR-2006','DD-MON-YYYY'))
   TABLESPACE tsa,
  partition sales_q2 values less than(to_date('01-JUL-2006','DD-MON-YYYY'))
   TABLESPACE tsb,
  partition sales_q3 values less than(to_date('01-OCT-2006','DD-MON-YYYY'))
  TABLESPACE tsc,
  partition sales_q4 values less than(to_date('01-JAN-2007','DD-MON-YYYY'))
 TABLESPACE tsd  )
 ENABLE ROW MOVEMENT;
 
 insert into sales_row_movement values(101,111,'01-JAN-2006','B',654,10);
 insert into sales_row_movement values(102,121,'01-APR-2006','B',654,10);
 insert into sales_row_movement values(103,211,'01-JUL-2006','B',654,10);
 insert into sales_row_movement values(104,151,'01-DEC-2006','B',654,10); 
 
 update sales_row_movement set time_id='03-JUL-2006' WHERE time_id='01-JAN-2006';
 
  exec dbms_stats.gather_table_stats('anshit','SALES_ROW_MOVEMENT');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='SALES_ROW_MOVEMENT';
 
/*OUTPUT
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
SALES_Q1                       TSA                            TO_DATE(' 2006-04-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
SALES_Q2                       TSB                            TO_DATE(' 2006-07-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
SALES_Q3                       TSC                            TO_DATE(' 2006-10-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          2
SALES_Q4                       TSD                            TO_DATE(' 2007-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
*/ 
 
/*3.Create a table with list partition as follows:
  Table having columns deptno, deptname, quarterly_sales and state.
  Create partition on state:
  Northwest on OR and WA 
  Southwest on AZ, UT and NM
  northeast on NY, VM and NJ  southeast on FL and GA 
  northcentral on SD and WI  southcentral on OK and TX 
  Add the following entries into the table and make conclusion to which partition the entry maps:
  (10, 'accounting', 100, 'WA')  (20, 'R&D', 150, 'OR')  (30, 'sales', 100, 'FL')
  (40, 'HR', 10, 'TX')  (50, 'systems engineering', 10, 'CA')*/
 
CREATE TABLE sales2
      (deptno number, 
       deptname varchar2(20),
       quarterly_sales number(10, 2),
       state varchar2(2))
   PARTITION BY LIST (state)
      (PARTITION nw VALUES ('OR', 'WA'),
       PARTITION sw VALUES ('AZ', 'UT', 'NM'),
       PARTITION ne VALUES  ('NY', 'VM', 'NJ'),
      PARTITION se VALUES ('FL', 'GA'),
	  PARTITION nc VALUES ('SD','WI'),
	  PARTITION sc VALUES ('OK','TX'));

alter table sales2 add partition def values(default);	  
	  
INSERT INTO sales2 values(10, 'accounting', 100, 'WA');	  
INSERT INTO sales2 values(20, 'RandD', 150, 'OR');
INSERT INTO sales2 values(30, 'sales', 100, 'FL');
INSERT INTO sales2 values(40, 'HR', 10, 'TX');
INSERT INTO sales2 values(50, 'systems engineering', 10, 'CA');
/*OUTPUT  
  DEPTNO DEPTNAME             QUARTERLY_SALES ST
---------- -------------------- --------------- --
        10 accounting                       100 WA
        20 RandD                            150 OR
        30 sales                            100 FL
        40 HR                                10 TX
        50 systems engineering               10 CA
		*/
		
/*4.Create a table with hash partition as follows:
  Create table Emp with attributes empno, job, sal, deptno and perform hash partitioning on empno. 
Number of Partitions should be 5. Demonstarte using system defined and user defined partition concepts.*/

Create table Employee_hash
(emp_no number(2),
 job varchar2(5),
sal number,
deptno number )
partition by hash (emp_no)
partitions 5;

select partition_name from user_tab_partitions where table_name='EMPLOYEE_HASH';
/*output
PARTITION_NAME
------------------------------
SYS_P21
SYS_P22
SYS_P23
SYS_P24
SYS_P25
*/
	
Create table emp2
(emp_no number(2),
 job varchar2(5),
sal number,
deptno number )
partition by hash (emp_no)
(partition h1,
 partition h2,
  partition h3,
  partition h4,
  partition h5);	
 
 select partition_name from user_tab_partitions where table_name='EMP2';

/*OUTPUT	
PARTITION_NAME
------------------------------
H1
H2
H3
H4
H5
*/

/*5.Create a multi-column range partitioned table as directed: 
 Create a table with the actual DATE information in three separate columns: year, month, and day. Also amount_ sold. 
 Create following partitions: o Before 2001: Less than jan 2001 o Less than april 2001 
o Less than july 2001 o Les than oct 2001 o Less than jan 2002 o Future with max incoming value
  Insert values into table and show to which partition does the value belong. o (2001,3,17, 2000); 
 o (2001,11,1, 5000);
o (2002,1,1, 4000);
Make conclusion for each result.*/

create table t5 (
 year number,
 month number,
 day number,
 amount_sold number)
 partition by range(year,month)
 ( partition p1 values less than (2001,1),
   partition p2 values less than (2001,4),
   partition p3 values less than (2001,7),
   partition p4 values less than (2001,10),
   partition p5 values less than (2002,1),
   partition p6 values less than (MAXVALUE,MAXVALUE));
	
INSERT INTO t5 values(2001,3,17, 2000);	
INSERT INTO t5 values(2001,11,1, 5000);		
INSERT INTO t5 values(2002,1,1, 4000);

 SELECT * FROM t5 partition(p5);
 /*

 YEAR      MONTH        DAY AMOUNT_SOLD
---------- ---------- ---------- -----------
      2001         11          1        5000
*/
SELECT * FROM t5 partition(p2);

      YEAR      MONTH        DAY AMOUNT_SOLD
---------- ---------- ---------- -----------
      2001          3         17        2000

 SELECT * FROM t5 partition(p6);

      YEAR      MONTH        DAY AMOUNT_SOLD
---------- ---------- ---------- -----------
      2002          1          1        4000



/*6. Create a multicolumn partitioned table as directed:
 Table supplier_parts, storing the information about which suppliers deliver
which parts. To distribute the data in equal-sized partitions, it is not sufficient
to partition the table based on the supplier_id, because some suppliers might
provide hundreds of thousands of parts, while others provide only a few
specialty parts. Instead, you partition the table on (supplier_id, partnum) to
manually enforce equal-sized partitions.
 Insert the following values
(5,5, 1000);
(5,150, 1000);
(10,100, 1000);*/

create table supplier_parts(
sid number,
pnum number,
sold number)
partition by range(sid,pnum)
(partition p1 values less than(10,100),
 partition p2 values less than(20,200),
 partition future values less than(MAXVALUE,MAXVALUE));
 
INSERT INTO supplier_parts values(5,200,500);
INSERT INTO supplier_parts values(11,100,500); 
INSERT INTO supplier_parts values(22,250,500);
INSERT INTO supplier_parts values(11,90,500);

select * from supplier_parts partition(p1);

      SID       PNUM       SOLD
--------- ---------- ----------
        5        200        500
		
select * from supplier_parts partition(p2);

       SID       PNUM       SOLD
---------- ---------- ----------
        11        100        500
        11         90        500
		
select * from supplier_parts partition(future);
       SID       PNUM       SOLD
---------- ---------- ----------
        22        250        500
	

	
/*7. Create interval partitioned table as directed:
 Creates a table named- Sales consisting of four partitions, one for each quarter
of sales. Each partition is given a name (sales_q1, sales_q2, ...)
 The columns for table must be prod_id, cust_id, promo_id, quantify sold,
amount_sold – all in number format and month in number format
 Perform interval partitioning on month and take interval of 01 months.*/


CREATE TABLE sales3
( prod_id number(6), 
  cust_id number,
  promo_id number(3),
  amount_sold number(10,2),
  q_sold number,
  month number)
  partition by range(month)
  interval(1)
  (partition sales_q1 values less than(04),
  partition sales_q2 values less than(07),
  partition sales_q3 values less than(10));		
  
  insert into sales3 values (1,2,3,4,5,1);
  insert into sales3 values (1,8,3,4,5,5);
  insert into sales3 values (1,2,3,74,5,9);
  insert into sales3 values (1,54,3,4,5,11);
  
  exec dbms_stats.gather_table_stats('anshit','SALES3');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='SALES3';
 
 /*output
 PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----
SALES_Q1                       USERS                          04                                                                                1
SALES_Q2                       USERS                          07                                                                                1
SALES_Q3                       USERS                          10                                                                                1
SYS_P26                        USERS                          12                                                                                1
*/


/*8. Demonstrate reference partitioning as directed:
 Create parent table Orders with the attributes order_id, order_date,
customer_id, shipper_id.
 Perform Range partitioning on Order Date. Take Range of 03 Months i.e. 01
quarter
 Create child table order_items with attributes order_id, product_id, price and
quantity.
 Perform Reference partitioning on child table.
 Delete the created partitions. */

create table orders
( order_id number primary key,
  order_date date ,
  customer_id number,
  shipper_id number)
  partition by range(order_date)
  ( PARTITION p1 VALUES LESS THAN (TO_DATE('01-apr-2011', 'DD-MON-YYYY')),
     PARTITION p2  VALUES LESS THAN (TO_DATE('01-jul-2011', 'DD-MON-YYYY')),
     PARTITION p3 VALUES LESS THAN (TO_DATE('01-oct-2011', 'DD-MON-YYYY')),
	 PARTITION p4 VALUES LESS THAN (TO_DATE('01-jan-2012', 'DD-MON-YYYY')));





create table order_items
( order_id number not null,
product_id number primary key,
price number,
quantity number,
constraint fo foreign key (order_id) references orders)
partition by reference(fo);

select table_name, partition_name
        from user_tab_partitions where table_name in ('ORDERS', 'ORDER_ITEMS');

/*output
TABLE_NAME                     PARTITION_NAME
------------------------------ -----------------------
ORDERS                         P1
ORDERS                         P2
ORDERS                         P3
ORDERS                         P4
ORDER_ITEMS                    P1
ORDER_ITEMS                    P2
ORDER_ITEMS                    P3
ORDER_ITEMS                    P4

8 rows selected.
*/

insert into orders values(1,'01-feb-2011',05,5);
insert into order_items values(1,1,100,150);

alter table orders drop partition p2;

/*OUTPUT:
TABLE_NAME                     PARTITION_NAME
------------------------------ ----------------------------
ORDERS                         P1
ORDERS                         P3
ORDERS                         P4
ORDER_ITEMS                    P1
ORDER_ITEMS                    P3
ORDER_ITEMS                    P4

6 rows selected.*/



/*9. Implement virtual column based partitioning as below:
 Create table employee with attributes Emp_id, emp_name, fixed_salary,
variable_salary. Generate Total salary as virtual colum.
 Perform range partitioning on Total Salary with four partitions as below:
o Partition P1 stores salary less than 25000
o Partition P2 stores salary less than 50000
o Partition P3 stores salary less than 75000
o Partition P4 stores any salary above and equal to than 75000*/


 create table employee
 ( emp_id number,
  emp_name varchar2(10),
  fixed_salary number,
  variable_salary number,
  total_salary number generated always as (fixed_salary+variable_salary)virtual 
 )
 partition by range(total_salary)
 ( partition p1 values less than (25000),
   partition p2 values less than (50000),
   partition p3 values less than (75000),
   partition p4 values less than (maxvalue)
 );
 
 insert into employee(emp_id,emp_name,fixed_salary,variable_salary) values(1,'anshit',25000,75000);
 select * from employee;
 /*OUTPUT
     EMP_ID EMP_NAME   FIXED_SALARY VARIABLE_SALARY TOTAL_SALARY
---------- ---------- ------------ --------------- ------------
         1 anshit            25000           75000       100000
		 */
		 
 exec dbms_stats.gather_table_stats('anshit','EMPLOYEE');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='EMPLOYEE';		 
 
 /*output:-
 
 PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ------
P1                             USERS                          25000                                                                             0
P2                             USERS                          50000                                                                             0
P3                             USERS                          75000                                                                             0
P4                             USERS                          MAXVALUE                                                                          1
*/

/*10. Demonstrate Composite partitioning technique as directed
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
 Partition unknown should accept any other state.*/

create table customer
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  time_id date)
partition by range(time_id)
subpartition by list(cust_state)
subpartition template(
 subpartition west values('mh','gj'),
 subpartition south values('ap','tn'),
 subpartition north values('hp','up'),
 subpartition other values(default))
( partition old values less than(TO_DATE('01-jan-2005', 'DD-MON-YYYY')),
 partition acquired values less than(TO_DATE('01-jan-2010', 'DD-MON-YYYY')),
partition recent values less than(TO_DATE('01-jan-2015', 'DD-MON-YYYY')), 
partition p1 values less than(maxvalue));

insert into customer values(1,'anshit','mh','01-feb-2009');
exec dbms_stats.gather_table_stats('anshit','CUSTOMER');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER';
 
 /*output
 PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
OLD                            USERS                          TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
ACQUIRED                       USERS                          TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
RECENT                         USERS                          TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
P1                             USERS                          MAXVALUE                                                                          0
*/



/*11 RANGE-RANGE*/
create table customer2
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by range(time_id)
subpartition by range(cust_id)
subpartition template(
 subpartition s1 values less than(10),
subpartition s2 values less than(20),
 subpartition other values less than(maxvalue))
( partition old values less than(TO_DATE('01-jan-2005', 'DD-MON-YYYY')),
 partition acquired values less than(TO_DATE('01-jan-2010', 'DD-MON-YYYY')),
partition recent values less than(TO_DATE('01-jan-2015', 'DD-MON-YYYY')), 
partition p1 values less than(maxvalue));


insert into customer2 values(1,'anshit','mh',5,'01-feb-2009');
exec dbms_stats.gather_table_stats('anshit','CUSTOMER2');
 select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER2';
 
 /*OUTPUT

PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ACQUIRED                       USERS                          TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
OLD                            USERS                          TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
P1                             USERS                          MAXVALUE                                                                          0
RECENT                         USERS                          TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0

*/

select * from customer2 subpartition(acquired_s1);
/*

   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 anshit     mh                   5 01-FEB-09
		 */






/* 12 range hash*/

create table customer3
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by range(time_id)
subpartition by hash(cust_id)
subpartition template(
 subpartition h1,
  subpartition h2)
( partition old values less than(TO_DATE('01-jan-2005', 'DD-MON-YYYY')),
 partition acquired values less than(TO_DATE('01-jan-2010', 'DD-MON-YYYY')),
partition recent values less than(TO_DATE('01-jan-2015', 'DD-MON-YYYY')), 
partition p1 values less than(maxvalue));

insert into customer3 values(1,'anshit','mh',5,'01-feb-2009');

exec dbms_stats.gather_table_stats('anshit','CUSTOMER3');
select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER3';


/*OUTPUT
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ACQUIRED                       USERS                          TO_DATE(' 2010-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          1
OLD                            USERS                          TO_DATE(' 2005-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
P1                             USERS                          MAXVALUE                                                                          0
RECENT                         USERS                          TO_DATE(' 2015-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIA          0
*/
select * from customer3 subpartition(acquired_h2);
/*   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 anshit     mh                   5 01-FEB-09
		 */



/*13 list hash*/
create table customer4
( cust_id number,
  cust_name varchar2(10),
  cust_state varchar2(10),
  amount_sold number,
  time_id date)
partition by list(cust_state)
subpartition by hash(cust_id)
subpartition template(
 subpartition h1,
  subpartition h2)
( partition old values ('mh','tn'),
 partition acquired values ('cg','up'),
partition recent values (default));

insert into customer4 values(1,'anshit','mh',5,'01-feb-2009');

exec dbms_stats.gather_table_stats('anshit','CUSTOMER4');
select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER4';

/*OUTPUT
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----------
ACQUIRED                       USERS                          'cg', 'up'                                                                        0
OLD                            USERS                          'mh', 'tn'                                                                        1
RECENT                         USERS                          default                                                                           0
*/

select * from customer4 subpartition(old_h2);
/*
   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 anshit     mh                   5 01-FEB-09
*/



/*14 list list*/

create table customer5
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
( partition old values ('mh','tn'),
 partition acquired values ('cg','up'),
partition recent values (default));

insert into customer5 values(1,'anshit','mh',5,'01-feb-2009');

exec dbms_stats.gather_table_stats('anshit','CUSTOMER5');
select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOMER5';

/*output
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----
ACQUIRED                       USERS                          'cg', 'up'                                                                        0
OLD                            USERS                          'mh', 'tn'                                                                        1
RECENT                         USERS                          default                                                                           0
*/

select * from customer5 subpartition(old_s1);
/*
 CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
-------- ---------- ---------- ----------- ---------
       1 anshit     mh                   5 01-FEB-09
	   */
	   
	

/*15 list range*/
create table custome6
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
( partition old values ('mh','tn'),
 partition acquired values ('cg','up'),
partition recent values (default));

insert into custome6 values(1,'anshit','mh',5,'01-feb-2009');
exec dbms_stats.gather_table_stats('anshit','CUSTOME6');
select partition_name,tablespace_name,high_value,num_rows from user_tab_partitions where table_name='CUSTOME6';

/*OUTPUT
PARTITION_NAME                 TABLESPACE_NAME                HIGH_VALUE                                                                 NUM_ROWS
------------------------------ ------------------------------ -------------------------------------------------------------------------------- ----
ACQUIRED                       USERS                          'cg', 'up'                                                                        0
OLD                            USERS                          'mh', 'tn'                                                                        1
RECENT                         USERS                          default                                                                           0
*/
select * from custome6 subpartition(old_s1);
/*OUTPUT
   CUST_ID CUST_NAME  CUST_STATE AMOUNT_SOLD TIME_ID
---------- ---------- ---------- ----------- ---------
         1 anshit     mh                   5 01-FEB-09
		 */