/*
Name    : Snehal Nerkar 
Roll No : CSE 7B - 17
Pract no: 2
*/
-- -------------------------------------------------------------------------------------------
Aim: Write and Execute SQL aggregation queries for data warehouse.
-- -------------------------------------------------------------------------------------------

/*QUERY NO. 1 :Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following: */

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
-- -------------------------------------------------------------------------------------------
/* QUERY NO. 2 : Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
countries.country_iso_code. */

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

/*
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
-- -------------------------------------------------------------------------------------------
/* QUERY NO. 3 : Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000 */

SQL> SELECT CHANNELS.CHANNEL_DESC,
  2  COUNTRIES.COUNTRY_ISO_CODE,
  3  TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
  4  FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
  5  WHERE SALES.TIME_ID=TIMES.TIME_ID
  6  AND SALES.CUST_ID=CUSTOMERS.CUST_ID
  7  AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
  8  AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
  9  AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
 10  AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09')
 11  AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('FR', 'US')
 12  GROUP BY
 13  CUBE(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE);
/*
CHANNEL_DESC         CO TOTAL_SALES
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
*/

-- -------------------------------------------------------------------------------------------
/* QUERY NO. 4 : Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000 */

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
/*
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
Direct Sales         US 2000-10         682,297
Direct Sales         US               1,320,497
Direct Sales                          1,497,646

14 rows selected.
*/

-- -------------------------------------------------------------------------------------------
/* QUERY NO. 5 : . Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc. */

SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY  channel_desc, CUBE (calendar_month_desc, countries.country_iso_code);
/*
CO CALENDAR CHANNEL_DESC         SALES$
-- -------- -------------------- --------------
            Internet                    292,387
GB          Internet                     31,109
US          Internet                    261,278
   2000-09  Internet                    140,793
GB 2000-09  Internet                     16,569
US 2000-09  Internet                    124,224
   2000-10  Internet                    151,593
GB 2000-10  Internet                     14,539
US 2000-10  Internet                    137,054
            Direct Sales              1,497,646
GB          Direct Sales                177,148
US          Direct Sales              1,320,497
   2000-09  Direct Sales                723,424
GB 2000-09  Direct Sales                 85,223
US 2000-09  Direct Sales                638,201
   2000-10  Direct Sales                774,222
GB 2000-10  Direct Sales                 91,925
US 2000-10  Direct Sales                682,297

18 rows selected.
*/

-- -------------------------------------------------------------------------------------------
/* QUERY NO. 6 : Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO 

1 1 1 ->APEX
0 0 0 0 -> BASE */

SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	GROUPING(CHANNELS.CHANNEL_DESC) CH,
	GROUPING(CALENDAR_MONTH_DESC) MO,
	GROUPING(COUNTRIES.COUNTRY_ISO_CODE)
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
/*
CO CALENDAR CHANNEL_DESC         SALES$                 CH         MO         CO
-- -------- -------------------- -------------- ---------- ---------- ----------
GB 2000-09  Internet                     16,569          0          0          0
US 2000-09  Internet                    124,224          0          0          0
   2000-09  Internet                    140,793          0          0          1
GB 2000-10  Internet                     14,539          0          0          0
US 2000-10  Internet                    137,054          0          0          0
   2000-10  Internet                    151,593          0          0          1
            Internet                    292,387          0          1          1
GB 2000-09  Direct Sales                 85,223          0          0          0
US 2000-09  Direct Sales                638,201          0          0          0
   2000-09  Direct Sales                723,424          0          0          1
GB 2000-10  Direct Sales                 91,925          0          0          0
US 2000-10  Direct Sales                682,297          0          0          0
   2000-10  Direct Sales                774,222          0          0          1
            Direct Sales              1,497,646          0          1          1
                                      1,790,032          1          1          1

15 rows selected.
*/

