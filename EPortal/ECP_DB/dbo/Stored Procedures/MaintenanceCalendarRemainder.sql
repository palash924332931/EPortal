
CREATE PROCEDURE [dbo].[MaintenanceCalendarRemainder]
AS
BEGIN
DECLARE @Today DATETIME,@PDate as Date,@ScheduleTo as Date,@Month varchar(20), @Year varchar(10),@EndDate DATETIME,@Holiday int,@WorkingDays Int
 
SET @Today = GETDATE()
--SET @Today = '2017/10/13'
SET @PDate = @Today

if exists(select * from Maintenance_Calendar where @PDate between cast(Schedule_From as DATE) and cast(Schedule_To as DATE))
begin
			
   select @Month =  month,@Year = Year,@ScheduleTo=Schedule_To from Maintenance_Calendar
   where @PDate between cast(Schedule_From as DATE) and cast(Schedule_To as DATE)
   SET @EndDate = @ScheduleTo
   Print  @EndDate

   --Gets the number of holidays excluding the weekend holidays
   select @Holiday=count(*) from AU9_HOLIDAY where CAL_DT between cast(@Today as DATE) and cast(@EndDate as DATE)
   and (DATENAME(dw, CAL_DT) != 'Sunday' and DATENAME(dw, CAL_DT) != 'Saturday')    

   SELECT @WorkingDays =
   (DATEDIFF(dd, @Today, @EndDate) )
  -(DATEDIFF(wk, @Today, @EndDate) * 2)  
  - @Holiday
  -(CASE WHEN DATENAME(dw, @Today) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)   

	 if(@WorkingDays = 2)
	 begin
	  DECLARE @RecipientList varchar(max), @emailSub varchar(100),@bodyText nvarchar(max)
			SET @RecipientList = STUFF((SELECT ';' + email FROM [User] WHERE MaintenancePeriodEmail = 1 FOR XML PATH('')),1,1,'')
			SET @emailSub = 'Everest: Maintenance reminder - '  + @Month + ' ' + @Year
			SET @bodyText=  N'Please do not reply to this system generated e-mail.' +
			CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
			N'Dear User,' +
			CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
			N'If you have already submitted your maintenance for ' + @Month + ' ' + @Year + ', thank you and please ignore this email reminder.' +
			CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
			N'Please note, that this is a reminder that the ' + @Month + ' ' + @Year + ' maintenance is due on ' + CAST(@ScheduleTo AS varchar) + '.' +
			CHAR(13)+CHAR(10)+
			N'NOTE - Maintenance received after the due date will be aligned for the following production month.' +
			CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
			N'Thanks,' + 
			CHAR(13)+CHAR(10)+
			N'IQVIA'
			
			EXEC msdb.dbo.sp_send_dbmail  
				@profile_name = 'SQLMAIL',  
				--@recipients = @RecipientList,
				@recipients = 'sivaswamy.g@in.imshealth.com',  
				@body =  @bodyText,
				@subject = @emailSub;
	 end
	 else print 'Mail not sent'
	
End
			  
End
 
 
 




