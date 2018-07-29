--select top 100 * from groups  
  
CREATE PROCEDURE [dbo].[IRPDeleteTerritory]   
 @pTerritoryId int   
AS  
BEGIN  
 SET NOCOUNT ON;  
 declare @rootGroupId int;  
   
 --Read deliverables id before deleting territory  
   
 DECLARE @TempDelivery TABLE ( DeliverableId int)  
 insert into @TempDelivery (DeliverableId) select distinct DeliverableId from DeliveryTerritory where TerritoryId = @pTerritoryId  
   
 --------delete from DeliveryTerritory--------  
    delete From DeliveryTerritory Where TerritoryID=@pTerritoryId;  
  
 --------delete from OutletBrickAllocations--------  
 delete from OutletBrickAllocations where TerritoryId = @pTerritoryId;  
   
 --------delete from Groups--------  
 select @rootGroupId = RootGroup_id from Territories where Id = @pTerritoryId;  
 update Territories set RootGroup_id = NULL where Id = @pTerritoryId;  
 ;WITH CTEGroups AS (  
   SELECT *  
   FROM Groups  
   WHERE Id = @rootGroupId  
   UNION ALL  
   SELECT t1.*  
   FROM Groups t1 INNER JOIN  
   CTEGroups v ON t1.ParentId = v.Id  
  )  
 DELETE  
 FROM Groups  
 WHERE Id IN (SELECT Id FROM CTEGroups);  
   
 --------delete from Levels--------  
 delete from Levels where TerritoryId = @pTerritoryId;  
  
 --------delete from Territories--------  
 delete from Territories where Id = @pTerritoryId;  
   
 -- update Restriction level in Deliverables   
    
  declare @Delid int,@Restrictionid int,@LvlNo int  
  while exists (select DeliverableId from @TempDelivery)  
  begin  
   Set @LvlNo=0  
   select top 1 @Delid = DeliverableId from @TempDelivery order by DeliverableId asc  
   --  
   select @Restrictionid = RestrictionId from Deliverables where DeliverableId=@Delid  
   if @Restrictionid is not null and @Restrictionid > 0  
    begin  
    select @LvlNo=min(lvl) from(  
    select max(LevelNumber)lvl from [Levels] where TerritoryId in(select TerritoryId from DeliveryTerritory  
      where DeliverableId =@Delid) group by TerritoryId )x  
  
    if  @Restrictionid > @LvlNo or @LvlNo is null  
    begin  
     Update Deliverables set RestrictionId=null where DeliverableId=@Delid  
    end  
   end  
  
   delete @TempDelivery  where DeliverableId = @Delid  
  
  end  
END  
  
-- TO TEST --  
---------------------------------------------  
 --select * from territories  
 --select * from groups where id >= 1470  
 --declare @id int  
 --set @id = 1116  
 --select * from Territories where id = @id order by 1  
 --select * from Levels where TerritoryId = @id  
 --select * from Groups where TerritoryId = @id --and CustomGroupNumberSpace is null--and levelNo = 3 order by LevelNo  
 --select * from OutletBrickAllocations where TerritoryId = @id --order by   
---------------------------------------------  
  
--[dbo].[IRPDeleteTerritory] 1116  
  
go
Create Procedure DeleteMarketDefinition  
@MarketDefID as int  
AS  
BEGIN  
 Delete from DeliveryMarket Where MarketDefId=@MarketDefID  
 Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)  
 Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID  
 Delete From MarketDefinitionPacks Where MarketDefinitionId=@MarketDefID  
 Delete From MarketDefinitions Where Id=@MarketDefID  
END
go
Create Procedure DeleteMarketDefinitionBaseMap  
@MarketDefID as int  
AS  
BEGIN  
 Delete from AdditionalFIlters Where MarketDefinitionBaseMapId in (Select Id from MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID)  
 Delete From MarketDefinitionBaseMaps Where MarketDefinitionID=@MarketDefID  
END
go