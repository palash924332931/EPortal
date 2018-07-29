--Add new column IsReference
IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'IsReferenced'
          AND Object_ID = Object_ID(N'dbo.Territories'))
BEGIN
	alter table dbo.Territories add IsReferenced bit not null default(0)
END

--Create Internal client
if not exists (select * from dbo.clients where name = 'Internal')
begin
	declare @Id int
	insert into dbo.clients(Name,IsMyClient,DivisionOf, IRPClientId,IRPClientNo) values('Internal',0,NULL,NULL,NULL)
	SELECT @Id=SCOPE_IDENTITY()
	print 'Client created successfully.'
	
	if not exists (select * from irp.ClientMap where IRPClientNo = 0)
	begin
		insert into irp.ClientMap(ClientID, IRPClientId, IRPClientNo) values(@Id, 0,0)
		print 'ClientMap created successfully.'
	end

	if not exists (select * from dbo.subscription where ClientId = @Id and Name = 'AUS PROBE Sell In Retail')
	begin
		insert into dbo.subscription(Name,ClientId,Country,Service,Data,Source,StartDate,EndDate,ServiceTerritoryId,Active,LastModified,ModifiedBy,CountryId,ServiceId,DataTypeId,SourceId)
		values	('AUS PROBE Sell In Retail',@Id,NULL,NULL,NULL,NULL,getdate(),'2019-12-31 00:00:00.000',1,1,getdate(),1,1,1,1,1)
		print 'Subscription created successfully.'
	end

	if not exists (select * from dbo.UserClient where UserID = (select UserId from dbo.[User] where UserName = 'Admin@au.imshealth.com') and ClientId = @Id)
	begin
		insert into dbo.UserClient(UserID,ClientID) values((select UserId from dbo.[User] where UserName = 'Admin@au.imshealth.com'),@Id)
		print 'UserClient created successfully.'
	end

	--update existing IMS standard
	update  dbo.Territories set Client_id=@Id, IsReferenced=1, IsBrickBased=0 where Client_id=0 and Name='IMS Standard Outlet Structure'
	update  dbo.Territories set Client_id=@Id, IsReferenced=1 where Client_id=0 and Name='IMS Standard Brick Structure'
end
GO

--Update view for IsReferenced column

DROP VIEW [dbo].[vwTerritories]
GO

CREATE View [dbo].[vwTerritories]
AS
 SELECT Id, CASE WHEN SRA_Client is not null then Name+' ('+SRA_Client +'' + SRA_Suffix+')' ELSE Name END as Name, RootGroup_id, RootLevel_Id, Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD,CASE WHEN DimensionID is null then 0 ELSE DimensionID END as DimensionID,LastSaved, IsReferenced
FROM Territories
GO