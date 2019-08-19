-------------------------------QUERY 1---------------------------------
/*Q1. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.
*/QUERY 1:
SQL> SELECT channels.channel_desc, calendar_month_desc,
    countries.country_iso_code,
    TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
    FROM sales, customers, times, channels, countries
    WHERE sales.time_id*times.time_id
    AND sales.cust_id*customers.cust_id
    AND customers.country_id * countries.country_id
    AND sales.channel_id * channels.channel_id
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

***********************************************

----------------------------------------QUERY-2-----------------------------------------------
/*Q2. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
countries.country_iso_code.
*/

QUERY 2:
SQL> SELECT channels.channel_desc, calendar_month_desc,
  2  countries.country_iso_code,
  3  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4  FROM sales, customers, times, channels, countries
  5  WHERE sales.time_id*times.time_id
  6  AND sales.cust_id*customers.cust_id
  7  AND customers.country_id * countries.country_id
  8  AND sales.channel_id * channels.channel_id
  9  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10  AND times.calendar_month_desc IN ('2000-09', '2000-10')
 11  AND countries.country_iso_code IN ('GB', 'US')
 12  GROUP BY
 13  CUBE(channels.channel_desc, calendar_month_desc,
 14  countries.country_iso_code);

CHANNEL_DESC         CALENDAR CO SALES$
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

CHANNEL_DESC         CALENDAR CO SALES$
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

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297

27 rows selected.
*********************************************************
----------------------------------------QUERY-3-----------------------------------------------
/*Q3. Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000
*/

QUERY 3:
SQL> SELECT channels.channel_desc ,
  2  countries.country_iso_code,
  3  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4  FROM sales, customers, times, channels, countries
  5  WHERE sales.time_id*times.time_id
  6  AND sales.cust_id*customers.cust_id
  7  AND customers.country_id * countries.country_id
  8  AND sales.channel_id * channels.channel_id
  9  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10  AND times.calendar_month_desc IN ('2000-09')
 11  AND countries.country_iso_code IN ('FR', 'US')
 12  GROUP BY CUBE(channels.channel_desc,
 13  countries.country_iso_code);

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

***************************************************************

----------------------------------------QUERY-4-----------------------------------------------
/*Q4. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using PARTIAL
ROLL-UP. The query should return the following:
? Regular aggregation rows that would be produced by GROUP BY without
using ROLLUP.
? First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month_desc.
? Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
? It does not produce a grand total row.
*/

QUERY 4 :
SQL> SELECT channels.channel_desc, calendar_month_desc,
  2  countries.country_iso_code,
  3  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4  FROM sales, customers, times, channels, countries
  5  WHERE sales.time_id*times.time_id
  6  AND sales.cust_id*customers.cust_id
  7  AND customers.country_id * countries.country_id
  8  AND sales.channel_id * channels.channel_id
  9  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10  AND times.calendar_month_desc IN ('2000-09', '2000-10')
 11  AND countries.country_iso_code IN ('GB', 'US')
 12  GROUP BY
 13  channels.channel_desc , ROLLUP(calendar_month_desc,
 14  countries.country_iso_code);

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

14 rows selected.

********************************************************************
----------------------------------------QUERY-5-----------------------------------------------
/*Q5. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc.
*/

QUERY 5

SQL> SELECT channels.channel_desc, calendar_month_desc,
  2  countries.country_iso_code,
  3  TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4  FROM sales, customers, times, channels, countries
  5  WHERE sales.time_id*times.time_id
  6  AND sales.cust_id*customers.cust_id
  7  AND customers.country_id * countries.country_id
  8  AND sales.channel_id * channels.channel_id
  9  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10  AND times.calendar_month_desc IN ('2000-09', '2000-10')
 11  AND countries.country_iso_code IN ('GB', 'US')
 12  GROUP BY
 13  channels.channel_desc , CUBE(calendar_month_desc,
 14   countries.country_iso_code);

