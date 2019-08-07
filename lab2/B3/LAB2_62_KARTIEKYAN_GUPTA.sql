--Q1. Find the total sales by country_id and channel_desc for the US and GB through
--the Internet and direct sales in September 2000 and October 2000 using ROLL-UP
--Extension. The query should return the following:
-- 1 .The aggregation rows that would be produced by GROUP BY ,
-- 2 .The First-level subtotals aggregating across country_id for each combination
--    of channel_desc and calendar_month.
-- 3 .Second-level subtotals aggregating
--    across calendar_month_desc and country_id for each channel_desc value.
-- 4 .A grand total row.
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);

-----OUTPUT

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

--Q2. Find the total sales by country_id and channel_desc for the US and GB through
--    the Internet and direct sales in September 2000 and October 2009 using
--    CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
--    countries.country_iso_code.
---------------------------------------------------------------------------------------------------------------------------------------------

SELECT countries.country_iso_code,channels.channel_desc,calendar_month_desc,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('FR')
	GROUP BY CUBE(channels.channel_desc, calendar_month_desc,countries.country_iso_code);

---OUTPUT

CO CHANNEL_DESC         CALENDAR SALES$
-- -------------------- -------- --------------
                                      1,790,032
GB                                      208,257
US                                    1,581,775
                        2000-09         864,217
GB                      2000-09         101,792
US                      2000-09         762,425
                        2000-10         925,815
GB                      2000-10         106,465
US                      2000-10         819,351
   Internet                             292,387
GB Internet                              31,109

CO CHANNEL_DESC         CALENDAR SALES$
-- -------------------- -------- --------------
US Internet                             261,278
   Internet             2000-09         140,793
GB Internet             2000-09          16,569
US Internet             2000-09         124,224
   Internet             2000-10         151,593
GB Internet             2000-10          14,539
US Internet             2000-10         137,054
   Direct Sales                       1,497,646
GB Direct Sales                         177,148
US Direct Sales                       1,320,497
   Direct Sales         2000-09         723,424

CO CHANNEL_DESC         CALENDAR SALES$
-- -------------------- -------- --------------
GB Direct Sales         2000-09          85,223
US Direct Sales         2000-09         638,201
   Direct Sales         2000-10         774,222
GB Direct Sales         2000-10          91,925
US Direct Sales         2000-10         682,297

27 rows selected.

--Q3. Find the total sales by country_iso and channel_desc for the US and France
--    through the Internet and direct sales in September 2000
-----------------------------------------------------------------------------------------------------------------------------------

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09')
	AND countries.country_iso_code IN ('FR', 'US')
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);

--OUTPUT

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- --------------
Internet             2000-09  FR          9,597
Internet             2000-09  US        124,224
Internet             2000-09            133,821
Internet                                133,821
Direct Sales         2000-09  FR         61,202
Direct Sales         2000-09  US        638,201
Direct Sales         2000-09            699,403
Direct Sales                            699,403
                                        833,224
										

--Q4. Find the total sales by country_id and channel_desc for the US and GB through
--    the Internet and direct sales in September 2000 and October 2000 using PARTIAL
--    ROLL-UP. The query should return the following:

--     1. Regular aggregation rows that would be produced by GROUP BY without
--        using ROLLUP.
--     2. First-level subtotals aggregating across country_id for each combination
--        of channel_desc and calendar_month_desc.
--     3. Second-level subtotals aggregating
--        across calendar_month_desc and country_id for each channel_desc value.
--     4. It does not produce a grand total row.

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09','2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY channels.channel_desc,ROLLUP(calendar_month_desc,countries.country_iso_code);
	
--OUTPUT
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

--Q5. Find the total sales by country_id and channel_desc for the US and GB through
--    the Internet and direct sales in September 2000 and October 2009 using PARTIAL
---   CUBE aggregation on month and country code and GROUP BY on channel_desc.

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09','2000-10')
	AND countries.country_iso_code IN ('GB', 'US')
	GROUP BY channels.channel_desc,CUBE(calendar_month_desc,countries.country_iso_code);

--OUTPUT
	
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

--Q6. Use GROUPING to create a set of mask columns for the result set of Q1.
--    1. Create grouping on channel_desc and name it as CH
--    2. Create grouping calendar_month_desc and name it as MO
--    3. Create grouping on country_iso_code and name it as CO

-------

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,
	GROUPING(channels.channel_desc) AS CH, 
	GROUPING(calendar_month_desc) AS  MO,
	GROUPING(countries.country_iso_code) AS CO,
	TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US') 
	GROUP BY ROLLUP(channels.channel_desc, calendar_month_desc,countries.country_iso_code);
	
