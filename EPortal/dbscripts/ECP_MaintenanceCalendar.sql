IF OBJECT_ID('dbo.Maintenance_Calendar') IS NULL
Begin
	CREATE TABLE [dbo].[Maintenance_Calendar](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[Year] [int] NOT NULL,
		[Month] [varchar](30) NOT NULL,
		[Schedule_From] [datetime] NULL,
		[Schedule_To] [datetime] NULL,
		[ActionDate] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Maintenance_Calendar] ADD CONSTRAINT DF_ActionDate DEFAULT GETDATE() FOR ActionDate
End

IF OBJECT_ID('Maintenance_Calendar_Staging') IS NULL
Begin
	CREATE TABLE [dbo].[Maintenance_Calendar_Staging](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[Year] [int] NOT NULL,
		[Month] [varchar](30) NOT NULL,
		[Schedule_From] [datetime] NULL,
		[Schedule_To] [datetime] NULL,
		[ActionDate] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Maintenance_Calendar_Staging] ADD  CONSTRAINT [Staging_ActionDate]  DEFAULT (getdate()) FOR [ActionDate]
End

Go

	create PROCEDURE [dbo].[PopulateMaintenanceCalendar] 
	AS
	BEGIN

	Update Maintenance_Calendar
	Set Schedule_From=a.Schedule_From,Schedule_To=a.Schedule_To
	From Maintenance_Calendar_Staging a
	Join  Maintenance_Calendar b on a.[year]=b.[year] and LEFT(a.Month,3)=LEFT(b.Month,3)

	INSERT INTO  [dbo].[Maintenance_Calendar]
			   ([Year]           ,[Month]
			   ,[Schedule_From]           ,[Schedule_To]
			   ,[ActionDate])
	Select		a.[Year]           ,a.[Month]
			   ,a.[Schedule_From]           ,a.[Schedule_To]
			   ,a.[ActionDate]
	from Maintenance_Calendar_Staging a
	left join  Maintenance_Calendar b on a.[year]=b.[year] and LEFT(a.Month,3)=LEFT(b.Month,3)
	where b.ID is null
	
	END