CHANNEL_DESC         CALENDAR CO SALES$
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

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales                  US      1,320,497
Direct Sales         2000-09            723,424
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297
18 ROWS SELECTED.
*********************************************************

----------------------------------------QUERY-6-----------------------------------------------
/*Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
? Create grouping on channel_desc and name it as CH
? Create grouping calendar_month_desc and name it as MO
? Create grouping on country_iso_code and name it as CO
*/

QUERY 6 :
SQL> SELECT channels.channel_desc, calendar_month_desc,
  2      countries.country_iso_code,
  3      TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ ,
  4  GROUPING(channels.channel_desc) AS CH,
  5  GROUPING(calendar_month_desc) AS MO,
  6     GROUPING(countries.country_iso_code) AS CO
  7      FROM sales, customers, times, channels, countries
  8      WHERE sales.time_id*times.time_id
  9      AND sales.cust_id*customers.cust_id
 10      AND customers.country_id * countries.country_id
 11      AND sales.channel_id * channels.channel_id
 12      AND channels.channel_desc IN ('Direct Sales', 'Internet')
 13     AND times.calendar_month_desc IN ('2000-09', '2000-10')
 14     AND countries.country_iso_code IN ('GB', 'US')
 15     GROUP BY
 16     ROLLUP(channels.channel_desc, calendar_month_desc,
 17     countries.country_iso_code);

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

*******************************************************************

QUERY 7:
SQL> SELECT channels.channel_desc, calendar_month_desc,
  2      countries.country_iso_code,
  3      TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4      FROM sales, customers, times, channels, countries
  5      WHERE sales.time_id*times.time_id
  6      AND sales.cust_id*customers.cust_id
  7      AND customers.country_id * countries.country_id
  8      AND sales.channel_id * channels.channel_id
  9      AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10     AND times.calendar_month_desc IN ('2000-09', '2000-10')
 11     AND countries.country_iso_code IN ('GB', 'US')
 12     GROUP BY
 13  GROUPING SETS((channels.channel_desc, calendar_month_desc, countries.country_iso_code),
 14      (channels.channel_desc,
 15     countries.country_iso_code),(calendar_month_desc,
 16     countries.country_iso_code));

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

*******************************************************

----------------------------------------QUERY-7-----------------------------------------------
/*Q7. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using GROUPING
SETS.
Calculate aggregates over three groupings:
? (channel_desc, calendar_month_desc, country_iso_code)
? (channel_desc, country_iso_code)
? (calendar_month_desc, country_iso_code)
*/
QUERY 7:
SQL> SELECT channels.channel_desc, calendar_month_desc,
  2      countries.country_iso_code,
  3      TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
  4      FROM sales, customers, times, channels, countries
  5      WHERE sales.time_id*times.time_id
  6      AND sales.cust_id*customers.cust_id
  7      AND customers.country_id * countries.country_id
  8      AND sales.channel_id * channels.channel_id
  9      AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10     AND times.calendar_month_desc IN ('2000-09', '2000-10')
 11     AND countries.country_iso_code IN ('GB', 'US')
 12     GROUP BY
 13  GROUPING SETS((channels.channel_desc, calendar_month_desc, countries.country_iso_code),
 14      (channels.channel_desc,
 15     countries.country_iso_code),(calendar_month_desc,
 16     countries.country_iso_code));

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

*****************************************************

----------------------------------------QUERY-8-----------------------------------------------
/*Q:8 Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.
*/
QUERY 8:
SQL> SELECT   TIMES.CALENDAR_MONTH_DESC , TIMES.CALENDAR_QUARTER_DESC , TIMES.CALENDAR_YEAR ,SUM(amount_sold)
  2  FROM SALES , TIMES , CHANNELS , COUNTRIES , CUSTOMERS
  3  WHERE sales.time_id*times.time_id
  4  AND CHANNELS.CHANNEL_ID * SALES.CHANNEL_ID
  5  AND CUSTOMERS.CUST_ID * SALES.CUST_ID
  6  AND customers.country_id * countries.country_id
  7  AND TIMES.CALENDAR_YEAR * 1999
  8  AND countries.country_iso_code IN ('GB', 'US')
  9  AND channels.channel_desc IN ('Direct Sales', 'Internet')
 10  GROUP BY ROLLUP(TIMES.CALENDAR_YEAR , TIMES.CALENDAR_QUARTER_DESC , TIMES.calendar_month_DESC);

