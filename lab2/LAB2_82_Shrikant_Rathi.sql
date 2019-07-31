1.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and 
October 2000 using ROLL-UP Extension. The query should return the following: 
The aggregation rows that would be produced by GROUP BY ,The First-level subtotals aggregating across country_id for each
 combination of channel_desc and calendar_month.     Second-level subtotals aggregating across calendar_month_desc and country_id 
 for each channel_desc value.A grand total row.

 
SELECT channels.channel_desc, calendar_month_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10')  
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY 
ROLLUP(channels.channel_desc, calendar_month_desc, countries.country_iso_code); 


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



2.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in 
September 2000 and October 2009 using CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
 countries.country_iso_code. 
 
 
SELECT channels.channel_desc, calendar_month_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10')  
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY 
CUBE(channels.channel_desc, calendar_month_desc, countries.country_iso_code)
ORDER BY CHANNEL_DESC; 

CHANNEL_DESC         CALENDAR CO SALES$
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

CHANNEL_DESC         CALENDAR CO SALES$
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

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
                     2000-10  US        819,351
                     2000-10            925,815
                              GB        208,257
                              US      1,581,775
                                      1,790,032

27 rows selected.



3.Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000

SELECT channels.channel_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09')  
AND countries.country_iso_code IN ('FR', 'US') 
GROUP BY 
CUBE(channels.channel_desc, countries.country_iso_code)
ORDER BY CHANNEL_DESC; 


CHANNEL_DESC         CO SALES$
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



4.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
 First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.

SELECT channels.channel_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09','2000-10')  
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY channels.channel_desc,
ROLLUP(calendar_month_desc, countries.country_iso_code)
ORDER BY CHANNEL_DESC; 


CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Direct Sales         GB         85,223
Direct Sales         US        638,201
Direct Sales                   723,424
Direct Sales         GB         91,925
Direct Sales         US        682,297
Direct Sales                   774,222
Direct Sales                 1,497,646
Internet             GB         16,569
Internet             US        124,224
Internet                       140,793
Internet             GB         14,539

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Internet             US        137,054
Internet                       151,593
Internet                       292,387

14 rows selected.


5.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 
and October 2009 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.


SELECT channels.channel_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09','2000-10')  
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY channels.channel_desc,
CUBE(calendar_month_desc, countries.country_iso_code)
ORDER BY CHANNEL_DESC; 


CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Direct Sales         GB         85,223
Direct Sales         US        638,201
Direct Sales                   723,424
Direct Sales         GB         91,925
Direct Sales         US        682,297
Direct Sales                   774,222
Direct Sales         GB        177,148
Direct Sales         US      1,320,497
Direct Sales                 1,497,646
Internet             GB         16,569
Internet             US        124,224

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Internet                       140,793
Internet             GB         14,539
Internet             US        137,054
Internet                       151,593
Internet             GB         31,109
Internet             US        261,278
Internet                       292,387

18 rows selected.



6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO



SQL> SELECT channels.channel_desc,calendar_month_desc,countries.country_iso_code,
  2  GROUPING(channels.channel_desc) as CH, GROUPING(calendar_month_desc) as MO,
  3  grouping(countries.country_iso_code) as CO,
  4  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  5  FROM sales, customers, times, channels, countries
  6  WHERE sales.time_id=times.time_id
  7  AND sales.cust_id=customers.cust_id
  8  AND customers.country_id = countries.country_id
  9  AND sales.channel_id = channels.channel_id
 10  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 11  AND times.calendar_month_desc IN ('2000-09', '2000-10')
 12  AND countries.country_iso_code IN ('GB', 'US')
 13  GROUP BY
 14  ROLLUP(channels.channel_desc, calendar_month_desc, countries.country_iso_code);

CHANNEL_DESC         CALENDAR CO         CH         MO         CO SALES$
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

CHANNEL_DESC         CALENDAR CO         CH         MO         CO SALES$
-------------------- -------- -- ---------- ---------- ---------- --------------
Direct Sales         2000-10  US          0          0          0        682,297
Direct Sales         2000-10              0          0          1        774,222
Direct Sales                              0          1          1      1,497,646
                                          1          1          1      1,790,032


15 rows selected.


7.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September
 2000 and October 2009 using GROUPING SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)

SELECT channels.channel_desc, 
countries.country_iso_code, calendar_month_desc,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09','2000-10')  
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY GROUPING SETS((channel_desc,calendar_month_desc,
countries.country_iso_code),(channel_desc, country_iso_code),
(calendar_month_desc, country_iso_code));
ORDER BY CHANNEL_DESC; 


CHANNEL_DESC         CO CALENDAR SALES$
-------------------- -- -------- --------------
Internet             GB 2000-09          16,569
Direct Sales         GB 2000-09          85,223
Internet             US 2000-09         124,224
Direct Sales         US 2000-09         638,201
Internet             GB 2000-10          14,539
Direct Sales         GB 2000-10          91,925
Internet             US 2000-10         137,054
Direct Sales         US 2000-10         682,297
                     GB 2000-09         101,792
                     US 2000-09         762,425
                     GB 2000-10         106,465

