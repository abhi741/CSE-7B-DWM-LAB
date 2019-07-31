-- PRACTICAL -2
/*
AIM : Write and Execute SQL aggregation queries for data warehouse.
*/

/*
NAME: SARTHAK BAISWAR
BATCH : B3
ROLL NO: 76
*/

------------------------ PREPROCESSING QUERIES ----------------------------------

-- FACT TABLE
SELECT COUNT(*) FROM SALES;
/*
COUNT(*)
----------
918843
*/

-- DIM TABLE
SELECT COUNT(*) FROM PRODUCTS;
/*
COUNT(*)
----------
72
*/

SELECT * FROM SALES WHERE ROWNUM<10;
/*
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
*/

------------------------------------------- QUERY SECTION -----------------------------------------

-- QUES. 1 :
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and
direct sales in September 2000 and October 2000 using ROLL-UP Extension.
The query should return the following:
1. The aggregation rows that would be produced by GROUP BY
2. The First-level subtotals aggregating across country_id for
each combination of channel_desc and calendar_month.
3. Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
4. A grand total row.
*/
--QUERY 1:

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') SALES$
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				ROLLUP(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE);

/*

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
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
                                      1,790,032

15 rows selected.
*/

-- QUES. 2:
/*
Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
 countries.country_iso_code.
*/
-- QUERY 2:
	-- year =2000 change in query

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				CUBE(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE);

/*

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
                                      1,790,032
                              GB        208,257
                              US      1,581,775
                     2000-09            864,217
                     2000-09  GB        101,792
                     2000-09  US        762,425
                     2000-10            925,815
                     2000-10  GB        106,465
                     2000-10  US        819,351
Internet                                292,387
Internet                      GB         31,109

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Internet                      US        261,278
Internet             2000-09            140,793
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-10            151,593
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Direct Sales                          1,497,646
Direct Sales                  GB        177,148
Direct Sales                  US      1,320,497
Direct Sales         2000-09            723,424

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297

27 rows selected.


-- with france

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
                                      1,702,123
                              FR        120,347
                              US      1,581,775
                     2000-09            833,224
                     2000-09  FR         70,799
                     2000-09  US        762,425
                     2000-10            868,899
                     2000-10  FR         49,548
                     2000-10  US        819,351
Internet                                276,266
Internet                      FR         14,988

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Internet                      US        261,278
Internet             2000-09            133,821
Internet             2000-09  FR          9,597
Internet             2000-09  US        124,224
Internet             2000-10            142,445
Internet             2000-10  FR          5,391
Internet             2000-10  US        137,054
Direct Sales                          1,425,857
Direct Sales                  FR        105,360
Direct Sales                  US      1,320,497
Direct Sales         2000-09            699,403

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Direct Sales         2000-09  FR         61,202
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            726,454
Direct Sales         2000-10  FR         44,157
Direct Sales         2000-10  US        682,297

27 rows selected.
*/

-- QUES. 3:
/*
Find the total sales by country_iso and channel_desc for the US and
France through the Internet and direct sales in September 2000
*/

-- QUERY 3:

SELECT CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('FR', 'US')
			GROUP BY
				ROLLUP(CHANNELS.CHANNEL_DESC,COUNTRIES.COUNTRY_ISO_CODE);

/*
CHANNEL_DESC         CO TOTAL_SALES
-------------------- -- --------------
Internet             FR          9,597
Internet             US        124,224
Internet                       133,821
Direct Sales         FR         61,202
Direct Sales         US        638,201
Direct Sales                   699,403
                               833,224

7 rows selected.
*/

-- QUES. 4:
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and
direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP.
The query should return the following:
	1.Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
	2.First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
	3.Second-level subtotals aggregating
		across calendar_month_desc and country_id for each channel_desc value.
	4.It does not produce a grand total row.
*/

-- QUERY 4:
		-- take highest level outside the roll up clause, dont consider other levels

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				CHANNELS.CHANNEL_DESC, ROLLUP(CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE);

