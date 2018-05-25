-- GRANDMA's LIVESTOCK BUSINESS - 3NF TABLES
-- Foster, Daniel (817895293)
-- CompE561 Midterm

-- USE statement.
USE TSQLV4;

-- Table drops.
DROP TABLE IF EXISTS dbo.TransactionInformation;
DROP TABLE IF EXISTS dbo.SalesInformation;
DROP TABLE IF EXISTS dbo.PaymentInformation;

DROP TABLE IF EXISTS dbo.CustomerInformation;
DROP TABLE IF EXISTS dbo.CustomerLocation;
DROP TABLE IF EXISTS dbo.BuyerInformation;
DROP TABLE IF EXISTS dbo.SellerInformation;

DROP TABLE IF EXISTS dbo.HorseInformation;
DROP TABLE IF EXISTS dbo.CattleInformation;
DROP TABLE IF EXISTS dbo.TackInformation;

-- Customer location table.
CREATE TABLE dbo.CustomerLocation
(
CustomerZip			VARCHAR(15)	NOT NULL,
CustomerAddress		VARCHAR(50)	NOT NULL,
CustomerCity		VARCHAR(50)	NOT NULL,
CustomerState		VARCHAR(3)	NOT NULL,
CONSTRAINT PK_CustomerLocation
	PRIMARY KEY(CustomerZip)
);

