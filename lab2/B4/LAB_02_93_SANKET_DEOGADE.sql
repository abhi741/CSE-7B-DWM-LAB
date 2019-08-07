			-- Practical 2 

/*
Problem Statement: Write and Execute SQL aggregation queries for data warehouse. '
*/

/*
Name: Sanket Deogade 
Roll No: 93
Batch : B4
*/

-- Question 1
/*
Find the total sales by country_id and channel_desc for the US and GB through 
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP Extension. 
The query should return the following: 
 
 1. The aggregation rows that would be produced by GROUP BY , 
 2. The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month.
 3. Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
 4. A grand total row. 
*/


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

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
                                      1,790,032

15 rows selected.
*/



-- Question 2
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc, countries.country_iso_code. 
*/


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
		CUBE(channels.channel_desc, calendar_month_desc, countries.country_iso_code);

/*
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
*/



-- Question 3
/*
Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000 
*/


SELECT channels.channel_desc, countries.country_iso_code,
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

/*
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
*/


-- Question 4
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2000 using PARTIAL ROLL-UP. The query should return the following:
1. Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
2. First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
3. Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
4. It does not produce a grand total row.
*/


SELECT channels.channel_desc, calendar_month_desc, countries.country_iso_code,
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
		ROLLUP(calendar_month_desc, countries.country_iso_code);

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

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646

14 rows selected.
*/



-- Question 5
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2000 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.
*/


SELECT channels.channel_desc, calendar_month_desc, countries.country_iso_code,
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
		CUBE(calendar_month_desc, countries.country_iso_code);

/*
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
*/



-- Question 6
/*
Use GROUPING to create a set of mask columns for the result set of Q1.
1. Create grouping on channel_desc and name it as CH
2. Create grouping calendar_month_desc and name it as MO
3. Create grouping on country_iso_code and name it as CO
*/


SELECT channels.channel_desc, calendar_month_desc,
	countries.country_iso_code,
		TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
			GROUPING (channels.channel_desc) as CH,
			GROUPING (calendar_month_desc) as MO,
			GROUPING (countries.country_iso_code) as CO
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



-- Question 7
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using GROUPING SETS.
Calculate aggregates over three groupings:
1. (channel_desc, calendar_month_desc, country_iso_code)
2. (channel_desc, country_iso_code)
3. (calendar_month_desc, country_iso_code)
*/


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
		GROUPING SETS((channels.channel_desc, calendar_month_desc, countries.country_iso_code),(channels.channel_desc, countries.country_iso_code),(calendar_month_desc, countries.country_iso_code)); 

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



-- Question 8
/*
Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter, and then across all months and quarters in the year.
*/


SELECT times.calendar_month_desc as MONTH,times.calendar_quarter_desc as QUARTER, times.calendar_year as YEAR,  
		TO_CHAR(SUM(amount_sold), '9,999,999,999') SUM_AMOUNT_SOLD
		FROM sales, customers, times, channels, countries
			WHERE sales.time_id=times.time_id
				AND sales.cust_id=customers.cust_id
				AND customers.country_id = countries.country_id
				AND sales.channel_id = channels.channel_id
				AND channels.channel_desc IN ('Direct Sales', 'Internet')
				AND times.calendar_year IN ('1999')
				AND countries.country_iso_code IN ('GB', 'US')
		GROUP BY
		ROLLUP(times.calendar_year, times.calendar_quarter_desc, times.calendar_month_desc ); 

/*
MONTH    QUARTER       YEAR SUM_AMOUNT_SOL
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

MONTH    QUARTER       YEAR SUM_AMOUNT_SOL
-------- ------- ---------- --------------
         1999-03       1999      2,700,490
1999-10  1999-04       1999        715,831
1999-11  1999-04       1999        742,248
1999-12  1999-04       1999        841,572
         1999-04       1999      2,299,652
                       1999     10,073,847
                                10,073,847

18 rows selected.
*/



-- Question 9
/*
mplement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/


SELECT channels.channel_total, channels.channel_class,
	countries.country_region,countries.country_iso_code,
		TO_CHAR(SUM(amount_sold), '9,999,999,999') SUM_AMOUNT_SOLD
		FROM sales, customers, times, channels, countries
			WHERE sales.time_id=times.time_id
				AND sales.cust_id=customers.cust_id
				AND customers.country_id = countries.country_id
				AND sales.channel_id = channels.channel_id
				AND times.calendar_month_desc IN ('2000-09', '2000-10')
				AND countries.country_iso_code IN ('GB', 'US')
		GROUP BY
		ROLLUP(channels.channel_total, channels.channel_class),
		ROLLUP(countries.country_region,countries.country_iso_code);

/*
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM_AMOUNT_SOL
------------- -------------------- -------------------- -- --------------
                                   Europe               GB        266,786
                                   Europe                         266,786
                                   Americas             US      2,382,647
                                   Americas                     2,382,647
                                                                2,649,433
Channel total                      Europe               GB        266,786
Channel total                      Europe                         266,786
Channel total                      Americas             US      2,382,647
Channel total                      Americas                     2,382,647
Channel total                                                   2,649,433
Channel total Direct               Europe               GB        177,148

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM_AMOUNT_SOL
------------- -------------------- -------------------- -- --------------
Channel total Direct               Europe                         177,148
Channel total Direct               Americas             US      1,320,497
Channel total Direct               Americas                     1,320,497
Channel total Direct                                            1,497,646
Channel total Others               Europe               GB         58,529
Channel total Others               Europe                          58,529
Channel total Others               Americas             US        800,871
Channel total Others               Americas                       800,871
Channel total Others                                              859,401
Channel total Indirect             Europe               GB         31,109
Channel total Indirect             Europe                          31,109

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SUM_AMOUNT_SOL
------------- -------------------- -------------------- -- --------------
Channel total Indirect             Americas             US        261,278
Channel total Indirect             Americas                       261,278
Channel total Indirect                                            292,387

25 rows selected.
*/



-- Question 11
/*
Find the total sales by country name and channel_desc for the country name starting from U through the Internet and direct sales in September 2000 and October.
*/

SELECT channels.channel_desc, times.calendar_month_desc as CALENDAR,
	countries.country_name as COUNTRY_NAME,
		TO_CHAR(SUM(amount_sold), '9,999,999,999') SUM_AMOUNT_SOLD
		FROM sales, customers, times, channels, countries
			WHERE sales.time_id=times.time_id
				AND sales.cust_id=customers.cust_id
				AND customers.country_id = countries.country_id
				AND sales.channel_id = channels.channel_id
				AND channels.channel_desc IN ('Direct Sales', 'Internet')
				AND times.calendar_month_desc IN ('2000-09', '2000-10')
				AND countries.country_name LIKE 'U%'
		GROUP BY
		ROLLUP(channels.channel_desc, times.calendar_month_desc, countries.country_name);

/*
CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SUM_AMOUNT_SOL
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

CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SUM_AMOUNT_SOL
-------------------- -------- ---------------------------------------- --------------
Direct Sales         2000-10  United States of America                        682,297
Direct Sales         2000-10                                                  774,222
Direct Sales                                                                1,497,646
                                                                            1,790,032

15 rows selected.
*/
