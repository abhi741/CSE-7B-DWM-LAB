ROLL NO : B1-07
PRACTICAL NO. : 02
Aim: Write and Execute SQL aggregation queries for data warehouse.

QUERIES:

----------------------------------------------------------------------------------------------------------------------------------------
Q1. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 
    and October 2000 using ROLL-UP Extension. The query should return the following:
	 The aggregation rows that would be produced by GROUP BY ,
	 The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month.
	 Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
	 A grand total row.
----------------------------------------------------------------------------------------------------------------------------------------
 Query 1:
	SELECT channels.channel_desc, calendar_month_desc,country_iso_code,TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);

OUTPUTs:-
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

----------------------------------------------------------------------------------------------------------------------------------------
Q2. Find the total sales by country_id and channel_desc for the US and GB through the Internet and 
direct sales in September 2000 and October 2000 using CUBE aggregation across three dimensions- channel_desc,
calendar_month_desc, countries.country_iso_code.
----------------------------------------------------------------------------------------------------------------------------------------

Query 2:-
SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, 
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
		ORDER by channels.channel_desc;
OUTPUTs:
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

----------------------------------------------------------------------------------------------------------------------------------------
Q3. Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 3:
SELECT channels.channel_desc,countries.country_iso_code, 
	to_char(sum(amount_sold), '9,999,999,999') total_sales 
		from sales, customers, times, channels, countries 
			where sales.time_id=times.time_id 
				and sales.cust_id=customers.cust_id 
				and customers.country_id = countries.country_id 
				and sales.channel_id = channels.channel_id 
				and upper(channels.channel_desc) in ('DIRECT SALES', 'INTERNET') 
				and times.calendar_month_desc in ('2000-09') 
				and upper(countries.country_iso_code) in ('FR', 'US') 
		group by 
		cube(channels.channel_desc, countries.country_iso_code)
		ORDER by channels.channel_desc;

OUTPUTs:

CHANNEL_DESC         CO TOTAL_SALES
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

----------------------------------------------------------------------------------------------------------------------------------------
Q4. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and
    October 2000 using PARTIAL ROLL-UP. The query should return the following:
 Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
 First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
 Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
 It does not produce a grand total row.
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 4:
	SELECT channels.channel_desc, calendar_month_desc,country_iso_code,TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY channels.channel_desc,
		ROLLUP( calendar_month_desc,countries.country_iso_code);

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

	SELECT channels.channel_desc, calendar_month_desc,country_iso_code,TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY countries.country_iso_code,
		ROLLUP( calendar_month_desc,channels.channel_desc);

OUTPUTs:
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

----------------------------------------------------------------------------------------------------------------------------------------
Q5. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 
    and October 2000 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 5:
SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, 
	to_char(sum(amount_sold), '9,999,999,999') total_sales 
		from sales, customers, times, channels, countries 
			where sales.time_id=times.time_id 
				and sales.cust_id=customers.cust_id 
				and customers.country_id = countries.country_id 
				and sales.channel_id = channels.channel_id 
				and upper(channels.channel_desc) in ('DIRECT SALES', 'INTERNET') 
				and times.calendar_month_desc in ('2000-09', '2000-10') 
				and upper(countries.country_iso_code) in ('GB', 'US') 
		group by channels.channel_desc,
		cube( calendar_month_desc, countries.country_iso_code);

OUTPUTs:
CHANNEL_DESC         CALENDAR CO TOTAL_SALES
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
Direct Sales                  US      1,320,497
Direct Sales         2000-09            723,424
Direct Sales         2000-09  GB         85,223
Direct Sales         2000-09  US        638,201
Direct Sales         2000-10            774,222
Direct Sales         2000-10  GB         91,925
Direct Sales         2000-10  US        682,297

18 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------
Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 6:
	SELECT channels.channel_desc, countries.country_iso_code,calendar_month_desc,to_char(sum(amount_sold), '9,999,999,999') total_sales ,
	grouping (channels.channel_desc) as CH,
	grouping (calendar_month_desc) as MO,
	grouping (country_iso_code) as CO
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);
		
OUTPUTs:
CHANNEL_DESC         CO CALENDAR TOTAL_SALES            CH         MO         CO
-------------------- -- -------- -------------- ---------- ---------- ----------
Internet             GB 2000-09          16,569          0          0          0
Internet             US 2000-09         124,224          0          0          0
Internet                2000-09         140,793          0          0          1
Internet             GB 2000-10          14,539          0          0          0
Internet             US 2000-10         137,054          0          0          0
Internet                2000-10         151,593          0          0          1
Internet                                292,387          0          1          1
Direct Sales         GB 2000-09          85,223          0          0          0
Direct Sales         US 2000-09         638,201          0          0          0
Direct Sales            2000-09         723,424          0          0          1
Direct Sales         GB 2000-10          91,925          0          0          0
Direct Sales         US 2000-10         682,297          0          0          0
Direct Sales            2000-10         774,222          0          0          1
Direct Sales                          1,497,646          0          1          1
                                      1,790,032          1          1          1

15 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------
Q7. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and
    October 2000 using GROUPING SETS.
Calculate aggregates over three groupings:
 (channel_desc, calendar_month_desc, country_iso_code)
 (channel_desc, country_iso_code)
 (calendar_month_desc, country_iso_code)
