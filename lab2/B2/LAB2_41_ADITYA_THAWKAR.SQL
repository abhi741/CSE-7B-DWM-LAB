             ***             PRACTICAL NO: 02           ***
-------------------------------------------------------------------------------
        AUTHOR  : ADITYA GOURKAR
        ROLL NO : 42 [6B]
        DATE    : 30-JULY-2019
-------------------------------------------------------------------------------

Aim: Write and Execute SQL aggregation queries for data warehouse. 

Details: To run queries for CUBE, PARTIAL CUBE, ROLLUP, PARTIAL ROLLUP, GROUPING, GROUPING SETS, GROUP_ID( ) 
 
--*******************************************************************************
Q1. Find the total sales by country_id and channel_desc for the US and GB through the 
	Internet and direct sales in September 2000 and October 2000 using ROLL-UP Extension. 
	The query should return the following: 
	• The aggregation rows that would be produced by GROUP BY , 
	• The First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month. 
	• Second-level subtotals aggregating across calendar_month.
--******************************************************************************
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
		GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);

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


--******************************************************************************
Q2. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and 
October 2009 using CUBE aggregation across three dimensions- channel_desc, calendar_month_desc, countries.country_iso_code.
--*******************************************************************************

SELECT channels.channel_desc, calendar_month_desc, countries.country_iso_code, 
	SUM(amount_sold) SALES$ 
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

CHANNEL_DESC         CALENDAR CO     SALES$
-------------------- -------- -- ----------
                                 1790032.29
                              GB  208256.85
                              US 1581775.44
                     2000-09      864216.84
                     2000-09  GB  101792.28
                     2000-09  US  762424.56
                     2000-10      925815.45
                     2000-10  GB  106464.57
                     2000-10  US  819350.88
Internet                          292386.54
Internet                      GB    31108.5

CHANNEL_DESC         CALENDAR CO     SALES$
-------------------- -------- -- ----------
Internet                      US  261278.04
Internet             2000-09      140793.11
Internet             2000-09  GB   16569.36
Internet             2000-09  US  124223.75
Internet             2000-10      151593.43
Internet             2000-10  GB   14539.14
Internet             2000-10  US  137054.29
Direct Sales                     1497645.75
Direct Sales                  GB  177148.35
Direct Sales                  US  1320497.4
Direct Sales         2000-09      723423.73

CHANNEL_DESC         CALENDAR CO     SALES$
-------------------- -------- -- ----------
Direct Sales                     2000-09      GB       85222.92
Direct Sales                     2000-09      US      638200.81
Direct Sales                    2000-10                     774222.02
Direct Sales                    2000-10        GB        91925.43
Direct Sales                     2000-10       US        682296.59

27 rows selected.
*/

--*******************************************************************************
Q3. Find the total sales by country_iso and channel_desc for the US and France through the Internet and direct sales in September 2000

--*******************************************************************************
SELECT channels.channel_desc,countries.country_iso_code,sum(amount_sold) sales
	FROM sales,channels,countries,customers,times
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND countries.country_iso_code in ('US','FR')
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09')
	GROUP BY CUBE(channels.channel_desc,countries.country_iso_code); 

/*

CHANNEL_DESC         CO      SALES
-------------------- -- ----------
                         833223.68
                     FR   70799.12
                     US  762424.56
Internet                 133820.61
Internet             FR    9596.86
Internet             US  124223.75
Direct Sales             699403.07
Direct Sales         FR   61202.26
Direct Sales         US  638200.81

9 rows selected.
*/

--*******************************************************************************
Q4. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP. The query should return the following: 
• Regular aggregation rows that would be produced by GROUP BY without using ROLLUP. 
• First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc. 
• Second-level subtotals aggregating 
across calendar_month_desc and country_id for each channel_desc value. 
• It does not produce a grand total row.
--*******************************************************************************
SELECT calendar_month_desc,countries.country_iso_code,channels.channel_desc,sum(amount_sold)sales$
	from sales,channels,countries,customers,times
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND countries.country_iso_code in ('US','GB')
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09','2000-10')
	GROUP BY channel_desc,ROLLUP(countries.country_iso_code,times.calendar_month_desc);

/*
CALENDAR CO CHANNEL_DESC             SALES$
-------- -- -------------------- ----------
2000-09  GB Internet               16569.36
2000-10  GB Internet               14539.14
         GB Internet                31108.5
2000-09  US Internet              124223.75
2000-10  US Internet              137054.29
         US Internet              261278.04
            Internet              292386.54
2000-09  GB Direct Sales           85222.92
2000-10  GB Direct Sales           91925.43
         GB Direct Sales          177148.35
2000-09  US Direct Sales          638200.81

CALENDAR CO CHANNEL_DESC             SALES$
-------- -- -------------------- ----------
2000-10  US Direct Sales          682296.59
         US Direct Sales          1320497.4
            Direct Sales         1497645.75

14 rows selected.
*/

--*******************************************************************************
Q5. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using PARTIAL CUBE aggregation on month and country code and GROUP BY on channel_desc.
--*******************************************************************************

