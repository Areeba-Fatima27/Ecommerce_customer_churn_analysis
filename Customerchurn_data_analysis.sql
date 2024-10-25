select *
from ecommerce_data

---// DATA ANALYSIS//--
--/1. What is the overall customer churn rate?/--
SELECT 
    COUNT(*) AS TotalNumberofCustomers,
    COUNT(CASE WHEN Churn_Status = 'Churned' THEN 1 END) AS TotalNumberofChurnedCustomers,
    CAST(COUNT(CASE WHEN Churn_Status = 'Churned' THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data;

--/2. What is the typical tenure for churned customers?/--
ALTER TABLE ecommerce_data
ADD Tenure_Range VARCHAR(50)

UPDATE ecommerce_data
SET Tenure_Range =
CASE 
    WHEN tenure <= 6 THEN '6 Months'
    WHEN tenure > 6 AND tenure <= 12 THEN '1 Year'
    WHEN tenure > 12 AND tenure <= 24 THEN '2 Years'
    WHEN tenure > 24 THEN 'more than 2 years'
END

Select Tenure_Range
FROM ecommerce_data

SELECT Tenure_Range, 
        COUNT(*) AS TotalCustomers,
        SUM(churn) AS ChurnedCustomers,
        CAST(SUM (churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
GROUP BY Tenure_Range
ORDER BY ChurnRate DESC

--/3. How does the churn rate vary based on the preferred login device?/--
SELECT preferredlogindevice, 
        COUNT(*) AS TotalCustomers,
        SUM(churn) AS ChurnedCustomers,
        CAST(SUM (churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
GROUP BY preferredlogindevice
--/Churn rate for only churn customer/--
SELECT preferredlogindevice, 
COUNT(*) AS ChurnedCustomers,
CAST(COUNT(*) * 1.0 / 948 * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
WHERE churn = 1
GROUP BY preferredlogindevice
ORDER BY ChurnRate DESC

--/4. What is the distribution of customers across different city tiers?/---
SELECT citytier, 
   COUNT(*) AS TotalCustomer, 
   SUM(Churn) AS ChurnedCustomers, 
   CAST(SUM (churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
GROUP BY citytier
ORDER BY churnrate DESC
--/ churn rate for only churn custumer/--
SELECT  citytier, 
COUNT(*) AS ChurnedCustomers,
CAST(COUNT(*) * 1.0 / 948 * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
WHERE churn = 1
GROUP BY citytier
ORDER BY ChurnRate DESC

--/5.correlation between warehouse to home and churn rate./--
ALTER TABLE ecommerce_data
ADD warehousetohome_range VARCHAR(50)

UPDATE ecommerce_data
SET warehousetohome_range =
CASE 
    WHEN warehousetohome <= 10 THEN 'Very close distance'
    WHEN warehousetohome > 10 AND warehousetohome <= 20 THEN 'Close distance'
    WHEN warehousetohome > 20 AND warehousetohome <= 30 THEN 'Moderate distance'
    WHEN warehousetohome > 30 THEN 'Far distance'
END

select warehousetohome_range 
From ecommerce_data

SELECT warehousetohome_range,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY warehousetohome_range
ORDER BY Churnrate DESC

--/6. Which is the most preferred payment mode among churned customers?/--
SELECT preferredpaymentmode,
  COUNT(*) AS TotalCustomer,
  SUM(churn) AS CustomerChurn,
  CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2))AS Churnrate 
FROM ecommerce_data
GROUP BY preferredpaymentmode
ORDER BY Churnrate DESC
--/7.Is there any difference in churn rate between male and female customers?/--
SELECT gender,
COUNT(*) AS total_customers,
SUM(churn) AS total_churn, 
Sum(ordercount) as sum_order,
CAST(SUM(churn) * 1.0 /COUNT(*) * 100.0 AS DECIMAL(10,2)) AS Churnrate
FROM Ecommerce_data
GROUP BY gender
ORDER BY Churnrate DESC
--/churn rate for churn custumer only/--
SELECT  gender, 
COUNT(*) AS ChurnedCustomers,
CAST(COUNT(*) * 1.0 / 948 * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
WHERE churn = 1
GROUP BY gender
ORDER BY ChurnRate DESC

--/8. How does the average time spent on the app differ for churned and non-churned customers?/--
SELECT Churn_status,ROUND(AVG(hourspendonapp),2) AS avg_hourspendonapp
FROM ecommerce_data
GROUP BY churn_status

--/9. Does the number of registered devices impact the likelihood of churn?/--
SELECT numberofdeviceregistered,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY numberofdeviceregistered
ORDER BY Churnrate DESC
--/10. Which order category is most preferred among churned customers?/--
SELECT preferredordercat,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY preferredordercat
ORDER BY Churnrate DESC

--/churn rate for churn custumer only/--
SELECT preferredordercat, 
COUNT(*) AS ChurnedCustomers,
CAST(COUNT(*) * 1.0 / 948 * 100 AS DECIMAL(10,2)) AS ChurnRate
FROM ecommerce_data
WHERE churn = 1
GROUP BY preferredordercat
ORDER BY ChurnRate DESC

--/ 11. Is there any relationship between customer satisfaction scores and churn?/--
SELECT satisfactionscore,
       COUNT(*) AS TotalCustomer,
       SUM(Churn) AS CustomerChurn,
       CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY satisfactionscore
ORDER BY Churnrate DESC

--/12. Does the marital status of customers influence churn behavior?/--
SELECT maritalstatus,
   COUNT(*) AS TotalCustomer,
   SUM(Churn) AS CustomerChurn,
   CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY maritalstatus
ORDER BY Churnrate DESC
--/13. How many addresses do churned customers have on average?/--
SELECT ROUND(AVG(numberofaddress),2) as avg_churned_num_address
FROM ecommerce_data
WHERE churn_status = 'Churned'
--/14. Do customer complaints influence churned behavior?/--
SELECT complain_recieved,
   COUNT(*) AS TotalCustomer,
   SUM(Churn) AS CustomerChurn,
   CAST(SUM(Churn) * 1.0 /COUNT(*) * 100 AS DECIMAL(10,2)) AS Churnrate
FROM ecommerce_data
GROUP BY complain_recieved
ORDER BY Churnrate DESC
--/15. How does the use of coupons differ between churned and non-churned customers?/--
select churn_status, sum(couponused) as sum_couponused
FROM Ecommerce_data
GROUP BY churn_status
--/16. What is the average number of days since the last order for churned customers?/--
SELECT Round(AVG(daysincelastorder)) as avg_day_last_order
FROM Ecommerce_data
WHERE churn_status= 'Churned'
--/17. orderamounthike from last year/--
SELECT SUM(orderamounthikefromlastyear) AS total_order_amount
FROM Ecommerce_data
--/18. Is there any correlation between cashback amount and churn rate?/--
ALTER TABLE Ecommerce_data
ADD cashbackamount_range VARCHAR(50)

UPDATE Ecommerce_data
SET cashbackamount_range =
CASE 
    WHEN cashbackamount <= 100 THEN 'Low Cashback Amount'
    WHEN cashbackamount > 100 AND cashbackamount <= 200 THEN 'Moderate Cashback Amount'
    WHEN cashbackamount > 200 AND cashbackamount <= 300 THEN 'High Cashback Amount'
    WHEN cashbackamount > 300 THEN 'Very High Cashback Amount'
END

SELECT cashbackamount_range FROM Ecommerce_data

SELECT cashbackamount_range,
 COUNT(*) AS total_customers,
 SUM(churn) AS total_churn, 
 CAST(SUM(churn) * 1.0 /COUNT(*) * 100.0 AS DECIMAL(10,2)) AS Churnrate
FROM Ecommerce_data
GROUP BY cashbackamount_range
ORDER BY Churnrate DESC

--/ENDDDDDDDDDDDDDDDDDDDDDDDDDDDDD/--