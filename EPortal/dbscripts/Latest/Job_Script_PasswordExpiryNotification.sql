USE [msdb]
GO

/***********************************************************************************************
				ALERT - Need to be modify as per the environment 
***********************************************************************************************/

DECLARE @IsProductionEnvironment BIT = 0 /* Test Environment = 0 , Production Environment = 1 */
DECLARE @PasswordExpirationAge int = 90 
DECLARE @DatabaseName NVARCHAR(100) = N'EverestClientPortal' /* Please verify database name */

/***********************************************************************************************/


BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'PasswordExpiryNotification', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Job will send password expiry notification email.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'ECPUser', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback


DECLARE @StepCommand NVARCHAR(200) = N'/* Script to be run on the sql job to send password expiry notification mail */
EXEC ' + @DatabaseName + '.[dbo].SendPasswordExpiryNotificationEmail ' + CAST(@IsProductionEnvironment AS nvarchar(10)) + ', ' + CAST(@PasswordExpirationAge AS nvarchar(10))

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PasswordExpiryNotificationStep', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@StepCommand, 
		@database_name=@DatabaseName, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'PasswordExpiryNotificationSchedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20171011, 
		@active_end_date=99991231, 
		@active_start_time=235500
		--, 
		--@active_end_time=235959, 
		--@schedule_uid=N'2ae9f344-317d-4c74-9a7f-e41cd97a5cab'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