CALENDAR CALENDA CALENDAR_YEAR SUM(AMOUNT_SOLD)
-------- ------- ------------- ----------------
1999-01  1999-01          1999        974627.95
1999-02  1999-01          1999       1089255.92
1999-03  1999-01          1999         754026.7
         1999-01          1999       2817910.57
1999-04  1999-02          1999        708060.57
1999-05  1999-02          1999        818055.52
1999-06  1999-02          1999        729677.52
         1999-02          1999       2255793.61
1999-07  1999-03          1999        893452.47
1999-08  1999-03          1999        883460.92
1999-09  1999-03          1999        923577.01

CALENDAR CALENDA CALENDAR_YEAR SUM(AMOUNT_SOLD)
-------- ------- ------------- ----------------
         1999-03          1999        2700490.4
1999-10  1999-04          1999        715831.36
1999-11  1999-04          1999        742248.42
1999-12  1999-04          1999        841572.17
         1999-04          1999       2299651.95
                          1999       10073846.5
                                     10073846.5

18 rows selected.

***********************************************************
----------------------------------------QUERY-9-----------------------------------------------
/*Q:9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/ 
QUERY 9:

SQL> SELECT  CHANNELS.CHANNEL_TOTAL ,CHANNELS.CHANNEL_CLASS,COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE ,SUM(amount_sold)
  2  FROM SALES , TIMES , CHANNELS , COUNTRIES , CUSTOMERS
  3  WHERE sales.time_id*times.time_id
  4  AND CHANNELS.CHANNEL_ID * SALES.CHANNEL_ID
  5  AND CUSTOMERS.CUST_ID * SALES.CUST_ID
  6  AND customers.country_id * countries.country_id
  7  AND TIMES.CALENDAR_MONTH_DESC IN ('2001-09', '2001-10')
  8  AND countries.country_iso_code IN ('GB', 'US')
  9  GROUP BY ROLLUP(CHANNELS.CHANNEL_TOTAL ,CHANNELS.CHANNEL_CLASS),ROLLUP(COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE);

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM(AMOUNT_SOLD)
------------- -------------------- -------------------- -- ----------------
                                   Europe               GB        321244.43
                                   Europe                         321244.43
                                   Americas             US       2603472.57
                                   Americas                      2603472.57
                                                                    2924717
Channel total                      Europe               GB        321244.43
Channel total                      Europe                         321244.43
Channel total                      Americas             US       2603472.57
Channel total                      Americas                      2603472.57
Channel total                                                       2924717
Channel total Direct               Europe               GB        168161.48

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM(AMOUNT_SOLD)
------------- -------------------- -------------------- -- ----------------
Channel total Direct               Europe                         168161.48
Channel total Direct               Americas             US       1187917.74
Channel total Direct               Americas                      1187917.74
Channel total Direct                                             1356079.22
Channel total Others               Europe               GB         77265.46
Channel total Others               Europe                          77265.46
Channel total Others               Americas             US        729606.32
Channel total Others               Americas                       729606.32
Channel total Others                                              806871.78
Channel total Indirect             Europe               GB         75817.49
Channel total Indirect             Europe                          75817.49

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM(AMOUNT_SOLD)
------------- -------------------- -------------------- -- ----------------
Channel total Indirect             Americas             US        685948.51
Channel total Indirect             Americas                       685948.51
Channel total Indirect                                               761766

25 rows selected.

************************************************************************
----------------------------------------QUERY-11-----------------------------------------------
/*Q11. Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October 2000.
*/

