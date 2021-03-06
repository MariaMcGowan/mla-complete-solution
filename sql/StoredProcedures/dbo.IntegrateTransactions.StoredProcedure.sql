USE [MLA]
GO
/****** Object:  StoredProcedure [dbo].[IntegrateTransactions]    Script Date: 3/9/2020 7:27:08 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[IntegrateTransactions]
GO
/****** Object:  StoredProcedure [dbo].[IntegrateTransactions]    Script Date: 3/9/2020 7:27:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IntegrateTransactions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[IntegrateTransactions] AS' 
END
GO



ALTER proc [dbo].[IntegrateTransactions] 
	@Testing bit = 1, 
	@Document varchar(100) = null
as



--select *
--from staging.DetailEntryWork
--where Document = '200883'

--select Document
--from staging.DetailEntryWork
--group by Document
--order by 1

--select *
--from staging.DetailEntryWork
--where Document = '0'
	declare @BatchNo int = 0
	declare @Journal varchar(4)

	if @Testing = 1
		select @Journal = 'INJ'
	else
		select @Journal = 'GJ'

-- Create the batches			
	if exists (select 1 from GLBatch)
		select @BatchNo = max(batchno) from GLBATCH

	create table #WorkBatch (BatchNo int , BatchTitle varchar(100), Document varchar(100), Date date, ClientNumber varchar(20), Invoiced bit default 0, Paid bit default 0)

	insert into #WorkBatch (BatchNo, BatchTitle, Document, Date, ClientNumber)
	select
		BatchNo = @BatchNo + ROW_NUMBER() OVER (ORDER BY ClientNumber, Document, Date),
		BatchTitle = Document + ' ' + convert(varchar(100), Date, 100),
		Document,
		Date,
		ClientNumber
	from staging.DetailEntryWork
	where (@Document is not null and Document = @Document)
	or (@Document is null)
	group by Document, Date, ClientNumber

	update b set b.Invoiced = 1
	from #WorkBatch b 
	inner join staging.DetailEntryWork s on
		b.ClientNumber = s.ClientNumber 
		and b.Document = s.Document
		and b.Date = s.Date
	where s.JournalEntryCategory = 'Accounts Receivable' and s.JournalEntryType = 'Invoices'

	update b set b.Paid = 1
	from #WorkBatch b 
	inner join staging.DetailEntryWork s on
		b.ClientNumber = s.ClientNumber 
		and b.Document = s.Document
		and b.Date = s.Date
	where s.JournalEntryCategory = 'Accounts Receivable' and s.JournalEntryType = 'Cash Payments'


	create index idxMatch on #WorkBatch(Document, Date, ClientNumber)

	declare @Work table (ClientNumber varchar(20), Document varchar(20), Amount numeric(18,2), Location varchar(20), ClassID varchar(20), BatchNo int)

	insert into GLBATCH (BATCHNO, BATCH_TITLE, BATCH_DATE, JOURNAL, IntegrationStatusID)
	select BatchNo, BatchTitle, Date, @Journal, 1
	from #WorkBatch
	order by 1


-- Create the entries
----------------------------------------------------
-- 1) Beginning Balances
----------------------------------------------------

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1070',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Work in Progress' and JournalEntryType = 'Beginning Balance'

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '4020',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Work in Progress' and JournalEntryType = 'Beginning Balance'

----------------------------------------------------
-- 2) Billable Fees / Expenses / Progress Applied (?)
----------------------------------------------------

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1070',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where (JournalEntryCategory = 'Work in Progress' and JournalEntryType in ('Billable Fee', 'Billing Expense'))
	or (JournalEntryCategory = 'Progress Billings' and JournalEntryType = 'Progress Applied')

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '4020',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where (JournalEntryCategory = 'Work in Progress' and JournalEntryType in ('Billable Fee', 'Billing Expense'))
	or (JournalEntryCategory = 'Progress Billings' and JournalEntryType = 'Progress Applied')


----------------------------------------------------
-- 3) Progress Billed
----------------------------------------------------

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1060',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Progress Billings' and JournalEntryType = 'Progress Billed'

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '2035',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Progress Billings' and JournalEntryType = 'Progress Billed'


----------------------------------------------------
-- 4) Reverse out Beginning Balance
----------------------------------------------------

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1070',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = 'Reverse out ' + JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Work in Progress' and JournalEntryType = 'Beginning Balance'


	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '4020',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = 'Reverse out ' + JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
		and s.Date = b.Date
	where JournalEntryCategory = 'Work in Progress' and JournalEntryType = 'Beginning Balance'

----------------------------------------------------
-- 5) Invoiced
----------------------------------------------------

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	output inserted.CUSTOMERID, inserted.DOCUMENT, inserted.TRX_AMOUNT, inserted.BATCHNO, inserted.LOCATION, inserted.CLASSID into @Work (ClientNumber, Document, Amount, BatchNo, Location, ClassID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1060',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID = null, -- new
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Invoiced = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Invoices'

-- Credit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	output inserted.CUSTOMERID, inserted.DOCUMENT, inserted.TRX_AMOUNT * -1, inserted.BATCHNO, inserted.LOCATION, inserted.CLASSID into @Work (ClientNumber, Document, Amount, BatchNo, Location, ClassID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = 
			CASE
				WHEN JournalEntryType in ('Billable Fee', 'Billable Expenses') then '4020'
				--WHEN JournalEntryType in ('Beginning Balance') then '4010'
				WHEN JournalEntryType in ('Write Ups', 'Write Downs') then '4040'
			end,
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID = null, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Invoiced = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Work in Progress' and JournalEntryType in ('Billable Fee', 'Billable Expenses', 'Write Ups', 'Write Downs') 
	and exists (select 1 from staging.DetailEntryWork where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Invoices' and ClientNumber = s.ClientNumber and Document = s.Document)
	--where JournalEntryCategory = 'Work in Progress' and JournalEntryType in ('Billable Fee', 'Billable Expenses', 'Beginning Balance', 'Write Ups', 'Write Downs') 
	--and exists (select 1 from staging.DetailEntryWork where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Invoices' and ClientNumber = s.ClientNumber and Document = s.Document)

	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = BatchNo, 
		ACCOUNTNO = '4010',
		TRX_AMOUNT = ABS(sum(Amount)),
		TR_TYPE =
			CASE
				WHEN sum(Amount) * -1 < 0 then -1
				else 1
			END,
		Location,
		EmployeeID = null, 
		ClassID, 
		Document,
		DESCRIPTION = 'Standard Billing',
		CUSTOMERID = ClientNumber
	from @Work
	group by ClientNumber, Document, BatchNo, Location, ClassID
	order by BatchNo, Document
	

----------------------------------------------------
-- 6) Payment
----------------------------------------------------

-- Debit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1060',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Cash Payments'

-- Credit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1010',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Invoices'


----------------------------------------------------
-- 7) Service Charges
----------------------------------------------------

-- Debit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1060',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Service Charge'

-- Credit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '4070',		-- Service Charge?
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Service Charge'



----------------------------------------------------
-- 8) Adjustments to AR
----------------------------------------------------

-- Debit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '4070',			-- Service Charnge?
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Adjustments to A/R'

-- Credit
	insert into GLENTRY (BATCHNO, ACCOUNTNO, TRX_AMOUNT, TR_TYPE, LOCATION, EMPLOYEEID, CLASSID, DOCUMENT, DESCRIPTION, CUSTOMERID)
	select
		BATCHNO = b.BatchNo, 
		ACCOUNTNO = '1060',
		TRX_AMOUNT = ABS(Amount),
		TR_TYPE =
			CASE
				WHEN Amount < 0 then -1
				else 1
			END,
		Location,
		EmployeeID, 
		ClassID, 
		s.Document,
		DESCRIPTION = JournalEntryType,
		CUSTOMERID = s.ClientNumber
	from staging.DetailEntryWork s 
	inner join #WorkBatch b on 
		b.Paid = 1
		and s.Document = b.Document 
		and s.ClientNumber = s.ClientNumber
	where JournalEntryCategory = 'Accounts Receivable' and JournalEntryType = 'Adjustments to A/R'


--select *
--from #WorkBatch



GO
