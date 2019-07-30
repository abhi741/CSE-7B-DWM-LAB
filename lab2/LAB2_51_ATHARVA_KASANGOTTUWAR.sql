/*QUERY 1*/

/*Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.*/
 
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


/*QUERY 2*/

/*Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
countries.country_iso_code.*/

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

/*QUERY 3*/

/*Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000*/

SELECT channels.channel_desc,
countries.country_iso_code,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc = '2000-09'
AND countries.country_iso_code IN ('US', 'FR')
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

/*QUERY 4*/

/*Q4. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
ROLL-UP. The query should return the following:
* Regular aggregation rows that would be produced by GROUP BY without
using ROLLUP.
* First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month_desc.
* Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
* It does not produce a grand total row.*/

SELECT channels.channel_desc,calendar_month_desc,
countries.country_iso_code,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc  IN ('2000-09', '2000-10')
AND countries.country_iso_code IN ('US', 'GB')
GROUP BY channel_desc,
ROLLUP(calendar_month_desc,countries.country_iso_code);

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


/*QUERY 5*/

/*Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc.*/

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
GROUP BY channels.channel_desc, 
CUBE(calendar_month_desc,
countries.country_iso_code);

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


/*QUERY 6*/

/*Use GROUPING to create a set of mask columns for the result set of Q1.
* Create grouping on channel_desc and name it as CH
* Create grouping calendar_month_desc and name it as MO
* Create grouping on country_iso_code and name it as CO*/

SELECT channels.channel_desc, calendar_month_desc,
countries.country_iso_code,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
grouping(channel_desc) as CH,
grouping(calendar_month_desc) as MO,
grouping(countries.country_iso_code) as CO
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

/*QUERY 7*/

/*Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using GROUPING
SETS.
Calculate aggregates over three groupings:
* (channel_desc, calendar_month_desc, country_iso_code)
* (channel_desc, country_iso_code)
* (calendar_month_desc, country_iso_code)*/

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
grouping sets((channels.channel_desc, calendar_month_desc, countries.country_iso_code)
,(channels.channel_desc, countries.country_iso_code)
,(calendar_month_desc, countries.country_iso_code));

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


/*QUERY 8*/

/*Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.*/

SELECT  times.calendar_month_desc as MONTHS,
		times.calendar_quarter_desc as QUARTER,
		times.calendar_year as YEARS, 
		TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
		FROM sales,times,channels,countries,customers
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND times.calendar_year = 1999
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND countries.country_iso_code IN ('GB', 'US')
		GROUP BY ROLLUP(times.calendar_year,times.calendar_quarter_desc,times.calendar_month_desc);
		
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

/*QUERY 9*/	

/*Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)*/
		
SELECT channels.channel_total, channels.channel_class,
countries.country_iso_code,countries.country_region,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND times.calendar_month_desc IN ('2001-09', '2001-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
	ROLLUP(channel_total, channel_class),ROLLUP(country_region , country_iso_code);

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
	
/*QUERY 10*/

/*Consider the following Query and make conclusion from the result obtained.
Query: (scott Schema)
SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY CUBE(deptno, job)*/

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

/*QUERY 11*/

/*Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October.*/

SELECT channels.channel_desc, countries.country_name, 
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

/*QUERY 12*/

SELECT channels.channel_desc,times.calendar_month_desc,countries.country_iso_code,
SUM(s.amount_sold) sum_amount_sold,
GROUPING_ID(channels.channel_desc,times.calendar_month_desc,countries.country_iso_code) grouping_id
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customer.cust_id 
	AND customer.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2001-09', '2001-10') 
	AND	countries.country_iso_code IN ('GB', 'US')
	GROUP BY
	ROLLUP(channels.channel_desc,times.calendar_month_desc,countries.country_iso_code),
	ROLLUP(channels.channel_desc,times.calendar_month_desc,countries.country_iso_code)
	ORDER BY (grouping_id);
	
CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  GB        36806.73           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0
Direct Sales         2001-10  US        566719.8           0
Internet             2001-09  GB        36806.73           0
Internet             2001-09  US       299621.96           0
Internet             2001-10  GB        39010.76           0
Internet             2001-10  US       386326.55           0
Direct Sales         2001-09  GB        92865.04           0
Direct Sales         2001-09  US       621197.94           0
Direct Sales         2001-10  GB        75296.44           0

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Internet             2001-09  US       299621.96           0
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet             2001-10           425337.31           1
Direct Sales         2001-10           642016.24           1
Direct Sales         2001-09           714062.98           1
Internet             2001-09           336428.69           1
Internet                                  761766           3

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales                          1356079.22           3
Internet                                  761766           3
Direct Sales                          1356079.22           3
Internet                                  761766           3
Direct Sales                          1356079.22           3
                                      2117845.22           7

83 rows selected.	