

CREATE PROCEDURE [dbo].[PopulateMaintenanceCalendar] 
AS
BEGIN

Update Maintenance_Calendar
Set Schedule_From=a.Schedule_From,Schedule_To=a.Schedule_To,ActionDate=GETDATE()
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





