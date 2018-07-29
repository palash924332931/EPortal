IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.SendPasswordExpiryNotificationEmail'))
   DROP PROCEDURE dbo.SendPasswordExpiryNotificationEmail
GO

CREATE PROCEDURE SendPasswordExpiryNotificationEmail 
	@IsProductionEnvironment BIT = 0
AS
BEGIN

	DECLARE @Subject VARCHAR(100), 
			@BodyFor2DaysRemainder NVARCHAR(500), 
			@BodyFor1DaysRemainder NVARCHAR(500),
			@RecipientListFor2DaysRemainder VARCHAR(MAX), 
			@RecipientListFor1DaysRemainder VARCHAR(MAX)

	SET @BodyFor2DaysRemainder= N'Please do not reply to this system generated e-mail.' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Dear User,' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Your password will expire in 2 days. Please change your password.' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Thank you,' + 
								CHAR(13)+CHAR(10)+
								N'IQVIA'

	SET @BodyFor1DaysRemainder= N'Please do not reply to this system generated e-mail.' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Dear User,' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Your password will expire in 1 days. Please change your password.' +
								CHAR(13)+CHAR(10)+CHAR(13)+CHAR(10)+
								N'Thank you,' + 
								CHAR(13)+CHAR(10)+
								N'IQVIA'

	SET @RecipientListFor2DaysRemainder =  STUFF((SELECT ';' + email FROM [User] WHERE IsActive = 1 AND DATEDIFF(DAY, PasswordCreatedDate, GETDATE()) = 89 FOR XML PATH('')),1,1,'')
	SET @RecipientListFor1DaysRemainder =  STUFF((SELECT ';' + email FROM [User] WHERE IsActive = 1 AND DATEDIFF(DAY, PasswordCreatedDate, GETDATE()) = 90 FOR XML PATH('')),1,1,'')

	SET @Subject = 'Everest: Password expiry notification'

	--On test server
	IF @IsProductionEnvironment = 0 
	BEGIN
		IF @RecipientListFor2DaysRemainder <> '' AND @RecipientListFor2DaysRemainder IS NOT NULL
		BEGIN
			SET @RecipientListFor2DaysRemainder = 'VKumar2@in.imshealth.com'
		END

		IF @RecipientListFor1DaysRemainder <> '' AND @RecipientListFor1DaysRemainder IS NOT NULL
		BEGIN
			SET @RecipientListFor1DaysRemainder = 'VKumar2@in.imshealth.com'
		END
	END

	IF @RecipientListFor2DaysRemainder <> '' AND @RecipientListFor2DaysRemainder IS NOT NULL
	BEGIN
		PRINT @RecipientListFor2DaysRemainder
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'SQLMAIL', 
		@recipients = @RecipientListFor2DaysRemainder,
		@body =  @BodyFor2DaysRemainder,
		@subject = @Subject;
	END
	
	IF @RecipientListFor1DaysRemainder <> '' AND @RecipientListFor1DaysRemainder IS NOT NULL
	BEGIN
		PRINT @RecipientListFor1DaysRemainder
		EXEC msdb.dbo.sp_send_dbmail  
		@profile_name = 'SQLMAIL',  
		@recipients = @RecipientListFor1DaysRemainder,
		@body =  @BodyFor1DaysRemainder,
		@subject = @Subject;
	END

END