--OUTPUT

CHANNEL_DESC         CALENDAR CO         CH         MO         CO SALES$
-------------------- -------- -- ---------- ---------- ---------- --------------
Internet             2000-09  GB          0          0          0         16,569
Internet             2000-09  US          0          0          0        124,224
Internet             2000-09              0          0          1        140,793
Internet             2000-10  GB          0          0          0         14,539
Internet             2000-10  US          0          0          0        137,054
Internet             2000-10              0          0          1        151,593
Internet                                  0          1          1        292,387
Direct Sales         2000-09  GB          0          0          0         85,223
Direct Sales         2000-09  US          0          0          0        638,201
Direct Sales         2000-09              0          0          1        723,424
Direct Sales         2000-10  GB          0          0          0         91,925

CHANNEL_DESC         CALENDAR CO         CH         MO         CO SALES$
-------------------- -------- -- ---------- ---------- ---------- --------------
Direct Sales         2000-10  US          0          0          0        682,297
Direct Sales         2000-10              0          0          1        774,222
Direct Sales                              0          1          1      1,497,646
                                          1          1          1      1,790,032
								
---Q7. Find the total sales by country_id and channel_desc for the US and GB through
--     the Internet and direct sales in September 2000 and October 2000 using GROUPING
--     SETS.
--     Calculate aggregates over three groupings:
--     1. (channel_desc, calendar_month_desc, country_iso_code)
--     2. (channel_desc, country_iso_code)
--     3. (calendar_month_desc, country_iso_code)

SELECT channels.channel_desc, calendar_month_desc,countries.country_iso_code,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	AND countries.country_iso_code IN ('GB', 'US') 
	GROUP BY GROUPING SETS((channels.channel_desc, calendar_month_desc,countries.country_iso_code),(channels.channel_desc,countries.country_iso_code),(calendar_month_desc,countries.country_iso_code));
	
--OUTPUT
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

--Q: 8 Perform aggregation on amount sold. It should get aggregated by month first,
--     then by all the months in each quarter, and then across all months and quarters in
--     the year.

SELECT calendar_month_desc,calendar_quarter_desc,calendar_year,TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales,times
	WHERE sales.time_id=times.time_id
	AND times.calendar_year IN ('1999') 
	GROUP BY ROLLUP(calendar_year,calendar_quarter_desc,calendar_month_desc);
	
--OUTPUT
CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
1999-01  1999-01          1999      2,077,440
1999-02  1999-01          1999      2,357,629
1999-03  1999-01          1999      1,658,678
         1999-01          1999      6,093,747
1999-04  1999-02          1999      1,573,273
1999-05  1999-02          1999      1,711,728
1999-06  1999-02          1999      1,640,471
         1999-02          1999      4,925,472
1999-07  1999-03          1999      1,891,216
1999-08  1999-03          1999      1,904,917
1999-09  1999-03          1999      2,030,918

CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- --------------
         1999-03          1999      5,827,050
1999-10  1999-04          1999      1,722,615
1999-11  1999-04          1999      1,719,132
1999-12  1999-04          1999      1,931,931
         1999-04          1999      5,373,679
                          1999     22,219,948
                                   22,219,948

18 rows selected.

--Q: 9 Implement concatenated rollup. First roll up on (channel_total,channel_class)
--     and second roll up on(country_region and country_iso_code)

-----

SELECT channels.channel_total, channels.channel_class,countries.country_iso_code,countries.country_region, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, channels, countries , customers
	WHERE sales.cust_id=customers.cust_id 
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	GROUP BY ROLLUP(channels.channel_total,channels.channel_class),
			 ROLLUP(countries.country_region,countries.country_iso_code);
			 
--OUTPUT

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
                                   CN Asia                          3,828
                                   JP Asia                      7,207,880
                                   SG Asia                      3,063,094
                                      Asia                     10,274,802
                                   DE Europe                    9,210,129
                                   DK Europe                    1,977,765
                                   ES Europe                    2,090,863
                                   FR Europe                    3,776,270
                                   GB Europe                    6,393,763
                                   IT Europe                    4,854,505
                                   PL Europe                        8,447

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
                                   TR Europe                        7,837
                                      Europe                   28,319,580
                                   AU Oceania                   3,962,293
                                   NZ Oceania                         271
                                      Oceania                   3,962,564
                                   AR Americas                     14,647
                                   BR Americas                     36,052
                                   CA Americas                  2,686,510
                                   US Americas                 52,910,773
                                      Americas                 55,647,982
                                   SA Middle East                     904

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
                                      Middle East                     904
                                                               98,205,831