SELECT calendar_month_desc,countries.country_iso_code,channels.channel_desc,sum(amount_sold)sales$
	from sales,channels,countries,customers,times
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND countries.country_iso_code in ('US','GB')
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09','2000-10')
	GROUP BY channel_desc,cube(countries.country_iso_code,times.calendar_month_desc);
/*
CALENDAR CO CHANNEL_DESC             SALES$
-------- -- -------------------- ----------
            Internet              292386.54
2000-09     Internet              140793.11
2000-10     Internet              151593.43
         GB Internet                31108.5
2000-09  GB Internet               16569.36
2000-10  GB Internet               14539.14
         US Internet              261278.04
2000-09  US Internet              124223.75
2000-10  US Internet              137054.29
            Direct Sales         1497645.75
2000-09     Direct Sales          723423.73

CALENDAR CO CHANNEL_DESC             SALES$
-------- -- -------------------- ----------
2000-10     Direct Sales          774222.02
         GB Direct Sales          177148.35
2000-09  GB Direct Sales           85222.92
2000-10  GB Direct Sales           91925.43
         US Direct Sales          1320497.4
2000-09  US Direct Sales          638200.81
2000-10  US Direct Sales          682296.59

18 rows selected.
*/

--*******************************************************************************
Q6. Use GROUPING to create a set of mask columns for the result set of Q1. 
• Create grouping on channel_desc and name it as CH 
• Create grouping calendar_month_desc and name it as MO 
• Create grouping on country_iso_code and name it as CO
--*******************************************************************************

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, 
SUM(amount_sold) SALES$ ,
GROUPING(channels.channel_desc)AS CH,
GROUPING(TIMES.CALENDAR_MONTH_DESC)AS MO,
GROUPING(COUNTRIES.COUNTRY_ISO_CODE)AS CO
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
CHANNEL_DESC         CALENDAR CO     SALES$         CH         MO         CO
-------------------- -------- -- ---------- ---------- ---------- ----------
Internet             2000-09  GB   16569.36          0          0          0
Internet             2000-09  US  124223.75          0          0          0
Internet             2000-09      140793.11          0          0          1
Internet             2000-10  GB   14539.14          0          0          0
Internet             2000-10  US  137054.29          0          0          0
Internet             2000-10      151593.43          0          0          1
Internet                          292386.54          0          1          1
Direct Sales         2000-09  GB   85222.92          0          0          0
Direct Sales         2000-09  US  638200.81          0          0          0
Direct Sales         2000-09      723423.73          0          0          1
Direct Sales         2000-10  GB   91925.43          0          0          0

CHANNEL_DESC         CALENDAR CO     SALES$         CH         MO         CO
-------------------- -------- -- ---------- ---------- ---------- ----------
Direct Sales         2000-10  US  682296.59          0          0          0
Direct Sales         2000-10      774222.02          0          0          1
Direct Sales                     1497645.75          0          1          1
                                 1790032.29          1          1          1

15 rows selected
*/

--*******************************************************************************
Q7. Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales in September 2000 and October 2009 using GROUPING SETS. 
Calculate aggregates over three groupings: 
• (channel_desc, calendar_month_desc, country_iso_code) 
• (channel_desc, country_iso_code) 
• (calendar_month_desc, country_iso_code)
--*******************************************************************************
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
	GROUP BY
	GROUPING SETS((channel_desc,calendar_month_desc,country_iso_code),(channel_desc,country_iso_code),(calendar_month_desc,country_iso_code));

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

--*******************************************************************************
Q.8 Perform aggregation on amount sold. It should get aggregated by month first, then by all the months in each quarter, and then across all
months and quarters in the year.
--*******************************************************************************

SELECT times.calendar_month_desc as months,times.calendar_quarter_desc as quarter ,times.calendar_year as years ,sum(amount_sold) as sales$  
FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_year in('1999') 
	AND countries.country_iso_code IN ('GB', 'US') 
	GROUP BY ROLLUP( calendar_year,calendar_quarter_desc,calendar_month_desc); 	

/*
MONTHS   QUARTER      YEARS     SALES$
-------- ------- ---------- ----------
1999-01  1999-01       1999  974627.95
1999-02  1999-01       1999 1089255.92
1999-03  1999-01       1999   754026.7
         1999-01       1999 2817910.57
1999-04  1999-02       1999  708060.57
1999-05  1999-02       1999  818055.52
1999-06  1999-02       1999  729677.52
         1999-02       1999 2255793.61
1999-07  1999-03       1999  893452.47
1999-08  1999-03       1999  883460.92
1999-09  1999-03       1999  923577.01

MONTHS   QUARTER      YEARS     SALES$
-------- ------- ---------- ----------
         1999-03       1999  2700490.4
1999-10  1999-04       1999  715831.36
1999-11  1999-04       1999  742248.42
1999-12  1999-04       1999  841572.17
         1999-04       1999 2299651.95
                       1999 10073846.5
                            10073846.5

18 rows selected.*/

