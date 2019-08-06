
PRACTICAL -2
/*
AIM : Write and Execute SQL aggregation queries for data warehouse.
*/

/*
NAME: MANMEET GANDHI
BATCH : B3
ROLL NO: 66
*/

SELECT *
FROM SALES
WHERE ROWNUM<10;
/*
   PROD_ID    CUST_ID TIME_ID   CHANNEL_ID   PROMO_ID QUANTITY_SOLD AMOUNT_SOLD
---------- ---------- --------- ---------- ---------- ------------- -----------
        13        987 10-JAN-98          3        999             1     1232.16
        13       1660 10-JAN-98          3        999             1     1232.16
        13       1762 10-JAN-98          3        999             1     1232.16
        13       1843 10-JAN-98          3        999             1     1232.16
        13       1948 10-JAN-98          3        999             1     1232.16
        13       2273 10-JAN-98          3        999             1     1232.16
        13       2380 10-JAN-98          3        999             1     1232.16
        13       2683 10-JAN-98          3        999             1     1232.16
        13       2865 10-JAN-98          3        999             1     1232.16
*/


-- Q-1 :
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and
 direct sales in September 2000 and October 2000 using ROLL-UP Extension. 
 The query should return the following:
 1. The aggregation rows that would be produced by GROUP BY
 2. The First-level subtotals aggregating across country_id for
		each combination of channel_desc and calendar_month.
 3. Second-level subtotals aggregating
		across calendar_month_desc and country_id for each channel_desc value.
 4. A grand total row.
*/

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
        COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE);

--OUTPUT(Q1):
CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- ------------------
Internet             2000-09  GB         16,569.360
Internet             2000-09  US        124,223.750
Internet             2000-09            140,793.110
Internet             2000-10  GB         14,539.140
Internet             2000-10  US        137,054.290
Internet             2000-10            151,593.430
Internet                                292,386.540
Direct Sales         2000-09  GB         85,222.920
Direct Sales         2000-09  US        638,200.810
Direct Sales         2000-09            723,423.730
Direct Sales         2000-10  GB         91,925.430

CHANNEL_DESC         CALENDAR CO SALES$
-------------------- -------- -- ------------------
Direct Sales         2000-10  US        682,296.590
Direct Sales         2000-10            774,222.020
Direct Sales                          1,497,645.750
                                      1,790,032.290


-- Q-2:
/*
Find the total sales by country_id and channel_desc for the US and GB through
the Internet and direct sales in September 2000 and October 2009 using
CUBE aggregation across three dimensions- channel_desc, calendar_month_desc,
 countries.country_iso_code.
*/

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
        COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999') TOTAL_SALES
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND UPPER(CHANNELS.CHANNEL_DESC) IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND UPPER(COUNTRIES.COUNTRY_ISO_CODE) IN ('GB', 'US')
GROUP BY 
		CUBE(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE);

--OUTPUT(Q2):
CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- ------------------
                                 1,790,032.290
                         GB        208,256.850
                         US      1,581,775.440
                2000-09            864,216.840
                2000-09  GB        101,792.280
                2000-09  US        762,424.560
                2000-10            925,815.450
                2000-10  GB        106,464.570
                2000-10  US        819,350.880
Internet                           292,386.540
Internet                 GB         31,108.500

CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- ------------------
Internet                 US        261,278.040
Internet        2000-09            140,793.110
Internet        2000-09  GB         16,569.360
Internet        2000-09  US        124,223.750
Internet        2000-10            151,593.430
Internet        2000-10  GB         14,539.140
Internet        2000-10  US        137,054.290
Direct Sales                     1,497,645.750
Direct Sales             GB        177,148.350
Direct Sales             US      1,320,497.400
Direct Sales    2000-09            723,423.730

CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- ------------------
Direct Sales    2000-09  GB         85,222.920
Direct Sales    2000-09  US        638,200.810
Direct Sales    2000-10            774,222.020
Direct Sales    2000-10  GB         91,925.430
Direct Sales    2000-10  US        682,296.590


