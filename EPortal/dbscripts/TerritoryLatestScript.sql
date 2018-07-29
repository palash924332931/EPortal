USE [EverestClientPortal]
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 18-Mar-17 4:43:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[GroupNumber] [nvarchar](max) NULL,
	[CustomGroupNumber] [nvarchar](max) NULL,
	[IsLineHide] [bit] NOT NULL DEFAULT ((0)),
	[PaddingLeft] [int] NOT NULL DEFAULT ((0)),
	[ParentGroupNumber] [int] NULL,
 CONSTRAINT [PK_dbo.Groups] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Levels]    Script Date: 18-Mar-17 4:43:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Levels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[LevelNumber] [int] NOT NULL,
	[LevelIDLength] [int] NOT NULL DEFAULT ((0)),
	[LevelColor] [nvarchar](max) NULL,
	[BackgroundColor] [nvarchar](max) NULL,
	[TerritoryId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Levels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Territories]    Script Date: 18-Mar-17 4:43:28 PM ******/
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
	[IsBrickBased] [bit] NULL,
 CONSTRAINT [PK_dbo.Territories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Groups] ON 

GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (13, N'Australia', NULL, N'11', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (14, N'NSW', 13, N'21', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (15, N'VIC', 13, N'22', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1002, N'Australia', NULL, N'11', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1003, N'NSW', 1002, N'21', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1004, N'VIC', 1002, N'22', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1005, N'NSW_CH1', 1003, N'31', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1006, N'NSW_CH2', 1003, N'32', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1007, N'VIC_CH1', 1004, N'33', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1008, N'VIC_CH2', 1004, N'34', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1009, N'Australia', NULL, N'11', N'01', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1010, N'NSW', 1009, N'21', N'', 0, 130, NULL)
GO
INSERT [dbo].[Groups] ([id], [Name], [ParentId], [GroupNumber], [CustomGroupNumber], [IsLineHide], [PaddingLeft], [ParentGroupNumber]) VALUES (1011, N'VIC', 1009, N'22', N'', 0, 130, NULL)
GO
SET IDENTITY_INSERT [dbo].[Groups] OFF
GO
SET IDENTITY_INSERT [dbo].[Levels] ON 

GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1002, N'Level 1:Australia 01', 1, 2, N'', N'', 1003)
GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1003, N'Level 2', 2, 1, N'', N'', 1003)
GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1004, N'Level 3', 3, 2, N'', N'', 1003)
GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1005, N'Australia 01', 1, 2, N'', N'', 1004)
GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1006, N'Level 2', 2, 1, N'', N'', 1004)
GO
INSERT [dbo].[Levels] ([Id], [Name], [LevelNumber], [LevelIDLength], [LevelColor], [BackgroundColor], [TerritoryId]) VALUES (1007, N'Level 3', 3, 2, N'', N'', 1004)
GO
SET IDENTITY_INSERT [dbo].[Levels] OFF
GO
SET IDENTITY_INSERT [dbo].[Territories] ON 

GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (1003, N'T1', 1002, NULL, 0, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (1004, N'T1', 1009, NULL, 0, 0)
GO
SET IDENTITY_INSERT [dbo].[Territories] OFF
GO
ALTER TABLE [dbo].[Groups]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Groups] ([id])
GO
ALTER TABLE [dbo].[Groups] CHECK CONSTRAINT [FK_dbo.Groups_dbo.Groups_Parent_Id]
GO
ALTER TABLE [dbo].[Levels]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId] FOREIGN KEY([TerritoryId])
REFERENCES [dbo].[Territories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Levels] CHECK CONSTRAINT [FK_dbo.Levels_dbo.Territories_TerritoryId]
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
ALTER TABLE [dbo].[Territories]  WITH CHECK ADD  CONSTRAINT [FK_Territories_Territories] FOREIGN KEY([Id])
REFERENCES [dbo].[Territories] ([Id])
GO
ALTER TABLE [dbo].[Territories] CHECK CONSTRAINT [FK_Territories_Territories]
GO
