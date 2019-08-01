
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


----------------------------------------------------------------------------------------------------------------------------------------
Q3. Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 3:
SELECT COUNTRIES.COUNTRY_ISO_CODE, CHANNELS.CHANNEL_DESC,  
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
FROM SALES,CUSTOMERS,TIMES,CHANNELS,COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09')
AND countries.country_iso_code IN ('FR', 'US')
GROUP BY
cube(channels.channel_desc, countries.country_iso_code) -- since nothing mentioned
ORDER BY channels.channel_desc;

OUTPUTs:

CO CHANNEL_DESC         SALES$
-- -------------------- --------------
FR Direct Sales                 61,202
US Direct Sales                638,201
   Direct Sales                699,403
FR Internet                      9,597
US Internet                    124,224
   Internet                    133,821
FR                              70,799
US                             762,425
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
 
 OUTPUTs:
 
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


--FOR COUNTRY_WISE TOTAL
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
		COUNTRIES.COUNTRY_ISO_CODE , ROLLUP  (CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC);
		
		
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
			
14 rows selected.
----------------------------------------------------------------------------------------------------------------------------------------
Q5. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 
    and October 2000 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 5:

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
		CHANNELS.CHANNEL_DESC, CUBE ( COUNTRIES.COUNTRY_ISO_CODE ,CALENDAR_MONTH_DESC);
		
OUTPUTs:
		
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

18 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------
Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
 Create grouping on channel_desc and name it as CH
 Create grouping calendar_month_desc and name it as MO
 Create grouping on country_iso_code and name it as CO
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 6:

SELECT CHANNELS.CHANNEL_DESC,  
COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
GROUPING(CHANNELS.CHANNEL_DESC) CH,
GROUPING(CALENDAR_MONTH_DESC) MO,
GROUPING(COUNTRIES.COUNTRY_ISO_CODE) CO,
TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES 
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

CHANNEL_DESC         CO CALENDAR         CH         MO         CO TOTAL_SALES
-------------------- -- -------- ---------- ---------- ---------- --------------
Internet             GB 2000-09           0          0          0         16,569
Internet             US 2000-09           0          0          0        124,224
Internet                2000-09           0          0          1        140,793
Internet             GB 2000-10           0          0          0         14,539
Internet             US 2000-10           0          0          0        137,054
Internet                2000-10           0          0          1        151,593
Internet                                  0          1          1        292,387
Direct Sales         GB 2000-09           0          0          0         85,223
Direct Sales         US 2000-09           0          0          0        638,201
Direct Sales            2000-09           0          0          1        723,424
Direct Sales         GB 2000-10           0          0          0         91,925

CHANNEL_DESC         CO CALENDAR         CH         MO         CO TOTAL_SALES
-------------------- -- -------- ---------- ---------- ---------- --------------
Direct Sales         US 2000-10           0          0          0        682,297
Direct Sales            2000-10           0          0          1        774,222
Direct Sales                              0          1          1      1,497,646
                                          1          1          1      1,790,032

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