Channel total                      CN Asia                          3,828
Channel total                      JP Asia                      7,207,880
Channel total                      SG Asia                      3,063,094
Channel total                         Asia                     10,274,802
Channel total                      DE Europe                    9,210,129
Channel total                      DK Europe                    1,977,765
Channel total                      ES Europe                    2,090,863
Channel total                      FR Europe                    3,776,270
Channel total                      GB Europe                    6,393,763

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total                      IT Europe                    4,854,505
Channel total                      PL Europe                        8,447
Channel total                      TR Europe                        7,837
Channel total                         Europe                   28,319,580
Channel total                      AU Oceania                   3,962,293
Channel total                      NZ Oceania                         271
Channel total                         Oceania                   3,962,564
Channel total                      AR Americas                     14,647
Channel total                      BR Americas                     36,052
Channel total                      CA Americas                  2,686,510
Channel total                      US Americas                 52,910,773

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total                         Americas                 55,647,982
Channel total                      SA Middle East                     904
Channel total                         Middle East                     904
Channel total                                                  98,205,831
Channel total Direct               CN Asia                          2,528
Channel total Direct               JP Asia                      3,903,727
Channel total Direct               SG Asia                      1,412,645
Channel total Direct                  Asia                      5,318,900
Channel total Direct               DE Europe                    6,239,351
Channel total Direct               DK Europe                    1,199,141
Channel total Direct               ES Europe                    1,270,651

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Direct               FR Europe                    2,501,284
Channel total Direct               GB Europe                    4,219,313
Channel total Direct               IT Europe                    3,101,710
Channel total Direct               PL Europe                        4,516
Channel total Direct               TR Europe                        7,364
Channel total Direct                  Europe                   18,543,330
Channel total Direct               AU Oceania                   2,431,280
Channel total Direct               NZ Oceania                         271
Channel total Direct                  Oceania                   2,431,551
Channel total Direct               AR Americas                     12,118
Channel total Direct               BR Americas                     24,242

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Direct               CA Americas                  1,405,682
Channel total Direct               US Americas                 30,416,235
Channel total Direct                  Americas                 31,858,277
Channel total Direct               SA Middle East                     629
Channel total Direct                  Middle East                     629
Channel total Direct                                           58,152,687
Channel total Others               CN Asia                            629
Channel total Others               JP Asia                      2,220,157
Channel total Others               SG Asia                      1,103,805
Channel total Others                  Asia                      3,324,591
Channel total Others               DE Europe                    1,919,360

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Others               DK Europe                      522,065
Channel total Others               ES Europe                      529,556
Channel total Others               FR Europe                      861,838
Channel total Others               GB Europe                    1,487,899
Channel total Others               IT Europe                    1,084,070
Channel total Others               PL Europe                        1,930
Channel total Others               TR Europe                          432
Channel total Others                  Europe                    6,407,151
Channel total Others               AU Oceania                     952,581
Channel total Others                  Oceania                     952,581
Channel total Others               AR Americas                         17

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Others               BR Americas                      7,021
Channel total Others               CA Americas                    850,966
Channel total Others               US Americas                 14,804,016
Channel total Others                  Americas                 15,662,020
Channel total Others                                           26,346,342
Channel total Indirect             CN Asia                            671
Channel total Indirect             JP Asia                      1,083,996
Channel total Indirect             SG Asia                        546,644
Channel total Indirect                Asia                      1,631,311
Channel total Indirect             DE Europe                    1,051,419
Channel total Indirect             DK Europe                      256,559

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Indirect             ES Europe                      290,656
Channel total Indirect             FR Europe                      413,148
Channel total Indirect             GB Europe                      686,552
Channel total Indirect             IT Europe                      668,725
Channel total Indirect             PL Europe                        2,001
Channel total Indirect             TR Europe                           41
Channel total Indirect                Europe                    3,369,099
Channel total Indirect             AU Oceania                     578,433
Channel total Indirect                Oceania                     578,433
Channel total Indirect             AR Americas                      2,512
Channel total Indirect             BR Americas                      4,789

CHANNEL_TOTAL CHANNEL_CLASS        CO COUNTRY_REGION       SALES$
------------- -------------------- -- -------------------- --------------
Channel total Indirect             CA Americas                    429,862
Channel total Indirect             US Americas                  7,690,522
Channel total Indirect                Americas                  8,127,684
Channel total Indirect             SA Middle East                     275
Channel total Indirect                Middle East                     275
Channel total Indirect                                         13,706,802

