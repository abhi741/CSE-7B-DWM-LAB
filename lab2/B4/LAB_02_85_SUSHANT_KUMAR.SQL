-- PRACTICAL -2
/*
AIM : Write and Execute SQL aggregation queries for data warehouse.
*/

/*
NAME: SUSHANT KUMAR
BATCH : B4
ROLL NO: 85
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

SELECT channels.channel_desc,calendar_month_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
GROUP BY 
ROLLUP(channels.channel_desc,calendar_month_desc,countries.country_iso_code); 

/*

CHANNEL_DESC         CALENDAR CO SALES
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
the Internet and direct sales in September 2000 and October 2000 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
 countries.country_iso_code.
*/
-- QUERY 2:

SELECT channels.channel_desc,times.calendar_month_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
		CUBE(channels.channel_desc,times.calendar_month_desc, countries.country_iso_code) ORDER BY channels.channel_desc; 
/*
CHANNEL_DESC         CALENDAR CO SALES
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
                     2000-10  US        819,351
                     2000-10            925,815
                              GB        208,257
                              US      1,581,775
                                      1,790,032

27 rows selected.


*/

-- QUES. 3:
/*
Find the total sales by country_iso and channel_desc for the US and
France through the Internet and direct sales in September 2000
*/

-- QUERY 3:
SELECT channels.channel_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09')
	AND countries.country_iso_code IN ('FR', 'US')
	GROUP BY 
		CUBE(channels.channel_desc, countries.country_iso_code) ORDER BY channels.channel_desc;

/*
CHANNEL_DESC         CO SALES
-------------------- -- --------------
Direct Sales         FR         61,202
Direct Sales         US        638,201
Direct Sales                   699,403
Internet             FR          9,597
Internet             US        124,224
Internet                       133,821
                     FR         70,799
                     US        762,425
                               833,224

9 rows selected.
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
SELECT channels.channel_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY channels.channel_desc,
		ROLLUP(times.calendar_month_desc,countries.country_iso_code); 

/*
CHANNEL_DESC         CO SALES
-------------------- -- --------------
Internet             GB         16,569
Internet             US        124,224
Internet                       140,793
Internet             GB         14,539
Internet             US        137,054
Internet                       151,593
Internet                       292,387
Direct Sales         GB         85,223
Direct Sales         US        638,201
Direct Sales                   723,424
Direct Sales         GB         91,925
Direct Sales         US        682,297
Direct Sales                   774,222
Direct Sales                 1,497,646

14 rows selected.
*/
SELECT channels.channel_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY countries.country_iso_code,
	ROLLUP(times.calendar_month_desc,channels.channel_desc); 
# USING GROUPBY ON COUNTRY_ISO_CODE
/*
CHANNEL_DESC         CO SALES
-------------------- -- --------------
Internet             GB         16,569
Direct Sales         GB         85,223
                     GB        101,792
Internet             GB         14,539
Direct Sales         GB         91,925
                     GB        106,465
                     GB        208,257
Internet             US        124,224
Direct Sales         US        638,201
                     US        762,425
Internet             US        137,054
Direct Sales         US        682,297
                     US        819,351
                     US      1,581,775
*/

-- QUES. 5:

/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales
 in September 2000 and October 2009 using PARTIAL CUBE aggregation on month
 and country code and GROUP BY on channel_desc.
*/
-- QUERY 5:

SELECT channels.channel_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY channels.channel_desc,
		CUBE(times.calendar_month_desc,countries.country_iso_code);

