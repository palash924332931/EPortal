CREATE FUNCTION [dbo].[fnGetDefaultStartDate]()  
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


