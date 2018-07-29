
--Add ExpiryDate field in ClientPackException
IF COL_LENGTH('ClientPackException','ExpiryDate') IS  NULL
 BEGIN
 ALTER TABLE [ClientPackException]
 ADD ExpiryDate datetime;
 END

 Go
 -- modified GetPacksFromClientMarketBase procedure for new search criteria
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'GetPacksFromClientMarketBase')
DROP PROCEDURE [dbo].[GetPacksFromClientMarketBase]    
GO

CREATE PROCEDURE[dbo].[GetPacksFromClientMarketBase]    
 @Clientid int  ,  
 @searchString varchar(max)  
AS    
BEGIN    
 SET NOCOUNT ON;    
    
  declare  @MarketBaseId int    
  DECLARE @MarketBaseName varchar(max)  
  DECLARE @ClientMktBaseCursor as CURSOR;  
  SET @ClientMktBaseCursor = CURSOR FAST_FORWARD FOR  
  
SELECT MarketBaseId from ClientMarketBases where ClientId=@Clientid  
  
create table #Result (  
 MarketBase varchar(max),   
 Pack nvarchar(max)  
   
)  
 
OPEN @ClientMktBaseCursor  
FETCH NEXT FROM @ClientMktBaseCursor INTO @MarketBaseId  
 WHILE @@FETCH_STATUS = 0  
BEGIN  
--set @MarketBaseId=3  
 select B.Id, B.Name, C.ColumnName as Criteria, B.[Values], B.MarketBaseId, C.ColumnName     
 into #baseFilters    
 from dbo.BaseFilters B join [dbo].[CONFIG_ECP_MKT_DEF_FILTERS] C on B.Criteria = C.FilterValue    
 where B.MarketBaseId = @MarketBaseId and name <> 'Molecule'  
    
 --select * from #baseFilters    
  select @MarketBaseName = Name + ' ' + Suffix from MarketBases  where ID=@MarketBaseId  
 select marketbaseid, Criteria + ' in ' + '(' + [Values] + ') AND ' conditions    
 into #columnsToAppend    
 from #baseFilters     
    
 --select * from #columnsToAppend    
    
 declare @whereClause nvarchar(max)    
 declare @selectSql nvarchar(max)    
  set @whereClause = ''  
  set @selectSql =''  
 select distinct @whereClause = ' where ' + conditions from    
  (    
   SELECT     
    b.marketbaseid,     
    (SELECT ' ' + a.conditions     
    FROM #columnsToAppend a    
    WHERE a.marketbaseid = b.marketbaseid    
    FOR XML PATH('')) [conditions]    
   FROM #columnsToAppend b    
   GROUP BY b.marketbaseid, b.conditions    
   --ORDER BY 1    
  )c    
   
 if len(@whereClause) > 0  
  begin  
  set @whereClause = left(@whereClause, len(@whereClause) - 4)    
  print(@whereClause)   
  --if @searchType = 0   
  -- set @whereClause = @whereClause + ' and Pack_Description like '''  + @searchString + '%'''  
  -- else  
  -- set @whereClause = @whereClause + ' and Pack_Description like ' + '''%' + @searchString + '%''' 
  if len(@searchString) > 1
     set @whereClause = @whereClause + ' and ' + @searchString
  set @selectSql = 'insert into #Result select distinct ''' + @MarketBaseName + ''', Pack_Description from DimProduct_Expanded A
   left join  dbo.DMMolecule B on A.FCC = B.FCC ' + @whereClause    
  --print @MarketBaseId   
  --print(@selectSql)    
  EXEC(@selectSql)    
  
  --insert into #Result select 'market' +cast(@count as varchar),'Pack_Description' +cast(@count as varchar)
   end  
    FETCH NEXT FROM @ClientMktBaseCursor INTO @MarketBaseId  
    drop table #baseFilters  
   drop table #columnsToAppend  
     
 end  
CLOSE @ClientMktBaseCursor;  
DEALLOCATE @ClientMktBaseCursor;  
--select * from #Result   
SELECT Pack  
, STUFF((SELECT ', ' + A.marketbase FROM #Result A  
Where A.Pack=B.Pack FOR XML PATH('')),1,1,'') As [MarketBase]  
From #Result B  
Group By Pack  
end  
    