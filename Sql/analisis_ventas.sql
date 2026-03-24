-- Ventas totales
SELECT sum(Price * Quantity) as total_ventas 
FROM Products p
INNER JOIN OrderDetails od on p.ProductID=od.ProductID


-- Ventas por país
SELECT Country as pais, 
		sum(Price * Quantity) as total_ventas
FROM Customers c
inner JOIN Orders o on c.CustomerID=o.CustomerID
INNER JOIN OrderDetails od on o.OrderID=od.OrderID
inner JOIN Products p on p.ProductID=od.ProductID
GROUP by Country
ORDER by total_ventas DESC

-- Top clientes
SELECT CustomerName as nombre_cliente,
		sum(Price * Quantity) as total_ventas
FROM Customers c
inner JOIN Orders o on c.CustomerID=o.CustomerID
INNER JOIN OrderDetails od on o.OrderID=od.OrderID
inner JOIN Products p on p.ProductID=od.ProductID
GROUP by CustomerName 
order by total_ventas DESC
LIMIT 10

-- Top productos 
SELECT ProductName as nombre_producto,
		sum(Price * Quantity) as total_ventas
FROM Products p 
INNER JOIN OrderDetails od on p.ProductID=od.ProductID
INNER JOIN Orders o on o.OrderID=od.OrderID
GROUP by ProductName
order by total_ventas DESC
LIMIT 10

-- Ventas por categoría
SELECT CategoryName as nombre_categoria, 
		sum(Price * Quantity) as total_ventas
FROM Categories c 
INNER JOIN Products p on c.CategoryID=p.CategoryID
INNER JOIN OrderDetails od on p.ProductID=od.ProductID
INNER JOIN Orders o on o.OrderID=od.OrderID
GROUP by CategoryName
ORDER by total_ventas DESC

-- Ventas por mes
SELECT strftime('%Y', OrderDate) as año,
	   strftime('%m', OrderDate) as mes,
	   sum(Price * Quantity) as total_ventas
FROM Orders o
INNER JOIN OrderDetails od on o.OrderID=od.OrderID 
INNER JOIN Products p on p.ProductID=od.ProductID
GROUP by año, mes

--Producto más vendido por categoría

WITH  vantas_producto as(
SELECT ProductName as nombre_producto, 
	CategoryName as nombre_categoria,
	sum (Price * Quantity) as total_vendido,
	rank () over(PARTITION by CategoryName ORDER by sum(Price * Quantity)  DESC ) as ranking
FROM Products p 
INNER JOIN Categories c on p.CategoryID=c.CategoryID
INNER JOIN OrderDetails od on p.ProductID = od.ProductID
GROUP by CategoryName, ProductName
)
SELECT nombre_categoria, nombre_producto, total_vendido
FROM vantas_producto
WHERE ranking = 1

-- Clientes que compran más que el promedio
WITH ventas_cliente as (
SELECT CustomerName as nombre_cliente,
		sum(Price * Quantity) as total_ventas
FROM Customers c
INNER JOIN Orders o on c.CustomerID=o.CustomerID
INNER JOIN OrderDetails od on o.OrderID=od.OrderID
INNER JOIN Products p on p.ProductID=od.ProductID
GROUP by CustomerName
)
SELECT nombre_cliente, total_ventas
FROM ventas_cliente 
WHERE total_ventas > (
SELECT avg(total_ventas) 
FROM ventas_cliente
) 
ORDER by total_ventas DESC
