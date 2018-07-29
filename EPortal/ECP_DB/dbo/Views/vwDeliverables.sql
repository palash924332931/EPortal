CREATE VIEW dbo.vwDeliverables
AS
SELECT c.Name AS Client, cn.Name AS Country, dty.Name AS DataType, svc.Name AS Service, src.Name AS Source, st.TerritoryBase, FORMAT(s.StartDate, 'MMM-yy') 
                  AS SubscriptionDurationFrom, FORMAT(s.EndDate, 'MMM-yy') AS SubscriptionDurationTo, dt.Name AS DeliverableType, pr.Name AS Period, fr.Name AS Frequency, 
                  ft.Name AS FrequencyType, rw.code AS ReportWriterCode, rw.Name AS ReportWriterName, FORMAT(d.StartDate, 'MMM-yy') AS DeliverableDurationFrom, 
                  FORMAT(d.EndDate, 'MMM-yy') AS DeliverableDurationTo, c.Id AS ClientId, s.SubscriptionId, d.DeliverableId, cmap.IRPClientNo, NULL AS IRPReportNo
FROM     dbo.Deliverables AS d INNER JOIN
                  dbo.Subscription AS s ON s.SubscriptionId = d.SubscriptionId INNER JOIN
                  dbo.Clients AS c ON c.Id = s.ClientId INNER JOIN
                  dbo.Country AS cn ON cn.CountryId = s.CountryId INNER JOIN
                  dbo.DataType AS dty ON dty.DataTypeId = s.DataTypeId INNER JOIN
                  dbo.Service AS svc ON svc.ServiceId = s.ServiceId INNER JOIN
                  dbo.ServiceTerritory AS st ON st.ServiceTerritoryId = s.ServiceTerritoryId INNER JOIN
                  dbo.Source AS src ON src.SourceId = s.SourceId INNER JOIN
                  dbo.ReportWriter AS rw ON rw.ReportWriterId = d.ReportWriterId INNER JOIN
                  dbo.Frequency AS fr ON fr.FrequencyId = d.Frequencyid INNER JOIN
                  dbo.FrequencyType AS ft ON ft.FrequencyTypeId = d.FrequencyTypeId INNER JOIN
                  dbo.Period AS pr ON pr.PeriodId = d.PeriodId INNER JOIN
                  dbo.DeliveryType AS dt ON dt.DeliveryTypeId = d.DeliveryTypeId LEFT OUTER JOIN
                  IRP.ClientMap AS cmap ON cmap.ClientId = c.Id LEFT OUTER JOIN
                  dbo.DeliveryReport AS rpt ON rpt.DeliverableId = d.DeliverableId

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[55] 4[3] 2[24] 3) )"
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
         Begin Table = "d"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 168
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 2
               Left = 349
               Bottom = 163
               Right = 560
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 7
               Left = 562
               Bottom = 168
               Right = 756
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cn"
            Begin Extent = 
               Top = 7
               Left = 804
               Bottom = 146
               Right = 998
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dty"
            Begin Extent = 
               Top = 7
               Left = 1046
               Bottom = 124
               Right = 1240
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "svc"
            Begin Extent = 
               Top = 7
               Left = 1288
               Bottom = 124
               Right = 1482
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 136
               Left = 1057
               Bottom = 253
               Right = 1268
            End
            DisplayFlags = 280
            TopColumn = 0
         ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vwDeliverables';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'End
         Begin Table = "src"
            Begin Extent = 
               Top = 126
               Left = 1305
               Bottom = 243
               Right = 1499
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rw"
            Begin Extent = 
               Top = 371
               Left = 1264
               Bottom = 532
               Right = 1458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "fr"
            Begin Extent = 
               Top = 340
               Left = 9
               Bottom = 479
               Right = 216
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ft"
            Begin Extent = 
               Top = 379
               Left = 593
               Bottom = 518
               Right = 800
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pr"
            Begin Extent = 
               Top = 384
               Left = 914
               Bottom = 523
               Right = 1108
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dt"
            Begin Extent = 
               Top = 370
               Left = 287
               Bottom = 487
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cmap"
            Begin Extent = 
               Top = 147
               Left = 804
               Bottom = 286
               Right = 998
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rpt"
            Begin Extent = 
               Top = 168
               Left = 48
               Bottom = 285
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
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vwDeliverables';




GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vwDeliverables';

