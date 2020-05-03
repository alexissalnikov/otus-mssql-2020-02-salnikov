--1. ��� ������, � ������� � �������� ���� ������� urgent ��� �������� ���������� � Animal
SELECT [StockItemID]
      ,[StockItemName]
  FROM [Warehouse].[StockItems]
  WHERE StockItemName like 'Animal%' or StockItemName like '%urgent%';

--2. �����������, � ������� �� ���� ������� �� ������ ������ (����� ������� ��� ��� ������ ����� ���������, ������ �������� ����� JOIN)
SELECT s.[SupplierID]
      ,s.[SupplierName]
  FROM [Purchasing].[Suppliers] s
  LEFT JOIN [Purchasing].[SupplierTransactions] st
  ON s.SupplierID = st.SupplierID
  WHERE st.SupplierID IS NULL;

--3. ������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������,
--�������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, ���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20.
  SELECT
     o.OrderID
	,o.OrderDate
	,CONVERT(nvarchar(3), o.OrderDate, 0) AS SaleMonth
	,(MONTH(o.OrderDate) + 2) / 3 AS SaleQuarter
	,(MONTH(o.OrderDate) + 3) / 4 AS SaleYearThird
  FROM [Sales].[Orders] o
  INNER JOIN [Sales].[OrderLines] ol on ol.OrderID = o.OrderID and (ol.Quantity > 20 or ol.UnitPrice > 100) and o.[PickingCompletedWhen] is not null
   
--�������� ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� �������.
  SELECT
     o.OrderID
	,o.OrderDate
	,CONVERT(nvarchar(3), o.OrderDate, 0) AS SaleMonth
	,(MONTH(o.OrderDate) + 2) / 3 AS SaleQuarter
	,(MONTH(o.OrderDate) + 3) / 4 AS SaleYearThird
  FROM [Sales].[Orders] o
  INNER JOIN [Sales].[OrderLines] ol on ol.OrderID = o.OrderID and (ol.Quantity > 20 or ol.UnitPrice > 100) and o.[PickingCompletedWhen] is not null
  ORDER BY (MONTH(o.OrderDate) + 2) / 3, (MONTH(o.OrderDate) + 3) / 4, o.OrderDate
  OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

--4. ������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, �������� �������� ����������, ��� ����������� ���� ������������ �����
SELECT distinct po.PurchaseOrderID, s.SupplierName, p.FullName
  FROM [WideWorldImporters].[Purchasing].[PurchaseOrders] po
  INNER JOIN [Application].[DeliveryMethods] dm on po.DeliveryMethodID = dm.DeliveryMethodID and dm.DeliveryMethodName in ('Road Freight','Post')
  INNER JOIN [Purchasing].[Suppliers] s on po.SupplierID = s.SupplierID
  INNER JOIN [Application].[People] p on po.ContactPersonID = p.PersonID
  INNER JOIN [Warehouse].[StockItemTransactions] sit on sit.PurchaseOrderID = po.PurchaseOrderID
  --WHERE po.ExpectedDeliveryDate between '20140101' and '20141231' ----� �������������, ��� ����� "��������", ���� ��������� ���� � ��������� ���
  WHERE sit.TransactionOccurredWhen > '20140101' and sit.TransactionOccurredWhen < '20150101'  --� �������������, ��� ����� "��������", ���� �������� �� �����

--5. 10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����.
SELECT TOP(10)
    o.OrderID
   ,o.OrderDate
   ,pcust.FullName AS ClientName
   ,pemp.FullName AS SalespersonName
  FROM [Sales].[Orders] o
  INNER JOIN [Application].[People] pemp on o.SalespersonPersonID = pemp.PersonID
  INNER JOIN [Application].[People] pcust on o.ContactPersonID = pcust.PersonID
  ORDER BY o.OrderDate DESC  --�������� ����� �������� LastEditedWhen

--6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g
SELECT distinct
    pcust.PersonID
   ,pcust.FullName
   ,pcust.PhoneNumber
  FROM [Sales].[OrderLines] ol
  INNER JOIN [Sales].[Orders] o on ol.OrderID = o.OrderID
  INNER JOIN [Application].[People] pcust on o.ContactPersonID = pcust.PersonID
  WHERE ol.Description = 'Chocolate frogs 250g'
  