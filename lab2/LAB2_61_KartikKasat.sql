                                         *******PRACTICAL 2*********
										 
==================================================================================										 
Q1.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales
 in September 2000 and October 2000 using ROLL-UP Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.

QUERY:-

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

==========================================================================================
Q2.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales 
in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc, countries.country_iso_code.

QUERY:-


SELECT channels.channel_desc, calendar_month_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2009-10') 
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY 
CUBE(channels.channel_desc, calendar_month_desc, countries.country_iso_code); 

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
                                        864,217
                              GB        101,792
                              US        762,425
                     2000-09            864,217
                     2000-09  GB        101,792
                     2000-09  US        762,425
Internet                                140,793
Internet                      GB         16,569
Internet                      US        124,224
Internet             2000-09            140,793
Internet             2000-09  GB         16,569

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  US        124,224
Direct Sales                            723,424
Direct Sales                  GB         85,223
Direct Sales                  US        638,201
Direct Sales         2000-09            723,424
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201

18 rows selected.

=====================================================================
Q3.Find the total sales by country_iso and channel_desc for the US and France through the Internet and 
direct sales in September 2000

QUERY:-


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
CUBE(channels.channel_desc, countries.country_iso_code); 

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

=============================================================================
Q4.Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales 
in September 2000 and October 2009 using PARTIAL ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
 First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.

QUERY:-

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
GROUP BY channel_desc,
ROLLUP(calendar_month_desc, countries.country_iso_code);

CHANNEL_DESC         CO SALES$
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

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Direct Sales         US        682,297
Direct Sales                   774,222
Direct Sales                 1,497,646

14 rows selected.

===================================================================
Q5.Find the total sales by country_id and channel_desc for the US and GB through the Internet
 and direct sales in September 2000 and October 2009 using PARTIAL CUBE aggregation on month 
 and country code and GROUP BY on channel_desc.
 
 QUERY:-
 
 
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
GROUP BY channel_desc,
CUBE(calendar_month_desc, countries.country_iso_code);

CHANNEL_DESC         CO SALES$
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

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Direct Sales         US      1,320,497
Direct Sales                   723,424
Direct Sales         GB         85,223
Direct Sales         US        638,201
Direct Sales                   774,222
Direct Sales         GB         91,925
Direct Sales         US        682,297

18 rows selected.

=============================================================
Q6.Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO

QUERY:-


SELECT channels.channel_desc, calendar_month_desc, 
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
GROUPING(channel_desc) as CH,
GROUPING(calendar_month_desc) as MO,
GROUPING(country_iso_code) as CO
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

===================================================================================================
Q7.Find the total sales by country_id and channel_desc for the US and GB through the Internet and
 direct sales in September 2000 and October 2009 using GROUPING SETS.
 Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)
 
 QUERY:-

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, channels, countries, customers, times
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09','2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY 
grouping sets((channels.channel_desc, calendar_month_desc, countries.country_iso_code),
(channels.channel_desc, countries.country_iso_code),
(calendar_month_desc, countries.country_iso_code));
	
CO CALENDAR CHANNEL_DESC         SALES$
-- -------- -------------------- --------------
GB 2000-09  Internet                     16,569
GB 2000-09  Direct Sales                 85,223
US 2000-09  Internet                    124,224
US 2000-09  Direct Sales                638,201
GB 2000-10  Internet                     14,539
GB 2000-10  Direct Sales                 91,925
US 2000-10  Internet                    137,054
US 2000-10  Direct Sales                682,297
GB 2000-09                              101,792
US 2000-09                              762,425
GB 2000-10                              106,465

CO CALENDAR CHANNEL_DESC         SALES$
-- -------- -------------------- --------------
US 2000-10                              819,351
GB          Direct Sales                177,148
GB          Internet                     31,109
US          Direct Sales              1,320,497
US          Internet                    261,278

16 rows selected.

================================================================================================
Q8.Perform aggregation on amount sold. It should get aggregated by month first, then by all the
 months in each quarter, and then across all months and quarters in the year.

QUERY:-


SELECT times.calendar_month_desc as MONTH, times.calendar_quarter_desc as QUARTER, times.calendar_year as YEAR, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id = times.time_id
	AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND countries.country_iso_code IN ('GB', 'US')
	AND times.calendar_year = 1999
	GROUP BY
	ROLLUP(times.calendar_year, times.calendar_quarter_desc, times.calendar_month_desc);	
	
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

=================================================================================================
Q9.Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)

QUERY:-

SELECT channels.channel_total,  
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
ROLLUP(channels.channel_total,channels.channel_class),
ROLLUP(countries.country_region,countries.country_iso_code);

CHANNEL_TOTAL CO SALES$
------------- -- --------------
              GB        208,257
                        208,257
              US      1,581,775
                      1,581,775
                      1,790,032
Channel total GB        208,257
Channel total           208,257
Channel total US      1,581,775
Channel total         1,581,775
Channel total         1,790,032
Channel total GB        177,148

CHANNEL_TOTAL CO SALES$
------------- -- --------------
Channel total           177,148
Channel total US      1,320,497
Channel total         1,320,497
Channel total         1,497,646
Channel total GB         31,109
Channel total            31,109
Channel total US        261,278
Channel total           261,278
Channel total           292,387

