
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

