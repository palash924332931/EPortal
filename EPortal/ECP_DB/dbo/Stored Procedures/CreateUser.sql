--exec [dbo].[CreateUser] 
CREATE PROCEDURE [dbo].[CreateUser]
 @UserName varchar(300), @FirstName varchar(80), @LastName varchar(80),
 @Email varchar(300), @Pwd varchar(50), @RoleID int, @UserType int
AS
BEGIN
declare @id int
If (select count(*) from [dbo].[User] where username=@UserName)=0 
Begin
INSERT INTO  [dbo].[User]
           ([UserName]           ,[FirstName]           ,[LastName]
           ,[email]           ,[UserTypeID]           ,[IsActive]
           ,[ReceiveEmail]           ,[Password])
     VALUES (@UserName
           ,@FirstName          ,@LastName          ,@Email
           ,@UserType          ,1           ,1           ,@Pwd)
    
	set @id=@@IDENTITY       
--select * from [dbo].[User] order by UserID desc

--INSERT INTO  [dbo].[UserClient]
--           ([UserID]           ,[ClientId])
--     select 49, ? from clients
     
 INSERT INTO  [dbo].[UserRole]
           ([UserID]           ,[RoleId])
     VALUES  (@id           ,@RoleID)

end


SELECT *
  FROM  [dbo].[user] u
  join [dbo].[UserRole] ur on u.userid=ur.UserID
  join dbo.Role r on ur.RoleId=r.RoleID
  where u.username=@UserName
  
  /*
  INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (16,2)
     
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (17,16)
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (18,17)
     INSERT INTO [ECP].[dbo].[UserClient]           ([UserID]           ,[ClientId])
     VALUES  (19,18)
*/
--SELECT *
--  FROM  [dbo].[RoleAction] ra
--  join dbo.Role r on ra.RoleId=r.RoleID
--  join dbo.Action a on ra.ActionID=a.ActionID
--  join dbo.AccessPrivilege ap on ap.AccessPrivilegeID=ra.AccessPrivilegeID
--  join dbo.Module m on a.ModuleID=m.ModuleID
--  join dbo.Section s on m.SectionID=s.SectionID
--  where ra.RoleId=5 and  a.ActionName='Use global navigation toolbar'
/*
SELECT  u.UserID,u.UserName,u.FirstName,u.LastName,u.Password,u.email,r.RoleName,c.Name Client
  FROM [ECP].[dbo].[User] u
  join dbo.UserRole ur on u.UserID=ur.userid
  join [Role] r on ur.RoleId=r.RoleID
  join dbo.UserClient uc on u.UserID=uc.UserID
  join dbo.Clients c on uc.ClientId=c.Id 
   where u.UserID>=14 and UserTypeID=2
   order by UserName 
   */
  
END





