--Update sub-channels
declare @actionId int
declare @roleId int
if not exists(select * from dbo.[Action] where ActionName='Update sub-channels' and ModuleID = 11)
begin
	insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Update sub-channels', 1, 11)
	SELECT @actionId=SCOPE_IDENTITY()

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal GTM'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Production'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Support'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)
end

GO

--Update IRP report number
declare @actionId int
declare @roleId int
if not exists(select * from dbo.[Action] where ActionName='Update IRP report number' and ModuleID = 11)
begin
	insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Update IRP report number', 1, 11)
	SELECT @actionId=SCOPE_IDENTITY()

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Production'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Support'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)
end

GO

--Edit content of internal client
declare @actionId int
declare @roleId int
if not exists(select * from dbo.[Action] where ActionName='Edit content of internal client' and ModuleID = 8)
begin
	insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Edit content of internal client', 1, 8)
	SELECT @actionId=SCOPE_IDENTITY()

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Production'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Support'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)

	select @roleId = RoleID from dbo.[Role] where RoleName='Internal Data Reference'
	insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)
end

GO

--Data channel
declare @secionId int
declare @moduleId int
declare @actionId int
declare @roleId int
if not exists(select * from dbo.Section where SectionName='Data Channel')
begin
	insert into dbo.Section(SectionName, IsActive) values('Data Channel', 1)
	select @secionId = SCOPE_IDENTITY()

	insert into dbo.Module(ModuleName, IsActive, SectionID) values('Data Channel', 1, @secionId)
	select @moduleId  = SCOPE_IDENTITY()

	if not exists(select * from dbo.[Action] where ActionName = 'View data channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('View data channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,1)

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Production'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,1)

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Support'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,1)

	end

	if not exists(select * from dbo.[Action] where ActionName = 'Add data channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Add data channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,2)		
	end

	if not exists(select * from dbo.[Action] where ActionName = 'Delete data channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Delete data channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,4)		
	end

	if not exists(select * from dbo.[Action] where ActionName = 'Add new subchannel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Add new subchannel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,2)		
	end
	
	if not exists(select * from dbo.[Action] where ActionName = 'Delete sub channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Delete sub channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,4)		
	end

	if not exists(select * from dbo.[Action] where ActionName = 'Modify name of channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Modify name of channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)		
	end
	
	if not exists(select * from dbo.[Action] where ActionName = 'Modify name of sub channel' )
	begin
		insert into dbo.[Action](ActionName, IsActive,ModuleID) values('Modify name of sub channel', 1, @moduleId)
		SELECT @actionId=SCOPE_IDENTITY()

		select @roleId = RoleID from dbo.[Role] where RoleName='Internal Admin'
		insert into dbo.RoleAction(RoleId,ActionID,AccessPrivilegeID) values(@roleId,@actionId,3)		
	end

end

GO