-- Q-3:
/*
Find the total sales by country_iso and channel_desc for the US and 
France through the Internet and direct sales in September 2000
*/

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
		ROLLUP(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE);

--OUTPUT(Q3):
CHANNEL_DESC         CO TOTAL_SALES
-------------------- -- --------------
Internet             FR          9,597
Internet             US        124,224
Internet                       133,821
Direct Sales         FR         61,202
Direct Sales         US        638,201
Direct Sales                   699,403
                               833,224


-- Q-4:
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and 
direct sales in September 2000 and October 2009 using PARTIAL ROLL-UP.
The query should return the following:
	1.Regular aggregation rows that would be produced by GROUP BY without using ROLLUP.
	2.First-level subtotals aggregating across country_id for each combination of channel_desc and calendar_month_desc.
	3.Second-level subtotals aggregating across calendar_month_desc and country_id for each channel_desc value.
	4.It does not produce a grand total row.
*/

SELECT CHANNELS.CHANNEL_DESC,
        COUNTRIES.COUNTRY_ISO_CODE, CALENDAR_MONTH_DESC,
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

--OUTPUT(Q4):
CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
Internet        2000-09  GB         16,569.36
Internet        2000-09  US        124,223.75
Internet        2000-09            140,793.11
Internet        2000-10  GB         14,539.14
Internet        2000-10  US        137,054.29
Internet        2000-10            151,593.43
Internet                           292,386.54
Direct Sales    2000-09  GB         85,222.92
Direct Sales    2000-09  US        638,200.81
Direct Sales    2000-09            723,423.73
Direct Sales    2000-10  GB         91,925.43

CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
Direct Sales    2000-10  US        682,296.59
Direct Sales    2000-10            774,222.02
Direct Sales                     1,497,645.75

-- Q-5:
/*
Find the total sales by country_id and channel_desc for the US and GB through the Internet and direct sales
 in September 2000 and October 2009 using PARTIAL CUBE aggregation on month
 and country code and GROUP BY on channel_desc.
*/

SELECT CHANNELS.CHANNEL_DESC,
        COUNTRIES.COUNTRY_ISO_CODE, CALENDAR_MONTH_DESC,
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
		CHANNELS.CHANNEL_DESC  , CUBE  (COUNTRIES.COUNTRY_ISO_CODE,CALENDAR_MONTH_DESC);

--OUTPUT(Q5):
CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
Internet                           292,386.54
Internet                 GB         31,108.50
Internet                 US        261,278.04
Internet        2000-09            140,793.11
Internet        2000-09  GB         16,569.36
Internet        2000-09  US        124,223.75
Internet        2000-10            151,593.43
Internet        2000-10  GB         14,539.14
Internet        2000-10  US        137,054.29
Direct Sales                     1,497,645.75
Direct Sales             GB        177,148.35

CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
Direct Sales             US      1,320,497.40
Direct Sales    2000-09            723,423.73
Direct Sales    2000-09  GB         85,222.92
Direct Sales    2000-09  US        638,200.81
Direct Sales    2000-10            774,222.02
Direct Sales    2000-10  GB         91,925.43
Direct Sales    2000-10  US        682,296.59		

-- Q-6:
/*
Use GROUPING to create a set of mask columns for the result set of Q1
	1.Create grouping on channel_desc and name it as CH
	2.Create grouping calendar_month_desc and name it as MO
	3.Create grouping on country_iso_code and name it as CO
*/

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
        COUNTRIES.COUNTRY_ISO_CODE,
        GROUPING(CHANNELS.CHANNEL_DESC) AS CH,
        GROUPING(CALENDAR_MONTH_DESC) AS MO,
        GROUPING(COUNTRIES.COUNTRY_ISO_CODE) AS CO,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE);

