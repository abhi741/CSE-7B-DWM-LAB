--practical 2 --
/*
AUTHOR : SANSKRUTI BAJORIA
ROLL NO: 11

AIM :Write and Execute SQL aggregation queries for data warehouse.
Details: To run queries for CUBE, PARTIAL CUBE, ROLLUP, PARTIAL ROLLUP, GROUPING, GROUPING SETS, GROUP_ID( ).

************************************************************************************************************

SQL> select count(*) from sales;

  COUNT(*)
----------
    918843

SQL> select count(*) from products;

  COUNT(*)
----------
        72

SQL> select * from sales where rownum<10;

   PROD_ID    CUST_ID TIME_ID   CHANNEL_ID   PROMO_ID QUANTITY_SOLD AMOUNT_SOLD
---------- ---------- --------- ---------- ---------- ------------- -----------
        13        987 10-JAN-98          3        999             1     1232.16
        13       1660 10-JAN-98          3        999             1     1232.16
        13       1762 10-JAN-98          3        999             1     1232.16
        13       1843 10-JAN-98          3        999             1     1232.16
        13       1948 10-JAN-98          3        999             1     1232.16
        13       2273 10-JAN-98          3        999             1     1232.16
        13       2380 10-JAN-98          3        999             1     1232.16
        13       2683 10-JAN-98          3        999             1     1232.16
        13       2865 10-JAN-98          3        999             1     1232.16

9 rows selected.

---QUERY 1 --------
*********************************************************************************************************************************
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and 
October 2000 using ROLL-UP Extension. The query should return the following: 
 
    The aggregation rows that would be produced by GROUP BY ,  The First-level subtotals aggregating across country_id for each
 combination of channel_desc and calendar_month.     Second-level subtotals aggregating across calendar_month_desc and country_id 
 for each channel_desc value.     A grand total row. 
 

SQL> select channels.channel_desc,calendar_month_desc,
  2       countries.country_iso_code,
  3      TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
  4       FROM sales,customers,times,channels,countries
  5       WHERE sales.time_id=times.time_id
  6       and sales.cust_id=customers.cust_id
  7      AND customers.country_id=countries.country_id
  8     AND sales.channel_id=channels.channel_id
  9      AND channels.channel_desc IN ('Direct Sales','Internet')
 10      AND times.calendar_month_desc IN ('2000-09','2000-10')
 11   AND channels.channel_desc IN ('Direct Sales','Internet')
 12   AND countries.country_iso_code IN ('GB','US')
 13   group by
 14   ROLLUP(channels.channel_desc,calendar_month_desc,countries.country_iso_code);

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-09            140,793
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Internet             2000-10            151,593
Internet                                292,387
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-09            723,424
Direct Sales         2000-10  GB         91,925

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
                                      1,790,032

15 rows selected.


************************************************************************************************************
---QUERY 2---

Q2. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in 
September 2000 and October 2009 using CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
 countries.country_iso_code. 
 
 
SQL> select channels.channel_desc, calendar_month_desc,
  2  countries.country_iso_code,
  3  to_char(sum(amount_sold), '9,999,999,999') total_sales
  4  from sales, customers, times, channels, countries
  5  where sales.time_id=times.time_id
  6  and sales.cust_id=customers.cust_id
  7  and customers.country_id = countries.country_id
  8  and sales.channel_id = channels.channel_id
  9  and upper(channels.channel_desc) in ('DIRECT SALES', 'INTERNET')
 10  and times.calendar_month_desc in ('2000-09', '2000-10')
 11  and upper(countries.country_iso_code) in ('GB', 'US')
 12  group by
 13  cube(channels.channel_desc, calendar_month_desc, countries.country_iso_code)
 14  ORDER BY channel_desc;

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-09            723,424
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                  GB        177,148
Direct Sales                  US      1,320,497
Direct Sales                          1,497,646
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Internet             2000-09            140,793
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Internet             2000-10            151,593
Internet                      GB         31,109
Internet                      US        261,278
Internet                                292,387
                     2000-09  GB        101,792
                     2000-09  US        762,425
                     2000-09            864,217
                     2000-10  GB        106,465

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
                     2000-10  US        819,351
                     2000-10            925,815
                              GB        208,257
                              US      1,581,775
                                      1,790,032

27 rows selected.

******************************************************************************************
---QUERY 3---
Q3. Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000

select channels.channel_desc, countries.country_iso_code,
    to_char(sum(amount_sold), '9,999,999,999') total_sales
    from sales, customers, times, channels, countries
    where sales.time_id=times.time_id
   and sales.cust_id=customers.cust_id
    and customers.country_id = countries.country_id
    and sales.channel_id = channels.channel_id
   and upper(channels.channel_desc) in ('DIRECT SALES', 'INTERNET')
   and times.calendar_month_desc in ('2000-09', '2000-10')
   and upper(countries.country_iso_code) in ('FR', 'US')
   group by
   cube(channels.channel_desc, countries.country_iso_code)
   ORDER BY channel_desc;


CHANNEL_DESC         CO TOTAL_SALES
-------------------- -- --------------
Direct Sales         FR        105,360
Direct Sales         US      1,320,497
Direct Sales                 1,425,857
Internet             FR         14,988
Internet             US        261,278
Internet                       276,266
                     FR        120,347
                     US      1,581,775
                             1,702,123

9 rows selected.


******************************************************************************************
---query 4---
Q4. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
 First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.

SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		CHANNELS.CHANNEL_DESC  , ROLLUP  (COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);


CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Internet             GB 2000-09          16,569
Internet             GB 2000-10          14,539
Internet             GB                  31,109
Internet             US 2000-09         124,224
Internet             US 2000-10         137,054
Internet             US                 261,278
Internet                                292,387
Direct Sales         GB 2000-09          85,223
Direct Sales         GB 2000-10          91,925
Direct Sales         GB                 177,148
Direct Sales         US 2000-09         638,201

CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Direct Sales         US 2000-10         682,297
Direct Sales         US               1,320,497
Direct Sales                          1,497,646

14 rows selected.

SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		  COUNTRIES.COUNTRY_ISO_CODE, ROLLUP  (CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC);

CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Internet             GB 2000-09          16,569
Internet             GB 2000-10          14,539
Internet             GB                  31,109
Direct Sales         GB 2000-09          85,223
Direct Sales         GB 2000-10          91,925
Direct Sales         GB                 177,148
                     GB                 208,257
Internet             US 2000-09         124,224
Internet             US 2000-10         137,054
Internet             US                 261,278
Direct Sales         US 2000-09         638,201

CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Direct Sales         US 2000-10         682,297
Direct Sales         US               1,320,497
                     US               1,581,775

					 
**********************************************************************************************************************************
----query 5-----

Q5. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 
and October 2009 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.

SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		CHANNELS.CHANNEL_DESC  , CUBE  (COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);


CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Internet                                292,387
Internet                2000-09         140,793
Internet                2000-10         151,593
Internet             GB                  31,109
Internet             GB 2000-09          16,569
Internet             GB 2000-10          14,539
Internet             US                 261,278
Internet             US 2000-09         124,224
Internet             US 2000-10         137,054
Direct Sales                          1,497,646
Direct Sales            2000-09         723,424

CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
Direct Sales            2000-10         774,222
Direct Sales         GB                 177,148
Direct Sales         GB 2000-09          85,223
Direct Sales         GB 2000-10          91,925
Direct Sales         US               1,320,497
Direct Sales         US 2000-09         638,201
Direct Sales         US 2000-10         682,297

18 rows selected.


****************************************************************************************************************************
------------query 6----------------
Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO

SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	GROUPING(CHANNELS.CHANNEL_DESC) as CH,
	GROUPING(CALENDAR_MONTH_DESC) as MO,
	GROUPING(COUNTRIES.COUNTRY_ISO_CODE)as CO
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		ROLLUP(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);

CHANNEL_DESC         CO CALENDAR         CH         MO         CO
-------------------- -- -------- ---------- ---------- ----------
Internet             GB 2000-09           0          0          0
Internet             GB 2000-10           0          0          0
Internet             GB                   0          1          0
Internet             US 2000-09           0          0          0
Internet             US 2000-10           0          0          0
Internet             US                   0          1          0
Internet                                  0          1          1
Direct Sales         GB 2000-09           0          0          0
Direct Sales         GB 2000-10           0          0          0
Direct Sales         GB                   0          1          0
Direct Sales         US 2000-09           0          0          0

CHANNEL_DESC         CO CALENDAR         CH         MO         CO
-------------------- -- -------- ---------- ---------- ----------
Direct Sales         US 2000-10           0          0          0
Direct Sales         US                   0          1          0
Direct Sales                              0          1          1
                                          1          1          1

15 rows selected.


***********************************************************************************************************************************
------------------query 7------------------------------------
Q7. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September
 2000 and October 2009 using GROUPING SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)


SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES$ 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		grouping sets((CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC),
		(channel_desc, country_iso_code), (calendar_month_desc, country_iso_code) ) ;


CHANNEL_DESC         CO CALENDAR TOTAL_SALES$
-------------------- -- -------- --------------
Internet             GB 2000-09          16,569
Direct Sales         GB 2000-09          85,223
Internet             GB 2000-10          14,539
Direct Sales         GB 2000-10          91,925
Internet             US 2000-09         124,224
Direct Sales         US 2000-09         638,201
Internet             US 2000-10         137,054
Direct Sales         US 2000-10         682,297
                     GB 2000-09         101,792
                     GB 2000-10         106,465
                     US 2000-09         762,425

CHANNEL_DESC         CO CALENDAR TOTAL_SALES$
-------------------- -- -------- --------------
                     US 2000-10         819,351
Direct Sales         GB                 177,148
Internet             GB                  31,109
Direct Sales         US               1,320,497
Internet             US                 261,278

16 rows selected.


******************************************************************************************************************************
----------------query 8 ----------------------
Q: 8 Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter,
 and then across all months and quarters in the year. 


SELECT TIMES.CALENDAR_MONTH_DESC,TIMES.CALENDAR_QUARTER_DESC,TIMES.CALENDAR_YEAR,SUM(AMOUNT_SOLD) SUM_AMOUNT_SOLD
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_YEAR = 1999
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
		GROUP BY 
		ROLLUP(TIMES.CALENDAR_YEAR,TIMES.CALENDAR_QUARTER_DESC,TIMES.CALENDAR_MONTH_DESC);


CALENDAR CALENDA CALENDAR_YEAR SUM_AMOUNT_SOLD
-------- ------- ------------- ---------------
1999-01  1999-01          1999       974627.95
1999-02  1999-01          1999      1089255.92
1999-03  1999-01          1999        754026.7
         1999-01          1999      2817910.57
1999-04  1999-02          1999       708060.57
1999-05  1999-02          1999       818055.52
1999-06  1999-02          1999       729677.52
         1999-02          1999      2255793.61
1999-07  1999-03          1999       893452.47
1999-08  1999-03          1999       883460.92
1999-09  1999-03          1999       923577.01

CALENDAR CALENDA CALENDAR_YEAR SUM_AMOUNT_SOLD
-------- ------- ------------- ---------------
         1999-03          1999       2700490.4
1999-10  1999-04          1999       715831.36
1999-11  1999-04          1999       742248.42
1999-12  1999-04          1999       841572.17
         1999-04          1999      2299651.95
                          1999      10073846.5
                                    10073846.5

18 rows selected.


*******************************************************************************************************************************
QUERY 9
Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)

SELECT CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS, COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE,
	SUM(AMOUNT_SOLD) TOTAL_SALES
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				ROLLUP(CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS),
				ROLLUP(COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE);

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
                                   Europe               GB   266785.98
                                   Europe                    266785.98
                                   Americas             US  2382646.81
                                   Americas                 2382646.81
                                                            2649432.79
Channel total                      Europe               GB   266785.98
Channel total                      Europe                    266785.98
Channel total                      Americas             US  2382646.81
Channel total                      Americas                 2382646.81
Channel total                                               2649432.79
Channel total Direct               Europe               GB   177148.35

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
Channel total Direct               Europe                    177148.35
Channel total Direct               Americas             US   1320497.4
Channel total Direct               Americas                  1320497.4
Channel total Direct                                        1497645.75
Channel total Others               Europe               GB    58529.13
Channel total Others               Europe                     58529.13
Channel total Others               Americas             US   800871.37
Channel total Others               Americas                  800871.37
Channel total Others                                          859400.5
Channel total Indirect             Europe               GB     31108.5
Channel total Indirect             Europe                      31108.5

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
Channel total Indirect             Americas             US   261278.04
Channel total Indirect             Americas                  261278.04
Channel total Indirect                                       292386.54

25 rows selected.

***********************************************************************************************************************
------	QUERY 10 --------
Consider the following Query and make conclusion from the result obtained.

SELECT deptno, job, SUM(sal) 
	FROM emp 
		GROUP BY CUBE(deptno, job) ;
		
/*
    DEPTNO JOB         SUM(SAL)
---------- --------- ----------
                          29025
           CLERK           4150
           ANALYST         6000
           MANAGER         8275
           SALESMAN        5600
           PRESIDENT       5000
        10                 8750
        10 CLERK           1300
        10 MANAGER         2450
        10 PRESIDENT       5000
        20                10875

    DEPTNO JOB         SUM(SAL)
---------- --------- ----------
        20 CLERK           1900
        20 ANALYST         6000
        20 MANAGER         2975
        30                 9400
        30 CLERK            950
        30 MANAGER         2850
        30 SALESMAN        5600

18 rows selected.

*/
***********************************************************************************************************************************

