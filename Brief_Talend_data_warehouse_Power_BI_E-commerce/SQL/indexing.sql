use Ecommerce_store_dw

---Clustred Index
CREATE NONCLUSTERED INDEX IX_SalesFact_Sales_ID ON FactSales(Sales_ID);

CREATE NONCLUSTERED INDEX IX_SalesFact_CustomerKey ON FactSales (Customer_ID);

select * from FactSales

---Product
CREATE NONCLUSTERED INDEX IX_DimProducts_ProductName ON DimProducts(ProductName);
CREATE NONCLUSTERED INDEX IX_DimProducts_ProductCategory ON DimProducts(ProductCategory);
CREATE NONCLUSTERED INDEX IX_DimProducts_ProductSubCategory ON DimProducts(ProductSubCategory);