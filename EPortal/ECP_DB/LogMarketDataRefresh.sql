CREATE TABLE [dbo].[LogMarketDataRefresh](
	[Time_Stamp] [datetime] NULL,
	[TotalPacks] [int] NULL,
	[NewPacks] [int] NULL,
	[DeletedPacks] [int] NULL,
	[ModifiedPacks] [int] NULL,
	[Status] [nvarchar](30) NULL,
	[StepFailed] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
