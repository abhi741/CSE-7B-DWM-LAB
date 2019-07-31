----------------------------------------QUERY-1-----------------------------------------------
/*Q1. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
Extension. The query should return the following:
 The aggregation rows that would be produced by GROUP BY ,
 The First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month.
 Second-level subtotals aggregating
across calendar_month_desc and country_id for each channel_desc value.
 A grand total row.
*/

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
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
                             1,790,032

15 rows selected.
		
----------------------------------------QUERY-1-----------------------------------------------
/*Q2. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
countries.country_iso_code.
*/
SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
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

----------------------------------------QUERY-1-----------------------------------------------
/*Q3. Find the total sales by country_iso and channel_desc for the US and France
through the Internet and direct sales in September 2000
*/
SELECT channels.channel_desc,countries.country_iso_code,
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
		CUBE(channels.channel_desc,	countries.country_iso_code)
	ORDER BY channels.channel_desc;

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
----------------------------------------QUERY-3-----------------------------------------------
/*Q4. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using PARTIAL
ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without
using ROLLUP.
 First-level subtotals aggregating across country_id for each combination
of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.
*/
	
SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
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
		ROLLUP(calendar_month_desc,	countries.country_iso_code);
		
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

----------------------------------------QUERY-5-----------------------------------------------
/*Q5. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using PARTIAL
CUBE aggregation on month and country code and GROUP BY on channel_desc.
*/

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
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
		CUBE(calendar_month_desc,	countries.country_iso_code);
	
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
----------------------------------------QUERY-6-----------------------------------------------
/*Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO
*/

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
	GROUPING (channels.channel_desc) AS CH,
	GROUPING (calendar_month_desc) AS MO,
	GROUPING (countries.country_iso_code) AS CO
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

----------------------------------------QUERY-7-----------------------------------------------
/*Q7. Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2000 using GROUPING
SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)
*/

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
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
		GROUPING SETS((channels.channel_desc,calendar_month_desc,countries.country_iso_code),
		(channels.channel_desc,countries.country_iso_code),(calendar_month_desc,countries.country_iso_code));
		
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
		 
----------------------------------------QUERY-8-----------------------------------------------
/*Q:8 Perform aggregation on amount sold. It should get aggregated by month first,
then by all the months in each quarter, and then across all months and quarters in
the year.
*/
SELECT calendar_month_desc AS MONTH,calendar_quarter_desc AS QUARTER,calendar_year AS YEAR,
	TO_CHAR(SUM(amount_sold), '9,999,999,999.99') SALES$
		FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND countries.country_iso_code IN ('GB', 'US')
		AND times.calendar_year IN ('1999')
	GROUP BY 
		ROLLUP(calendar_year,calendar_quarter_desc,calendar_month_desc);

		
MONTH    QUARTER       YEAR SALES$
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

MONTH    QUARTER       YEAR SALES$
-------- ------- ---------- -----------------
         1999-03       1999      2,700,490.40
1999-10  1999-04       1999        715,831.36
1999-11  1999-04       1999        742,248.42
1999-12  1999-04       1999        841,572.17
         1999-04       1999      2,299,651.95
                       1999     10,073,846.53
                                10,073,846.53

18 rows selected.

----------------------------------------QUERY-9-----------------------------------------------
/*Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/
SELECT channels.channel_total,channels.channel_class ,countries.country_iso_code,countries.country_region,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND times.calendar_month_desc IN ('2001-09', '2001-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(channels.channel_total,channels.channel_class ),
		ROLLUP(countries.country_region,countries.country_iso_code);
	
CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
                                   GB Europe                      321,244
                                      Europe                      321,244
                                   US Americas                  2,603,473
                                      Americas                  2,603,473
                                                                2,924,717
Channel total                      GB Europe                      321,244
Channel total                         Europe                      321,244
Channel total                      US Americas                  2,603,473
Channel total                         Americas                  2,603,473
Channel total                                                   2,924,717
Channel total Direct               GB Europe                      168,161

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Direct                  Europe                      168,161
Channel total Direct               US Americas                  1,187,918
Channel total Direct                  Americas                  1,187,918
Channel total Direct                                            1,356,079
Channel total Others               GB Europe                       77,265
Channel total Others                  Europe                       77,265
Channel total Others               US Americas                    729,606
Channel total Others                  Americas                    729,606
Channel total Others                                              806,872
Channel total Indirect             GB Europe                       75,817
Channel total Indirect                Europe                       75,817

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Indirect             US Americas                    685,949
Channel total Indirect                Americas                    685,949
Channel total Indirect                                            761,766

25 rows selected.
----------------------------------------QUERY-11-----------------------------------------------
/*Q11. Find the total sales by country name and channel_desc for the country name
starting from U through the Internet and direct sales in September 2000 and October 2000.
*/

SELECT channels.channel_desc,calendar_month_desc,countries.country_name,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	FROM sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND UPPER(countries.country_name) LIKE 'U%'
	GROUP BY
		ROLLUP(channels.channel_desc,calendar_month_desc,countries.country_name);
		
CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SALES$
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

CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SALES$
-------------------- -------- ---------------------------------------- --------------
Direct Sales         2000-10  United States of America                        682,297
Direct Sales         2000-10                                                  774,222
Direct Sales                                                                1,497,646
                                                                            1,790,032

15 rows selected.