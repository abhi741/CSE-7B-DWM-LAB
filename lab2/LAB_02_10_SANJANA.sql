﻿--QUERY 1
Q1. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.

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
ROLLUP(channels.channel_desc, calendar_month_desc,
countries.country_iso_code);

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

--QUERY 2
Q2. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
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
CUBE(channels.channel_desc, calendar_month_desc,
countries.country_iso_code)
ORDER BY channels.channel_desc;

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

--QUERY 3
Q3. Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000

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
CUBE(channels.channel_desc,countries.country_iso_code);

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
                               833,224
                     FR         70,799
                     US        762,425
Internet                       133,821
Internet             FR          9,597
Internet             US        124,224
Direct Sales                   699,403
Direct Sales         FR         61,202
Direct Sales         US        638,201

9 rows selected.

--QUERY 4
Q4. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without
using ROLLUP.
 First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.

SELECT channels.channel_desc,calendar_month_desc,
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
GROUP BY channels.channel_desc,
ROLLUP(calendar_month_desc,
countries.country_iso_code)
ORDER BY channels.channel_desc;

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-09            723,424
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-09            140,793
Internet             2000-10  GB         14,539

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-10  US        137,054
Internet             2000-10            151,593
Internet                                292,387

14 rows selected.

--QUERY 5
Q5. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc.

SELECT channels.channel_desc,calendar_month_desc,
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
GROUP BY channels.channel_desc,
CUBE(calendar_month_desc,
countries.country_iso_code)
ORDER BY channels.channel_desc;

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

18 rows selected.

--QUERY 6
Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO

SELECT channels.channel_desc,calendar_month_desc,
countries.country_iso_code,
GROUPING(channel_desc) as CH,
GROUPING(calendar_month_desc) as MO,
GROUPING(country_iso_code) as CO,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09', '2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY ROLLUP(channel_desc,calendar_month_desc,country_iso_code);
 
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

--QUERY 7
Q7. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using GROUPING
SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)

SELECT channels.channel_desc,calendar_month_desc,
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
GROUP BY GROUPING SETS((channel_desc, calendar_month_desc, country_iso_code),
(channel_desc, country_iso_code),
(calendar_month_desc, country_iso_code));


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

--QUERY 8
Q: 8 Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.

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

--QUERY 9
Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)

SELECT channels.channel_total "CHANNEL_TOTAL",channels.channel_class "CHANNEL_CLASS" ,
countries.country_region "COUNTRY_REGIOIN",countries.country_iso_code "COUNTRY_CODE",
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
ROLLUP(channel_total,channel_class),
ROLLUP(countries.country_region,countries.country_iso_code );

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGIOIN      CO SALES$
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

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGIOIN      CO SALES$
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


--QUERY 11
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




-QUERY 12

SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code, SUM(s.amount_sold) sum_amount_sold, 
GROUPING_ID( ch.channel_desc, t.calendar_month_desc, co.country_iso_code) 
grouping_id FROM sales s, customers cu, times t, channels ch, countries co 
WHERE   s.time_id=t.time_id 
AND s.cust_id=cu.cust_id 
AND cu.country_id = co.country_id 
AND s.channel_id = ch.channel_id 
AND ch.channel_desc IN ('Direct Sales', 'Internet') 
AND t.calendar_month_desc IN ('2001-09', '2001-10') 
AND co.country_iso_code IN ('GB', 'US') 
GROUP BY 
ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code); 

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

--QUERY 10
Q10. Consider the following Query and make conclusion from the result obtained. 
Query: (scott Schema) 
SELECT deptno, job, SUM(sal) FROM emp GROUP BY CUBE(deptno, job) 



















SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code, SUM(s.amount_sold) sum_amount_sold, 
GROUPING_ID( ch.channel_desc, t.calendar_month_desc, co.country_iso_code) 
grouping_id FROM sales s, customers cu, times t, channels ch, countries co 
WHERE   s.time_id=t.time_id 
AND s.cust_id=cu.cust_id 
AND cu.country_id = co.country_id 
AND s.channel_id = ch.channel_id 
AND ch.channel_desc IN ('Direct Sales', 'Internet') 
AND t.calendar_month_desc IN ('2001-09', '2001-10') 
AND co.country_iso_code IN ('GB', 'US') 
GROUP BY 
ROLLUP (ch.channel_desc,t.calendar_month_desc),
ROLLUP (co.country_iso_code,t.calendar_month_desc);


CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  GB        36806.73           0
Direct Sales         2001-09  GB        92865.04           0
Internet             2001-09  US       299621.96           0
Direct Sales         2001-09  US       621197.94           0
Internet             2001-10  GB        39010.76           0
Direct Sales         2001-10  GB        75296.44           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Direct Sales         2001-09  GB        92865.04           0
Internet             2001-09  US       299621.96           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-09  US       621197.94           0
Internet             2001-10  GB        39010.76           0
Direct Sales         2001-10  GB        75296.44           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Direct Sales         2001-09  GB        92865.04           0
Internet             2001-09  US       299621.96           0
Direct Sales         2001-09  US       621197.94           0
Internet             2001-10  GB        39010.76           0
Direct Sales         2001-10  GB        75296.44           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-10  US       386326.55           0
Direct Sales         2001-10  US        566719.8           0
                     2001-09  GB       129671.77           4
                     2001-09  US        920819.9           4
                     2001-10  GB        114307.2           4
                     2001-10  US       953046.35           4
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Internet                                  761766           3
Direct Sales         2001-09           714062.98           1
Direct Sales         2001-10           642016.24           1

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales                          1356079.22           3
                                      2117845.22           7
Internet                      GB        75817.49           2
Direct Sales                  GB       168161.48           2
                              GB       243978.97           6
Internet                      US       685948.51           2
Direct Sales                  US      1187917.74           2
                              US      1873866.25           6

41 rows selected.













