/*
PRACTICAL NO. 02 

Aim: Write and Execute SQL aggregation queries for data warehouse. 
*/


-------------------------------------query 1---------------------------------------------------
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and 
direct sales in September 2000 and October 2000 using ROLL-UP Extension. 
The query should return the following: 
• The aggregation rows that would be produced by GROUP BY , 
• The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month. 
• Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value. 
• A grand total row. 

*/
SELECT channels.channel_desc, calendar_month_desc,
 countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
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
Direct Sales         2000-10  US        682,297
Direct Sales         2000-10            774,222
Direct Sales                          1,497,646
                                      1,790,032

15 rows selected.

*/
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
ROLLUP(channels.channel_desc, countries.country_iso_code); 

/*
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
*/

-------------------------------------------------------query 2-----------------------------------------------
/*
 Find the total sales by country_id and channel_desc for the US and GB through the
  Internet and direct sales in September 2000 and October
  2000 using CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
   countries.country_iso_code.
*/
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
cube(channels.channel_desc, calendar_month_desc, countries.country_iso_code)
order by
channel_desc; 
/*
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
Internet                       140,793
Internet             GB         14,539
Internet             US        137,054
Internet                       151,593
Internet             GB         31,109
Internet             US        261,278
Internet                       292,387
                     GB        101,792
                     US        762,425
                               864,217
                     GB        106,465
                     US        819,351
                               925,815
                     GB        208,257
                     US      1,581,775
                             1,790,032

27 rows selected.

*/
----------------------------------query 3-----------------------------------
/*
 Find the total sales by country_iso and channel_desc for the US and France through
  the Internet and direct sales in September 2000 

*/
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
cube(channels.channel_desc, countries.country_iso_code)
order by
channel_desc; 
/*
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

*/

---------------------------------------query 4------------------------------------
/*
 Find the total sales by country_id and channel_desc for the US and GB through the
  Internet and direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP.
   The query should return the following: 
• Regular aggregation rows that would be produced by GROUP BY without using ROLLUP. 
• First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc. 
• Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value. 
• It does not produce a grand total row.
*/
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
GROUP BY channels.channel_desc,
ROLLUP( calendar_month_desc, countries.country_iso_code)
order by
channel_desc; 
/*
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
Internet             US        137,054
Internet                       151,593
Internet                       292,387

14 rows selected.

*/
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
GROUP BY countries.country_iso_code,
ROLLUP( calendar_month_desc, channels.channel_desc);
/*
CHANNEL_DESC         CO SALES$
-------------------- -- --------------
Internet             GB         16,569
Direct Sales         GB         85,223
                     GB        101,792
Internet             GB         14,539
Direct Sales         GB         91,925
                     GB        106,465
                     GB        208,257
Internet             US        124,224
Direct Sales         US        638,201
                     US        762,425
Internet             US        137,054
Direct Sales         US        682,297
                     US        819,351
                     US      1,581,775

14 rows selected.
*/
------------------------------------------query 5--------------------
/* and GB through the Internet and direct sales in September 2000
  and October 2000 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc. 
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
GROUP BY channels.channel_desc,
CUBE( countries.country_iso_code,calendar_month_desc );
/*
CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet                                292,387
Internet             2000-09            140,793
Internet             2000-10            151,593
Internet                      GB         31,109
Internet             2000-09  GB         16,569
Internet             2000-10  GB         14,539
Internet                      US        261,278
Internet             2000-09  US        124,224
Internet             2000-10  US        137,054
Direct Sales                          1,497,646
Direct Sales         2000-09            723,424
Direct Sales         2000-10            774,222
Direct Sales                  GB        177,148
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-10  GB         91,925
Direct Sales                  US      1,320,497
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10  US        682,297

18 rows selected.

*/

-------------------------------------query 6--------------------------
/*
Use GROUPING to create a set of mask columns for the result set of Q1. 
• Create grouping on channel_desc and name it as CH 
• Create grouping calendar_month_desc and name it as MO 
• Create grouping on country_iso_code and name it as CO
*/
SELECT channels.channel_desc, calendar_month_desc,
countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$,
grouping (channels.channel_desc) as CH,
grouping (calendar_month_desc) as MO,
grouping (countries.country_iso_code) as CO
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_month_desc IN ('2000-09', '2000-10') 
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY 
ROLLUP(  channels.channel_desc,countries.country_iso_code,
	calendar_month_desc );
/*
CHANNEL_DESC         CALENDAR CO SALES$                 CH         MO         CO
-------------------- -------- -- -------------- ---------- ---------- ----------
Internet             2000-09  GB         16,569          0          0          0
Internet             2000-10  GB         14,539          0          0          0
Internet                      GB         31,109          0          1          0
Internet             2000-09  US        124,224          0          0          0
Internet             2000-10  US        137,054          0          0          0
Internet                      US        261,278          0          1          0
Internet                                292,387          0          1          1
Direct Sales         2000-09  GB         85,223          0          0          0
Direct Sales         2000-10  GB         91,925          0          0          0
Direct Sales                  GB        177,148          0          1          0
Direct Sales         2000-09  US        638,201          0          0          0
Direct Sales         2000-10  US        682,297          0          0          0
Direct Sales                  US      1,320,497          0          1          0
Direct Sales                          1,497,646          0          1          1
                                      1,790,032          1          1          1

15 rows selected.
*/

--------------------------------------------query 7---------------------
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using GROUPING SETS. 
Calculate aggregates over three groupings: 
• (channel_desc, calendar_month_desc, country_iso_code) 
• (channel_desc, country_iso_code) 
• (calendar_month_desc, country_iso_code) 
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
grouping sets((channels.channel_desc,calendar_month_desc,countries.country_iso_code),
	(channels.channel_desc,	countries.country_iso_code),
	(channels.channel_desc,calendar_month_desc));