--OUTPUT(Q6):
CHANNEL_DESC         CALENDAR CO  CH  MO  CO SALES$
-------------------- -------- -- --- --- --- ------------------
Internet             2000-09  GB   0   0   0         16,569.360
Internet             2000-09  US   0   0   0        124,223.750
Internet             2000-09       0   0   1        140,793.110
Internet             2000-10  GB   0   0   0         14,539.140
Internet             2000-10  US   0   0   0        137,054.290
Internet             2000-10       0   0   1        151,593.430
Internet                           0   1   1        292,386.540
Direct Sales         2000-09  GB   0   0   0         85,222.920
Direct Sales         2000-09  US   0   0   0        638,200.810
Direct Sales         2000-09       0   0   1        723,423.730
Direct Sales         2000-10  GB   0   0   0         91,925.430

CHANNEL_DESC         CALENDAR CO  CH  MO  CO SALES$
-------------------- -------- -- --- --- --- ------------------
Direct Sales         2000-10  US   0   0   0        682,296.590
Direct Sales         2000-10       0   0   1        774,222.020
Direct Sales                       0   1   1      1,497,645.750
                                   1   1   1      1,790,032.290
								   
						  
-- Q-7:
/*
Find the total sales by country_id and channel_desc for the US and GB through 
the Internet and direct sales in September 2000 and October 2009 using GROUPING SETS.
Calculate aggregates over three groupings:
1.(channel_desc, calendar_month_desc, country_iso_code)
2.(channel_desc, country_iso_code)
3.(calendar_month_desc, country_iso_code)
*/

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.99') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID = TIMES.TIME_ID
        AND SALES.CUST_ID = CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('US', 'GB')
GROUP BY 
GROUPING SETS((CHANNELS.CHANNEL_DESC,CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE),
(CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE),
 (CALENDAR_MONTH_DESC, COUNTRIES.COUNTRY_ISO_CODE));

--OUTPUT(Q7):
CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
Internet        2000-09  GB         16,569.36
Direct Sales    2000-09  GB         85,222.92
Internet        2000-09  US        124,223.75
Direct Sales    2000-09  US        638,200.81
Internet        2000-10  GB         14,539.14
Direct Sales    2000-10  GB         91,925.43
Internet        2000-10  US        137,054.29
Direct Sales    2000-10  US        682,296.59
                2000-09  GB        101,792.28
                2000-09  US        762,424.56
                2000-10  GB        106,464.57

CHANNEL_DESC    CALENDAR CO SALES$
--------------- -------- -- -----------------
                2000-10  US        819,350.88
Direct Sales             GB        177,148.35
Internet                 GB         31,108.50
Direct Sales             US      1,320,497.40
Internet                 US        261,278.04

-- Q-8:
/*
Perform aggregation on amount sold. 
It should get aggregated by month first, then by all the months in each quarter, 
and then across all months and quarters in the year.
*/

SELECT CALENDAR_MONTH_DESC, CALENDAR_QUARTER_DESC, CALENDAR_YEAR,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_YEAR IN ('1999')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
        ROLLUP(CALENDAR_YEAR,CALENDAR_QUARTER_DESC,CALENDAR_MONTH_DESC );

--OUTPUT(Q8):
CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- ------------------
1999-01  1999-01          1999        974,627.950
1999-02  1999-01          1999      1,089,255.920
1999-03  1999-01          1999        754,026.700
         1999-01          1999      2,817,910.570
1999-04  1999-02          1999        708,060.570
1999-05  1999-02          1999        818,055.520
1999-06  1999-02          1999        729,677.520
         1999-02          1999      2,255,793.610
1999-07  1999-03          1999        893,452.470
1999-08  1999-03          1999        883,460.920
1999-09  1999-03          1999        923,577.010

CALENDAR CALENDA CALENDAR_YEAR SALES$
-------- ------- ------------- ------------------
         1999-03          1999      2,700,490.400
1999-10  1999-04          1999        715,831.360
1999-11  1999-04          1999        742,248.420
1999-12  1999-04          1999        841,572.170
         1999-04          1999      2,299,651.950
                          1999     10,073,846.530
                                   10,073,846.530

