
----------------------------------------------------------
--Table changes [dbo].[PasswordHistory]
----------------------------------------------------------
IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'PasswordHistory')
BEGIN
    CREATE TABLE [dbo].[PasswordHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[Password] [varchar](300) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET ANSI_PADDING OFF

	ALTER TABLE [dbo].[PasswordHistory]  WITH CHECK ADD FOREIGN KEY([UserID])
	REFERENCES [dbo].[User] ([UserID])
END
----------------------------------------------------------
--Alter command - [dbo].[User]
----------------------------------------------------------
ALTER TABLE [dbo].[User] ALTER COLUMN [Password] VARCHAR(300)
---------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'PasswordCreatedDate'
          AND Object_ID = Object_ID(N'dbo.User'))
BEGIN
    ALTER TABLE [dbo].[User] ADD [PasswordCreatedDate] DATETIME
	EXEC('UPDATE [dbo].[User] SET [PasswordCreatedDate] = GETDATE()')
	EXEC('ALTER TABLE [dbo].[User] ALTER COLUMN [PasswordCreatedDate] DATETIME NOT NULL')
END
---------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'IsPasswordVerified'
          AND Object_ID = Object_ID(N'dbo.User'))
BEGIN
	ALTER TABLE [dbo].[User] ADD [IsPasswordVerified] BIT NOT NULL DEFAULT(0)
	EXEC('UPDATE [dbo].[User] SET [IsPasswordVerified] = 1')
END
---------------------------------------------------------
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'FailedPasswordAttempt'
          AND Object_ID = Object_ID(N'dbo.User'))
BEGIN
	ALTER TABLE [dbo].[User] ADD [FailedPasswordAttempt] INT NOT NULL DEFAULT(0)
END
----------------------------------------------------------
IF NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'ResetToken')
BEGIN

	CREATE TABLE [dbo].[ResetToken](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[UserID] [int] NULL,
		[Token] [varchar](300) NOT NULL,
		[ExpiryDate] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]


	ALTER TABLE [dbo].[ResetToken]  WITH CHECK ADD FOREIGN KEY([UserID])
	REFERENCES [dbo].[User] ([UserID])
END 

-----------------------------------------------------------------------
--Update password as default password ecp888
-----------------------------------------------------------------------
UPDATE [User] SET Password='ki3HiRdjK1LhtXVpy3D4AZiptGQHJJVI23rc8aWXvZ0='

----------------------------------------------------------
--Store Procedure Changes [dbo].[CheckUserLogin]
----------------------------------------------------------

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('dbo.CheckUserLogin'))
	DROP PROCEDURE [dbo].[CheckUserLogin]
GO

CREATE PROCEDURE [dbo].[CheckUserLogin]
 @userName varchar(300), 
 @pwd varchar(300),
 @pwdAgeForNewPwd int = 1,
 @pwdAgeForRegularPwd int = 90 
AS
BEGIN
--update [EverestClientPortal].[dbo].[User]
--  set LastName=SUBSTRING(UserName,CHARINDEX('.',UserName)+1,LEN(UserName)-CHARINDEX('.',UserName))
--  where LastName=''
  
  Declare @err varchar(300)='', @UserID int =-99, @FailedPasswordAttempt Int
  select @UserID=UserID, @FailedPasswordAttempt = FailedPasswordAttempt from [dbo].[User] where [UserName]=@userName
  
	INSERT INTO [dbo].[UserLogin_History]
           ([UserID]           ,[UserName]           ,[UserType]
           ,[RoleID]           ,[LoginDate])
    Select @UserID,  @userName,
		   (select UserTypeID from [dbo].[User] where [UserName]=@userName),
		   (SELECT RoleId 
			FROM [dbo].[User] u
			join dbo.UserRole ur on u.UserID=ur.UserID
			where [UserName]=@userName), GETDATE()
			
	If (select COUNT(*) from [dbo].[User] where [UserName]=@userName and [Password]=@pwd)=0
		Set @err='Invalid UserName or Password'
		
	--print cast(@UserID as varchar)
	
	If @UserID <> -99
	Begin
		If @err = '' and @FailedPasswordAttempt <= 3
		Begin
			If (select COUNT(*) from [dbo].[User] where [UserID]=@UserID and isnull(IsActive,0)=1 )=0
				Set @err='User is Inactive'
		 
			Else If (select COUNT(*) from [dbo].[UserRole] where [UserID]=@UserID)=0
				Set @err='Invalid User Role'

			Else If (select COUNT(*) from [dbo].[User] where [UserID]=@UserID and [IsPasswordVerified]=1)=0
				Set @err='Your password link has not yet been verified. Please contact support.'

			Else If (select DATEDIFF(DAY, PasswordCreatedDate, GETDATE()) from [dbo].[User] where UserID = @UserID) > @pwdAgeForRegularPwd
				Set @err='Your password has expired. Please contact support or click on Forgot Password.'
		End
		Else
		Begin
			Set @FailedPasswordAttempt = @FailedPasswordAttempt + 1
			If @FailedPasswordAttempt > 3
			Begin
				UPDATE [dbo].[User] SET [FailedPasswordAttempt] = @FailedPasswordAttempt, IsActive = 0 WHERE UserID = @UserID
				Set @err='Number of failed password attempts reached to three. Please contact support.'
			End
			Else
			Begin
				UPDATE [dbo].[User] SET [FailedPasswordAttempt] = @FailedPasswordAttempt WHERE UserID = @UserID
			End
		End
	End

	if @err <>''
		Select @err AS 'ErrorMessage', 0 As 'IsSuccess'
	else
		UPDATE [dbo].[User] SET FailedPasswordAttempt = 0 WHERE [UserName] = @userName 

		SELECT u.UserID, '' [Password], r.RoleID, r.RoleName, u.email EmailId, FirstName+'.'+LastName username, 1 As 'IsSuccess', ''  AS 'ErrorMessage'
		FROM [dbo].[User] u
		join dbo.UserRole ur on u.UserID=ur.UserID
		join dbo.Role r on ur.RoleId=r.RoleID
		where [UserName]=@userName and [Password]=@pwd and u.IsActive=1
		
END