/*
CHANNEL_DESC         CALENDAR CO TOTAL_SALES
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

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646

14 rows selected.
*/

-- QUES. 5:

/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales
 in September 2000 and October 2009 using PARTIAL CUBE aggregation on month
 and country code and GROUP BY on channel_desc.
*/
-- QUERY 5:

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				CHANNELS.CHANNEL_DESC, CUBE(CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE);

/*
CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Internet                                292,387
Internet                      GB         31,109
Internet                      US        261,278
Internet             2000-09            140,793
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-10            151,593
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Direct Sales                          1,497,646
Direct Sales                  GB        177,148

CHANNEL_DESC         CALENDAR CO TOTAL_SALES
-------------------- -------- -- --------------
Direct Sales                  US      1,320,497
Direct Sales         2000-09            723,424
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297

18 rows selected.
*/

-- QUES. 6:
/*
Use GROUPING to create a set of mask columns for the result set of Q1
	1.Create grouping on channel_desc and name it as CH
	2.Create grouping calendar_month_desc and name it as MO
	3.Create grouping on country_iso_code and name it as CO
*/
-- QUERY 6:
		--- 1 1 1 ->APEX
		--- 0 0 0 0 -> BASE

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') SALES$,
	GROUPING (CHANNELS.CHANNEL_DESC) CH,
	GROUPING (CALENDAR_MONTH_DESC) MO,
	GROUPING (COUNTRIES.COUNTRY_ISO_CODE) CO
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				ROLLUP(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE);

/*
CHANNEL_DESC         CALENDAR CO SALES$                 CH         MO         CO
-------------------- -------- -- -------------- ---------- ---------- ----------
Internet             2000-09  GB         16,569          0          0          0
Internet             2000-09  US        124,224          0          0          0
Internet             2000-09            140,793          0          0          1
Internet             2000-10  GB         14,539          0          0          0
Internet             2000-10  US        137,054          0          0          0
Internet             2000-10            151,593          0          0          1
Internet                                292,387          0          1          1
Direct Sales         2000-09  GB         85,223          0          0          0
Direct Sales         2000-09  US        638,201          0          0          0
Direct Sales         2000-09            723,424          0          0          1
Direct Sales         2000-10  GB         91,925          0          0          0

CHANNEL_DESC         CALENDAR CO SALES$                 CH         MO         CO
-------------------- -------- -- -------------- ---------- ---------- ----------
Direct Sales         2000-10  US        682,297          0          0          0
Direct Sales         2000-10            774,222          0          0          1
Direct Sales                          1,497,646          0          1          1
                                      1,790,032          1          1          1

15 rows selected.
*/

-- QUES. 7:
/*
Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using GROUPING SETS.
Calculate aggregates over three groupings:
1.(channel_desc, calendar_month_desc, country_iso_code)
2.(channel_desc, country_iso_code)
3.(calendar_month_desc, country_iso_code)
*/

-- QUERY 7:

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') SALES$
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				GROUPING SETS((CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE),
				(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE),
				(CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE));

/*
CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  GB         16,569
Direct Sales         2000-09  GB         85,223
Internet             2000-09  US        124,224
Direct Sales         2000-09  US        638,201
Internet             2000-10  GB         14,539
Direct Sales         2000-10  GB         91,925
Internet             2000-10  US        137,054
Direct Sales         2000-10  US        682,297
                     2000-09  GB        101,792
                     2000-09  US        762,425
                     2000-10  GB        106,465

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
                     2000-10  US        819,351
Direct Sales                  GB        177,148
Internet                      GB         31,109
Direct Sales                  US      1,320,497
Internet                      US        261,278

16 rows selected.

*/

-- QUES. 8:
/*

Perform aggregation on amount sold.
It should get aggregated by month first, then by all the months in each quarter,
and then across all months and quarters in the year.
*/

-- QUERY 8: COUNRIES: US.GB. YEAR =1999, DIRECT SALES AND INTERNET