-- Inventory information tables.
CREATE TABLE dbo.HorseInformation
(
HorseSaleSlip#			INT			NOT NULL,
HorseSaleTag#			INT			NOT NULL,
HorseDescription		VARCHAR(50)	NOT NULL,
HorseSaleBreed			VARCHAR(50)	NOT NULL,
HorseCogginsBloodTest	BIT			NOT NULL,
HorseType				VARCHAR(50) NOT NULL,
CONSTRAINT PK_HorseInformation
	PRIMARY KEY(HorseSaleSlip#)
);

CREATE TABLE dbo.CattleInformation
(
CattleSaleSlip#		INT			NOT NULL,
CattleTag#			INT			NOT NULL,
CattleDescription	VARCHAR(50)	NOT NULL,
Cattle#Head			INT			NOT NULL,
CattleSaleBreed		VARCHAR(50)	NOT NULL,
CONSTRAINT PK_CattleInformation
	PRIMARY KEY(CattleSaleSlip#)
);

CREATE TABLE dbo.TackInformation
(
TackSaleSlip#	INT			NOT NULL,
TackLot#		INT			NOT NULL,
TackDescription	VARCHAR(50)	NOT NULL,
TackUsedorNew	BIT			NOT NULL,
CONSTRAINT PK_TackInformation
	PRIMARY KEY(TackSaleSlip#)
);

-- Transaction information table.
CREATE TABLE dbo.TransactionInformation
(
TransactionID#			INT		NOT NULL,
TransactionTotalSale	MONEY	NOT NULL,
TransactionTotalCharges	MONEY	NOT NULL,
CommissionCharges		MONEY	NOT NULL,
InsuranceCharges		MONEY	NOT NULL,
VetCharges				MONEY	NOT NULL,
LaborCharges			MONEY	NOT NULL,
SalesTax				MONEY	NOT NULL,
YardageCharges			MONEY	NOT NULL,
UtilitiesExpenses		MONEY	NOT NULL,
OfficeExpenses			MONEY	NOT NULL,
TaxExempt				BIT		NOT NULL,
DateofSale				DATE	NOT NULL,
TimeofSale				TIME	NOT NULL,
CONSTRAINT PK_TransactionInformation
	PRIMARY KEY(TransactionID#)
);

-- Customer payment information table.
CREATE TABLE dbo.PaymentInformation
(
CustomerID#				INT		NOT NULL,
CashPayment				MONEY	NOT NULL,
CheckPayment			MONEY	NOT NULL,
CustomerBalance			MONEY	NOT NULL,
CustomerDeposit			MONEY	NOT NULL,
CustomerPaid			BIT		NOT NULL,
CheckVoided				BIT		NOT NULL,
CheckClearedBank		BIT		NOT NULL,
VetPaid					BIT		NOT NULL,
CONSTRAINT PK_CustomerInformation
	PRIMARY KEY(CustomerID#)
);

-- Buyer and seller information tables.
CREATE TABLE dbo.BuyerInformation
(
BuyerID#				INT			NOT NULL,
CustomerID#				INT			NOT NULL,
CustomerFirstName		VARCHAR(30)	NOT NULL,
CustomerLastName		VARCHAR(30)	NOT NULL,
CustomerZip				VARCHAR(15)	NOT NULL,
CustomerDOB				DATE		NOT NULL,
CustomerPhoneNumber		VARCHAR(50)	NOT NULL,
CustomerEmail			VARCHAR(50)	NOT NULL,
CustomerDriversLicense	VARCHAR(50)	NOT NULL,
CONSTRAINT PK_BuyerInformation
	PRIMARY KEY(BuyerID#),
CONSTRAINT FK_BuyerInformation_PaymentInformation
	FOREIGN KEY(CustomerID#)
	REFERENCES dbo.PaymentInformation(CustomerID#),
CONSTRAINT FK_BuyerInformation_CustomerLocation
	FOREIGN KEY(CustomerZip)
	REFERENCES dbo.CustomerLocation(CustomerZip)
);

CREATE TABLE dbo.SellerInformation
(
SellerID#				INT			NOT NULL,
CustomerID#				INT			NOT NULL,
CustomerFirstName		VARCHAR(30)	NOT NULL,
CustomerLastName		VARCHAR(30)	NOT NULL,
CustomerZip				VARCHAR(15)	NOT NULL,
CustomerDOB				DATE		NOT NULL,
CustomerPhoneNumber		VARCHAR(50)	NOT NULL,
CustomerEmail			VARCHAR(50)	NOT NULL,
CustomerDriversLicense	VARCHAR(50)	NOT NULL,
CONSTRAINT PK_SellerInformation
	PRIMARY KEY(SellerID#),
CONSTRAINT FK_SellerInformation_PaymentInformation
	FOREIGN KEY(CustomerID#)
	REFERENCES dbo.PaymentInformation(CustomerID#),
CONSTRAINT FK_SellerInformation_CustomerLocation
	FOREIGN KEY(CustomerZip)
	REFERENCES dbo.CustomerLocation(CustomerZip)
);

-- Customer information reference table.
CREATE TABLE dbo.CustomerInformation
(
CustomerID#	INT	NOT NULL,
BuyerID#	INT	NULL,
SellerID#	INT	NULL,
CONSTRAINT FK_CustomerInformation_PaymentInformation
	FOREIGN KEY(CustomerID#)
	REFERENCES dbo.PaymentInformation(CustomerID#),
CONSTRAINT FK_CustomerInformation_BuyerInformation
	FOREIGN KEY(BuyerID#)
	REFERENCES dbo.BuyerInformation(BuyerID#),
CONSTRAINT FK_CustomerInformation_SellerInformation
	FOREIGN KEY(SellerID#)
	REFERENCES dbo.SellerInformation(SellerID#)
);

-- Sales information table. (reference table)
CREATE TABLE dbo.SalesInformation
(
TransactionID#	INT		NOT NULL,
BuyerID#		INT		NOT NULL,
SellerID#		INT		NOT NULL,
HorseSaleSlip#	INT		NULL,
CattleSaleSlip#	INT		NULL,
TackSaleSlip#	INT		NULL,
CONSTRAINT FK_SalesInformation_TransactionInformation
	FOREIGN KEY(TransactionID#)
	REFERENCES dbo.TransactionInformation(TransactionID#),
CONSTRAINT FK_SalesInformation_BuyerInformation
	FOREIGN KEY(BuyerID#)
	REFERENCES dbo.BuyerInformation(BuyerID#),
CONSTRAINT FK_SalesInformation_SellerInformation
	FOREIGN KEY(SellerID#)
	REFERENCES dbo.SellerInformation(SellerID#),
CONSTRAINT FK_SalesInformation_HorseInformation
	FOREIGN KEY(HorseSaleSlip#)
	REFERENCES dbo.HorseInformation(HorseSaleSlip#),
CONSTRAINT FK_SalesInformation_CattleInformation
	FOREIGN KEY(CattleSaleSlip#)
	REFERENCES dbo.CattleInformation(CattleSaleSlip#),
CONSTRAINT FK_SalesInformation_TackInformation
	FOREIGN KEY(TackSaleSlip#)
	REFERENCES dbo.TackInformation(TackSaleSlip#)
);

-- UNIQUE constraints for ID's.
ALTER TABLE dbo.HorseInformation
	ADD CONSTRAINT UNQ_HorseInformation_HorseSaleSlip#
	UNIQUE(HorseSaleSlip#);

ALTER TABLE dbo.CattleInformation
	ADD CONSTRAINT UNQ_CattleInformation_CattleSaleSlip#
	UNIQUE(CattleSaleSlip#);

ALTER TABLE dbo.TackInformation
	ADD CONSTRAINT UNQ_HorseInformation_TackSaleSlip#
	UNIQUE(TackSaleSlip#);

ALTER TABLE dbo.HorseInformation
	ADD CONSTRAINT UNQ_HorseInformation_HorseSaleTag#
	UNIQUE(HorseSaleTag#);

ALTER TABLE dbo.CattleInformation
	ADD CONSTRAINT UNQ_CattleInformation_CattleTag#
	UNIQUE(CattleTag#);

ALTER TABLE dbo.TackInformation
	ADD CONSTRAINT UNQ_TackInformation_TackLot#
	UNIQUE(TackLot#);

ALTER TABLE dbo.BuyerInformation
	ADD CONSTRAINT UNQ_BuyerInformation_BuyerID#
	UNIQUE(BuyerID#);

ALTER TABLE dbo.SellerInformation
	ADD CONSTRAINT UNQ_SellerInformation_SellerID#
	UNIQUE(SellerID#);

ALTER TABLE dbo.TransactionInformation
	ADD CONSTRAINT UNQ_TransactionInformation_TransactionID#
	UNIQUE(TransactionID#);

ALTER TABLE dbo.PaymentInformation
	ADD CONSTRAINT UNQ_PaymentInformation_CustomerID#
	UNIQUE(CustomerID#);