-- -------------------------------------------------------------------------------------------
/* QUERY NO. 7: Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using GROUPING
SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)
*/
SELECT countries.country_iso_code, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
	grouping(channels.channel_desc) as CH,
	grouping(calendar_month_desc) as MO,
	grouping(countries.country_iso_code) as CO
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
	
/*
CO CALENDAR CHANNEL_DESC         SALES$                 CH         MO         CO
-- -------- -------------------- -------------- ---------- ---------- ----------
GB 2000-09  Internet                     16,569          0          0          0
GB 2000-09  Direct Sales                 85,223          0          0          0
US 2000-09  Internet                    124,224          0          0          0
US 2000-09  Direct Sales                638,201          0          0          0
GB 2000-10  Internet                     14,539          0          0          0
GB 2000-10  Direct Sales                 91,925          0          0          0
US 2000-10  Internet                    137,054          0          0          0
US 2000-10  Direct Sales                682,297          0          0          0
GB 2000-09                              101,792          1          0          0
US 2000-09                              762,425          1          0          0
GB 2000-10                              106,465          1          0          0
US 2000-10                              819,351          1          0          0
GB          Direct Sales                177,148          0          1          0
GB          Internet                     31,109          0          1          0
US          Direct Sales              1,320,497          0          1          0
US          Internet                    261,278          0          1          0

16 rows selected.
*/

-- -------------------------------------------------------------------------------------------
/* QUERY NO. 8:  Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.
*/
 -- COUNRIES: US.GB. YEAR =1999, DIRECT SALES AND INTERNET 
SELECT TIMES.CALENDAR_MONTH_DESC,TIMES.CALENDAR_QUARTER_DESC, TIMES.CALENDAR_YEAR,
	SUM(AMOUNT_SOLD) TOTAL_SALES
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_YEAR=1999 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
			GROUP BY 
 				ROLLUP(TIMES.CALENDAR_YEAR,TIMES.CALENDAR_QUARTER_DESC,TIMES.CALENDAR_MONTH_DESC);
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
         1999-03          1999   2700490.4
1999-10  1999-04          1999   715831.36
1999-11  1999-04          1999   742248.42
1999-12  1999-04          1999   841572.17
         1999-04          1999  2299651.95
                          1999  10073846.5
                                10073846.5

18 rows selected.
*/
-- -------------------------------------------------------------------------------------------
/* QUERY NO. 9: Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code).
*/
 SELECT CHANNELS.CHANNEL_TOTAL,CHANNELS.CHANNEL_CLASS,COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE,
 SUM(AMOUNT_SOLD) 
 FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
 WHERE SALES.TIME_ID=TIMES.TIME_ID 
	AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
	AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
	AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
	AND TIMES.CALENDAR_MONTH_DESC IN ('2001-09','2001-10') 
	AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US') 
 GROUP BY 
	ROLLUP(CHANNELS.CHANNEL_TOTAL,CHANNELS.CHANNEL_CLASS),
	ROLLUP(COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE);
	/*
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
Channel total Indirect             Americas             US        685948.51
Channel total Indirect             Americas                       685948.51
Channel total Indirect                                               761766

25 rows selected.
	*/
	
