USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[csiGetCurrentProcesses]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[csiGetCurrentProcesses]
GO
/****** Object:  StoredProcedure [dbo].[csiGetCurrentProcesses]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csiGetCurrentProcesses]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csiGetCurrentProcesses] AS' 
END
GO



ALTER PROCEDURE [dbo].[csiGetCurrentProcesses]
	@BlockedOnly bit = 0
AS
	SET NOCOUNT ON

	/*
	Author:
	Benjamin Bolte
	brbolte@msn.com

	Purpose:
	Identify active or blocking connections, and list the active command on the connection.
	*/

	/*
	Status Definitions, per Books Online:

	Background	SPID is performing a background task. 
	Sleeping	SPID is not currently executing. This usually indicates that the SPID is awaiting a command from the application. 
	Runnable	SPID is currently executing. 
	Dormant  	Same as Sleeping, except Dormant also indicates that the SPID has been reset after completing an RPC event. The reset cleans up resources used during the RPC event. This is a normal state and the SPID is available and waiting to execute further commands.  
	Rollback	The SPID is in rollback of a transaction. 
	Defwakeup	Indicates that a SPID is waiting on a resource that is in the process of being freed. The waitresource field should indicate the resource in question. 
	Spinloop	Process is waiting while attempting to acquire a spinlock used for concurrency control on SMP systems 

	*/
	create table #ProcCheck(
		Status varchar(50) ,
		SPID int ,
		CPU int ,
		Pys_IO int ,
		WaitTime int ,
		BlockSPID int ,
		LastCmd varchar(500) ,
		HostName varchar(36) ,
		ProgName varchar(100) ,
		NTUser varchar(50) ,
		LoginTime datetime ,
		LastBatch datetime ,
		OpenTrans int)

	create table #ProcInfo(
		EventType varchar(100) ,
		Parameters int ,
		EventInfo varchar(7000)
	)

	INSERT INTO #ProcCheck(Status, SPID, CPU, Pys_IO, WaitTime, BlockSPID, HostName, ProgName, NTUSer, LoginTime, LastBatch, OpenTrans)
	SELECT status, SPID, CPU, Physical_IO, WaitTime, Blocked, SUBSTRING(HostName, 1, 36), SUBSTRING(Program_Name, 1, 100), SUBSTRING(nt_username, 1, 50), Login_Time, Last_Batch, Open_Tran
	FROM master..sysprocesses
	where (blocked > 0
	or spid in (select blocked from master..sysprocesses (NOLOCK) where blocked > 0)
		or (open_tran > 0 and @BlockedOnly=0)
		)
	and SPID <> @@SPID

	declare @spid int ,
		@cmd varchar(7000)

	declare Procs cursor fast_forward for
	SELECT SPID FROM #ProcCheck

	OPEN Procs

	FETCH NEXT FROM Procs INTO @SPID
	WHILE @@FETCH_STATUS = 0
		BEGIN

		SET @cmd = 'DBCC INPUTBUFFER(' + CONVERT(varchar, @SPID) + ')'

		INSERT INTO #ProcInfo
		EXEC(@cmd)
	
		SELECT @cmd = EventInfo
		FROM #ProcInfo

		DELETE FROM #ProcInfo

		UPDATE #ProcCheck
		SET LastCmd = SUBSTRING(@cmd, 1, 500)
		WHERE SPID = @SPID

		FETCH NEXT FROM Procs INTO @SPID

		END

	CLOSE Procs
	DEALLOCATE Procs

	SELECT * FROM #ProcCheck	

	DROP TABLE #ProcCheck
	DROP TABLE #ProcInfo



GO
