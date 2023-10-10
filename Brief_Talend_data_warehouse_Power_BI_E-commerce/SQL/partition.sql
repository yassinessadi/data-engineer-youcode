----------------------------------------------  Inventory ----------------------------------------------------------------
use Ecom_Inventory_DM
-- ceration de la function de partitionement
CREATE PARTITION FUNCTION InventoryDatePartitionFunction (DATE)
AS RANGE LEFT FOR VALUES ('2021-01-01', '2022-01-01', '2023-01-01');

-- creation des filegroups
ALTER DATABASE Ecom_Inventory_DM ADD FILEGROUP [FG_inventory_Archive]
GO

ALTER DATABASE Ecom_Inventory_DM ADD FILEGROUP [FG_inventory_2021]
GO

ALTER DATABASE Ecom_Inventory_DM ADD FILEGROUP [FG_inventory_2022]
GO

ALTER DATABASE Ecom_Inventory_DM ADD FILEGROUP [FG_inventory_2023]
GO


-- liee avec les filegroup
ALTER DATABASE Ecom_Inventory_DM ADD FILE
(NAME = N'inventory_Archive',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\inventory_Archive.ndf', SIZE = 2048KB) TO FILEGROUP [FG_inventory_Archive];

ALTER DATABASE Ecom_Inventory_DM ADD FILE
(NAME = N'inventory_2021',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\inventory_2021.ndf', SIZE = 2048KB) TO FILEGROUP [FG_inventory_2021];

ALTER DATABASE Ecom_Inventory_DM ADD FILE
(NAME = N'inventory_2022',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\inventory_2022.ndf', SIZE = 2048KB) TO FILEGROUP [FG_inventory_2022];

ALTER DATABASE Ecom_Inventory_DM ADD FILE
(NAME = N'inventory_2023',
FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\inventory_2023.ndf', SIZE = 2048KB) TO FILEGROUP [FG_inventory_2023];

-- creation de shema
CREATE PARTITION SCHEME inventoryPartitionScheme
AS PARTITION InventoryDatePartitionFunction
TO ([Primary], [FG_inventory_2021], [FG_inventory_2022], [FG_inventory_2023]);

drop view FactInventories_view

-- creation de view pour extre les donnee qu'on a besion
CREATE VIEW FactInventories_view
AS
SELECT
	FactInventories.inv_ID,
    FactInventories.StockReceived ,
    FactInventories.StockSold ,
    FactInventories.StockOnHand ,
    FactInventories.Date_ID ,
    FactInventories.Product_ID ,
    FactInventories.Supplier_ID,
    DimDates.Date AS InventoryDate
FROM
    FactInventories
JOIN
    DimDates ON FactInventories.Date_ID = DimDates.Date_ID;


-- Create de neveux table de fait de partitionnement
CREATE TABLE inventoryFactPartitioned
(
    inv_ID INT,
    StockReceived INT,
    StockSold INT,
    StockOnHand INT,
    Date_ID INT,
    Product_ID INT,
    Supplier_ID INT,
    IventoryDate DATE,
    PRIMARY KEY (inv_ID, IventoryDate) 
)
ON inventoryPartitionScheme (IventoryDate);


-- l'insertion des donnees
INSERT INTO inventoryFactPartitioned (inv_ID, StockReceived, StockSold, StockOnHand, Date_ID, Product_ID, Supplier_ID, IventoryDate)
SELECT inv_ID, StockReceived, StockSold, StockOnHand, Date_ID, Product_ID, Supplier_ID, IventoryDate
FROM FactInventories_view;



-- affichage des information
SELECT 
	p.partition_number AS partition_number,
	f.name AS file_group, 
	p.rows AS row_count
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'inventoryFactPartitioned'
order by partition_number;


-- creation FK
ALTER TABLE inventoryFactPartitioned
ADD CONSTRAINT FK_ProductIDPar FOREIGN KEY (productID) REFERENCES DimProducts(productID);

ALTER TABLE inventoryFactPartitioned
ADD CONSTRAINT FK_DateIDPar FOREIGN KEY (DateID) REFERENCES DimDates(DateID);

ALTER TABLE inventoryFactPartitioned
ADD CONSTRAINT FK_SupplierIDPar FOREIGN KEY (SupplierID) REFERENCES DimSuppliers(SupplierID);