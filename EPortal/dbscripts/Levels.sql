
/****** Object:  Table [dbo].[Levels]    Script Date: 23/12/2016 2:58:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Levels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Parent_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Levels]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Levels_dbo.Levels_Parent_Id] FOREIGN KEY([Parent_Id])
REFERENCES [dbo].[Levels] ([Id])
GO

ALTER TABLE [dbo].[Levels] CHECK CONSTRAINT [FK_dbo.Levels_dbo.Levels_Parent_Id]
GO


