CREATE PROCEDURE [dbo].[IRPImportTerritoryDefinitionForClient] 
	-- Add the parameters for the stored procedure here
	@pClientId int,
	@pUser Nvarchar(100) = NULL 
AS
BEGIN
	SET NOCOUNT ON;
	--disabling auto increment
	--SET IDENTITY_INSERT Territories ON
	--SET IDENTITY_INSERT Levels ON
	--SET IDENTITY_INSERT Groups ON
	
	declare @dimensionId int
	declare @refDimensionId int
	declare @parentClientId int
	declare @refClientId int

	declare @Tkount int
	declare @Lkount int
	declare @Gkount int
	declare @Okount int

	declare @RefKount int

	declare @key nvarchar(100)
	select @key = newid()
	--print(@Key)

	--IMPORT NON-REF TERRITORIES
	select distinct dimensionid into #tDim 
	from irp.dimension
	where clientid in (select distinct irpclientid from irp.clientmap where clientid in (@pClientId))
	and dimensionid=refdimensionid and baseid in (1,2,11,12)
	--and dimensionid not in (select distinct dimensionid from territories where dimensionid is not null)
	and versionto=32767 

	while exists(select * from #tDim)
	begin
		select @dimensionId = (select top 1 dimensionid from #tDim order by dimensionId asc)
		exec [dbo].[IRPImportTerritoryDefinition] @dimensionId
			exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId, @key, @pUser

		delete #tDim where dimensionid = @dimensionId

	end
	drop table #tDim

	--IMPORT REF TERRITORIES

	select distinct dimensionId, refdimensionid into #tDim2 from irp.dimension
	where clientid in (select distinct irpclientid from irp.clientmap where clientid in (@pClientId))
	and dimensionid<>refdimensionid and baseid in (1,2,11,12)
	and versionto=32767 
	--and dimensionId not in(select distinct dimensionid from territories where dimensionid is not null)

	while exists(select * from #tDim2)
	begin
		select @refDimensionId = (select top 1 refdimensionid from #tDim2 order by dimensionId asc)
		select @dimensionId = (select top 1 dimensionid from #tDim2 order by dimensionId asc)
		
		--select @RefKount = count(*) from territories where dimensionid = @refDimensionId

		--if (@RefKount > 0)
		--begin
		----delete parent when exists-----------------------------------------
		--	exec [dbo].[IRPDeleteTerritory] @refDimensionId
		----------------------------------------------------------------------
			--exec [dbo].[IRPImportTerritoryDefinition] @refDimensionId
			--select @refClientId = client_id from territories where dimensionid = @refDimensionId
			--	exec [dbo].[IRPImportLogStatus] 'T', @refClientId, @refDimensionId, @key, @pUser
			--exec [dbo].[IRPImportDuplicateTerritoryDefinition] @dimensionId
			--	exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId, @key, @pUser
		--end
		--else
		--begin
			--CHECK IF CLIENT EXISTS FOR REFERENCE PARENT
			select distinct @parentClientId = clientid from irp.dimension where dimensionid= @refDimensionId
			and versionto=32767 and clientid not in(select distinct irpclientid from irp.clientmap)
		
			if(@parentClientId <> '' or @parentClientId is not null) -- this means - parent client NOT exists
			begin
				insert into clients
				select clientname as Name,0 as IsMyClient,null as DivisionOf, clientid as IRPClientId, clientno as IRPClientNo
				from irp.client 
				where clientid = @parentClientId
				and versionto=32767

				insert into irp.clientmap
				select a.id as clientid,b.clientid as irpclientid, b.clientno as clientno
				from clients a join	IRP.client b on a.name=b.clientname
				where b.versionto=32767
				and a.id not in (select distinct clientid from IRP.clientMap)
				and b.clientid=@parentClientId
			end
			
			exec [dbo].[IRPImportTerritoryDefinition] @refDimensionId
				select @refClientId = client_id from territories where dimensionid = @refDimensionId
				exec [dbo].[IRPImportLogStatus] 'T', @refClientId, @refDimensionId, @key, @pUser
			exec [dbo].[IRPImportDuplicateTerritoryDefinition] @dimensionId
				exec [dbo].[IRPImportLogStatus] 'T', @pClientId, @dimensionId, @key, @pUser
			
		--end
		
		delete #tDim2 where dimensionid = @dimensionId
	end
	drop table #tDim2

	--enabling auto increment
	SET IDENTITY_INSERT Territories OFF
	SET IDENTITY_INSERT Levels OFF
	SET IDENTITY_INSERT Groups OFF
	
	exec IRPImportDeliveryMarketAndTerritory

	--Show latest import result---
	select a.ClientId, c.name ClientName, a.DimensionId, t.name as TerritoryDefinition, Status, TimeOfImport, UserName from dbo.IRPImportLog a 
	join clients c on c.id = a.clientid
	join territories t on t.dimensionid = a.dimensionid
	where [Key] = @key and DimType = 'T'
		

END


