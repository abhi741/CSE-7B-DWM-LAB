			-- Practical 2 

/*
Problem Statement: Write and Execute SQL aggregation queries for data warehouse. '
*/

/*
Name: Rakshit Kathawate 
Roll No: 74
Batch : B3
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

select channels.channel_desc, calendar_month_desc, 
	countries.country_iso_code, 
		to_char(sum(amount_sold), '9,999,999,999') sales$ 
		from sales, customers, times, channels, countries 
			where sales.time_id=times.time_id 
				and sales.cust_id=customers.cust_id 
				and customers.country_id = countries.country_id 
				and sales.channel_id = channels.channel_id 
				and channels.channel_desc in ('direct sales', 'internet') 
				and times.calendar_month_desc in ('2000-09', '2000-10') 
				and countries.country_iso_code in ('gb', 'us') 
		group by 
		rollup(channels.channel_desc, calendar_month_desc, countries.country_iso_code);

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