CREATE TABLE [dbo].[EntityType](
	[EntityTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EntityTypeCode] [varchar](50) NOT NULL,
	[EntityTypeName] [varchar](200) NOT NULL,
	[DataTypeId] [int] NULL,
	[Abbrev] [varchar](50) NULL,
	[Display] [varchar](200) NULL,
	[Description] [varchar](200) NULL,
	[IsActive] [bit] NOT NULL DEFAULT(1)
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