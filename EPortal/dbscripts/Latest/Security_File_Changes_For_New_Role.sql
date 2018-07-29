if not exists(select * from dbo.Role where RoleName='Third Party')
begin
	insert into dbo.Role(RoleName, IsActive, IsExternal) values('Third Party',1,1)

	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	40,	1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	38,	1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	38,	2)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	38,	3)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	38,	4)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	54,	3)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	55,	3)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	54,	4)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	55,	4)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	56,	3)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,	56,	4)
end

--global admin navigation for GTM
if not exists(select * from dbo.RoleAction where RoleId	= 3 and ActionID=62)
begin
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,	62,	1)
end

declare @actionId int

if not exists(select * from dbo.Action where ActionName	= 'Can change internal user role' and ModuleID=12)
begin
	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Can change internal user role', 1, 12)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end 

--Admin
update dbo.Module set ModuleName='User management' where ModuleName='Admin' and SectionID=5

if not exists(select * from dbo.Module where ModuleName	= 'Content Administration' and SectionID = 5)
begin
	insert into dbo.Module(ModuleName, IsActive,SectionID) values('Content Administration', 1, 5)
end
--

if not exists(select * from dbo.Action where ActionName	= 'Modify Tile names' and ModuleID=13)
begin
	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Modify Tile names', 1, 13)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end

if not exists(select * from dbo.Action where ActionName	= 'Modify popular links' and ModuleID=13)
begin
	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Modify popular links', 1, 13)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end

if not exists(select * from dbo.Action where ActionName	= 'Use global navigation toolbar' and ModuleID=13)
begin
	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Use global navigation toolbar', 1, 13)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(5,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end


--Reporting
declare @sectionId int 
declare @moduleId int
if not exists(select * from dbo.Section where SectionName = 'System Reporting')
begin

	insert into dbo.Section(SectionName, IsActive) values('System Reporting',1)

	SELECT @sectionId=SCOPE_IDENTITY()
	insert into dbo.Module(ModuleName,IsActive,SectionID) values('Reports',1,@sectionId)

	SELECT @moduleId=SCOPE_IDENTITY()
	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Select section type',1,@moduleId)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(1,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(2,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(5,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(6,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)

	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Modify default filter',1,@moduleId)

	SELECT @actionId=SCOPE_IDENTITY()
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(5,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end

--Release
if not exists(select * from dbo.RoleAction where RoleId	= 3 and ActionID=42)
begin
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,42,2)
end

if not exists(select * from dbo.RoleAction where RoleId	= 3 and ActionID=44)
begin
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,44,2)
end


--Audit Reports
if not exists(select * from dbo.Module where ModuleName	= 'Audit Reports' and SectionID = 6)
begin
	insert into dbo.Module(ModuleName,IsActive,SectionID) values('Audit Reports',1,6)
	SELECT @moduleId=SCOPE_IDENTITY()

	insert into dbo.Action(ActionName,IsActive,ModuleID) values('Use global navigation toolbar', 1, @moduleId)
	SELECT @actionId=SCOPE_IDENTITY()

	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(1,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(2,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(5,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(6,@actionId,1)
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
end


--1ST Step User role

if not exists(select * from dbo.Role where RoleName='1ST Step User')
begin
	insert into dbo.Role(RoleName,IsActive,IsExternal) values('1ST Step User', 1, 1)
end

--declare @moduleId int
--declare @actionId int
if exists(select * from dbo.Module where ModuleName='Reports')
begin
	select @moduleId=ModuleID from dbo.Module where ModuleName='Reports'

	if not exists(select * from dbo.Action where ActionName	= 'Use global navigation toolbar' and ModuleID=@moduleId)
	begin
		insert into dbo.Action(ActionName,IsActive,ModuleID) values('Use global navigation toolbar', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(1,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(2,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(3,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(4,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(5,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(6,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(7,@actionId,1)
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(8,@actionId,1)
	end
end