----QUERY 11------
Find the total sales by country name and channel_desc for the country name starting from U through the Internet and 
direct sales in September 2000 and October. 

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-09           336428.69           1
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Internet             2001-10           425337.31           1
Internet                                  761766           3
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-09           714062.98           1
Direct Sales         2001-10  GB        75296.44           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-10  US        566719.8           0
Direct Sales         2001-10           642016.24           1
Direct Sales                          1356079.22           3
                                      2117845.22           7

15 rows selected.

********************************************************************************************************************

Q12. Analyze the output 


-- QUIERY 12:

 SELECT
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code,
CO.COUNTRY_NAME,
SUM(s.amount_sold) sum_amount_sold,
GROUPING_ID(
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code) grouping_id
FROM
sales s,
customers cu,
times t,
channels ch,
countries co
WHERE
s.time_id=t.time_id AND
s.cust_id=cu.cust_id AND
cu.country_id = co.country_id AND
s.channel_id = ch.channel_id AND
ch.channel_desc IN ('Direct Sales', 'Internet') AND
t.calendar_month_desc IN ('2001-09', '2001-10') AND
co.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code,CO.COUNTRY_NAME);

/*
CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Internet             2001-09  GB United Kingdom                                  36806.73           0
Internet             2001-09  GB                                                 36806.73           0
Internet             2001-09  US United States of America                       299621.96           0
Internet             2001-09  US                                                299621.96           0
Internet             2001-09                                                    336428.69           1
Internet             2001-10  GB United Kingdom                                  39010.76           0
Internet             2001-10  GB                                                 39010.76           0
Internet             2001-10  US United States of America                       386326.55           0
Internet             2001-10  US                                                386326.55           0
Internet             2001-10                                                    425337.31           1
Internet                                                                           761766           3

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Direct Sales         2001-09  GB United Kingdom                                  92865.04           0
Direct Sales         2001-09  GB                                                 92865.04           0
Direct Sales         2001-09  US United States of America                       621197.94           0
Direct Sales         2001-09  US                                                621197.94           0
Direct Sales         2001-09                                                    714062.98           1
Direct Sales         2001-10  GB United Kingdom                                  75296.44           0
Direct Sales         2001-10  GB                                                 75296.44           0
Direct Sales         2001-10  US United States of America                        566719.8           0
Direct Sales         2001-10  US                                                 566719.8           0
Direct Sales         2001-10                                                    642016.24           1
Direct Sales                                                                   1356079.22           3

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
                                                                               2117845.22           7
-- 1 1 1 == 7 IN BINARY , 0 1 1 =>3 , 0 0 1 =>1 , 000=>0
 

23 rows selected.
*/






