-- GRANDMA's LIVESTOCK BUSINESS - QUERIES
-- Foster, Daniel (817895293)
-- CompE561 Midterm

-- USE statement.
USE TSQLV4;

-- Query to return outstanding balances due to customers.
SELECT CustomerID# AS Customer_ID, CustomerBalance AS Outstanding_Balance
FROM dbo.PaymentInformation
ORDER BY Customer_ID;

-- Query to return outstanding balances due to the business.
SELECT TransactionID# AS Transaction_ID, TransactionTotalCharges AS Outsatnding_Balance
FROM dbo.TransactionInformation
ORDER BY Transaction_ID;

-- Query to return transactions that took place in a specified period of time.
DROP FUNCTION IF EXISTS dbo.GetTransactions;
GO
CREATE FUNCTION dbo.GetTransactions
	(@daterange1 AS DATE, @daterange2 AS DATE)
	RETURNS TABLE
AS
RETURN
	SELECT TransactionID# AS Transaction_ID, DateofSale AS Date_of_Sale
	FROM dbo.TransactionInformation
	WHERE ((DateofSale >= @daterange1) AND (DateofSale <= @daterange2))
GO

SELECT Transaction_ID, Date_of_Sale
FROM dbo.GetTransactions('2015-01-01', '2016-01-01') AS F -- Example between January 1st, 2015 and January 1st, 2016.
ORDER BY Date_of_Sale ASC;

-- Query to return the top 10 transactions by sales volume per month.
SELECT T.Transaction_ID, T.Transaction_Total, T.Month_of_Sale
FROM(SELECT TransactionID# AS Transaction_ID, TransactionTotalSale AS Transaction_Total, MONTH(DateofSale) AS Month_of_Sale, 
	 RANK() OVER(PARTITION BY(MONTH(DateofSale))
				 ORDER BY TransactionTotalSale DESC) AS Rank_in_Month
	 FROM dbo.TransactionInformation)
T WHERE Rank_in_Month <= 10;

-- Query to return the percentage of sales that each customer has contributed 
-- to the business in a specified period of time.
DROP FUNCTION IF EXISTS dbo.GetSalesPercentages;
GO
CREATE FUNCTION dbo.GetSalesPercentages
	(@daterange1 AS DATE, @daterange2 AS DATE)
	RETURNS TABLE
AS
RETURN
	SELECT CustomerID# AS Customer_ID,
	(((CAST(CashPayment AS DECIMAL(20, 10)) + CAST(CheckPayment AS DECIMAL(20, 10))) / (SELECT SUM(CAST(TransactionTotalSale AS DECIMAL(20,10))) -- Sum cash and check payments to get total contribution.
																						FROM dbo.TransactionInformation
																						WHERE ((DateofSale >= @daterange1) AND (DateofSale <= @daterange2)))) * 100) AS Percentage_of_Total_Sales
	FROM dbo.PaymentInformation
GO

SELECT Customer_ID, Percentage_of_Total_Sales
FROM dbo.GetSalesPercentages('2015-01-01', '2016-01-01') AS F -- Example between January 1st, 2015 and January 1st, 2016.
ORDER BY Customer_ID ASC;