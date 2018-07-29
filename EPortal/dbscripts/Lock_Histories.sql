IF OBJECT_ID (N'LockHistories', N'U') IS NULL 
BEGIN
   CREATE TABLE [dbo].[LockHistories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DefId] [int] NULL,
	[DocType] [nvarchar](200) NULL,
	[LockType] [nvarchar](200) NULL,
	[LockTime] [datetime] NULL,
	[ReleaseTime] [datetime] NULL,
	[Status] [nvarchar](100) NULL,
	[UserId] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[LockHistories]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserID])

END