
CREATE PROCEDURE [dbo].[IRPImportDeliveryMarketAndTerritory]
AS
BEGIN
	SET NOCOUNT ON;

	---insert into deliveryMarket table
	select distinct a.deliverableid, e.id marketdefinitionid into #tm1 
	from deliveryreport a 
	join (select distinct reportid, value from IRP.ReportParameter where code = 'DimProd' and versionto = 32767)d on a.reportid = d.reportid
	join MarketDefinitions e on e.dimensionid = d.value

	select distinct a.deliverableid, e.id MarketDefinitionId into #tm2
	from deliveryreportname a 
	join IRP.Dimension c on a.ReportName = c.DimensionName
	join MarketDefinitions e on e.dimensionid = c.DimensionId
	where c.versionto > 0

	MERGE [dbo].[deliverymarket] AS TARGET
	USING #tm1 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.MarketDefId=SOURCE.MarketDefinitionId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, MarketDefId)
	values(SOURCE.deliverableid, SOURCE.MarketDefinitionId)
	;

	MERGE [dbo].[deliverymarket] AS TARGET
	USING #tm2 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.MarketDefId=SOURCE.MarketDefinitionId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, MarketDefId)
	values(SOURCE.deliverableid, SOURCE.MarketDefinitionId)
	;

	---insert into deliveryTerritory table
	
	select distinct a.deliverableid, e.id TerritoryId into #tt1
	from deliveryreport a 
	join (select distinct reportid, value from IRP.ReportParameter where code = 'DimGeog' and versionto = 32767)d on a.reportid = d.reportid
	join Territories e on e.dimensionid = d.value

	select distinct a.deliverableid, e.id TerritoryId into #tt2
	from deliveryreportname a 
	join IRP.Dimension c on a.ReportName = c.DimensionName
	join Territories e on e.dimensionid = c.DimensionId
	where c.versionto > 0

	MERGE [dbo].[deliveryTerritory] AS TARGET
	USING #tt1 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.TerritoryId=SOURCE.TerritoryId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, TerritoryId)
	values(SOURCE.deliverableid, SOURCE.TerritoryId)
	;

	MERGE [dbo].[deliveryTerritory] AS TARGET
	USING #tt2 AS SOURCE
	ON (TARGET.deliverableid=SOURCE.deliverableid AND TARGET.TerritoryId=SOURCE.TerritoryId)

	WHEN NOT MATCHED BY TARGET THEN
	insert(deliverableid, TerritoryId)
	values(SOURCE.deliverableid, SOURCE.TerritoryId)
	;

	---------INCLUDE MISSING MARKET BASES TO SUBSCRIPTION

	select distinct subscriptionid, marketbaseid into #tmb from(
		select c.subscriptionid, a.*, e.marketbaseid from deliverymarket a 
		join deliverables b on a.deliverableid = b.deliverableid
		join subscription c on c.subscriptionid = b.subscriptionid
		join marketdefinitionbasemaps e on e.marketdefinitionid = a.marketdefid
	)A

	MERGE [dbo].[subscriptionmarket] AS TARGET
	USING #tmb AS SOURCE
	ON (TARGET.subscriptionid=SOURCE.subscriptionid AND TARGET.marketbaseid=SOURCE.marketbaseid)

	WHEN NOT MATCHED BY TARGET THEN
	insert(subscriptionid, marketbaseid)
	values(SOURCE.subscriptionid, SOURCE.marketbaseid)
	;

	
END




