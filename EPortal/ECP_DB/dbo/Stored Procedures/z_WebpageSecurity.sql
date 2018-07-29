


CREATE PROCEDURE [dbo].[z_WebpageSecurity]
 
AS
BEGIN

--alter table [dbo].[User]
--  add PwdEncrypted int null

--INSERT INTO [dbo].[Section]
--           ([SectionName]           ,[IsActive])
--     VALUES           ('Admin'           ,1)
	
--INSERT INTO [dbo].[Module]
--           ([ModuleName]           ,[IsActive]           ,[SectionID])
--     VALUES ('Admin', 1, 5)
       
----INSERT INTO  [dbo].[Action]
----           ([ActionName]           ,[IsActive]           ,[ModuleID])
----     VALUES ('Admin access',1,12)
     
     --only production user can see/edit/etc on admin
  INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  4,62, 1
    
    INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  7,62, 1
    /*
    INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,61, [AccessPrivilegeID]
  FROM  [dbo].[AccessPrivilege]

 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,14, 1
  --FROM  [dbo].[AccessPrivilege]
 
 INSERT INTO  [dbo].[RoleAction]
           ([RoleId]           ,[ActionID]           ,[AccessPrivilegeID])
    
    SELECT  5,62, 1
    */

 --update  [dbo].[Action]
 -- set [ActionName]='Admin'
 -- where [ActionName]='Admin Access'

--SELECT *
--  FROM  [dbo].[RoleAction] ra
--  join dbo.Role r on ra.RoleId=r.RoleID
--  join dbo.Action a on ra.ActionID=a.ActionID
--  join dbo.AccessPrivilege ap on ap.AccessPrivilegeID=ra.AccessPrivilegeID
--  join dbo.Module m on a.ModuleID=m.ModuleID
--  join dbo.Section s on m.SectionID=s.SectionID
--  where ra.RoleId=5 and  a.ActionName='Use global navigation toolbar'
  
END






