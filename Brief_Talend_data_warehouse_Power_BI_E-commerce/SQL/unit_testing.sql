---Query warehouse

create database Ecom_Inventory_DM
create database Ecom_Sales_DM
create database Ecommerce_store_dw

use Ecommerce_store_dw


use Ecom_Sales_DM
select * from FactSales


--unit testing

--- ===================================================================================================================
------ unite testing ----------------------------
Go
EXEC tsqlt.NewTestClass 'DatawareHouseTesting';
---- Foreign Key Integrity Test
Go
CREATE PROCEDURE DatawareHouseTesting.[test ForeignKeysAreValid]
AS
BEGIN
    -- Arrange (Insert test data into your data warehouse tables if needed)

    -- Act (Run the code that you want to test)
    DECLARE @FailedFKChecks TABLE (
        TableName NVARCHAR(255),
        ForeignKeyColumn NVARCHAR(255),
        ReferencedTable NVARCHAR(255),
        ReferencedColumn NVARCHAR(255)
    )
    -- Check foreign key integrity in your SalesFact table
    INSERT INTO @FailedFKChecks
    SELECT
        'FactSales' AS TableName,
        'Date_ID' AS ForeignKeyColumn,
        'DimDates' AS ReferencedTable,
        'Date_ID' AS ReferencedColumn
    FROM
        FactSales
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimDates
            WHERE FactSales.Date_ID = DimDates.Date_ID
        );

    INSERT INTO @FailedFKChecks
    SELECT
        'FactSales' AS TableName,
        'Product_ID' AS ForeignKeyColumn,
        'DimProducts' AS ReferencedTable,
        'Product_ID' AS ReferencedColumn
    FROM
        FactSales
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimProducts 
            WHERE FactSales.Product_ID = DimProducts.Product_ID
        );

    INSERT INTO @FailedFKChecks
    SELECT
        'FactSales' AS TableName,
        'Customer_ID' AS ForeignKeyColumn,
        'DimCustomers' AS ReferencedTable,
        'Customer_ID' AS ReferencedColumn
    FROM
        FactSales 
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimCustomers 
            WHERE FactSales.Customer_ID = DimCustomers.Customer_ID
        );

    INSERT INTO @FailedFKChecks
    SELECT
        'FactSales' AS TableName,
        'Shipper_ID' AS ForeignKeyColumn,
        'DimShippers' AS ReferencedTable,
        'Shipper_ID' AS ReferencedColumn
    FROM
        FactSales
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimShippers
            WHERE FactSales.Shipper_ID = DimShippers.Shipper_ID
        );
    -- Assert (Verify foreign key integrity)
    IF (SELECT COUNT(*) FROM @FailedFKChecks) > 0
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(MAX);
        
        SELECT @ErrorMessage = STRING_AGG(
            'Foreign key constraint violation in ' + TableName + 
            '. Column ' + ForeignKeyColumn + 
            ' references ' + ReferencedTable + '.' + ReferencedColumn,
            CHAR(10)
        )
        FROM @FailedFKChecks;

        -- Fail the test if there are foreign key violations
        EXEC tSQLt.Fail @ErrorMessage;
    END
END;


--- test ProductPrice, QuantitySold, NetAmount, TotalAmount
CREATE PROCEDURE DatawareHouseTesting.[test ValidSalesData]
AS
BEGIN
    -- Arrange (Insert test data into your data warehouse tables if needed)

    -- Act (Run the code that you want to test)
    DECLARE @InvalidSalesData TABLE (
        InvalidRowID INT IDENTITY(1,1),
        ProductPrice DECIMAL(18, 2),
        QuantitySold INT,
        NetAmount DECIMAL(18, 2),
        TotalAmount DECIMAL(18, 2)
    );

    -- Check for invalid sales data
    INSERT INTO @InvalidSalesData (ProductPrice, QuantitySold, NetAmount, TotalAmount)
    SELECT
        ProductPrice,
        QuantitySold,
        NetAmount,
        TotalAmount
    FROM
        FactSales
    WHERE
        ProductPrice <= 0
        OR QuantitySold <= 0
        OR NetAmount <= 0
        OR TotalAmount <= 0
        OR TotalAmount < NetAmount;

    -- Assert (Verify that there are no invalid sales data)
    IF (SELECT COUNT(*) FROM @InvalidSalesData) > 0
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(MAX);
        
        SELECT @ErrorMessage = STRING_AGG(
            'Invalid sales data in row ' + CAST(InvalidRowID AS NVARCHAR(255)) +
            '. ProductPrice: ' + CAST(ProductPrice AS NVARCHAR(255)) +
            ', QuantitySold: ' + CAST(QuantitySold AS NVARCHAR(255)) +
            ', NetAmount: ' + CAST(NetAmount AS NVARCHAR(255)) +
            ', TotalAmount: ' + CAST(TotalAmount AS NVARCHAR(255)),
            CHAR(10)
        )
        FROM @InvalidSalesData;

        -- Fail the test if invalid sales data is found
        EXEC tSQLt.Fail @ErrorMessage;
    END