SELECT TIMES.CALENDAR_MONTH_DESC, TIMES.CALENDAR_QUARTER_DESC, TIMES.CALENDAR_YEAR, SUM(AMOUNT_SOLD) TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_YEAR = 1999
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				ROLLUP(TIMES.CALENDAR_YEAR,TIMES.CALENDAR_QUARTER_DESC,TIMES.CALENDAR_MONTH_DESC);

				-- ORDER YEAR - QUARTER - MONTH
/*
CALENDAR CALENDA CALENDAR_YEAR TOTAL_SALES
-------- ------- ------------- -----------
1999-01  1999-01          1999   974627.95
1999-02  1999-01          1999  1089255.92
1999-03  1999-01          1999    754026.7
         1999-01          1999  2817910.57
1999-04  1999-02          1999   708060.57
1999-05  1999-02          1999   818055.52
1999-06  1999-02          1999   729677.52
         1999-02          1999  2255793.61
1999-07  1999-03          1999   893452.47
1999-08  1999-03          1999   883460.92
1999-09  1999-03          1999   923577.01

CALENDAR CALENDA CALENDAR_YEAR TOTAL_SALES
-------- ------- ------------- -----------
         1999-03          1999   2700490.4
1999-10  1999-04          1999   715831.36
1999-11  1999-04          1999   742248.42
1999-12  1999-04          1999   841572.17
         1999-04          1999  2299651.95
                          1999  10073846.5
                                10073846.5

18 rows selected.
*/

-- QUES. : 9
/*
Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/
-- QUERY 9:

SELECT CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS, COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE,
	SUM(AMOUNT_SOLD) TOTAL_SALES
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
			GROUP BY
				ROLLUP(CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS),
				ROLLUP(COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE);

/*
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
                                   Europe               GB   208256.85
                                   Europe                    208256.85
                                   Americas             US  1581775.44
                                   Americas                 1581775.44
                                                            1790032.29
Channel total                      Europe               GB   208256.85
Channel total                      Europe                    208256.85
Channel total                      Americas             US  1581775.44
Channel total                      Americas                 1581775.44
Channel total                                               1790032.29
Channel total Direct               Europe               GB   177148.35

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
Channel total Direct               Europe                    177148.35
Channel total Direct               Americas             US   1320497.4
Channel total Direct               Americas                  1320497.4
Channel total Direct                                        1497645.75
Channel total Indirect             Europe               GB     31108.5
Channel total Indirect             Europe                      31108.5
Channel total Indirect             Americas             US   261278.04
Channel total Indirect             Americas                  261278.04
Channel total Indirect                                       292386.54

20 rows selected.
*/

-- QUES. 10:
/*
Consider the following Query and make conclusion from the result obtained.
Query: (scott Schema)
SELECT deptno, job, SUM(sal) FROM emp GROUP BY CUBE(deptno, job)
*/

/*
RESULT : IT WILL HAVE CUBE WITH 2 DIMENSIONS AND ALL THE POSSIBLE COMIBINATIONS (18 rows) OF JOB AND DEPT NO
		FOLLOWED BY THE GRAND TOTAL : 29025
*/

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

-- QUES. 11:
/*
Find the total sales by country name and channel_desc for the country name
 starting from U through the Internet and direct sales in September 2000 and October.
*/
-- QUERY 11:

SELECT CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_NAME, TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
	FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_NAME) LIKE 'U%'
			GROUP BY
				ROLLUP (COUNTRIES.COUNTRY_NAME, CHANNELS.CHANNEL_DESC );

/*
CHANNEL_DESC         COUNTRY_NAME                             TOTAL_SALES
-------------------- ---------------------------------------- --------------
Internet             United Kingdom                                   31,109
Direct Sales         United Kingdom                                  177,148
                     United Kingdom                                  208,257
Internet             United States of America                        261,278
Direct Sales         United States of America                      1,320,497
                     United States of America                      1,581,775
                                                                   1,790,032

7 rows selected.
*/


-- QUES. 12:
/*
ANALYZE THE OUTPUT
*/
-- QUERY 12:
 -- 111 = 7 IN BINARY , 011 = 3, 001 = 1 , 000 = 0

