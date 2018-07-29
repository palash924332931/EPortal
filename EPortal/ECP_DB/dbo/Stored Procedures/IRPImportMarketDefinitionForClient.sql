
CREATE PROCEDURE [dbo].[IRPImportMarketDefinitionForClient] 
	-- Add the parameters for the stored procedure here
	@pClientId int,
	@pUser Nvarchar(100) = NULL 
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @dimensionId int
	declare @kount int
	declare @baseid int

	declare @key nvarchar(100)
	--declare @KeyKount int
	select @key = newid()
	--print(@Key)
	
	select distinct a.dimensionid into #tMkt from irp.dimension a
	join IRP.dimensionbasemap b on a.dimensionid=b.dimensionid
	join (select MarketBaseId from ClientMarketBases where clientid = @pClientId) c on c.MarketBaseId = b.MarketBaseId
	join (select * from SubscriptionMarket where SubscriptionId in (select SubscriptionId from dbo.Subscription where clientid = @pClientId)) d on d.MarketBaseId = c.MarketBaseId
	where a.clientid in (select distinct irpclientid from irp.clientmap where clientid =@pClientId)
	--and b.dimensionid not in (select distinct dimensionid from MarketDefinitions)
	and versionto=32767 and a.dimensionname not like '%PROBE Packs Exceptions%' 

	while exists(select * from #tMkt)
	begin
		select @dimensionId = (select top 1 dimensionid from #tMkt order by dimensionId asc)
		
		-- CHECK IF non-pack based market definition
		select @baseid = baseid from irp.dimension where dimensionid = @dimensionId
		if(@baseid <> 4)
		begin
			print ('dimensionid: ')
			print (@dimensionId)
			exec [dbo].[IRPImportMarketDefinition] @dimensionId
				exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId, @key, @pUser
		end

		else 
		begin
			--CHECK IF multiple MB pack based market definiton  
			select @kount = kount from
			(
				select distinct A.dimensionid, kount from 
				(
					select distinct Dimensionid, 
					count(Dimensionid) as kount from IRP.dimensionbasemap group by dimensionid having dimensionid = @dimensionId
				)A
				join irp.dimension B on A.dimensionid = B.dimensionid
				where B.versionto > 0 and B.baseid = 4 
			)X

			if(@kount > 1)
			begin
				print ('dimensionid: ')
				print (@dimensionId)	
				exec [dbo].[IRPImportMarketDefinitionMultipleMBAndPack] @dimensionId
					exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId, @key, @pUser
			end

			--CHECK IF single MB pack based market definiton 
			if(@kount = 1)
			begin
				print ('dimensionid: ')
				print (@dimensionId)
				exec [dbo].[IRPImportPackBaseMarketDefinition] @dimensionId
					exec [dbo].[IRPImportLogStatus] 'M', @pClientId, @dimensionId, @key, @pUser
			end

		end

		delete #tMkt where dimensionid = @dimensionId

	end
	drop table #tMkt

	exec [dbo].[CombineMultipleMarketBasesForAll]


	--Update delivery Territory Table
	exec IRPImportDeliveryMarketAndTerritory

	--Show latest import result---
	select a.ClientId, c.name ClientName, a.DimensionId, m.DimensionName MarketDefinition, Status, TimeOfImport, UserName from dbo.IRPImportLog a 
	join clients c on c.id = a.clientid
	join irp.dimension m on m.dimensionid = a.dimensionid
	where [Key] = @key and DimType = 'M' and m.VersionTo > 0


END
--exec [IRPImportMarketDefinitionForClient] 59



-------------------------------------------------------------




