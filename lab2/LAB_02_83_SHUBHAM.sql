
/*
Problem Statement: Write and Execute SQL aggregation queries for data warehouse. '
*/
/*
NAME:SHUBHAM REDDY
BATCH:B4 
ROLL NUMBER-83
*/

/*
Write the queries for the following:
Q1. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.
*/

Query:
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


Result:

CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Internet             GB         31,109
Internet             US        261,278
Internet                       292,387
Direct Sales         GB        177,148
Direct Sales         US      1,320,497
Direct Sales                 1,497,646
                             1,790,032
7

/*
Q2. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
countries.country_iso_code.
*/
Query:
select channels.channel_desc, calendar_month_desc, 
	countries.country_iso_code, 
	to_char(sum(amount_sold), '9,999,999,999') total_sales 
		from sales, customers, times, channels, countries 
			where sales.time_id=times.time_id 
				and sales.cust_id=customers.cust_id 
				and customers.country_id = countries.country_id 
				and sales.channel_id = channels.channel_id 
				and upper(channels.channel_desc) in ('DIRECT SALES', 'INTERNET') 
				and times.calendar_month_desc in ('2000-09', '2000-10') 
				and upper(countries.country_iso_code) in ('GB', 'US') 
		group by 
		cube(channels.channel_desc, calendar_month_desc, countries.country_iso_code)
		order by(channel_desc);
		
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

/*
Q3. Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000
*/

Query:
SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE, 
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09') 
				AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('FR', 'US') 
		GROUP BY 
		CUBE(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE);


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


/*
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
*/

Query:
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
		CHANNELS.CHANNEL_DESC,ROLLUP(COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);
		
		
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
		COUNTRIES.COUNTRY_ISO_CODE,ROLLUP(CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC);
		
		
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
		



/*
Q5. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc.
*/
Query:
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
		CHANNELS.CHANNEL_DESC,CUBE(COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);
		
		
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
		
/*
Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO
*/

Query:
SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
	GROUPING(CHANNELS.CHANNEL_DESC) CH,
	GROUPING(CALENDAR_MONTH_DESC) MO,
	GROUPING(COUNTRIES.COUNTRY_ISO_CODE) CO
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

8
/*Q7. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using GROUPING
SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)
*/
Query:
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
		GROUPING SETS((CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE),
			(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE),
				(CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE));


CHANNEL_DESC         CO CALENDAR TOTAL_SALES
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

CHANNEL_DESC         CO CALENDAR TOTAL_SALES
-------------------- -- -------- --------------
                     US 2000-10         819,351
Direct Sales         GB                 177,148
Internet             GB                  31,109
Direct Sales         US               1,320,497
Internet             US                 261,278

16 rows selected.

/*
Q: 8 Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.
*/
Query:
SELECT times.calendar_month_desc,times.calendar_quarter_desc,times.calendar_year,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_year='1999'
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(times.calendar_year,times.calendar_quarter_desc,times.calendar_month_desc);


CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
1999-01  1999-01          1999        974,628
1999-02  1999-01          1999      1,089,256
1999-03  1999-01          1999        754,027
         1999-01          1999      2,817,911
1999-04  1999-02          1999        708,061
1999-05  1999-02          1999        818,056
1999-06  1999-02          1999        729,678
         1999-02          1999      2,255,794
1999-07  1999-03          1999        893,452
1999-08  1999-03          1999        883,461
1999-09  1999-03          1999        923,577

CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
         1999-03          1999      2,700,490
1999-10  1999-04          1999        715,831
1999-11  1999-04          1999        742,248
1999-12  1999-04          1999        841,572
         1999-04          1999      2,299,652
                          1999     10,073,847
                                   10,073,847








/*Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/


Query:
SELECT CHANNELS.CHANNEL_TOTAL,CHANNELS.CHANNEL_CLASS,COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE,
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND times.calendar_year='1999'
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(CHANNELS.CHANNEL_TOTAL,CHANNELS.CHANNEL_CLASS),ROLLUP(COUNTRIES.COUNTRY_REGION,COUNTRIES.COUNTRY_ISO_CODE);


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

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
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

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
Channel total Indirect             Americas             US      1,326,471
Channel total Indirect             Americas                     1,326,471
Channel total Indirect                                          1,422,400

25 rows selected.
				

/*
Q11. Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October.
*/
Query:
SELECT CHANNELS.CHANNEL_DESC,  
	COUNTRIES.COUNTRY_NAME,CALENDAR_MONTH_DESC,
	TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
		FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES 
			WHERE SALES.TIME_ID=TIMES.TIME_ID 
				AND SALES.CUST_ID=CUSTOMERS.CUST_ID 
				AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID 
				AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID 
				AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET') 
				AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09','2000-10') 
				AND UPPER(COUNTRIES.COUNTRY_NAME) LIKE 'U%' 
		GROUP BY 
		ROLLUP(COUNTRIES.COUNTRY_NAME,CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC);
		

Query:
CHANNEL_DESC         COUNTRY_NAME                             CALENDAR TOTAL_SALES
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

CHANNEL_DESC         COUNTRY_NAME                             CALENDAR TOTAL_SALES
-------------------- ---------------------------------------- -------- --------------
Direct Sales         United States of America                 2000-10         682,297
Direct Sales         United States of America                               1,320,497
                     United States of America                               1,581,775
                                                                            1,790,032


/*
 CHANNEL_DESC CALENDAR CO COUNTRY_NAME
SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ----------------------------------------
--------------- -----------
Internet 2001-09 GB United Kingdom
36806.73 0
Internet 2001-09 GB
36806.73 0
Internet 2001-09 US United States of America
299621.96 0
Internet 2001-09 US
299621.96 0
Internet 2001-09
336428.69 1
Internet 2001-10 GB United Kingdom
39010.76 0
Internet 2001-10 GB
39010.76 0
Internet 2001-10 US United States of America
386326.55 0
Internet 2001-10 US
386326.55 0
Internet 2001-10
425337.31 1
Internet
761766 3
CHANNEL_DESC CALENDAR CO COUNTRY_NAME
SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ----------------------------------------
--------------- -----------
Direct Sales 2001-09 GB United Kingdom
92865.04 0
Direct Sales 2001-09 GB
92865.04 0
Direct Sales 2001-09 US United States of America
621197.94 0
Direct Sales 2001-09 US
621197.94 0
Direct Sales 2001-09
714062.98 1
Direct Sales 2001-10 GB United Kingdom
75296.44 0
Direct Sales 2001-10 GB
75296.44 0
Direct Sales 2001-10 US United States of America
566719.8 0
Direct Sales 2001-10 US
566719.8 0
Direct Sales 2001-10
642016.24 1
 Direct Sales
1356079.22 3
CHANNEL_DESC CALENDAR CO COUNTRY_NAME
SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ----------------------------------------
--------------- -----------
2117845.22 7
23 rows selected.
 */