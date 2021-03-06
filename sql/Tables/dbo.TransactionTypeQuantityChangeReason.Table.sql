USE [MLA]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]') AND type in (N'U'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason] DROP CONSTRAINT IF EXISTS [TransactionTypeQuantityChangeReason_TransactionTypeID_FK]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]') AND type in (N'U'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason] DROP CONSTRAINT IF EXISTS [TransactionTypeQuantityChangeReason_QuantityChangeReasonID_FK]
GO
/****** Object:  Table [dbo].[TransactionTypeQuantityChangeReason]    Script Date: 3/9/2020 7:27:09 PM ******/
DROP TABLE IF EXISTS [dbo].[TransactionTypeQuantityChangeReason]
GO
/****** Object:  Table [dbo].[TransactionTypeQuantityChangeReason]    Script Date: 3/9/2020 7:27:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TransactionTypeQuantityChangeReason](
	[TransactionTypeQuantityChangeReasonID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionTypeID] [int] NULL,
	[QuantityChangeReasonID] [int] NULL,
	[Notes] [varchar](1000) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TransactionTypeQuantityChangeReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason_QuantityChangeReasonID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason]  WITH CHECK ADD  CONSTRAINT [TransactionTypeQuantityChangeReason_QuantityChangeReasonID_FK] FOREIGN KEY([QuantityChangeReasonID])
REFERENCES [dbo].[QuantityChangeReason] ([QuantityChangeReasonID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason_QuantityChangeReasonID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason] CHECK CONSTRAINT [TransactionTypeQuantityChangeReason_QuantityChangeReasonID_FK]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason_TransactionTypeID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason]  WITH CHECK ADD  CONSTRAINT [TransactionTypeQuantityChangeReason_TransactionTypeID_FK] FOREIGN KEY([TransactionTypeID])
REFERENCES [dbo].[TransactionType] ([TransactionTypeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason_TransactionTypeID_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[TransactionTypeQuantityChangeReason]'))
ALTER TABLE [dbo].[TransactionTypeQuantityChangeReason] CHECK CONSTRAINT [TransactionTypeQuantityChangeReason_TransactionTypeID_FK]
GO
