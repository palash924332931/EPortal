
CREATE View [dbo].[vw_UserRoleMapping]
AS
Select U.*, UR.UserRolesId,UR.RoleID as RoleId,R.RoleName,R.IsExternal
From [User] U
LEFT JOIN [UserRole] UR ON U.UserID=UR.UserID
LEFT JOIN [Role] R ON R.RoleID=UR.RoleID
