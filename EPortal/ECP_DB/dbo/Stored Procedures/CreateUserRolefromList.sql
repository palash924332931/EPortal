--exec [dbo].[CreateUserFromList] 
CREATE PROCEDURE [dbo].[CreateUserRolefromList]

AS
BEGIN
declare @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int, @userid int,
 @Role varchar(100)
DECLARE user_cursor CURSOR FOR   
   SELECT [Role],userid
  FROM [ECP].[dbo].[z_UserList] ul join dbo.[user] u on ul.users=u.username
   where users like '%au.imshe%'

    OPEN user_cursor  
    FETCH NEXT FROM user_cursor INTO @Role,@userid

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

	print @Role
	if @Role='GTM'
	set @Roleid=3
	else
	select @Roleid=RoleId from dbo.role where rolename like '%'+rtrim(ltrim(@Role))+'%'

     if (select count(*) from userrole where userid=@userid and roleid=@RoleID)=0
	 INSERT INTO  [dbo].[UserRole]
           ([UserID]           ,[RoleId])
     VALUES  (@userid           ,@RoleID)

     FETCH NEXT FROM user_cursor INTO @Role,@userid
        END  

    CLOSE user_cursor  
    DEALLOCATE user_cursor  
        -- Get the next vendor.  

  
END





