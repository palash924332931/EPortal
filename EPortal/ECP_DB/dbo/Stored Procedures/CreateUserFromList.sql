--exec [dbo].[CreateUserFromList] 
CREATE PROCEDURE [dbo].[CreateUserFromList]

AS
BEGIN
declare @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int,
 @Role varchar(100)
DECLARE user_cursor CURSOR FOR   
   SELECT TOP 1000 [Users]      ,[First Name]
      ,[Last Name]      ,[Role]
  FROM [ECP].[dbo].[z_UserList]
   where users like '%au.imshe%'

    OPEN user_cursor  
    FETCH NEXT FROM user_cursor INTO @UserName,@FirstName,@LastName,@Role
   

    WHILE @@FETCH_STATUS = 0  
    BEGIN  

	select @Roleid=RoleId from dbo.role where rolename like '%'+@Role+'%'

      exec  [dbo].[CreateUser] @UserName , @FirstName, @LastName ,
 @UserName, 'ECP888',@Roleid, 1
     FETCH NEXT FROM user_cursor INTO @UserName,@FirstName,@LastName,@Role
        END  

    CLOSE user_cursor  
    DEALLOCATE user_cursor  
        -- Get the next vendor.  

  
END