-- Q-9:
/*
Implement concatenated rollup. First roll up on (channel_total, channel_class)
and second roll up on(country_region and country_iso_code)
*/

SELECT CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS,
        COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP(CHANNELS.CHANNEL_TOTAL, CHANNELS.CHANNEL_CLASS),
ROLLUP(COUNTRIES.COUNTRY_REGION, COUNTRIES.COUNTRY_ISO_CODE);

--OUTPUT(Q9):
CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- ------------------
                                   Europe               GB        208,256.850
                                   Europe                         208,256.850
                                   Americas             US      1,581,775.440
                                   Americas                     1,581,775.440
                                                                1,790,032.290
Channel total                      Europe               GB        208,256.850
Channel total                      Europe                         208,256.850
Channel total                      Americas             US      1,581,775.440
Channel total                      Americas                     1,581,775.440
Channel total                                                   1,790,032.290
Channel total Direct               Europe               GB        177,148.350

CHANNEL_TOTAL CHANNEL_CLASS        COUNTRY_REGION       CO SALES$
------------- -------------------- -------------------- -- ------------------
Channel total Direct               Europe                         177,148.350
Channel total Direct               Americas             US      1,320,497.400
Channel total Direct               Americas                     1,320,497.400
Channel total Direct                                            1,497,645.750
Channel total Indirect             Europe               GB         31,108.500
Channel total Indirect             Europe                          31,108.500
Channel total Indirect             Americas             US        261,278.040
Channel total Indirect             Americas                       261,278.040
Channel total Indirect                                            292,386.540


-- Q-10:
/*
Consider the following Query and make conclusion from the result obtained.
Query: (scott Schema)
SELECT deptno, job, SUM(sal) FROM emp GROUP BY CUBE(deptno, job)
*/

/*
RESULT : IT WILL HAVE CUBE WITH 2 DIMMENSIONS AND ALL THE POSSIBLE COMIBINATIONS (18 rows)  OF JOB AND DEPT NO	
		FOLLOWED BY THE GRAND TOTAL : 29025
*/


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




-- Q-11:
/*
Find the total sales by country name and channel_desc for the country name
 starting from U through the Internet and direct sales in September 2000 and October.
*/

SELECT CHANNELS.CHANNEL_DESC,
        COUNTRIES.COUNTRY_NAME,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_NAME LIKE 'U%'
GROUP BY
ROLLUP(CHANNELS.CHANNEL_DESC,
COUNTRIES.COUNTRY_NAME);

--OUTPUT(Q11):
CHANNEL_DESC         COUNTRY_NAME              SALES$
-------------------- ------------------------- ------------------
Internet             United Kingdom                    31,108.500
Internet             United States of America         261,278.040
Internet                                              292,386.540
Direct Sales         United Kingdom                   177,148.350
Direct Sales         United States of America       1,320,497.400
Direct Sales                                        1,497,645.750
                                                    1,790,032.290

SELECT CHANNELS.CHANNEL_DESC, COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
GROUP BY 
ROLLUP(CHANNELS.CHANNEL_DESC,COUNTRIES.COUNTRY_ISO_CODE)
ORDER BY (SALES$);

CHANNEL_DESC         CO SALES$
-------------------- -- ------------------
Direct Sales         BR              8.460
Internet             DK          7,937.590
Internet             ES          9,411.660
Internet             AU         12,903.020
Internet             CA         13,547.600
Internet             FR         14,987.630
Internet             SG         17,727.090
Internet             IT         20,602.320
Internet             GB         31,108.500
Internet             DE         36,865.380
Internet             JP         41,108.670

CHANNEL_DESC         CO SALES$
-------------------- -- ------------------
Direct Sales         DK         49,108.010
Direct Sales         SG         50,861.650
Direct Sales         CA         52,323.400
Direct Sales         ES         57,066.220
Direct Sales         AU         97,052.660
Direct Sales         FR        105,359.750
Direct Sales         IT        106,736.030
Direct Sales         JP        152,694.540
Direct Sales         GB        177,148.350
Internet             US        261,278.040
Direct Sales         DE        274,535.590

