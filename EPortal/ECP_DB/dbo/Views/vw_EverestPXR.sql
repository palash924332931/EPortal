
CREATE VIEW [dbo].[vw_EverestPXR]
AS
SELECT map.IRPClientNo AS IMSCLientNo, C.Name AS ClientName, m.Id AS marketDefinitionId, m.Name AS MarketDefinitionName, G.AttributeId, G.attributename, G.GroupId, 
                  G.ParentId, G.groupname, G.IsAttribute, null PFC, null Factor
FROM     dbo.vwGroupView AS G JOIN
                  dbo.MarketDefinitions AS m ON G.MarketDefinitionId = m.Id INNER JOIN
                  dbo.Clients AS C ON C.Id = m.ClientId INNER JOIN
                  IRP.ClientMap AS map ON map.ClientId = m.ClientId
UNION ALL
SELECT map.IRPClientNo AS IMSCLientNo, C.Name AS ClientName, m.Id AS marketDefinitionId, m.Name AS MarketDefinitionName, G.AttributeId, G.attributename, null GroupId, 
                  G.GroupId ParentId, G.groupname, G.IsAttribute, p.PFC, F.Factor
FROM     dbo.vwGroupView AS G JOIN
                  dbo.MarketGroupPacks AS p ON G.GroupId = p.GroupId JOIN
                  dbo.MarketDefinitionPacks AS F ON G.MarketDefinitionId = F.MarketDefinitionId AND p.PFC = F.PFC INNER JOIN
                  dbo.MarketDefinitions AS m ON G.MarketDefinitionId = m.Id INNER JOIN
                  dbo.Clients AS C ON C.Id = m.ClientId INNER JOIN
                  IRP.ClientMap AS map ON map.ClientId = m.ClientId
GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_EverestPXR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'    Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_EverestPXR';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "G"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 168
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 168
               Left = 48
               Bottom = 329
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent = 
               Top = 329
               Left = 48
               Bottom = 490
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 490
               Left = 48
               Bottom = 651
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 651
               Left = 48
               Bottom = 812
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "map"
            Begin Extent = 
               Top = 812
               Left = 48
               Bottom = 951
               Right = 242
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
     ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_EverestPXR';