116 rows selected.

---Q11. Find the total sales by country name and channel_desc for the country name
--      starting from U through the Internet and direct sales in September 2000 and October.
	
--------

SELECT channels.channel_desc,countries.country_name,countries.country_iso_code, TO_CHAR(SUM(amount_sold), '9,999,999,999') SALES$
	from  sales, customers, times, channels, countries
	WHERE sales.time_id=times.time_id
	AND sales.cust_id=customers.cust_id
	AND customers.country_id = countries.country_id
	AND sales.channel_id = channels.channel_id
	AND channels.channel_desc IN ('Direct Sales', 'Internet')
	AND times.calendar_month_desc IN ('2000-09', '2000-10')
	GROUP BY ROLLUP(channels.channel_desc,countries.country_name),countries.country_iso_code
	ORDER BY SUM(amount_sold);
	
--OUTPUT
CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
Direct Sales         Brazil                                   BR              8
                                                              BR              8
Direct Sales                                                  BR              8
Internet                                                      DK          7,938
Internet             Denmark                                  DK          7,938
Internet             Spain                                    ES          9,412
Internet                                                      ES          9,412
Internet                                                      AU         12,903
Internet             Australia                                AU         12,903
Internet             Canada                                   CA         13,548
Internet                                                      CA         13,548

CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
Internet             France                                   FR         14,988
Internet                                                      FR         14,988
Internet                                                      SG         17,727
Internet             Singapore                                SG         17,727
Internet             Italy                                    IT         20,602
Internet                                                      IT         20,602
Internet             United Kingdom                           GB         31,109
Internet                                                      GB         31,109
Internet             Germany                                  DE         36,865
Internet                                                      DE         36,865
Internet             Japan                                    JP         41,109

CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
Internet                                                      JP         41,109
Direct Sales                                                  DK         49,108
Direct Sales         Denmark                                  DK         49,108
Direct Sales                                                  SG         50,862
Direct Sales         Singapore                                SG         50,862
Direct Sales                                                  CA         52,323
Direct Sales         Canada                                   CA         52,323
                                                              DK         57,046
Direct Sales         Spain                                    ES         57,066
Direct Sales                                                  ES         57,066
                                                              CA         65,871

CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
                                                              ES         66,478
                                                              SG         68,589
Direct Sales                                                  AU         97,053
Direct Sales         Australia                                AU         97,053
Direct Sales                                                  FR        105,360
Direct Sales         France                                   FR        105,360
Direct Sales                                                  IT        106,736
Direct Sales         Italy                                    IT        106,736
                                                              AU        109,956
                                                              FR        120,347
                                                              IT        127,338

CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
Direct Sales         Japan                                    JP        152,695
Direct Sales                                                  JP        152,695
Direct Sales         United Kingdom                           GB        177,148
Direct Sales                                                  GB        177,148
                                                              JP        193,803
                                                              GB        208,257
Internet                                                      US        261,278
Internet             United States of America                 US        261,278
Direct Sales         Germany                                  DE        274,536
Direct Sales                                                  DE        274,536
                                                              DE        311,401

CHANNEL_DESC         COUNTRY_NAME                             CO SALES$
-------------------- ---------------------------------------- -- --------------
Direct Sales         United States of America                 US      1,320,497
Direct Sales                                                  US      1,320,497
                                                              US      1,581,775

58 rows selected.
	
--OUTPUT

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