CHANNEL_DESC         CO SALES$
-------------------- -- ------------------
Internet                       467,477.500
Direct Sales         US      1,320,497.400
Direct Sales                 2,443,392.060
                             2,910,869.560

-- Q-12:
/*
ANALYZE THE OUTPUT
*/
SELECT
        CH.CHANNEL_DESC,
        T.CALENDAR_MONTH_DESC,
        CO.COUNTRY_ISO_CODE,
        CO.COUNTRY_NAME,
        SUM(S.AMOUNT_SOLD) SUM_AMOUNT_SOLD,
        GROUPING_ID(
CH.CHANNEL_DESC,
T.CALENDAR_MONTH_DESC,
CO.COUNTRY_ISO_CODE,
CO.COUNTRY_NAME) GROUPING_ID
FROM
        SALES S,
        CUSTOMERS CU,
        TIMES T,
        CHANNELS CH,
        COUNTRIES CO
WHERE
S.TIME_ID=T.TIME_ID AND
        S.CUST_ID=CU.CUST_ID AND
        CU.COUNTRY_ID = CO.COUNTRY_ID AND
        S.CHANNEL_ID = CH.CHANNEL_ID AND
        CH.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET') AND
        T.CALENDAR_MONTH_DESC IN ('2001-09', '2001-10') AND
        CO.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP(
CH.CHANNEL_DESC,
T.CALENDAR_MONTH_DESC,
CO.COUNTRY_ISO_CODE,
CO.COUNTRY_NAME);

--OUTPUT(Q12):
CHANNEL_DESC    CALENDAR CO COUNTRY_NAME         SUM_AMOUNT_SOLD GROUPING_ID
--------------- -------- -- -------------------- --------------- -----------
Internet        2001-09  GB United Kingdom              36806.73           0
Internet        2001-09  GB                             36806.73           1
Internet        2001-09  US United States of Ame       299621.96           0
                            rica

Internet        2001-09  US                            299621.96           1
Internet        2001-09                                336428.69           3
Internet        2001-10  GB United Kingdom              39010.76           0
Internet        2001-10  GB                             39010.76           1
Internet        2001-10  US United States of Ame       386326.55           0
                            rica

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME         SUM_AMOUNT_SOLD GROUPING_ID
--------------- -------- -- -------------------- --------------- -----------

Internet        2001-10  US                            386326.55           1
Internet        2001-10                                425337.31           3
Internet                                                  761766           7
Direct Sales    2001-09  GB United Kingdom              92865.04           0
Direct Sales    2001-09  GB                             92865.04           1
Direct Sales    2001-09  US United States of Ame       621197.94           0
                            rica

Direct Sales    2001-09  US                            621197.94           1
Direct Sales    2001-09                                714062.98           3

CHANNEL_DESC    CALENDAR CO COUNTRY_NAME         SUM_AMOUNT_SOLD GROUPING_ID
--------------- -------- -- -------------------- --------------- -----------
Direct Sales    2001-10  GB United Kingdom              75296.44           0
Direct Sales    2001-10  GB                             75296.44           1
Direct Sales    2001-10  US United States of Ame        566719.8           0
                            rica

Direct Sales    2001-10  US                             566719.8           1
Direct Sales    2001-10                                642016.24           3
Direct Sales                                          1356079.22           7
                                                      2117845.22          15



--QUERY FOR GROUP ID
--WRITE A QUERY TO REPRESENT REPEATATION USING GROUPING ID:

SELECT CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
        COUNTRIES.COUNTRY_ISO_CODE,
        TO_CHAR(SUM(AMOUNT_SOLD), '9,999,999,999.999') SALES$, GROUP_ID()
