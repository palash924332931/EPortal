
CREATE PROCEDURE [dbo].[GenerateMarketDefinitionReport]
	
AS
BEGIN
SET NOCOUNT ON;

--select all marketdefinition except for client Demonstartion
select * into #mdef from marketdefinitions where clientid <> 41

--Prepare extraction and insert into a temp table
	select c.name as ClientName,b.name as MarketDefName,a.MarketDefinitionid,a.Pfc,a.Pack,a.MarketBaseID,
	a.MarketBase,a.GroupNumber,a.GroupName,a.Factor,a.Product,a.Manufacturer,a.ATC4,a.NEC4,a.Molecule
		into #mreport
		from marketdefinitionpacks a  
		join #mdef b on a.marketdefinitionid=b.id
		join clients c on b.clientid=c.id 
		where marketdefinitionid in (select distinct id from #mdef)

--select from temp table
select * from #mreport order by clientName,MarketDefinitionid,MarketBase,PFC,Pack
	
END

---------------------------------------------------------------------------------------------
--exec [dbo].[GenerateMarketDefinitionReport]