--Q12. Analyze the output
SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code,co.country_name,SUM(s.amount_sold) sum_amount_sold,
GROUPING_ID(ch.channel_desc,t.calendar_month_desc,co.country_iso_code,co.country_name) group_id
FROM sales s,customers cu,times t,channels ch,countries co
WHERE s.time_id=t.time_id 
AND s.cust_id=cu.cust_id 
AND cu.country_id = co.country_id 
AND s.channel_id = ch.channel_id 
AND ch.channel_desc IN ('Direct Sales', 'Internet') 
AND t.calendar_month_desc IN ('2001-09', '2001-10') 
AND co.country_iso_code IN ('GB', 'US')
GROUP BY ROLLUP(ch.channel_desc,t.calendar_month_desc,co.country_iso_code,co.country_name);

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Internet             2001-09  GB United Kingdom                                  36806.73           0
Internet             2001-09  GB                                                 36806.73           1
Internet             2001-09  US United States of America                       299621.96           0
Internet             2001-09  US                                                299621.96           1
Internet             2001-09                                                    336428.69           3
Internet             2001-10  GB United Kingdom                                  39010.76           0
Internet             2001-10  GB                                                 39010.76           1
Internet             2001-10  US United States of America                       386326.55           0
Internet             2001-10  US                                                386326.55           1
Internet             2001-10                                                    425337.31           3
Internet                                                                           761766           7

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
Direct Sales         2001-09  GB United Kingdom                                  92865.04           0
Direct Sales         2001-09  GB                                                 92865.04           1
Direct Sales         2001-09  US United States of America                       621197.94           0
Direct Sales         2001-09  US                                                621197.94           1
Direct Sales         2001-09                                                    714062.98           3
Direct Sales         2001-10  GB United Kingdom                                  75296.44           0
Direct Sales         2001-10  GB                                                 75296.44           1
Direct Sales         2001-10  US United States of America                        566719.8           0
Direct Sales         2001-10  US                                                 566719.8           1
Direct Sales         2001-10                                                    642016.24           3
Direct Sales                                                                   1356079.22           7

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUPING_ID
-------------------- -------- -- ---------------------------------------- --------------- -----------
                                                                               2117845.22          15

23 rows selected.


SELECT ch.channel_desc, t.calendar_month_desc, co.country_iso_code,co.country_name,SUM(s.amount_sold) sum_amount_sold,group_id() 
FROM sales s,customers cu,times t,channels ch,countries co
WHERE s.time_id=t.time_id 
AND s.cust_id=cu.cust_id 
AND cu.country_id = co.country_id 
AND s.channel_id = ch.channel_id 
AND ch.channel_desc IN ('Direct Sales', 'Internet') 
AND t.calendar_month_desc IN ('2001-09', '2001-10') 
AND co.country_iso_code IN ('GB', 'US')
GROUP BY ROLLUP(ch.channel_desc,t.calendar_month_desc,co.country_iso_code,co.country_name,co.country_name)
ORDER BY group_id();

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUP_ID()
-------------------- -------- -- ---------------------------------------- --------------- ----------
Internet             2001-10                                                    425337.31          0
Direct Sales         2001-10                                                    642016.24          0
Direct Sales         2001-10  US United States of America                        566719.8          0
Direct Sales         2001-10  GB United Kingdom                                  75296.44          0
Direct Sales         2001-09  US United States of America                       621197.94          0
Direct Sales         2001-09  GB United Kingdom                                  92865.04          0
Internet             2001-10  US United States of America                       386326.55          0
Internet             2001-10  GB United Kingdom                                  39010.76          0
Internet             2001-09  US United States of America                       299621.96          0
Direct Sales         2001-09                                                    714062.98          0
Internet             2001-09                                                    336428.69          0

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUP_ID()
-------------------- -------- -- ---------------------------------------- --------------- ----------
Internet             2001-09  GB                                                 36806.73          0
Internet             2001-09  US                                                299621.96          0
Internet             2001-10  GB                                                 39010.76          0
Internet             2001-10  US                                                386326.55          0
Internet                                                                           761766          0
Direct Sales         2001-09  GB                                                 92865.04          0
Direct Sales         2001-09  US                                                621197.94          0
Direct Sales         2001-10  GB                                                 75296.44          0
Direct Sales         2001-10  US                                                 566719.8          0
Direct Sales                                                                   1356079.22          0
                                                                               2117845.22          0

CHANNEL_DESC         CALENDAR CO COUNTRY_NAME                             SUM_AMOUNT_SOLD GROUP_ID()
-------------------- -------- -- ---------------------------------------- --------------- ----------
Internet             2001-09  GB United Kingdom                                  36806.73          0
Direct Sales         2001-10  GB United Kingdom                                  75296.44          1
Direct Sales         2001-09  US United States of America                       621197.94          1
Direct Sales         2001-09  GB United Kingdom                                  92865.04          1
Internet             2001-10  US United States of America                       386326.55          1
Internet             2001-10  GB United Kingdom                                  39010.76          1
Internet             2001-09  US United States of America                       299621.96          1
Internet             2001-09  GB United Kingdom                                  36806.73          1
Direct Sales         2001-10  US United States of America                        566719.8          1

31 rows selected.

--Q10. Consider the following Query and make conclusion from the result obtained.
--Query: (scott Schema)
SELECT deptno, job, SUM(sal)
	FROM emp
	GROUP BY CUBE(deptno, job);

--OUTPUT
	
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