SELECT channels.channel_desc, countries.country_name, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id*times.time_id 
AND sales.cust_id*customers.cust_id 
AND customers.country_id * countries.country_id 
AND sales.channel_id * channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10') 
AND countries.country_iso_code IN ('GB', 'US')
AND countries.country_name LIKE 'U%' 
GROUP BY 
ROLLUP(channels.channel_desc, calendar_month_desc, countries.country_name);

CHANNEL_DESC         COUNTRY_NAME                             SALES$
-------------------- ---------------------------------------- --------------
Internet             United Kingdom                                   16,569
Internet             United States of America                        124,224
Internet                                                             140,793
Internet             United Kingdom                                   14,539
Internet             United States of America                        137,054
Internet                                                             151,593
Internet                                                             292,387
Direct Sales         United Kingdom                                   85,223
Direct Sales         United States of America                        638,201
Direct Sales                                                         723,424
Direct Sales         United Kingdom                                   91,925

CHANNEL_DESC         COUNTRY_NAME                             SALES$
-------------------- ---------------------------------------- --------------
Direct Sales         United States of America                        682,297
Direct Sales                                                         774,222
Direct Sales                                                       1,497,646
                                                                   1,790,032

15 rows selected.

SELECT channels.channel_desc, countries.country_name,GROUP_ID(),
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id*times.time_id 
AND sales.cust_id*customers.cust_id 
AND customers.country_id * countries.country_id 
AND sales.channel_id * channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10') 
AND countries.country_iso_code IN ('GB', 'US')
AND countries.country_name LIKE 'U%' 
GROUP BY 
ROLLUP((channels.channel_desc, calendar_month_desc, countries.country_name),
(channels.channel_desc, calendar_month_desc, countries.country_name),
(channels.channel_desc, calendar_month_desc, countries.country_name),
(channels.channel_desc, calendar_month_desc, countries.country_name))
ORDER BY GROUP_ID();

CHANNEL_DESC         COUNTRY_NAME                             GROUP_ID() SALES$
-------------------- ---------------------------------------- ---------- --------------
Internet             United Kingdom                                    0         16,569
Internet             United States of America                          0        124,224
Internet             United Kingdom                                    0         14,539
Internet             United States of America                          0        137,054
                                                                       0      1,790,032
Direct Sales         United States of America                          0        638,201
Direct Sales         United Kingdom                                    0         91,925
Direct Sales         United States of America                          0        682,297
Direct Sales         United Kingdom                                    0         85,223
Direct Sales         United States of America                          1        682,297
Direct Sales         United Kingdom                                    1         91,925

CHANNEL_DESC         COUNTRY_NAME                             GROUP_ID() SALES$
-------------------- ---------------------------------------- ---------- --------------
Direct Sales         United States of America                          1        638,201
Direct Sales         United Kingdom                                    1         85,223
Internet             United States of America                          1        137,054
Internet             United Kingdom                                    1         14,539
Internet             United States of America                          1        124,224
Internet             United Kingdom                                    1         16,569
Direct Sales         United States of America                          2        682,297
Direct Sales         United Kingdom                                    2         91,925
Direct Sales         United States of America                          2        638,201
Direct Sales         United Kingdom                                    2         85,223
Internet             United States of America                          2        137,054

CHANNEL_DESC         COUNTRY_NAME                             GROUP_ID() SALES$
-------------------- ---------------------------------------- ---------- --------------
Internet             United Kingdom                                    2         14,539
Internet             United Kingdom                                    2         16,569
Internet             United States of America                          2        124,224
Internet             United Kingdom                                    3         14,539
Internet             United States of America                          3        137,054
Direct Sales         United Kingdom                                    3         85,223
Direct Sales         United States of America                          3        638,201
Direct Sales         United Kingdom                                    3         91,925
Direct Sales         United States of America                          3        682,297
Internet             United States of America                          3        124,224
Internet             United Kingdom                                    3         16,569

33 rows selected.