20 rows selected.
===============================================================================================
Q10.Consider the following Query and make conclusion from the result obtained.
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


================================================================================================
Q11.Find the total sales by country name and channel_desc for the country name starting from U 
through the Internet and direct sales in September 2000 and October.

QUERY:-


SELECT channels.channel_desc,countries.country_name, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10') 
AND countries.country_iso_code IN ('GB', 'US') 
AND countries.country_name LIKE 'U%'
GROUP BY 
ROLLUP(channels.channel_desc , countries.country_name); 

CHANNEL_DESC         COUNTRY_NAME                             SALES$
-------------------- ---------------------------------------- --------------
Internet             United Kingdom                                   31,109
Internet             United States of America                        261,278
Internet                                                             292,387
Direct Sales         United Kingdom                                  177,148
Direct Sales         United States of America                      1,320,497
Direct Sales                                                       1,497,646
                                                                   1,790,032

7 rows selected.


================================================================================================
Q12.

SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code, co.country_name ,
SUM(s.amount_sold) sum_amount_sold, 
GROUPING_ID( ch.channel_desc, t.calendar_month_desc, co.country_iso_code, co.country_name) AS redu
FROM sales s, customers cu, times t, channels ch, countries co 
WHERE   s.time_id=t.time_id 
AND s.cust_id=cu.cust_id 
AND cu.country_id = co.country_id 
AND s.channel_id = ch.channel_id 
AND ch.channel_desc IN ('Direct Sales', 'Internet') 
AND t.calendar_month_desc IN ('2001-09', '2001-10') 
AND co.country_iso_code IN ('GB', 'US') 
GROUP BY ROLLUP( co.country_name), ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code, co.country_name)
order by group_id(); 

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Internet        2001-09     United Kingdom         36806.73          2
Internet        2001-10     United Kingdom         39010.76          2
Direct Sales    2001-10  US United States o       566719.80          0
                            f America

Direct Sales    2001-10  GB United Kingdom         75296.44          0
Direct Sales    2001-09  US United States o       621197.94          0
                            f America

Direct Sales    2001-09  GB United Kingdom         92865.04          0
Internet        2001-10  US United States o       386326.55          0

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
                            f America

Internet        2001-10  GB United Kingdom         39010.76          0
Internet        2001-09  US United States o       299621.96          0
                            f America

Internet        2001-09  GB United Kingdom         36806.73          0
                                                 ##########         15
Direct Sales                                     ##########          7
Direct Sales    2001-10  US                       566719.80          1
Direct Sales    2001-10  GB                        75296.44          1

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Direct Sales    2001-09  US                       621197.94          1
Direct Sales    2001-09  GB                        92865.04          1
Internet                                          761766.00          7
Internet                    United Kingdom         75817.49          6
Direct Sales    2001-09     United Kingdom         92865.04          2
Direct Sales    2001-10     United Kingdom         75296.44          2
Direct Sales                United Kingdom        168161.48          6
                            United Kingdom        243978.97         14
Internet        2001-09     United States o       299621.96          2
                            f America


CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Internet        2001-10     United States o       386326.55          2
                            f America

Internet                    United States o       685948.51          6
                            f America

Direct Sales    2001-09     United States o       621197.94          2
                            f America

Direct Sales    2001-10     United States o       566719.80          2
                            f America

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------

Direct Sales                United States o      ##########          6
                            f America

                            United States o      ##########         14
                            f America

Internet        2001-09                           336428.69          3
Internet        2001-10                           425337.31          3
Direct Sales    2001-09                           714062.98          3
Direct Sales    2001-10                           642016.24          3

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Internet        2001-09  GB                        36806.73          1
Internet        2001-09  US                       299621.96          1
Internet        2001-10  GB                        39010.76          1
Internet        2001-10  US                       386326.55          1
Internet        2001-09  US United States o       299621.96          0
                            f America

Direct Sales    2001-10  US United States o       566719.80          0
                            f America

Internet        2001-09  GB United Kingdom         36806.73          0

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Internet        2001-10  GB United Kingdom         39010.76          0
Internet        2001-10  US United States o       386326.55          0
                            f America

Direct Sales    2001-09  GB United Kingdom         92865.04          0
Direct Sales    2001-09  US United States o       621197.94          0
                            f America

Direct Sales    2001-10  GB United Kingdom         75296.44          0
Internet        2001-09  US United States o       299621.96          0
                            f America

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------

Internet        2001-09  GB United Kingdom         36806.73          0
Internet        2001-10  GB United Kingdom         39010.76          0
Internet        2001-10  US United States o       386326.55          0
                            f America

Direct Sales    2001-09  GB United Kingdom         92865.04          0
Direct Sales    2001-09  US United States o       621197.94          0
                            f America

Direct Sales    2001-10  GB United Kingdom         75296.44          0

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME    SUM_AMOUNT_SOLD       REDU
--------------- -------- -- --------------- --------------- ----------
Direct Sales    2001-10  US United States o       566719.80          0
                            f America


53 rows selected.


==============================================================================xxxxxxxx==============================================================================