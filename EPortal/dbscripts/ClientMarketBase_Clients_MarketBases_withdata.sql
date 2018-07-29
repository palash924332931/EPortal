USE [EverestClientPortal]
GO
/****** Object:  Table [dbo].[ClientMarketBases]    Script Date: 20-Jan-17 11:55:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientMarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[MarketBaseId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ClientMarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clients]    Script Date: 20-Jan-17 11:55:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[IsMyClient] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MarketBases]    Script Date: 20-Jan-17 11:55:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarketBases](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.MarketBases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[ClientMarketBases] ON 

GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (1, 1, 1)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (2, 1, 2)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (3, 2, 1)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (4, 3, 2)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (5, 4, 1)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (6, 4, 2)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (7, 5, 3)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (8, 6, 4)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (9, 1, 3)
GO
INSERT [dbo].[ClientMarketBases] ([Id], [ClientId], [MarketBaseId]) VALUES (10, 1, 4)
GO
SET IDENTITY_INSERT [dbo].[ClientMarketBases] OFF
GO
SET IDENTITY_INSERT [dbo].[Clients] ON 

GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (1, N'Client 1', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (2, N'Client 2', 0)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (3, N'Client 3', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (4, N'Client 4', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (5, N'Client 5', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (6, N'Client 6', 0)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (7, N'Client 7', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (8, N'Client 8', 1)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (9, N'Client 9', 0)
GO
INSERT [dbo].[Clients] ([Id], [Name], [IsMyClient]) VALUES (10, N'Client X', 1)
GO
SET IDENTITY_INSERT [dbo].[Clients] OFF
GO
SET IDENTITY_INSERT [dbo].[MarketBases] ON 

GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (1, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (2, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (3, N'ATC4 D07A0', N'D07A0')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (4, N'ATC3 A06A', N'A06A')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (7, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (8, N'ATC4 D07A0', N'D07A0')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (9, N'ATC3 A06A', N'A06A')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (10, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (11, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (14, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (15, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (16, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (17, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (18, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (19, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (20, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (21, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (22, N'ATC3 N02B', N'ATC3 N02B')
GO
INSERT [dbo].[MarketBases] ([Id], [Name], [Description]) VALUES (23, N'Manufacturer ALCON', N'Manufacturer ALCON')
GO
SET IDENTITY_INSERT [dbo].[MarketBases] OFF
GO