-- -------------------------------------------------------------------------------------------
/* QUERY NO. 11:Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October.
*/
SELECT countries.country_name, calendar_month_desc,channels.channel_desc, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, channels, countries, customers, times
	WHERE sales.time_id=times.time_id
    AND sales.cust_id=customers.cust_id
    AND customers.country_id = countries.country_id
    AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
    AND times.calendar_month_desc IN ('2000-09','2000-10')
    AND countries.country_name LIKE 'U%'
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_name);
/*
COUNTRY_NAME                             CALENDAR CHANNEL_DESC         SALES$
---------------------------------------- -------- -------------------- --------------
United Kingdom                           2000-09  Internet                     16,569
United States of America                 2000-09  Internet                    124,224
                                         2000-09  Internet                    140,793
United Kingdom                           2000-10  Internet                     14,539
United States of America                 2000-10  Internet                    137,054
                                         2000-10  Internet                    151,593
                                                  Internet                    292,387
United Kingdom                           2000-09  Direct Sales                 85,223
United States of America                 2000-09  Direct Sales                638,201
                                         2000-09  Direct Sales                723,424
United Kingdom                           2000-10  Direct Sales                 91,925
United States of America                 2000-10  Direct Sales                682,297
                                         2000-10  Direct Sales                774,222
                                                  Direct Sales              1,497,646
                                                                            1,790,032

15 rows selected.
*/
-- -------------------------------------------------------------------------------------------
/* QUERY NO. 12: ANALYZE THE OUTPUT
  SELECT
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code,
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
co.country_iso_code);
*/
/*

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
Direct Sales         2001-10  US        566719.8           0
Direct Sales         2001-10           642016.24           1
Direct Sales                          1356079.22           3
                                      2117845.22           7

15 rows selected.
*/

--EXITING GROUP ID QUERY 12 MODIFICATION
SELECT
ch.channel_desc,t.calendar_month_desc,co.country_iso_code,
SUM(s.amount_sold) sum_amount_sold
FROM
sales s,customers cu,times t,channels ch,countries co
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
co.country_iso_code),
ROLLUP(
ch.channel_desc,
t.calendar_month_desc,
co.country_iso_code)
order by group_id();

/*
CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD
-------------------- -------- -- ---------------
Internet             2001-10           425337.31
Direct Sales         2001-10           642016.24
Direct Sales         2001-09           714062.98
Internet             2001-09           336428.69
Internet             2001-09  GB        36806.73
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Internet             2001-10  US       386326.55
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-10  GB        75296.44
Direct Sales         2001-10  US        566719.8
Internet                                  761766
Direct Sales                          1356079.22
                                      2117845.22
Internet                                  761766
Direct Sales                          1356079.22
Internet             2001-10           425337.31
Direct Sales         2001-10           642016.24
Direct Sales         2001-09           714062.98
Internet             2001-09           336428.69
Direct Sales         2001-10  US        566719.8
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Internet             2001-10  US       386326.55
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-10  GB        75296.44
Internet             2001-09  GB        36806.73
Internet                                  761766
Direct Sales                          1356079.22
Internet             2001-10           425337.31
Direct Sales         2001-10           642016.24
Direct Sales         2001-09           714062.98
Internet             2001-09           336428.69
Internet             2001-09  GB        36806.73
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Internet             2001-10  US       386326.55
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-10  GB        75296.44
Direct Sales         2001-10  US        566719.8
Internet             2001-09  GB        36806.73
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Direct Sales         2001-10  US        566719.8
Internet             2001-10           425337.31
Internet             2001-10  US       386326.55
Direct Sales         2001-09           714062.98
Internet             2001-09           336428.69
Direct Sales         2001-10  GB        75296.44
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-10           642016.24
Internet             2001-09           336428.69
Direct Sales         2001-09           714062.98
Internet             2001-10           425337.31
Direct Sales         2001-10           642016.24
Direct Sales         2001-10  US        566719.8
Direct Sales         2001-10  GB        75296.44
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-09  GB        92865.04
Internet             2001-10  US       386326.55
Internet             2001-10  GB        39010.76
Internet             2001-09  US       299621.96
Internet             2001-09  GB        36806.73
Direct Sales         2001-10  US        566719.8
Internet             2001-09  GB        36806.73
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Internet             2001-10  US       386326.55
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-10  GB        75296.44
Direct Sales         2001-10  US        566719.8
Internet             2001-09  US       299621.96
Internet             2001-10  GB        39010.76
Internet             2001-10  US       386326.55
Direct Sales         2001-09  GB        92865.04
Direct Sales         2001-09  US       621197.94
Direct Sales         2001-10  GB        75296.44
Internet             2001-09  GB        36806.73

83 rows selected.
*/
-- ------------------------------------------------------------------------------