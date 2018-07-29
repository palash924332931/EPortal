
/****** Object:  Table [dbo].[Territories]    Script Date: 23/12/2016 2:59:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Territories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RootGroup_id] [int] NULL,
	[RootLevel_Id] [int] NULL,
	[Client_id] [int] NULL,
 CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id] FOREIGN KEY([RootGroup_id])
REFERENCES [dbo].[Groups] ([id])
GO

ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Groups_RootGroup_id]
GO

ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id] FOREIGN KEY([RootLevel_Id])
REFERENCES [dbo].[Levels] ([Id])
GO

ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_dbo.Territories_dbo.Levels_RootLevel_Id]
GO

ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Clients] FOREIGN KEY([Client_id])
REFERENCES [dbo].[Clients] ([Id])
GO

ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Clients]
GO

ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Territories] FOREIGN KEY([Id])
REFERENCES [dbo].[Territories] ([Id])
GO

ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Territories]
GO


