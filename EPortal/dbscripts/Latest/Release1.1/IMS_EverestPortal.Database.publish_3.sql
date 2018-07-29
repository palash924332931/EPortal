/****** Object:  Table [dbo].[PeriodType]    Script Date: 3/04/2018 1:51:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PeriodType](
	[PeriodTypeId] [int] NOT NULL,
	[PeriodType] [varchar](100) NULL,
 CONSTRAINT [PK_PeriodType] PRIMARY KEY CLUSTERED 
(
	[PeriodTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  Table [dbo].[EntityType]    Script Date: 3/04/2018 1:50:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EntityType](
	[EntityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeCode] [varchar](50) NOT NULL,
	[EntityTypeName] [varchar](200) NOT NULL,
	[DataTypeId] [int] NULL,
	[Abbrev] [varchar](50) NUll,
	[Display] [varchar](200) NUll
 CONSTRAINT [PK_EntityType] PRIMARY KEY CLUSTERED 
(
	[EntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EntityType]  WITH CHECK ADD  CONSTRAINT [FK_EntityType_DataType] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[DataType] ([DataTypeId])
GO

ALTER TABLE [dbo].[EntityType] CHECK CONSTRAINT [FK_EntityType_DataType]
GO



/****** Object:  Table [dbo].[SubChannels]    Script Date: 3/04/2018 2:20:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SubChannels](
	[DeliverableId] [int] NOT NULL,
	[EntityTypeId] [int] NOT NULL,
 CONSTRAINT [PK_SubChannels] PRIMARY KEY CLUSTERED 
(
	[DeliverableId] ASC,
	[EntityTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