SELECT
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code,
CO.COUNTRY_NAME,
SUM(s.amount_sold) sum_amount_sold,
GROUPING_ID(
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code,CO.COUNTRY_NAME) grouping_id
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
t.calendar_month_desc,CO.COUNTRY_NAME,
co.country_iso_code);

/*
RESULT : GROUPING ID VALUE SHOWS THE DECIMAL REPRESENTATION OF DIMENSIONAL SUM ,
	EX: 111 = 7 => SUM IS APPLIED ACROSS ALL THE 3 DIMENSIONS
		011 = 3 => SUM IS APPLIED ACROSS LAST TWO DIMENSIONS
*/

/*
CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Internet             2001-09  GB United Kingdom                                  36806.73           0
Internet             2001-09     United Kingdom                                  36806.73           2
Internet             2001-09  US United States of America                       299621.96           0
Internet             2001-09     United States of America                       299621.96           2
Internet             2001-09                                                    336428.69           3
Internet             2001-10  GB United Kingdom                                  39010.76           0
Internet             2001-10     United Kingdom                                  39010.76           2
Internet             2001-10  US United States of America                       386326.55           0
Internet             2001-10     United States of America                       386326.55           2
Internet             2001-10                                                    425337.31           3
Internet                                                                           761766           7

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Direct Sales         2001-09  GB United Kingdom                                  92865.04           0
Direct Sales         2001-09     United Kingdom                                  92865.04           2
Direct Sales         2001-09  US United States of America                       621197.94           0
Direct Sales         2001-09     United States of America                       621197.94           2
Direct Sales         2001-09                                                    714062.98           3
Direct Sales         2001-10  GB United Kingdom                                  75296.44           0
Direct Sales         2001-10     United Kingdom                                  75296.44           2
Direct Sales         2001-10  US United States of America                        566719.8           0
Direct Sales         2001-10     United States of America                        566719.8           2
Direct Sales         2001-10                                                    642016.24           3
Direct Sales                                                                   1356079.22           7

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
                                                                               2117845.22          15

23 rows selected.
*/

-- EXISTANCE OF GROUP_ID
-- GROUP_ID EXAMPLE

SELECT CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS,
	SUM(AMOUNT_SOLD) TOTAL_SALES, GROUP_ID()
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
		WHERE SALES.TIME_ID=TIMES.TIME_ID
			AND SALES.CUST_ID=CUSTOMERS.CUST_ID
			AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
			AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
			AND UPPER (CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
			AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
			AND UPPER(COUNTRIES.COUNTRY_NAME) LIKE 'U%'
			GROUP BY
			ROLLUP(COUNTRIES.COUNTRY_NAME,CHANNELS.CHANNEL_DESC),ROLLUP(CHANNELS.CHANNEL_DESC)
			ORDER BY GROUP_ID();


			/*

			CHANNEL_DESC         COUNTRY_NAME                             TOTAL_SALES    GROUP_ID()
			-------------------- ---------------------------------------- -------------- ----------
			                     United Kingdom                                  208,257          0
			                     United States of America                      1,581,775          0
			Direct Sales         United States of America                      1,320,497          0
			Direct Sales         United Kingdom                                  177,148          0
			Internet             United States of America                        261,278          0
			Internet             United Kingdom                                   31,109          0
			                                                                   1,790,032          0
			Direct Sales                                                       1,497,646          0
			Internet                                                             292,387          0
			Direct Sales         United Kingdom                                  177,148          1
			Internet             United States of America                        261,278          1

			CHANNEL_DESC         COUNTRY_NAME                             TOTAL_SALES    GROUP_ID()
			-------------------- ---------------------------------------- -------------- ----------
			Internet             United Kingdom                                   31,109          1
			Direct Sales         United States of America                      1,320,497          1
			Direct Sales         United States of America                      1,320,497          2
			Direct Sales         United Kingdom                                  177,148          2
			Internet             United States of America                        261,278          2
			Internet             United Kingdom                                   31,109          2

			17 rows selected.
			*/