END;

Go
EXEC tsqlt.Run 'DatawareHouseTesting';

-----------------unit testing for inventories ---------------------------------

-- inventory
select *
from FactInventories
join DimDates
On FactInventories.Date_ID = DimDates.Date_ID
join DimProducts
on FactInventories.Product_ID = DimProducts.Product_ID
join DimSuppliers
on FactInventories.Supplier_ID = DimSuppliers.Supplier_ID

-- Count Inventory :
--Conclusion (FactInventories) : Correct base on this result
select COUNT(*) as 'number of rows'
from FactInventories 
join DimDates
On FactInventories.Date_ID = DimDates.Date_ID
join DimProducts
on FactInventories.Product_ID = DimProducts.Product_ID
join DimSuppliers
on FactInventories.Supplier_ID = DimSuppliers.Supplier_ID


-------------------------------------
Go
EXEC tsqlt.NewTestClass 'DatawareHouseTestingInventory';
---- Foreign Key Integrity Test
Go
CREATE PROCEDURE DatawareHouseTestingInventory.[test ForeignKeysAreValid]
AS
BEGIN
    -- Arrange (Insert test data into your data warehouse tables if needed)

    -- Act (Run the code that you want to test)
    DECLARE @FailedFKChecks TABLE (
        TableName NVARCHAR(255),
        ForeignKeyColumn NVARCHAR(255),
        ReferencedTable NVARCHAR(255),
        ReferencedColumn NVARCHAR(255)
    )
    -- Check foreign key integrity in your SalesFact table
    INSERT INTO @FailedFKChecks
    SELECT
        'FactInventories' AS TableName,
        'Date_ID' AS ForeignKeyColumn,
        'DimDates' AS ReferencedTable,
        'Date_ID' AS ReferencedColumn
    FROM
        FactInventories
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimDates
            WHERE FactInventories.Date_ID = DimDates.Date_ID
        );

    INSERT INTO @FailedFKChecks
    SELECT
        'FactInventories' AS TableName,
        'Product_ID' AS ForeignKeyColumn,
        'DimProducts' AS ReferencedTable,
        'Product_ID' AS ReferencedColumn
    FROM
        FactInventories
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimProducts
            WHERE FactInventories.Product_ID = DimProducts.Product_ID
        );

    INSERT INTO @FailedFKChecks
    SELECT
        'FactSales' AS TableName,
        'Customer_ID' AS ForeignKeyColumn,
        'DimCustomers' AS ReferencedTable,
        'Customer_ID' AS ReferencedColumn
    FROM
        FactInventories 
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM DimSuppliers 
            WHERE FactInventories.Supplier_ID = DimSuppliers.Supplier_ID
        );
    -- Assert (Verify foreign key integrity)
    IF (SELECT COUNT(*) FROM @FailedFKChecks) > 0
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(MAX);
        
        SELECT @ErrorMessage = STRING_AGG(
            'Foreign key constraint violation in ' + TableName + 
            '. Column ' + ForeignKeyColumn + 
            ' references ' + ReferencedTable + '.' + ReferencedColumn,
            CHAR(10)
        )
        FROM @FailedFKChecks;

        -- Fail the test if there are foreign key violations
        EXEC tSQLt.Fail @ErrorMessage;
    END
END;



--- test 
CREATE PROCEDURE DatawareHouseTestingInventory.[test ValidInventoryData]
AS
BEGIN
    -- Arrange (Insert test data into your data warehouse tables if needed)

    -- Act (Run the code that you want to test)
    DECLARE @InvalidInventoryData TABLE (
        InvalidRowID INT IDENTITY(1,1),
        StockReceived INT,
        StockSold INT,
        StockOnHand INT
    );

    -- Check for invalid inventory data
    INSERT INTO @InvalidInventoryData (StockReceived, StockSold, StockOnHand)
    SELECT
        StockReceived,
        StockSold,
        StockOnHand
    FROM
        FactInventories
    WHERE
        StockReceived < 0
        OR StockSold < 0
        OR StockOnHand < 0;

    -- Assert (Verify that there are no invalid inventory data)
    IF (SELECT COUNT(*) FROM @InvalidInventoryData) > 0
    BEGIN
        DECLARE @ErrorMessage NVARCHAR(MAX);
        
        SELECT @ErrorMessage = STRING_AGG(
            'Invalid inventory data in row ' + CAST(InvalidRowID AS NVARCHAR(255)) +
            '. StockReceived: ' + CAST(StockReceived AS NVARCHAR(255)) +
            ', StockSold: ' + CAST(StockSold AS NVARCHAR(255)) +
            ', StockOnHand: ' + CAST(StockOnHand AS NVARCHAR(255)),
            CHAR(10)
        )
        FROM @InvalidInventoryData;

        -- Fail the test if invalid inventory data is found
        EXEC tSQLt.Fail @ErrorMessage;
    END
END;

Go
EXEC tsqlt.Run 'DatawareHouseTestingInventory';