'''
-- create database
createdb crime
$ psql crime < sf_crime_data.sql

SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

SELECT id, account_id, poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per FROM orders LIMIT 10;

SELECT	SELECT Col1, Col2, ...	Provide the columns you want
FROM	FROM Table	Provide the table where the columns exist
LIMIT	LIMIT 10	Limits based number of rows returned
ORDER BY	ORDER BY Col	Orders table based on the column. Used with DESC.
WHERE	WHERE Col > 5	A conditional statement to filter your results
LIKE	WHERE Col LIKE '%me%'	Only pulls rows where column has 'me' within the text
IN	WHERE Col IN ('Y', 'N')	A filter for only rows with column of 'Y' or 'N'
NOT	WHERE Col NOT IN ('Y', 'N')	NOT is frequently used with LIKE and IN
AND	WHERE Col1 > 5 AND Col2 < 3	Filter rows where two or more conditions must be true
OR	WHERE Col1 > 5 OR Col2 < 3	Filter rows where at least one condition must be true
BETWEEN	WHERE Col BETWEEN 3 AND 5	Often easier syntax than using an AND

SELECT * FROM orders WHERE referral_url LIKE '%google%' //'google' in name
SELECT name FROM accounts WHERE name LIKE 'C%'; //starts  with 'C'
SELECT name FROM accounts WHERE name LIKE '%C%'; //ends  with 'C'

SLECT * FROM orders WHERE account_id IN (1001, 1021, 2002)
SELECT name, primary_poc, sales_rep_id FROM accounts WHERE name IN ('Walmart' ,'Target', 'Nordstrom')
SELECT * FROM web_events WHERE channel IN ('organic' ,'adwords')
SELECT * FROM web_events WHERE channel NOT IN ('organic' ,'adwords') ORDER BY sales_id DESC, another_id
SELECT * FROM orders WHERE referral_url NOT LIKE '%google%' //'google' not in name


// exclude filterNOT

SELECT name, primary_poc, sales_rep_id FROM accounts WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');
SELECT * FROM web_events WHERE channel NOT IN ('organic', 'adwords');
SELECT name FROM accounts WHERE name NOT LIKE 'C%';
SELECT name FROM accounts WHERE name NOT LIKE '%one%';
SELECT name FROM accounts WHERE name NOT LIKE '%s';

//AND
SELECT * FROM orders WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01' ORDER BY ocurred_at DESC
SELECT * FROM orders WHERE column BETWEEN 6 AND 10 ORDER BY ocurred_at DESC
SELECT * FROM orders WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0
SELECT name FROM accounts WHERE name NOT LIKE 'C%' AND name NOT LIKE '%S'

SELECT occurred_at, gloss_qty FROM orders WHERE gloss_qty BETWEEN 24 AND 29 ORDER BY gloss_qty
SELECT * FROM web_events WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2016-12-30' ORDER BY occurred_at DESC

SELECT id from orders where (gloss_qty > 4000 or gloss_qty > 4000)
SELECT * from orders where standard_qty = 0 and (gloss_qty > 1000 or poster_qty > 1000)
SELECT * FROM accounts WHERE (name LIKE 'C%' OR name LIKE 'W%') AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');


SELECT orders.* FROM orders JOIN accounts ON orders.account_id = accounts.id;
SELECT accounts.name, orders.occurred_at FROM orders JOIN accounts ON orders.account_id = accounts.id;
SELECT * FROM orders JOIN accounts ON orders.account_id = accounts.id;
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,  accounts.website, accounts.primary_poc FROM orders join accounts ON orders.account_id = accounts.id;
SELECT * FROM web_events JOIN accounts ON web_events.account_id = accounts.id JOIN orders ON accounts.id = orders.account_id

SELECT accounts.name, accounts.primary_poc, web_events.channel, web_events.occurred_at from web_events  JOIN accounts ON web_events.account_id = accounts.id where name IN ('Walmart') 

SELECT region.name, sales_reps.id, sales_reps.name, accounts.name, accounts.primary_poc, region.id, sales_reps.region_id 
   FROM sales_reps 
   JOIN accounts 
   ON accounts.sales_rep_id = sales_reps.id 
   JOIN region 
   ON  sales_reps.region_id = region.id

SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
   FROM region r
   JOIN sales_reps s
   ON s.region_id = r.id
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id;

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
   FROM web_events w
   JOIN accounts a
   ON w.account_id = a.id
   WHERE a.name = 'Walmart';

SELECT r.name region, s.name rep, a.name account
   FROM sales_reps s
   JOIN region r
   ON s.region_id = r.id
   JOIN accounts a
   ON a.sales_rep_id = s.id
   ORDER BY a.name;

Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;


SELECT a.name AccName, r.name RegName, (o.total_amt_usd/o.total) UnitPrice
FROM orders o JOIN accounts a ON o.account_id = a.id AND o.standard_qty > 100 JOIN sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id

Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT a.name AccName, r.name RegName, (o.total_amt_usd/(o.total + 0.01)) UnitPrice
FROM orders o JOIN accounts a ON o.account_id = a.id AND o.standard_qty > 100 AND o.poster_qty >50
JOIN sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id ORDER BY UnitPrice

What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name AccName, w.channel Chan
FROM accounts a JOIN web_events w ON a.id = w.account_id AND a.id = 1001

Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name AccName, o.total_amt_usd, o.total FROM accounts a JOIN orders o ON a.id = o.account_id AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'


SELECT COUNT(accounts.id) FROM accounts;

SELECT SUM(standard_qty) as Standard, 
SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit, SUM(poster_qty) as Poster from orders


SELECT AVG(standard_qty) mean_standard, AVG(gloss_qty) mean_gloss, AVG(poster_qty) mean_poster, AVG(standard_amt_usd) mean_standard_usd, AVG(gloss_amt_usd) mean_gloss_usd, AVG(poster_amt_usd) mean_poster_usd FROM orders;


SELECT MIN(occurred_at) from orders

-- Calaculate median
SELECT * from (select total_amt_usd from orders order by total_amt_usd limit (6912/2) + 0.5) as t1 order by total_amt_usd DESC limit 1
SELECT * FROM (SELECT total_amt_usd FROM orders ORDER BY total_amt_usd LIMIT 3457) AS Table1 ORDER BY total_amt_usd DESC
LIMIT 2;

--earliest order account name? 
select a.name account_name, o.occurred_at from orders o join accounts a ON o.account_id = a.id order by occurred_at limit 1

----total sales for each account. (total sales and  company name)
select a.name company_name, SUM(o.total_amt_usd) Total from orders o join accounts a ON o.account_id = a.id group by a.name

--channel and account name for most recent web_event? (date, channel & account name)
select w.occurred_at date, w.channel, a.name from web_events w join accounts a ON w.account_id = a.id order by occurred_at DESC limit 1

--Total no. of times each channel was used. (channel & no. times used)
select channel, COUNT(channel) channel_count from web_events group by channel 

--primary contact of earliest web_event
select a.primary_poc POC , w.occurred_at occurred_at  from web_events w join accounts a ON a.id = w.account_id order by w.occurred_at limit 1

--smallest order by each account in terms of total usd. (account name and total usd) Order from smallest dollar amounts to largest.
select a.name, MIN(o.total_amt_usd) smallest_order from orders o join accounts a ON a.id = o.account_id group by a.name order by smallest_order DESC

--number of sales reps in each region. (region and number of sales_reps) Order from fewest reps to most 
select r.name, COUNT(s.id) No_sales_reps from region r join sales_reps s ON s.region_id = r.id group by r.name order by No_sales_reps

SELECT account_id, channel, COUNT(id) AS events FROM demo.web_events_full GROUP BY account_id, channel ORDER BY account_id, channel

--For each account, determine average amount of each type of paper purchased across their orders. (account name, average quantity purchased for each of the paper types for each account)
select a.name as name , AVG(o.gloss_qty) Gloss, AVG(o.poster_qty) poster, AVG(o.standard_qty) standard from accounts a join orders o on a.id = o.account_id group by a.name

--no of times a particular channel used in the web_events table for each sales rep. (name of the sales rep, channel, and no. of occurrences). Order by highest no of occurrences
select s.name SalesRep, w.channel as channel, COUNT(w.occurred_at) num_events from sales_reps s join accounts a on s.id = a.sales_rep_id join web_events w on w.account_id = a.id group by w.channel, s.name ORDER BY num_events DESC;

--no of times particular channel used in the web_events for each region. (region name, channel, number of occurrences) Order highest number of occurrences.
SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;

SELECT DISTINCT account_id, channel FROM web_events ORDER BY account_id 

Have any sales reps worked on more than one account?
SELECT DISTINCT s.id Srep, COUNT(a.id) as counta FROM accounts a JOIN sales_reps s on s.id = a.sales_rep_id  GROUP BY s.id ORDER BY counta

SELECT account_id, SUM(total_amt_usd) AS sum_total_amt_usd FROM orders GROUP BY 1 HAVING sum_total_amt_usd >= 250000

How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) num_accounts FROM accounts a JOIN sales_reps s ON s.id = a.sales_rep_id GROUP BY s.id, s.name HAVING COUNT(*) > 5 ORDER BY num_accounts;

--account has the most orders?
SELECT DISTINCT a.name, COUNT(*) orders FROM accounts a JOIN orders o ON o.account_id = a.id GROUP BY a.name HAVING COUNT(o.id) > 20 ORDER BY orders DESC LIMIT 1

--Which accounts spent more than 30,000 usd total across all orders
SELECT DISTINCT a.name, SUM(o.total_amt_usd) spend FROM accounts a JOIN orders o ON o.account_id = a.id GROUP BY a.name HAVING SUM(o.total_amt_usd) > 30000 ORDER BY spend 

--Which account has spent the most?
SELECT DISTINCT a.name, SUM(o.total_amt_usd) spend FROM accounts a JOIN orders o ON o.account_id = a.id GROUP BY a.name ORDER BY spend DESC LIMIT 1


--Which accounts used facebook channel to contact customers > 6 times
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel FROM accounts a JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel HAVING COUNT(*) > 6 AND w.channel = 'facebook' ORDER BY use_of_channel;

most frequently used channel by most accounts?
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel FROM accounts a JOIN web_events w ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel ORDER BY use_of_channel DESC LIMIT 10;


SELECT DATE_TRUNC('day', occurred_at) AS day, SUM(standard_qty) as standard_qty_sum FROM orders GROUP BY DATE_TRUNC('day', occurred_at) ORDER BY('day', occurred_at)
SELECT DATE_PART('dow', occurred_at) AS day_of_week, SUM(total) AS total_qty FROM orders GROUP BY 1 ORDER BY 3 DESC

-- Sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT DATE_PART('year', occurred_at), SUM(total_amt_usd) FROM orders GROUP BY 1 ORDER BY 2 DESC

Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd) FROM orders WHERE GROUP BY 1 ORDER BY 2 DESC LIMIT 1


Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd) FROM orders  WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01' GROUP BY 1 ORDER BY 2 

--year P&P had greatest sales in terms of total number of orders? All years evenly represented by the dataset?
SELECT DATE_PART('year', occurred_at), SUM(total) FROM orders GROUP BY 1 ORDER BY 2 DESC

--month of  year Walmart spent most on gloss paper in terms of dollars?
SELECT DATE_PART('month', o.occurred_at), SUM(o.gloss_amt_usd) FROM orders o JOIN accounts a ON a.id = o.account_id  WHERE a.name = 'Walmart' GROUP BY 1 ORDER BY 2 DESC

SELECT id, account_id, channel CASE WHEN channel = 'facebook' OR channel = 'direct' THEN 'yes' ELSE 'no' END AS is_facebook
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price FROM orders LIMIT 10;

--Show for each order, account ID, total amount, and level of the order - ‘Large’ or ’Small’ - if the order is $3000 or more, or smaller than $3000.
SELECT account_id, total_amt_usd, CASE WHEN total_amt_usd >= 3000  THEN 'Large' ELSE 'Small' END AS total_amt_size FROM orders ORDER BY total_amt_usd DESC

--Display no of orders in each of 3 categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT a.name, SUM(o.total_amt_usd) AS total CASE WHEN total > 200000 THEN 'greater than 200,000' WHEN total <= 200000 AND total >= 100000 THEN '200,000 and 100,000' ELSE 'under 100,000' FROM orders o JOIN accounts a ON o.account_id = a.id; GROUP BY total

--3 levels of customers based on the amount purchased. The top level includes sales greater than 200,000 usd. The second is between 200,000 and 100,000 usd. The lowest level is under 100,000 usd. Provide a table that includes the level of each account. Provide the account name, the total sales of all orders for the customer, and the level.
SELECT a.name, SUM(total_amt_usd) total_spent, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top' WHEN  SUM(total_amt_usd) > 100000 THEN 'middle' ELSE 'low' END AS customer_level FROM orders o JOIN accounts a ON o.account_id = a.id WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01' GROUP BY a.name ORDER BY 2 DESC

SELECT s.name, COUNT(*) num_ords, CASE WHEN COUNT(*) > 200 THEN 'top' ELSE 'not' END AS sales_rep_level FROM orders o JOIN accounts a ON o.account_id = a.id JOIN sales_reps s ON s.id = a.sales_rep_id GROUP BY s.name ORDER BY 2 DESC;

--identify sales reps associated with more than 200 orders. (sales rep name, total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(*) orders, SUM(total_amt_usd) money, CASE WHEN COUNT(*) > 200 OR SUM(total_amt_usd) > 750000 THEN 'top' WHEN COUNT(*) > 150 OR SUM(total_amt_usd) > 500000 THEN 'middle' ELSE 'low' END AS Category FROM sales_reps s JOIN accounts a ON a.sales_rep_id = s.id JOIN orders o ON o.account_id = a.id GROUP BY 1 ORDER BY 4 DESC, 2 DESC

SELECT channel, AVG(event_count) AS avg_event FROM (SELECT DATE_TRUNC ('day', occurred_at) AS day, channel, COUNT(*) AS event_count FROM web_events GROUP BY 1,2) sub GROUP BY 1 ORDER BY 2 DESC


--number of events occurring each day for each channel
SELECT DATE_TRUNC('day', occurred_at), channel, COUNT(DATE_PART('day', occurred_at)) from  web_events GROUP BY 1,2 ORDER BY 1

--number of events occurring each day for each channel -- average by day
SELECT  channel, AVG(count) FROM (SELECT DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(DATE_PART('day', occurred_at)) from  web_events GROUP BY 1,2 ORDER BY 3 DESC) sub GROUP BY 1


--monthlevel data of  first order ever placed in the order table
(SELECT AVG(standard_qty) Stan, AVG(gloss_qty) gl, AVG(poster_qty) ps, SUM(total_amt_usd) total_usd FROM orders WHERE DATE_TRUNC('month', occurred_at) = (SELECT MIN(DATE_TRUNC('month', occurred_at)) FROM orders)) 


SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

--account name most standard_qty paper

SELECT COUNT(*) FROM orders WHERE total > 
(SELECT total FROM accounts a JOIN  orders o ON o.account_id = a.id
WHERE o.standard_qty = 
(SELECT MAX(standard_qty) FROM orders)) AS sub 


For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT SUM (o.total_amt_usd), r.name AS regionname FROM orders o JOIN accounts a ON o.account_id = a.id JOIN  sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id GROUP BY 2

--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

      SELECT COUNT(o.total) FROM orders o JOIN accounts a ON o.account_id = a.id JOIN  sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id  WHERE r.name = (

      SELECT t1.regionname FROM (
      SELECT SUM (o.total_amt_usd) tmu, r.name AS regionname FROM orders o JOIN 	accounts a ON o.account_id = a.id JOIN  sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id GROUP BY 2 ) t1  JOIN (

      SELECT MAX(tmu) tmu  FROM (SELECT SUM (o.total_amt_usd) tmu, r.name AS regionname FROM orders o JOIN 	accounts a ON o.account_id = a.id JOIN  sales_reps s ON a.sales_rep_id = s.id JOIN region r ON r.id = s.region_id GROUP BY 2 ) t2 ) t3 

      ON t1.tmu = t3.tmu )
      

--How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?
SELECT COUNT(*) FROM  (
SELECT a.name, SUM(total) toto from accounts a JOIN orders o ON a.id = o.account_id GROUP BY 1 ) t3 WHERE t3.toto > 
(SELECT sumt FROM 
(SELECT t1.accname, SUM(o.total) sumt FROM accounts a JOIN 
(SELECT a.name accname, MAX(o.standard_qty) tot_Sqty FROM orders o JOIN accounts a ON o.account_id = a.id GROUP BY 1 ORDER BY 2 DESC LIMIT 1) t1
ON t1.accname = a.name JOIN  orders o on a.id = o.account_id GROUP BY 1) t2)


Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC), 
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;
For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH t1 AS (
   SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY r.name), 
t2 AS (
   SELECT MAX(total_amt)
   FROM t1)
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, how many accounts still had more in total purchases?

WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1), 
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;
For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 1)
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;
What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH t1 AS (
   SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id
   GROUP BY a.id, a.name
   ORDER BY 3 DESC
   LIMIT 10)
SELECT AVG(tot_spent)
FROM t1;

What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

WITH t1 AS (
   SELECT AVG(o.total_amt_usd) avg_all
   FROM orders o
   JOIN accounts a
   ON a.id = o.account_id),
t2 AS (
   SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
   FROM orders o
   GROUP BY 1
   HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1))
SELECT AVG(avg_amt)
FROM t2;

SELECT first_name, last_name, phone_number
      LEFT(phone_number, 3) AS area_code,
      RIGHT(phone_number, 8) AS phone_number_only,
      RIGTH(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt
      FROM custome_data


--In website IN accounts the last 3 digits specify extension (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT RIGHT(website, 3) AS extension, COUNT(RIGHT(website, 3)) FROM accounts GROUP BY 1


--Use accounts to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(name, 1) AS firstN, COUNT(*) FROM accounts GROUP BY 1 ORDER BY 2 DESC


--Count of num v count of letters.
SELECT  CASE WHEN X = '0' OR X = '1' OR X = '2' OR X = '3' OR X = '4' OR X = '5' OR X = '6' OR X = '7' OR X = '8' OR X = '9' THEN 'Num' ELSE 'Letter' END AS option, COUNT(*) FROM 
   (SELECT LEFT(name, 1) AS X FROM accounts ) t1 GROUP BY 1

SELECT first_name, city_name, POSITION(',' IN city_state) AS comma_position, STRPOS(city_state, ',') AS also_comma_position, LOWER(city_state) AS lowercase, UPPER(city_state) AS uppercase LEFT (city_state, POSITION(',' IN city_state) - 1) AS city FROM customer_data


--create first and last name columns that hold the first and last names for the primary_poc.

SELECT primary_poc, LEFT (primary_poc, POSITION(' ' IN primary_poc) - 1) fristName, RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) lastName FROM accounts

SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

SELECT first_name. last_name, CONCAT(first_name, ' ', last_name) AS full_name
      first_name || ' ' || last_name AS also_full_name FROM accounts


--create email address and remove space using company name and primary_poc

SELECT primary_poc, LEFT(primary_poc, STRPOS(primary_poc, ' ') - 1)  || '.' || RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) || '@' || REPLACE(name, ' ', '') || '.com' AS email FROM accounts

--Generate password, create email address and remove space using company name and primary_poc
WITH t1 AS (SELECT primary_poc, UPPER(name) companyName, LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name FROM accounts)
SELECT primary_poc, LOWER(LEFT(first_name, 1)) || RIGHT(first_name, 1) || LOWER(LEFT(last_name, 1)) || RIGHT(last_name, 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(companyName, ' ', '')  FROM t1 

--CAST
SELECT *, DATE_PART('month', TO_DATE(month, 'month')) AS clean_month, 
         year || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS concatenated_date,
         CAST (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS date) AS formatted_date,
         (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day):: date AS formatted_date_alt
         FROM accounts

--change date to correct SQL format
WITH t1 AS (SELECT date, SUBSTR(date, 1, 2) AS month,  SUBSTR(date, 4, 2) AS day , SUBSTR(date, 7, 4) AS year FROM sf_crime_data )
SELECT CAST(year || '-' || month || '-' || day AS date) AS formattedDate FROM t1

SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date FROM sf_crime_data;

SELECT COALESCE(primary_poc, 'no POC') AS fillNULL FROM account

--chack null values 
SELECT * FROM accounts a LEFT JOIN orders o ON a.id = o.account_id WHERE o.total IS NULL;

fill each qty column with 0 values
SELECT COALESCE(o.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
   FROM accounts a
   LEFT JOIN orders o
   ON a.id = o.account_id;


--WINDOW FUNCTIONS
SUM standard_qty, SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC('month', occurred_at) ORDER BY occurred_at) AS running_total FROM orders

--running total window function
SELECT standard_amt_usd, SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total FROM orders

--running total window function PARTION BY year  sum standard_amt_usd
SELECT DATE_TRUNC('year', occurred_at), standard_amt_usd, SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total FROM orders 

SELECT id, account_id, occurred_at, ROW_NUMBER OVER (ORDER BY id) AS row_num FROM orders

SELECT id, account_id, DATE_TRUNC('month', occurred_at), RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num FROM orders
SELECT id, account_id, DATE_TRUNC('month', occurred_at), DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num FROM orders

--rank total sales from highest to lowest
SELECT id, account_id, total, RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS total_rank FROM orders


SELECT id, account_id, standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

--aggregattion which makes all values equal 
SELECT id, account_id, standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders

--aliases for window functions
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

--comparing a row to a previous row LEAD LAG
SELECT account_id,
       standard_sum,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS LAG,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
       FROM orders 
       GROUP BY 1
     ) sub



--determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.
SELECT occurred_at,
       total_amt_usd,
       LAG(total_amt_usd) OVER (ORDER BY total_amt_usd) AS lag,
       LEAD(total_amt_usd) OVER (ORDER BY total_amt_usd) AS lead,
       total_amt_usd - LAG(total_amt_usd) OVER (ORDER BY total_amt_usd) AS lag_difference,
       LEAD(total_amt_usd) OVER (ORDER BY total_amt_usd) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
 ) sub


--PERCENTILES 
SELECT id, standard_qty, NTILE(4) OVER (ORDER BY standard_qty) AS quartile,
      standard_qty, NTILE(5) OVER (ORDER BY standard_qty) AS quintile,
      standard_qty, NTILE(100) OVER (ORDER BY standard_qty) AS percentile,
      FROM orders ORDER BY standard_qty DESC



--JOIN TYPES

--INNER JOIN
SELECT column_name(s)
FROM Table_A
INNER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

--LEFT JOIN
SELECT column_name(s)
FROM Table_A
LEFT JOIN Table_B ON Table_A.column_name = Table_B.column_name;


--RIGHT JOIN
SELECT column_name(s)
FROM Table_A
RIGHT JOIN Table_B ON Table_A.column_name = Table_B.column_name;

--FULL OUTER JOIN
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

--FULL OUTER JOIN with WHERE A.Key IS NULL OR B.Key IS NULL
SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;


SELECT orders.id, orders.occurred_at AS order_date, events.* 
   FROM orders
   LEFT JOIN web_events_full events
   ON events.account_id = orders.account_id
   AND events.occurres_at < orders.ocurred_at
   WHERE DATE_TRUNC('month', occurred_at) = (SELECT DATE_TRUNC('day', occurred_at)) FROM demo.orders)
   ORDER BY orders.account_id, orders.occurred_at


-- INEQUALITY JOIN ALPHABETICAL SORTING
SELECT a.name account_name, a.primary_poc, s.name sales_rep_name
FROM accounts a JOIN sales_reps s ON a.sales_rep_id = s.id AND a.primary_poc < s.name

--SELF JOINS
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

-- CHECK 1 day intervals in web_events
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o1.channel AS o1_channel,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at,
       o2.channel AS o2_channel
  FROM web_events o1
 LEFT JOIN web_events o2
   ON o1.account_id = o2.account_id
AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY o1.account_id, o1.occurred_at

--UNION ....appends only distinct values (same ow nums && same data type)
--UNION ALL ...appends all values
SELECT * FROM web_events WHERE channel = 'facebook' UNION ALL SELECT * FROM web_events

SELECT a.* FROM accounts a WHERE a.name = 'Walmart'
UNION ALL
SELECT a.* FROM accounts a WHERE a.name = 'Disney'

WITH double_accounts AS (
    SELECT * FROM accounts
    UNION ALL
    SELECT * FROM accounts
)

SELECT name, COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC




--


''' 













'''
primary keys - are unique for every row in a table. These are generally the first column in our database (like you saw with the id column for every table in the Parch & Posey database).
foreign keys - are the primary key appearing in another table, which allows the rows to be non-unique.

JOINs
In this lesson, you learned how to combine data from multiple tables using JOINs. The three JOIN statements you are most likely to use are:

JOIN - an INNER JOIN that only pulls data that exists in both tables.
LEFT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement.
There are a few more advanced JOINs that we did not cover here, and they are used in very specific use cases. UNION and UNION ALL, CROSS JOIN, and the tricky SELF JOIN. These are more advanced than this course will cover, but it is useful to be aware that they exist, as they are useful in special cases.

Alias
You learned that you can alias tables and columns using AS or not using it. This allows you to be more efficient in the number of characters you need to write, while at the same time you can assure that your column headings are informative of the data in your table.
'''