--*******************************************************************************
Q.9 Implement concatenated rollup. First roll up on (channel_total, channel_class) 
and second roll up on(country_region and country_iso_code)
--*******************************************************************************
SELECT channels.channel_total,channels.channel_class,countries.country_region,countries.country_iso_code, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id  
	AND times.calendar_month_desc IN ('2001-09', '2001-10') 
	AND countries.country_iso_code IN ('GB', 'US') 
	GROUP BY  
	ROLLUP(channels.channel_total,channels.channel_class),ROLLUP(countries.country_region,countries.country_iso_code);

/*
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
                                   Europe               GB        321,244
                                   Europe                         321,244
                                   Americas             US      2,603,473
                                   Americas                     2,603,473
                                                                2,924,717
Channel total                      Europe               GB        321,244
Channel total                      Europe                         321,244
Channel total                      Americas             US      2,603,473
Channel total                      Americas                     2,603,473
Channel total                                                   2,924,717
Channel total Direct               Europe               GB        168,161

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
Channel total Direct               Europe                         168,161
Channel total Direct               Americas             US      1,187,918
Channel total Direct               Americas                     1,187,918
Channel total Direct                                            1,356,079
Channel total Others               Europe               GB         77,265
Channel total Others               Europe                          77,265
Channel total Others               Americas             US        729,606
Channel total Others               Americas                       729,606
Channel total Others                                              806,872
Channel total Indirect             Europe               GB         75,817
Channel total Indirect             Europe                          75,817

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- --------------
Channel total Indirect             Americas             US        685,949
Channel total Indirect             Americas                       685,949
Channel total Indirect                                            761,766

25 rows selected.
*/
--*******************************************************************************
Q10. Consider the following Query and make conclusion from the result obtained.
--*******************************************************************************
Query: (scott Schema) 
SELECT deptno, job, SUM(sal) FROM emp 
GROUP BY CUBE(deptno, job);

/*
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

18 rows selected.*/

--*******************************************************************************
Q11. Find the total sales by country name and channel_desc for the country name starting from U through
 the Internet and direct sales in September 2000 and October.
--*******************************************************************************

SELECT channels.channel_desc, calendar_month_desc, countries.country_name, 
TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$ 
FROM sales, customers, times, channels, countries 
	WHERE sales.time_id=times.time_id 
	AND sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id 
	AND sales.channel_id = channels.channel_id 
	AND channels.channel_desc IN ('Direct Sales', 'Internet') 
	AND times.calendar_month_desc IN ('2000-09', '2000-10') 
	AND countries.country_name like 'U%'
	GROUP BY  
	ROLLUP(channels.channel_desc, calendar_month_desc, countries.country_name);

/*

CHANNEL_DESC         CALENDAR COUNTRY_NAME                  SALES$
-------------------- -------- --------------------------- --------------
Internet             2000-09  United Kingdom                  16,569
Internet             2000-09  United States of America        124,224
Internet             2000-09                                  140,793
Internet             2000-10  United Kingdom                  14,539
Internet             2000-10  United States of America        137,054
Internet             2000-10                                  151,593
Internet                                                      292,387
Direct Sales         2000-09  United Kingdom                 85,223
Direct Sales         2000-09  United States of America        638,201
Direct Sales         2000-09                                   723,424
Direct Sales         2000-10  United Kingdom                   91,925

CHANNEL_DESC         CALENDAR COUNTRY_NAME                   SALES$
-------------------- -------- ----------------------------- --------------
Direct Sales         2000-10  United States of America          682,297
Direct Sales         2000-10                                    774,222
Direct Sales                                                    1,497,646
                                                                1,790,032

15 rows selected.*/

--*******************************************************************************
Q12. Analyze the output
--*******************************************************************************

SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code, 
SUM(s.amount_sold) sum_amount_sold, GROUPING_ID( ch.channel_desc, t.calendar_month_desc, co.country_iso_code) grouping_id 
FROM sales s, customers cu, times t, channels ch, countries co 
	WHERE s.time_id=t.time_id 
	AND s.cust_id=cu.cust_id 
	AND cu.country_id = co.country_id 
	AND s.channel_id = ch.channel_id 
	AND ch.channel_desc IN ('Direct Sales', 'Internet') 
	AND t.calendar_month_desc IN ('2001-09', '2001-10') 
	AND co.country_iso_code IN ('GB', 'US') 
	GROUP BY ROLLUP( ch.channel_desc, t.calendar_month_desc, co.country_iso_code);
	
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

CHANNEL_DESC         CALENDAR CO SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- --------------- -----------
Direct Sales         2001-10  US        566719.8           0
Direct Sales         2001-10           642016.24           1
Direct Sales                          1356079.22           3
                                      2117845.22           7

15 rows selected.
 
It tells about how many dimensions are considered for calculating the GRAND TOTAL by calculating the decimal value of binary no. of dimensions.
i.e. here,(111) in binary is 7 which implies -> all 3 dimensions are considered.
 */
