USE [EverestClientPortal]
GO

alter table dbo.Territories add IsBrickBased BIT
GO
Truncate table dbo.Territories
GO
SET IDENTITY_INSERT [dbo].[Territories] ON 
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (1, N'Abbot-second', 1, 1, 2, 1)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (2, N'Abbot-second1', 1, 1, 2, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (3, N'Abbot-second2', 1, 1, 3, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (4, N'Abbot-second3', 1, 1, 4, 1)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (5, N'Abbot-second4', 1, 1, 5, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (6, N'Abbot-second5', 1, 1, 7, 1)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (7, N'Abbot-second6', 1, 1, 1, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (8, N'Abbot-second7', 1, 1, 1, 0)
GO
INSERT [dbo].[Territories] ([Id], [Name], [RootGroup_id], [RootLevel_Id], [Client_id], [IsBrickBased]) VALUES (9, N'GSK-TxR7', 1, 1, 2, 1)
GO
SET IDENTITY_INSERT [dbo].[Territories] OFF
GO