----------------------------------------------------------------------------------------------------------------------------------------
QUERY 7:
	SELECT channels.channel_desc, countries.country_iso_code,calendar_month_desc,to_char(sum(amount_sold), '9,999,999,999') total_sales
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		GROUPING SETS((channels.channel_desc, calendar_month_desc,countries.country_iso_code),(channels.channel_desc,countries.country_iso_code),(calendar_month_desc,countries.country_iso_code));

OUTPUTs:
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
                     US 2000-10         819,351
Direct Sales         GB                 177,148
Internet             GB                  31,109
Direct Sales         US               1,320,497
Internet             US                 261,278

16 rows selected.	

----------------------------------------------------------------------------------------------------------------------------------------
Q: 8 Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter, and then
     across all months and quarters in the year.
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 8:
    /*COUNRIES: US.GB. YEAR =1999, DIRECT SALES AND INTERNET */	
	SELECT times.calendar_month_desc,times.calendar_quarter_desc,times.calendar_year,TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_year = 1999
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(times.calendar_year,times.calendar_quarter_desc,times.calendar_month_desc);
/* Rollup on higher level concept to lower level concept;*/

OUTPUTs:
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
         1999-03          1999      2,700,490
1999-10  1999-04          1999        715,831
1999-11  1999-04          1999        742,248
1999-12  1999-04          1999        841,572
         1999-04          1999      2,299,652
                          1999     10,073,847
                                   10,073,847
18 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------
Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class) and second roll up 
	 on(country_region and country_iso_code)
----------------------------------------------------------------------------------------------------------------------------------------
QUERY 9:
	SELECT channels.channel_total,channels.channel_class,countries.country_region,country_iso_code
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND times.calendar_month_desc IN ('2001-09', '2001-10')
		AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY
		ROLLUP(channels.channel_total,channels.channel_class),ROLLUP(countries.country_region,countries.country_iso_code);
		
OUTPUTs:
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO
------------- -------------------- -------------------- --
                                   Europe               GB
                                   Europe
                                   Americas             US
                                   Americas
Channel total                      Europe               GB
Channel total                      Europe
Channel total                      Americas             US
Channel total                      Americas
Channel total
Channel total Direct               Europe               GB
Channel total Direct               Europe
Channel total Direct               Americas             US
Channel total Direct               Americas
Channel total Direct
Channel total Others               Europe               GB
Channel total Others               Europe
Channel total Others               Americas             US
Channel total Others               Americas
Channel total Others
Channel total Indirect             Europe               GB
Channel total Indirect             Europe
Channel total Indirect             Americas             US
Channel total Indirect             Americas
Channel total Indirect

25 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------		
Q11. Find the total sales by country name and channel_desc for the country name starting from U through the Internet and direct sales
     in September 2000 and October.
----------------------------------------------------------------------------------------------------------------------------------------
QUERY 11:
	SELECT channels.channel_desc, calendar_month_desc,countries.country_name,TO_CHAR(SUM(amount_sold),'9,999,999,999')SALES$
		FROM sales,customers,times,channels,countries
		WHERE sales.time_id=times.time_id
		AND sales.cust_id=customers.cust_id
		AND customers.country_id = countries.country_id
		AND sales.channel_id = channels.channel_id
		AND channels.channel_desc IN ('Direct Sales', 'Internet')
		AND times.calendar_month_desc IN ('2000-09', '2000-10')
		AND countries.country_name like 'U%'
	GROUP BY
		ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_name);

OUTPUTs:
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
Direct Sales         2000-10  United States of America                        682,297
Direct Sales         2000-10                                                  774,222
Direct Sales                                                                1,497,646
                                                                            1,790,032		


QUERY 12:
	SELECT ch.channel_desc,t.calendar_month_desc,co.country_iso_code,
	SUM(s.amount_sold) sum_amount_sold,
	GROUPING_ID(
	ch.channel_desc,t.calendar_month_desc,co.country_iso_code) grouping_id
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

OUTPUTs:
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

GROUP ID:

SELECT ch.channel_desc,co.country_iso_code,
SUM(s.amount_sold) sum_amount_sold, group_id()
FROM sales s,customers cu,times t,channels ch,countries co
WHERE
s.time_id=t.time_id AND
s.cust_id=cu.cust_id AND
cu.country_id = co.country_id AND
s.channel_id = ch.channel_id AND
ch.channel_desc IN ('Direct Sales', 'Internet') AND
t.calendar_month_desc IN ('2001-09', '2001-10') AND
co.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(ch.channel_desc,co.country_iso_code),ROLLUP(ch.channel_desc)
ORDER BY GROUP_ID();


OUTPUTs:
CHANNEL_DESC         		 CO SUM_AMOUNT_SOLD GROUPING_ID
--------------------------- --- --------------- -----------
Direct Sales                          1356079.22           0
Internet                                  761766           0
                                      2117845.22           0
Direct Sales         		  US      1187917.74           0
Internet             		  GB        75817.49           0
Internet             		  US       685948.51           0
Direct Sales         		  GB       168161.48           0
Direct Sales         		  GB       168161.48           1
Internet             		  US       685948.51           1
Internet             		  GB        75817.49           1
Direct Sales         		  US      1187917.74           1
Direct Sales                          1356079.22           1
Internet                                  761766           1
Direct Sales                          1356079.22           2
Internet                                  761766           2

15 rows selected.