/*
CHANNEL_DESC         CO SALES
-------------------- -- --------------
Internet                       292,387
Internet             GB         31,109
Internet             US        261,278
Internet                       140,793
Internet             GB         16,569
Internet             US        124,224
Internet                       151,593
Internet             GB         14,539
Internet             US        137,054
Direct Sales                 1,497,646
Direct Sales         GB        177,148
Direct Sales         US      1,320,497
Direct Sales                   723,424
Direct Sales         GB         85,223
Direct Sales         US        638,201
Direct Sales                   774,222
Direct Sales         GB         91,925
Direct Sales         US        682,297

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
SELECT channels.channel_desc,times.calendar_month_desc,countries.country_iso_code,GROUPING(channels.channel_desc) AS CH,GROUPING(times.calendar_month_desc) AS MO,GROUPING(countries.country_iso_code) AS CO,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
	ROLLUP(channels.channel_desc,times.calendar_month_desc, countries.country_iso_code); 

/*
CHANNEL_DESC         CALENDAR CO         CH         MO         CO SALES
-------------------- -------- -- ---------- ---------- ---------- --------------
Internet             2000-09  GB          0          0          0         16,569
Internet             2000-09  US          0          0          0        124,224
Internet             2000-09              0          0          1        140,793
Internet             2000-10  GB          0          0          0         14,539
Internet             2000-10  US          0          0          0        137,054
Internet             2000-10              0          0          1        151,593
Internet                                  0          1          1        292,387
Direct Sales         2000-09  GB          0          0          0         85,223
Direct Sales         2000-09  US          0          0          0        638,201
Direct Sales         2000-09              0          0          1        723,424
Direct Sales         2000-10  GB          0          0          0         91,925
Direct Sales         2000-10  US          0          0          0        682,297
Direct Sales         2000-10              0          0          1        774,222
Direct Sales                              0          1          1      1,497,646
                                          1          1          1      1,790,032

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
SELECT channels.channel_desc,times.calendar_month_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
	GROUPING SETS((channels.channel_desc,times.calendar_month_desc, countries.country_iso_code),(channels.channel_desc, countries.country_iso_code),(times.calendar_month_desc, countries.country_iso_code)); 

/*
CHANNEL_DESC         CALENDAR CO SALES
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
SELECT calendar_month_desc AS MONTH,calendar_quarter_desc AS QUARTER,calendar_year AS YEAR, TO_CHAR(SUM(amount_sold), '9,999,999,999.99') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_year IN ('1999')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
	ROLLUP(calendar_year,calendar_quarter_desc,calendar_month_desc); 

/*
MONTH    QUARTER       YEAR SALES
-------- ------- ---------- -----------------
1999-01  1999-01       1999        974,627.95
1999-02  1999-01       1999      1,089,255.92
1999-03  1999-01       1999        754,026.70
         1999-01       1999      2,817,910.57
1999-04  1999-02       1999        708,060.57
1999-05  1999-02       1999        818,055.52
1999-06  1999-02       1999        729,677.52
         1999-02       1999      2,255,793.61
1999-07  1999-03       1999        893,452.47
1999-08  1999-03       1999        883,460.92
1999-09  1999-03       1999        923,577.01
         1999-03       1999      2,700,490.40
1999-10  1999-04       1999        715,831.36
1999-11  1999-04       1999        742,248.42
1999-12  1999-04       1999        841,572.17
         1999-04       1999      2,299,651.95
                       1999     10,073,846.53
                                10,073,846.53

18 rows selected.
*/

-- QUES. : 9
/*
Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/
-- QUERY 9:

SELECT channels.channel_total,channels.channel_class,countries.country_region,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND times.calendar_month_desc IN ('2001-09', '2001-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY 
	ROLLUP(channels.channel_total,channels.channel_class),ROLLUP(countries.country_region,countries.country_iso_code); 

/*
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES
------------- -------------------- -------------------- -- --------------
                                   Europe               GB        321,244
                                   Europe                         321,244
                                   Americas             US      2,603,473
                                   Americas                     2,603,473
                                                                2,924,717
Channel total                      Europe               GB        321,244
Channel total                      Europe                         321,244
Channel total                      Americas             US      2,603,473
Channel total                      Americas                     2,603,473
Channel total                                                   2,924,717
Channel total Direct               Europe               GB        168,161
Channel total Direct               Europe                         168,161
Channel total Direct               Americas             US      1,187,918
Channel total Direct               Americas                     1,187,918
Channel total Direct                                            1,356,079
Channel total Others               Europe               GB         77,265
Channel total Others               Europe                          77,265
Channel total Others               Americas             US        729,606
Channel total Others               Americas                       729,606
Channel total Others                                              806,872
Channel total Indirect             Europe               GB         75,817
Channel total Indirect             Europe                          75,817
Channel total Indirect             Americas             US        685,949
Channel total Indirect             Americas                       685,949
Channel total Indirect                                            761,766

25 rows selected.
*/

-- QUES. 11:
/*
Find the total sales by country name and channel_desc for the country name
 starting from U through the Internet and direct sales in September 2000 and October.
*/
-- QUERY 11:

SELECT channels.channel_desc,times.calendar_month_desc,countries.country_name,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES
	FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_name LIKE 'U%'
	GROUP BY 
	ROLLUP(channels.channel_desc,times.calendar_month_desc,countries.country_name); 

/*
CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SALES
-------------------- -------- ---------------------------------------- --------------
Internet             2000-09  United Kingdom                                   16,569
Internet             2000-09  United States of America                        124,224
Internet             2000-09                                                  140,793
Internet             2000-10  United Kingdom                                   14,539
Internet             2000-10  United States of America                        137,054
Internet             2000-10                                                  151,593
Internet                                                                      292,387
Direct Sales         2000-09  United Kingdom                                   85,223
Direct Sales         2000-09  United States of America                        638,201
Direct Sales         2000-09                                                  723,424
Direct Sales         2000-10  United Kingdom                                   91,925
Direct Sales         2000-10  United States of America                        682,297
Direct Sales         2000-10                                                  774,222
Direct Sales                                                                1,497,646
                                                                            1,790,032

15 rows selected.

*/