FROM SALES, CUSTOMERS, TIMES, CHANNELS, COUNTRIES
WHERE SALES.TIME_ID=TIMES.TIME_ID
        AND SALES.CUST_ID=CUSTOMERS.CUST_ID
        AND CUSTOMERS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
        AND SALES.CHANNEL_ID = CHANNELS.CHANNEL_ID
        AND CHANNELS.CHANNEL_DESC IN ('DIRECT SALES', 'INTERNET')
        AND TIMES.CALENDAR_MONTH_DESC IN ('2000-09', '2000-10')
        AND COUNTRIES.COUNTRY_ISO_CODE IN ('GB', 'US')
GROUP BY
ROLLUP((CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE),(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE),(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE),(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE),(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE),(CHANNELS.CHANNEL_DESC, CALENDAR_MONTH_DESC,
COUNTRIES.COUNTRY_ISO_CODE)
)
ORDER BY GROUP_ID();

--OUTPUT:
CHANNEL_DESC         CALENDAR CO SALES$             GROUP_ID()
-------------------- -------- -- ------------------ ----------
Internet             2000-09  GB         16,569.360          0
Internet             2000-09  US        124,223.750          0
Internet             2000-10  GB         14,539.140          0
Internet             2000-10  US        137,054.290          0
                                      1,790,032.290          0
Direct Sales         2000-09  US        638,200.810          0
Direct Sales         2000-10  GB         91,925.430          0
Direct Sales         2000-10  US        682,296.590          0
Direct Sales         2000-09  GB         85,222.920          0
Direct Sales         2000-10  US        682,296.590          1
Direct Sales         2000-10  GB         91,925.430          1

CHANNEL_DESC         CALENDAR CO SALES$             GROUP_ID()
-------------------- -------- -- ------------------ ----------
Direct Sales         2000-09  US        638,200.810          1
Direct Sales         2000-09  GB         85,222.920          1
Internet             2000-10  US        137,054.290          1
Internet             2000-10  GB         14,539.140          1
Internet             2000-09  US        124,223.750          1
Internet             2000-09  GB         16,569.360          1
Direct Sales         2000-10  US        682,296.590          2
Internet             2000-09  US        124,223.750          2
Internet             2000-10  GB         14,539.140          2
Internet             2000-10  US        137,054.290          2
Direct Sales         2000-09  GB         85,222.920          2

CHANNEL_DESC         CALENDAR CO SALES$             GROUP_ID()
-------------------- -------- -- ------------------ ----------
Direct Sales         2000-09  US        638,200.810          2
Direct Sales         2000-10  GB         91,925.430          2
Internet             2000-09  GB         16,569.360          2
Direct Sales         2000-10  US        682,296.590          3
Direct Sales         2000-10  GB         91,925.430          3
Direct Sales         2000-09  US        638,200.810          3
Direct Sales         2000-09  GB         85,222.920          3
Internet             2000-10  US        137,054.290          3
Internet             2000-10  GB         14,539.140          3
Internet             2000-09  US        124,223.750          3
Internet             2000-09  GB         16,569.360          3

CHANNEL_DESC         CALENDAR CO SALES$             GROUP_ID()
-------------------- -------- -- ------------------ ----------
Direct Sales         2000-10  US        682,296.590          4
Direct Sales         2000-10  GB         91,925.430          4
Direct Sales         2000-09  US        638,200.810          4
Direct Sales         2000-09  GB         85,222.920          4
Internet             2000-10  US        137,054.290          4
Internet             2000-09  US        124,223.750          4
Internet             2000-10  GB         14,539.140          4
Internet             2000-09  GB         16,569.360          4
Internet             2000-10  GB         14,539.140          5
Direct Sales         2000-10  US        682,296.590          5
Direct Sales         2000-10  GB         91,925.430          5

CHANNEL_DESC         CALENDAR CO SALES$             GROUP_ID()
-------------------- -------- -- ------------------ ----------
Direct Sales         2000-09  US        638,200.810          5
Direct Sales         2000-09  GB         85,222.920          5
Internet             2000-10  US        137,054.290          5
Internet             2000-09  GB         16,569.360          5
Internet             2000-09  US        124,223.750          5



					
													