SELECT CHANNELS.CHANNEL_DESC,  
COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC,
TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND times.calendar_month_desc IN ('2000-09', '2000-10')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
GROUPING SETS((CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,COUNTRIES.COUNTRY_ISO_CODE),
(CHANNELS.CHANNEL_DESC,COUNTRIES.COUNTRY_ISO_CODE),
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

----------------------------------------------------------------------------------------------------------------------------------------
Q: 8 Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter, and then
     across all months and quarters in the year.
----------------------------------------------------------------------------------------------------------------------------------------

QUERY 8:
SELECT calendar_year,calendar_quarter_desc,calendar_month_desc,
SUM(AMOUNT_SOLD) TOTAL_SALES
FROM sales, customers, times, channels, countries
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = countries.country_id
AND sales.channel_id = channels.channel_id
AND channels.channel_desc IN ('Direct Sales', 'Internet')
AND TIMES.CALENDAR_YEAR IN ('1999')
AND countries.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(calendar_year,calendar_quarter_desc,calendar_month_desc);
 
 
 CALENDAR_YEAR CALENDA CALENDAR TOTAL_SALES
------------- ------- -------- -----------
         1999 1999-01 1999-01    974627.95
         1999 1999-01 1999-02   1089255.92
         1999 1999-01 1999-03     754026.7
         1999 1999-01           2817910.57
         1999 1999-02 1999-04    708060.57
         1999 1999-02 1999-05    818055.52
         1999 1999-02 1999-06    729677.52
         1999 1999-02           2255793.61
         1999 1999-03 1999-07    893452.47
         1999 1999-03 1999-08    883460.92
         1999 1999-03 1999-09    923577.01

CALENDAR_YEAR CALENDA CALENDAR TOTAL_SALES
------------- ------- -------- -----------
         1999 1999-03            2700490.4
         1999 1999-04 1999-10    715831.36
         1999 1999-04 1999-11    742248.42
         1999 1999-04 1999-12    841572.17
         1999 1999-04           2299651.95
         1999                   10073846.5
                                10073846.5

18 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------
Q: 9 Implement concatenated rollup. First roll up on (channel_total, channel_class) and second roll up 
	 on(country_region and country_iso_code)
----------------------------------------------------------------------------------------------------------------------------------------
QUERY 9:

SELECT C.CHANNEL_TOTAL,C.CHANNEL_CLASS,CC.COUNTRY_REGION ,CC.COUNTRY_ISO_CODE,
SUM(AMOUNT_SOLD) TOTAL_SALES
FROM sales, customers, times, channels C, countries CC
WHERE sales.time_id=times.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = CC.country_id
AND sales.channel_id = C.channel_id
AND times.calendar_month_desc IN ('2001-09', '2001-10')
AND CC.country_iso_code IN ('GB', 'US')
GROUP BY
ROLLUP(C.CHANNEL_TOTAL,C.CHANNEL_CLASS),
ROLLUP(CC.COUNTRY_REGION,CC.COUNTRY_ISO_CODE);

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
                                   Europe               GB   321244.43
                                   Europe                    321244.43
                                   Americas             US  2603472.57
                                   Americas                 2603472.57
                                                               2924717
Channel total                      Europe               GB   321244.43
Channel total                      Europe                    321244.43
Channel total                      Americas             US  2603472.57
Channel total                      Americas                 2603472.57
Channel total                                                  2924717
Channel total Direct               Europe               GB   168161.48

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
Channel total Direct               Europe                    168161.48
Channel total Direct               Americas             US  1187917.74
Channel total Direct               Americas                 1187917.74
Channel total Direct                                        1356079.22
Channel total Others               Europe               GB    77265.46
Channel total Others               Europe                     77265.46
Channel total Others               Americas             US   729606.32
Channel total Others               Americas                  729606.32
Channel total Others                                         806871.78
Channel total Indirect             Europe               GB    75817.49
Channel total Indirect             Europe                     75817.49

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO TOTAL_SALES
------------- -------------------- -------------------- -- -----------
Channel total Indirect             Americas             US   685948.51
Channel total Indirect             Americas                  685948.51
Channel total Indirect                                          761766

25 rows selected.

----------------------------------------------------------------------------------------------------------------------------------------		
Q11. Find the total sales by country name and channel_desc for the country name starting from U through the Internet and direct sales
     in September 2000 and October.
----------------------------------------------------------------------------------------------------------------------------------------
QUERY 11:

SELECT CC.COUNTRY_NAME,C.CHANNEL_DESC,T.CALENDAR_MONTH_DESC,
SUM(AMOUNT_SOLD) TOTAL_SALES
FROM sales, customers, times T, channels C, countries CC
WHERE sales.time_id=T.time_id
AND sales.cust_id=customers.cust_id
AND customers.country_id = CC.country_id
AND sales.channel_id = C.channel_id
AND C.channel_desc IN ('Direct Sales', 'Internet')
AND T.calendar_month_desc IN ('2000-09', '2000-10')
AND CC.COUNTRY_NAME LIKE 'U%'
GROUP BY
ROLLUP(CC.COUNTRY_NAME,C.CHANNEL_DESC,T.CALENDAR_MONTH_DESC);


COUNTRY_NAME                             CHANNEL_DESC         CALENDAR
---------------------------------------- -------------------- --------
TOTAL_SALES
-----------
United Kingdom                           Internet             2000-09
   16569.36

United Kingdom                           Internet             2000-10
   14539.14

United Kingdom                           Internet
    31108.5


COUNTRY_NAME                             CHANNEL_DESC         CALENDAR
---------------------------------------- -------------------- --------
TOTAL_SALES
-----------
United Kingdom                           Direct Sales         2000-09
   85222.92

United Kingdom                           Direct Sales         2000-10
   91925.43

United Kingdom                           Direct Sales
  177148.35


COUNTRY_NAME                             CHANNEL_DESC         CALENDAR
---------------------------------------- -------------------- --------
TOTAL_SALES
-----------
United Kingdom
  208256.85

United States of America                 Internet             2000-09
  124223.75

United States of America                 Internet             2000-10
  137054.29


COUNTRY_NAME                             CHANNEL_DESC         CALENDAR
---------------------------------------- -------------------- --------
TOTAL_SALES
-----------
United States of America                 Internet
  261278.04

United States of America                 Direct Sales         2000-09
  638200.81

United States of America                 Direct Sales         2000-10
  682296.59


COUNTRY_NAME                             CHANNEL_DESC         CALENDAR
---------------------------------------- -------------------- --------
TOTAL_SALES
-----------
United States of America                 Direct Sales
  1320497.4

United States of America
 1581775.44


 1790032.29


15 rows selected.