/*
CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  GB         16,569
Internet             2000-09  US        124,224
Internet             2000-10  GB         14,539
Internet             2000-10  US        137,054
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297
Internet             2000-09            140,793
Internet             2000-10            151,593
Direct Sales         2000-09            723,424
Direct Sales         2000-10            774,222
Direct Sales                  GB        177,148
Internet                      GB         31,109
Direct Sales                  US      1,320,497
Internet                      US        261,278

16 rows selected.
*/

--------------------------------query 8--------------------
/*
Perform aggregation on amount sold. It should get aggregated by month first, 
then by all the months in each quarter, and then across all months and quarters in the year. 
*/
SELECT calendar_month_desc AS MONTH,calendar_quarter_desc as QUARTER, calendar_year as YEAR,
TO_CHAR(SUM(amount_sold), '999999999.99') SUM_AMOUNT_SOLD 
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND times.calendar_year IN ('1999') 
AND countries.country_iso_code IN ('GB', 'US')  
GROUP BY 
ROLLUP(calendar_year, calendar_quarter_desc,calendar_month_desc); 
/*
MONTH    QUARTER       YEAR SUM_AMOUNT_SO
-------- ------- ---------- -------------
1999-01  1999-01       1999     974627.95
1999-02  1999-01       1999    1089255.92
1999-03  1999-01       1999     754026.70
         1999-01       1999    2817910.57
1999-04  1999-02       1999     708060.57
1999-05  1999-02       1999     818055.52
1999-06  1999-02       1999     729677.52
         1999-02       1999    2255793.61
1999-07  1999-03       1999     893452.47
1999-08  1999-03       1999     883460.92
1999-09  1999-03       1999     923577.01
         1999-03       1999    2700490.40
1999-10  1999-04       1999     715831.36
1999-11  1999-04       1999     742248.42
1999-12  1999-04       1999     841572.17
         1999-04       1999    2299651.95
                       1999   10073846.53
                              10073846.53

18 rows selected.

*/
------------------------------------------------query 9--------------------------------
/*
 Implement concatenated rollup. First roll up on (channel_total, channel_class) and
  second roll up on(country_region and country_iso_code) 
*/
SELECT channels.channel_total, channels.channel_class,countries.country_region,
 countries.country_iso_code as CO,TO_CHAR(SUM(amount_sold), '9,999,999,999.99') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND sales.channel_id = channels.channel_id  
AND times.calendar_month_desc IN ('2001-09', '2001-10') 
AND countries.country_iso_code IN ('GB', 'US') 
GROUP BY 
ROLLUP(channels.channel_total,channels.channel_class),
ROLLUP(countries.country_region,countries.country_iso_code); 
/*
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- -----------------
                                   Europe               GB        321,244.43
                                   Europe                         321,244.43
                                   Americas             US      2,603,472.57
                                   Americas                     2,603,472.57
                                                                2,924,717.00
Channel total                      Europe               GB        321,244.43
Channel total                      Europe                         321,244.43
Channel total                      Americas             US      2,603,472.57
Channel total                      Americas                     2,603,472.57
Channel total                                                   2,924,717.00
Channel total Direct               Europe               GB        168,161.48
Channel total Direct               Europe                         168,161.48
Channel total Direct               Americas             US      1,187,917.74
Channel total Direct               Americas                     1,187,917.74
Channel total Direct                                            1,356,079.22
Channel total Others               Europe               GB         77,265.46
Channel total Others               Europe                          77,265.46
Channel total Others               Americas             US        729,606.32
Channel total Others               Americas                       729,606.32
Channel total Others                                              806,871.78
Channel total Indirect             Europe               GB         75,817.49
Channel total Indirect             Europe                          75,817.49
Channel total Indirect             Americas             US        685,948.51
Channel total Indirect             Americas                       685,948.51
Channel total Indirect                                            761,766.00

25 rows selected.

*/

-----------------------------------------------query 10----------------------------------

-----------------------------------------------query 11----------------------------------
/*
Find the total sales by country name and channel_desc for the country
name starting from U through the Internet and direct sales in September 2000 and October. 
*/
SELECT channels.channel_desc,calendar_month_desc,countries.country_name,
TO_CHAR(SUM(amount_sold), '9,999,999,999.99') SALES$ 
FROM sales, customers, times, channels, countries 
WHERE sales.time_id=times.time_id 
AND sales.cust_id=customers.cust_id 
AND customers.country_id = countries.country_id 
AND channels.channel_desc IN ('Direct Sales', 'Internet') 
AND sales.channel_id = channels.channel_id  
AND times.calendar_month_desc IN ('2000-09', '2000-10') 
AND UPPER(countries.country_name) like 'U%' 
GROUP BY 
ROLLUP(channels.channel_desc,calendar_month_desc,countries.country_name);
/*
CHANNEL_DESC         CALENDAR COUNTRY_NAME                             SALES$
-------------------- -------- ---------------------------------------- -----------------
Internet             2000-09  United Kingdom                                   16,569.36
Internet             2000-09  United States of America                        124,223.75
Internet             2000-09                                                  140,793.11
Internet             2000-10  United Kingdom                                   14,539.14
Internet             2000-10  United States of America                        137,054.29
Internet             2000-10                                                  151,593.43
Internet                                                                      292,386.54
Direct Sales         2000-09  United Kingdom                                   85,222.92
Direct Sales         2000-09  United States of America                        638,200.81
Direct Sales         2000-09                                                  723,423.73
Direct Sales         2000-10  United Kingdom                                   91,925.43
Direct Sales         2000-10  United States of America                        682,296.59
Direct Sales         2000-10                                                  774,222.02
Direct Sales                                                                1,497,645.75
                                                                            1,790,032.29
*/
