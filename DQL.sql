--1

SELECT TOP 2
	EmployeeID, 
	EmployeeName, 
	Gender 
FROM MsEmployee
WHERE Gender = 'f'

--2
SELECT 
	EmployeeID,
	EmployeeName, 
	[Address], 
	Phone, Gender, 
	DateOfBirth,
	Salary, 
	BranchID 
FROM MsEmployee
WHERE RIGHT(Phone,1) = 5 AND Salary > 4000000

--3
CREATE VIEW view_1 AS	
SELECT * FROM MsMusicIns
WHERE (Price BETWEEN 5000000 AND 10000000) AND MusicIns LIKE 'Yamaha%'

--4 

SELECT 
REPLACE(EmployeeName, SUBSTRING(EmployeeName, 0, CHARINDEX(' ',EmployeeName )) , BranchID) AS 'Branch Employee'
FROM MsEmployee
where EmployeeName LIKE '% % %'

--5
SELECT 
	SUBSTRING(MusicIns, 0, CHARINDEX(' ', musicins)) AS 'Brand ', 
	CONCAT('Rp. ',CAST(price AS VARCHAR(255))), 
	Stock,
	MusicInsType
FROM MsMusicIns m
JOIN MsMusicInsType ms
ON ms.MusicInsTypeID = m.MusicInsTypeID

--6
SELECT 
	EmployeeName, 
	(CASE WHEN Gender = 'M' THEN 'Male' WHEN gender = 'F' THEN 'Female' END) AS 'Gender',
	CONVERT(VARCHAR, TransactionDate, 106) AS 'Transaction Date',
	CustomerName
FROM MsEmployee m
JOIN HeaderTransaction ht
ON m.EmployeeID = ht.EmployeeID
WHERE Gender = 'm' AND EmployeeName LIKE '% %'
ORDER BY EmployeeName

--7
SELECT 
	m.EmployeeID, 
	EmployeeName, 
	CONVERT(VARCHAR, DateOfBirth, 106) AS 'DateOfBirth', 
	CustomerName, 
	CONVERT(VARCHAR, transactiondate, 106) AS 'TransactionDate' 
FROM MsEmployee m
JOIN HeaderTransaction ht
ON ht.EmployeeID= m.EmployeeID
WHERE DATENAME(MONTH, DateOfBirth) = 'December' AND DATENAME(DAY, TransactionDate) = 16

--8
SELECT BranchName, EmployeeName FROM MsEmployee e
JOIN MsBranch b
On e.BranchID = b.BranchID
JOIN HeaderTransaction ht
ON ht.EmployeeID = e.EmployeeID
JOIN DetailTransaction dt
ON dt.TransactionID = ht.TransactionID
WHERE DATENAME(MONTH, TransactionDate)='October' AND qty >= 5

--9
GO
CREATE PROCEDURE search @search NVARCHAR(50) AS
SELECT EmployeeName, Address, Phone, Gender FROM MsEmployee
WHERE EmployeeName LIKE  '%' + @search + '%' OR phone LIKE '%' + @search + '%'  OR gender LIKE '%' + @search + '%'  OR address LIKE '%' + @search + '%' 

--9 EXEC lim
EXEC search @search = 'lim'

--9 EXEC 19
EXEC search @search = '19'

--9 EXEC F
EXEC search @search = 'F'

--10
Go
CREATE PROCEDURE "Check_Transaction"  @check NVARCHAR(50) AS
SELECT CustomerName, EmployeeName, BranchName, MusicIns, Price FROM MsEmployee e
JOIN HeaderTransaction ht
ON ht.EmployeeID = e.EmployeeID
JOIN MsBranch b
ON b.BranchID = e.BranchID
JOIN DetailTransaction dt
ON ht.TransactionID = dt.TransactionID
JOIN MsMusicIns ms 
ON ms.MusicInsID = dt.MusicInsID
WHERE ht.TransactionID = @check

--10 EXEC
EXEC Check_Transaction @check = 'TR001'

--11
SELECT COUNT(*), EmployeeName FROM MsEmployee e
JOIN HeaderTransaction ht
ON ht.EmployeeID = e.EmployeeID
JOIN DetailTransaction dt
ON dt.TransactionID = ht.TransactionID
GROUP BY EmployeeName

--12
GO
CREATE PROCEDURE "Add_Stock_MusicIns" @id VARCHAR(50), @stock INT AS
BEGIN
IF(@stock <=0) 
	PRINT 'Stok yang di input harus lebih besar dari 0'
	ELSE
	UPDATE MsMusicIns
	SET Stock = Stock + @stock
	WHERE MusicInsID = @id
	END
GO

--13
CREATE PROCEDURE "Check_Sale" @month VARCHAR(50) AS
SELECT MusicInsType, qty FROM MsMusicInsType mt
JOIN MsMusicIns mi
ON mi.MusicInsTypeID = mt.MusicInsTypeID
JOIN DetailTransaction dt
ON dt.MusicInsID= mi.MusicInsID
JOIN HeaderTransaction ht
ON ht.TransactionID = dt.TransactionID
WHERE DATENAME(MONTH, TransactionDate) = @month
GO

--14
CREATE PROCEDURE "Check_Employee" @id VARCHAR(50) AS
BEGIN
IF(@id NOT LIKE '')
SELECT 
	EmployeeName, 
	e.[Address], 
	e.phone ,
	CONVERT(VARCHAR,DateOfBirth,106) AS 'DateOfBirth',
	BranchName 
FROM MsEmployee e
JOIN HeaderTransaction ht 
ON ht.EmployeeID = e.EmployeeID
JOIN MsBranch b
ON e.BranchID = b.BranchID
	ELSE
SELECT 
	EmployeeName, 
	e.[Address], 
	e.phone ,
	CONVERT(VARCHAR,DateOfBirth,106) AS 'DateOfBirth',
	BranchName 
FROM MsEmployee e
JOIN HeaderTransaction ht 
ON ht.EmployeeID = e.EmployeeID
JOIN MsBranch b
ON e.BranchID = b.BranchID
WHERE TransactionID = @id
END
 













