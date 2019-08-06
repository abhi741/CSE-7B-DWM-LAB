Q1. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:


SELECT channels.channel_desc,
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
ROLLUP(channels.channel_desc, 
countries.country_iso_code);

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Internet             GB         31,109
Internet             US        261,278
Internet                       292,387
Direct Sales         GB        177,148
Direct Sales         US      1,320,497
Direct Sales                 1,497,646
                             1,790,032

7 rows selected.

Q2 : Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using
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
countries.country_iso_code);


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
CUBE(channels.channel_desc, 
countries.country_iso_code);

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
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
countries.country_iso_code,ROLLUP( calendar_month_desc,channels.channel_desc
);


CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  GB         16,569
Direct Sales         2000-09  GB         85,223
                     2000-09  GB        101,792
Internet             2000-10  GB         14,539
Direct Sales         2000-10  GB         91,925
                     2000-10  GB        106,465
                              GB        208,257
Internet             2000-09  US        124,224
Direct Sales         2000-09  US        638,201
                     2000-09  US        762,425
Internet             2000-10  US        137,054

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-10  US        682,297
                     2000-10  US        819,351
                              US      1,581,775

14 rows selected.


Q5. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
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
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
channels.channel_desc,CUBE( calendar_month_desc,countries.country_iso_code
);


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

18 rows selected.


Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO

SELECT channels.channel_desc,calendar_month_desc,
countries.country_iso_code,
GROUPING(CHANNELS.CHANNEL_DESC) CH,
GROUPING(CALENDAR_MONTH_DESC) MO,
GROUPING(countries.country_iso_code) CO
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(
channels.channel_desc, calendar_month_desc,countries.country_iso_code
);

CHANNEL_DESC         CALENDAR CO         CH         MO         CO
-------------------- -------- -- ---------- ---------- ----------
Internet             2000-09  GB          0          0          0
Internet             2000-09  US          0          0          0
Internet             2000-09              0          0          1
Internet             2000-10  GB          0          0          0
Internet             2000-10  US          0          0          0
Internet             2000-10              0          0          1
Internet                                  0          1          1
Direct Sales         2000-09  GB          0          0          0
Direct Sales         2000-09  US          0          0          0
Direct Sales         2000-09              0          0          1
Direct Sales         2000-10  GB          0          0          0

CHANNEL_DESC         CALENDAR CO         CH         MO         CO
-------------------- -------- -- ---------- ---------- ----------
Direct Sales         2000-10  US          0          0          0
Direct Sales         2000-10              0          0          1
Direct Sales                              0          1          1
                                          1          1          1

15 rows selected.

Q7. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using GROUPING
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
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
GROUPING SETS(
(channels.channel_desc, calendar_month_desc,countries.country_iso_code),(CHANNELS.channel_desc, country_iso_code),(calendar_month_desc, countries.country_iso_code)
);


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
                     2000-10  US        819,351
Direct Sales                  GB        177,148
Internet                      GB         31,109
Direct Sales                  US      1,320,497
Internet                      US        261,278

16 rows selected.

Q: 8 Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.

SELECT times.calendar_year "YEAR", times.calendar_quarter_desc "QUARTER",times.calendar_month_desc "MONTH",
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
and times.calendar_year in ('1999')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(times.calendar_year, times.calendar_quarter_desc,times.calendar_month_desc);

CALENDAR CALENDAR_YEAR CALENDA SALES$
-------- ------------- ------- --------------
1999-01           1999 1999-01        974,628
1999-02           1999 1999-01      1,089,256
1999-03           1999 1999-01        754,027
                  1999 1999-01      2,817,911
1999-04           1999 1999-02        708,061
1999-05           1999 1999-02        818,056
1999-06           1999 1999-02        729,678
                  1999 1999-02      2,255,794
1999-07           1999 1999-03        893,452
1999-08           1999 1999-03        883,461
1999-09           1999 1999-03        923,577
                  1999 1999-03      2,700,490
1999-10           1999 1999-04        715,831
1999-11           1999 1999-04        742,248
1999-12           1999 1999-04        841,572
                  1999 1999-04      2,299,652
                  1999             10,073,847
                                   10,073,847

18 rows selected.

Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)

SELECT channels.channel_total, channels.channel_class, countries.country_region , countries.country_iso_code,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
and times.calendar_year in ('1999')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(channels.channel_total, channels.channel_class),ROLLUP(countries.country_region , countries.country_iso_code);

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
                                   Europe               GB      1,508,110
                                   Europe                       1,508,110
                                   Americas             US     11,856,749
                                   Americas                    11,856,749
                                                               13,364,860
Channel total                      Europe               GB      1,508,110
Channel total                      Europe                       1,508,110
Channel total                      Americas             US     11,856,749
Channel total                      Americas                    11,856,749
Channel total                                                  13,364,860
Channel total Direct               Europe               GB      1,090,880
Channel total Direct               Europe                       1,090,880
Channel total Direct               Americas             US      7,560,567
Channel total Direct               Americas                     7,560,567
Channel total Direct                                            8,651,447
Channel total Others               Europe               GB        321,301
Channel total Others               Europe                         321,301
Channel total Others               Americas             US      2,969,712
Channel total Others               Americas                     2,969,712
Channel total Others                                            3,291,013
Channel total Indirect             Europe               GB         95,929
Channel total Indirect             Europe                          95,929
Channel total Indirect             Americas             US      1,326,471
Channel total Indirect             Americas                     1,326,471
Channel total Indirect                                          1,422,400

25 rows selected.

Q10 : Consider the following Query and make conclusion from the result obtained.
Query: (scott Schema)

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY CUBE(deptno, job)


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



Q11. Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October.


SELECT  channels.channel_desc,countries.country_name,calendar_month_desc,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_name like 'U%'
GROUP BY
ROLLUP(countries.country_name,channels.channel_desc,calendar_month_desc);


CHANNEL_DESC         COUNTRY_NAME                             CALENDAR SALES$
-------------------- ---------------------------------------- -------- --------------
Internet             United Kingdom                           2000-09          16,569
Internet             United Kingdom                           2000-10          14,539
Internet             United Kingdom                                            31,109
Direct Sales         United Kingdom                           2000-09          85,223
Direct Sales         United Kingdom                           2000-10          91,925
Direct Sales         United Kingdom                                           177,148
                     United Kingdom                                           208,257
Internet             United States of America                 2000-09         124,224
Internet             United States of America                 2000-10         137,054
Internet             United States of America                                 261,278
Direct Sales         United States of America                 2000-09         638,201
Direct Sales         United States of America                 2000-10         682,297
Direct Sales         United States of America                               1,320,497
                     United States of America                               1,581,775
                                                                            1,790,032

15 rows selected.
