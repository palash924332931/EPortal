CREATE PROCEDURE [dbo].[GenerateMarketDefinitionsReport]
	
AS
BEGIN
SET NOCOUNT ON;

--select all marketdefinition except for client Demonstartion
select * into #mdef from marketdefinitions where clientid not in (select id from clients where name='Demonstration')

--Prepare extraction and insert into a temp table
	select c.name as ClientName,b.name as MarketDefName,b.DimensionID,a.Pfc,a.Pack,a.MarketBaseID,
	a.MarketBase,a.GroupNumber,a.GroupName,a.Factor,a.Product,a.Manufacturer,a.ATC4,a.NEC4,a.Molecule
		into #mreport
		from marketdefinitionpacks a  
		join #mdef b on a.marketdefinitionid=b.id
		join clients c on b.clientid=c.id 
		where a.alignment='dynamic-right'
		
--select from temp table
select * from #mreport order by clientName,DimensionID,MarketBase,PFC,Pack
	
END