CHANNEL_DESC         CO CALENDAR SALES$
-------------------- -- -------- --------------
                     US 2000-10         819,351
Direct Sales         GB                 177,148
Internet             GB                  31,109
Direct Sales         US               1,320,497
Internet             US                 261,278

16 rows selected.



8.Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter,
 and then across all months and quarters in the year.

SELECT calendar_month_desc "MONTH" , calendar_quarter_desc "QUARTER", calendar_year "YEAR",
  2  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  3  FROM sales, customers, times, channels, countries
  4  WHERE sales.time_id=times.time_id
  5  AND sales.cust_id=customers.cust_id
  6  AND customers.country_id = countries.country_id
  7  AND sales.channel_id = channels.channel_id
  8  AND channels.channel_desc IN ('Direct Sales', 'Internet')
  9  AND times.calendar_year IN ('1999')
 10  AND countries.country_iso_code IN ('GB', 'US')
 11  GROUP BY ROLLUP(calendar_year,calendar_quarter_desc,calendar_month_desc);

MONTH    QUARTER       YEAR SALES$
-------- ------- ---------- --------------
1999-01  1999-01       1999        974,628
1999-02  1999-01       1999      1,089,256
1999-03  1999-01       1999        754,027
         1999-01       1999      2,817,911
1999-04  1999-02       1999        708,061
1999-05  1999-02       1999        818,056
1999-06  1999-02       1999        729,678
         1999-02       1999      2,255,794
1999-07  1999-03       1999        893,452
1999-08  1999-03       1999        883,461
1999-09  1999-03       1999        923,577

MONTH    QUARTER       YEAR SALES$
-------- ------- ---------- --------------
         1999-03       1999      2,700,490
1999-10  1999-04       1999        715,831
1999-11  1999-04       1999        742,248
1999-12  1999-04       1999        841,572
         1999-04       1999      2,299,652
                       1999     10,073,847
                                10,073,847

18 rows selected.




9.Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)

SELECT channels.channel_total "CHANNEL_TOTAL" , channels.channel_class "CHANNEL_CLASS", 
countries.country_region "COUNTRY_REGION",countries.country_iso_code "COUNTRY CODE",
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY ROLLUP(channel_total,channel_class),ROLLUP(countries.country_region,countries.country_iso_code); 
	
	CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
                                   Europe               GB        208,257
                                   Europe                         208,257
                                   Americas             US      1,581,775
                                   Americas                     1,581,775
                                                                1,790,032
Channel total                      Europe               GB        208,257
Channel total                      Europe                         208,257
Channel total                      Americas             US      1,581,775
Channel total                      Americas                     1,581,775
Channel total                                                   1,790,032
Channel total Direct               Europe               GB        177,148

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
Channel total Direct               Europe                         177,148
Channel total Direct               Americas             US      1,320,497
Channel total Direct               Americas                     1,320,497
Channel total Direct                                            1,497,646
Channel total Indirect             Europe               GB         31,109
Channel total Indirect             Europe                          31,109
Channel total Indirect             Americas             US        261,278
Channel total Indirect             Americas                       261,278
Channel total Indirect                                            292,387

20 rows selected.


10.Consider the following Query and make conclusion from the result obtained.
SELECT deptno, job, SUM(sal) 
	FROM emp 
		GROUP BY CUBE(deptno, job) ;
		

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


11.Find the total sales by country name and channel_desc for the country name starting from U through the Internet and 
direct sales in September 2000 and October.

SELECT channel_desc,countries.country_iso_code,
countries.country_name,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09', '2000-10')
AND countries.country_name like 'U%'
GROUP BY
ROLLUP(channels.channel_desc, country_name,
countries.country_iso_code,country_name);

CHANNEL_DESC         CO COUNTRY_NAME                             SALES$
-------------------- -- ---------------------------------------- --------------
Internet             GB United Kingdom                                   31,109
Internet             US United States of America                        261,278
Direct Sales         GB United Kingdom                                  177,148
Direct Sales         US United States of America                      1,320,497
Internet             GB United Kingdom                                   31,109
Internet             US United States of America                        261,278
Direct Sales         GB United Kingdom                                  177,148
Direct Sales         US United States of America                      1,320,497
Internet                United Kingdom                                   31,109
Internet                United States of America                        261,278
Internet                                                                292,387

CHANNEL_DESC         CO COUNTRY_NAME                             SALES$
-------------------- -- ---------------------------------------- --------------
Direct Sales            United Kingdom                                  177,148
Direct Sales            United States of America                      1,320,497
Direct Sales                                                          1,497,646
                                                                      1,790,032

15 rows selected.



12. Analyze the output 

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
23 rows selected.







