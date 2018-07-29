
create PROCEDURE [dbo].[IRPImportDeliveryMarketAndTerritory_backup]
AS
BEGIN
	SET NOCOUNT ON;

	---insert into deliveryMarket table
	select distinct deliverableid, MarketDefinitionId into #t from
	(
		select distinct c.clientid, deliverableid, c.reportid, d.value as DimensionId, e.id MarketDefinitionId 
		from deliverables a 
		join subscription b on a.subscriptionid = b.subscriptionid
		join IRP.ClientMap x on x.clientid = b.clientid
		join IRP.Report c on c.clientid = x.IRPClientId
		join (select distinct reportid, value from IRP.ReportParameter where code = 'DimProd' and versionto = 32767)d on d.reportid = c.reportid
		join MarketDefinitions e on e.dimensionid = d.value
	)X

	MERGE [dbo].[deliverymarket] AS TARGET
	USING #t AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.MarketDefId=SOURCE.MarketDefinitionId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, MarketDefId)
	values(SOURCE.deliverableid, SOURCE.MarketDefinitionId)
	;

	---insert into deliveryTerritory table
	select distinct deliverableid, TerritoryId into #t2 from
	(
		select distinct c.clientid, deliverableid, c.reportid, d.value as DimensionId, e.id TerritoryId 
		from deliverables a 
		join subscription b on a.subscriptionid = b.subscriptionid
		join IRP.ClientMap x on x.clientid = b.clientid
		join IRP.Report c on c.clientid = x.IRPClientId
		join (select distinct reportid, value from IRP.ReportParameter where code = 'DimGeog' and versionto = 32767)d on d.reportid = c.reportid
		join Territories e on e.dimensionid = d.value
		--order by b.subscriptionid
	)Y

	MERGE [dbo].[deliveryTerritory] AS TARGET
	USING #t2 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.TerritoryId=SOURCE.TerritoryId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, TerritoryId)
	values(SOURCE.deliverableid, SOURCE.TerritoryId)
	;

---update Deliverables table for restriction
	update b set b.RestrictionId=e.lvl_total from deliverables b
	join subscription c on b.subscriptionid=c.subscriptionid 
	join irp.clientmap d on c.clientid=d.clientid
	join irp.cld e on d.irpclientno=e.client_no
	where e.lvl_total is not null and b.deliverableid in (select distinct deliverableid from deliveryterritory)
	
END

----select * from deliverymarket
----select * from deliveryterritory
--select * into deliveryterritory_backup from deliveryterritory
--exec [IRPImportDeliveryMarketAndTerritory]