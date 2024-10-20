CREATE TABLE ecommerce_data(
 CustomerID integer,
 Churn integer,
 Tenure	integer,
 PreferredLoginDevice varchar(50),
 CityTier integer,	
 WarehouseToHome integer,
 PreferredPaymentMode varchar(50),
 Gender varchar(10),
 HourSpendOnApp	integer,
 NumberOfDeviceRegistered integer,
 PreferredOrderCat varchar(50),
 SatisfactionScore integer,
 MaritalStatus	varchar(25),
 NumberOfAddress  integer,	
 Complain  integer,	
 OrderAmountHikeFromlastYear  integer,	
 CouponUsed	 integer,	
 OrderCount	 integer,	
 DaySinceLastOrder  integer,	
 CashbackAmount  integer
)

--/ checking & importing dataset/--
SELECT *
FROM ecommerce_data

--//DATA CLEANING//--
--/1. Finding the total number of customers/--
SELECT DISTINCT COUNT(CustomerID) as TotalNumberOfCustomers
FROM ecommerce_data
--/2. checking for duplicate rows/--
SELECT CustomerID, COUNT (*) as Count
FROM ecommerce_data
GROUP BY CustomerID
Having COUNT (CustomerID) > 1
--/3. Checking for null values/---
SELECT ColumnName, COUNT(*) AS NullCount
FROM (
    SELECT 
        CASE 
			WHEN CustomerID IS NULL THEN 'CustomerID'
			WHEN Churn IS NULL THEN 'Churn'
			WHEN tenure IS NULL THEN 'tenure'
			WHEN PreferredLoginDevice IS NULL THEN 'PreferredLoginDevice'
			WHEN CityTier IS NULL THEN 'CityTier'
			WHEN PreferredPaymentMode IS NULL THEN 'PreferredPaymentMode'
            WHEN warehousetohome IS NULL THEN 'warehousetohome'
			WHEN Gender IS NULL THEN 'Gender'
			WHEN NumberOfDeviceRegistered IS NULL THEN 'NumberOfDeviceRegistered'
			WHEN PreferredOrderCat IS NULL THEN 'PreferredOrderCat'
            WHEN hourspendonapp IS NULL THEN 'hourspendonapp'
			WHEN SatisfactionScore IS NULL THEN 'SatisfactionScore'
			WHEN MaritalStatus	IS NULL THEN 'MaritalStatus'
            WHEN NumberOfAddress IS NULL THEN 'NumberOfAddress'
            WHEN Complain  IS NULL THEN 'Complain'
            WHEN orderamounthikefromlastyear IS NULL THEN 'orderamounthikefromlastyear'
            WHEN couponused IS NULL THEN 'couponused'
            WHEN ordercount IS NULL THEN 'ordercount'
            WHEN daysincelastorder IS NULL THEN 'daysincelastorder'
			WHEN CashbackAmount IS NULL THEN 'CashbackAmount'
        END AS ColumnName
    FROM ecommerce_data
) AS NullCounts
WHERE ColumnName IS NOT NULL
GROUP BY ColumnName;

--/3.1 Handling Null values/--
UPDATE ecommerce_data
SET tenure = (SELECT AVG(tenure) FROM ecommerce_data)
WHERE tenure IS NULL 

UPDATE ecommerce_data
SET orderamounthikefromlastyear = (SELECT AVG(orderamounthikefromlastyear) FROM ecommerce_data)
WHERE orderamounthikefromlastyear IS NULL 

UPDATE ecommerce_data
SET Hourspendonapp = (SELECT AVG(Hourspendonapp) FROM ecommerce_data)
WHERE Hourspendonapp IS NULL 

UPDATE ecommerce_data
SET WarehouseToHome = (SELECT  AVG(WarehouseToHome) FROM ecommerce_data)
WHERE WarehouseToHome IS NULL 

UPDATE ecommerce_data
SET couponused = (SELECT AVG(couponused) FROM ecommerce_data)
WHERE couponused IS NULL 

UPDATE ecommerce_data
SET ordercount = (SELECT AVG(ordercount) FROM ecommerce_data)
WHERE ordercount IS NULL 

UPDATE ecommerce_data
SET daysincelastorder = (SELECT AVG(daysincelastorder) FROM ecommerce_data)
WHERE daysincelastorder IS NULL 

--/4. Creating a new column from an already existing “churn” column/--
ALTER TABLE ecommerce_data
ADD Churn_Status VARCHAR(50)

UPDATE ecommerce_data
SET Churn_Status = 
  CASE 
    WHEN Churn = 1 THEN 'Churned' 
    WHEN Churn = 0 THEN 'Stayed'
END 

SELECT Churn_status
FROM ecommerce_data

--/Checking values in each column for correctness and accuracy/---
SELECT customerid, Complain, Complain_Recieved
FROM ecommerce_data

--/ 5.	Creating a new column from an already existing “complain” column/--
ALTER TABLE ecommerce_data
ADD Complain_Recieved VARCHAR(10)

UPDATE ecommerce_data
SET Complain_Recieved = 
  CASE 
    WHEN Complain = 1 THEN 'Yes' 
    WHEN Complain= 0 THEN 'No'
END 

----/6. Fixing redundancy in “PreferedLoginDevice” Column/--
select Distinct PreferredLoginDevice
FROM ecommerce_data

UPDATE ecommerce_data
SET PreferredLoginDevice = 'Phone'
WHERE  PreferredLoginDevice = 'Mobile Phone'

--/ 6.1 Fixing redundancy in “PreferedOrderCat” Column/---
select Distinct PreferredOrderCat
FROM ecommerce_data

 UPDATE ecommerce_data
 SET PreferredOrderCat = 'Mobile Phone'
 WHERE  PreferredOrderCat = ' Mobile'
 
--/6.3 Fixing redundancy in “PreferredPaymentMode” Column/---
select Distinct PreferredPaymentMode
FROM ecommerce_data

UPDATE ecommerce_data
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE  PreferredPaymentMode = 'COD'

UPDATE ecommerce_data
SET PreferredPaymentMode = 'Credit Card'
WHERE  PreferredPaymentMode = 'CC'

--/Fixing wrongly entered values in “WarehouseToHome” column/--
select Distinct WarehouseToHome
FROM ecommerce_data
ORDER BY WarehouseToHome desc

UPDATE ecommerce_data
SET warehousetohome = '27'
WHERE warehousetohome = '127'

UPDATE ecommerce_data
SET warehousetohome = '26'
WHERE warehousetohome = '126'

--/Our data has been cleaned and is now ready to be explored for insight generation./--