
create PROCEDURE [dbo].[MaintenanceCalendar_EmailNotification]
 
AS
BEGIN
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'SQLMAIL', 
		@recipients = 'lcao@au.imshealth.com',
		@body =  'test mail',
		@subject = 'test from SIT';
END