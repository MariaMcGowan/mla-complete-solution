DECLARE @BackupDB VARCHAR(50) -- backup database name  
DECLARE @RestoreDB VARCHAR(50)	-- restore to database
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name
DECLARE @sql VARCHAR(2000)	
 
-- specify database backup directory
SET @BackupDB = 'MLA'
SET @RestoreDB = @BackupDB + '_test'
SET @path = 'C:\Cargas\DatabaseBackups\'  
 
-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

SET @fileName = @path + @BackupDB + '_' + @fileDate + '.BAK'  
BACKUP DATABASE @BackupDB TO DISK = @fileName  





