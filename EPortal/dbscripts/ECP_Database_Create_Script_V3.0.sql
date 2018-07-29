

IF COL_LENGTH('User','MaintenancePeriodEmail') IS  NULL
 BEGIN
 ALTER TABLE [User]
 ADD MaintenancePeriodEmail bit DEFAULT(0);
 END
GO
IF COL_LENGTH('User','NewsAlertEmail') IS  NULL
 BEGIN
 ALTER TABLE [User]
 ADD NewsAlertEmail bit DEFAULT(0);
 END
GO

IF OBJECT_ID (N'dbo.fnGetDefaultStartDate', N'FN') IS NOT NULL  
    DROP FUNCTION fnGetDefaultStartDate;  
GO  
CREATE FUNCTION dbo.fnGetDefaultStartDate()  
RETURNS datetime   
AS   
 
BEGIN  
    DECLARE @ret datetime;
	   
    select @ret=Schedule_To from Maintenance_Calendar where GETDATE() between Schedule_From and Schedule_To
	if @ret is null
	select top 1 @ret =  Schedule_To from Maintenance_Calendar where Schedule_To >  GETDATE() order by Schedule_To
	if @ret is null
	set @ret=getdate()

    RETURN @ret;  
END;  
GO  





 