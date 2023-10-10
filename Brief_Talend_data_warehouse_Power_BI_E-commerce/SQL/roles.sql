CREATE LOGIN admin_jane WITH PASSWORD = 'jane/()';
CREATE LOGIN Yassine_regular WITH PASSWORD = 'yassine_7';

-------

USE Ecom_Inventory_DM;
CREATE USER Jane FOR LOGIN admin_jane;
CREATE USER Yassine FOR LOGIN Yassine_regular;

USE Ecom_Sales_DM;
CREATE USER Jane FOR LOGIN admin_jane;
CREATE USER Yassine FOR LOGIN Yassine_regular;

--------------

USE Ecom_Inventory_DM;
ALTER ROLE db_owner ADD MEMBER Jane;

USE Ecom_Sales_DM;

ALTER ROLE db_datareader ADD MEMBER Yassine;
ALTER ROLE db_datawriter ADD MEMBER Yassine;