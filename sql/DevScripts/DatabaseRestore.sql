DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name

 
SET @path = 'C:\Cargas\DatabaseBackups\'  

 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

SET @fileName = @path + 'MLA_' + @fileDate + '.BAK'  

restore database MLA_test from disk = @fileName with 
	move 'MLA' to 'D:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\MLA_test.mdf',
	move 'MLA_log' to 'D:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\MLA_test_log.ldf'



