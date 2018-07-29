CREATE PROCEDURE [dbo].[IRPImportTerritoryDefinition] 
       -- Add the parameters for the stored procedure here
       @pTerritoryId int 
AS
BEGIN
       SET NOCOUNT ON;

       SET IDENTITY_INSERT Territories ON

       declare @territoryType varchar(10)
       declare @lastLevel int
       declare @refTerritoryid int
       print('Loading: ')
       print(@pTerritoryId)

       -- Delete existing Territory Definition if any
       declare @tCount int
       declare @tId int
       select @tCount = count(Id) from Territories where DimensionId = @pTerritoryId
       select @tId = Id from Territories where DimensionId = @pTerritoryId

       if @tCount > 0
             begin
                    exec [IRPDeleteTerritory] @tId
             end

       --### STEP 1 : insert into Territories
       insert into Territories (Id, Name, RootGroup_id,RootLevel_id,Client_id, IsBrickBased, IsUsed, GuiId, SRA_Client, SRA_Suffix, AD, LD, DimensionId)
       select  distinct I.DimensionID,I.DimensionName, NULL, NULL, C.ClientID, case when BaseId = 2 then 0 else 1 end, 0, NULL, G.SRAClient as SRA_Client, G.SRASuffix as SRA_Suffix, G.AD, G.LD, @pTerritoryId
       from IRP.Dimension I join IRP.ClientMap C on I.ClientID = C.IRPClientId left join [IRP].[GeographyDimOptions] G on I.DimensionID=G.DimensionID
       where I.DimensionID = @pTerritoryId and I.VersionTo =32767 --and G.VersionTo = 32767 and (G.SRAClient is not null or G.AD is not null or G.LD is not null)
       
       select @territoryType = IsBrickBased from Territories where Id = @pTerritoryId 

       -- Implement refDimensionId if needed
       -------TEMPORARY COMMENTED
       --select @refTerritoryid = refdimensionid from IRP.Dimension where DimensionID = @pTerritoryId and VersionTo > 0
       --if @refTerritoryid <> @pTerritoryId
       --begin
       --     --SET IDENTITY_INSERT Territories OFF
       --     update Territories set Id = @refTerritoryid where Id = @pTerritoryId
       --     set @pTerritoryId = @refTerritoryid
       --end
       ------------------------------------

       --### STEP 2 : insert into Levels

       select @lastLevel = MAX(LevelNo) from IRP.Levels where DimensionID = @pTerritoryId and VersionTo > 0
       if @territoryType = 1 
       begin 
             set @lastLevel = @lastLevel - 1
       end 

       print('Last level: ')
       print(@lastLevel)

       SET IDENTITY_INSERT Territories OFF
       SET IDENTITY_INSERT Levels ON
       insert into Levels (Id, Name, LevelNumber, LevelIDLength, LevelColor, BackgroundColor, TerritoryId)
       select LevelID, LevelName, LevelNo, case when LevelNo < 3 then 1 else 2 end, NULL, NULL, DimensionID 
       from IRP.Levels where DimensionID = @pTerritoryId and LevelNo <= @lastLevel - 1 and VersionTo > 0

       update Levels set LevelIdLength =  0 where LevelNumber = 1
       --select * from Levels

       --### STEP 3 : insert into Groups
       SET IDENTITY_INSERT Levels OFF
       SET IDENTITY_INSERT Groups ON
       insert into Groups (Id, Name, ParentId, LevelNo, GroupNumber, IsOrphan, PaddingLeft, TerritoryId)
       select ItemID, Name, Parent, LevelNo, cast(LevelNo as varchar) + cast(ROW_NUMBER() over(partition by LevelNo order by ItemID) as varchar), 0, 130, DimensionID from IRP.Items 
       where DimensionID = @pTerritoryId and LevelNO <= @lastLevel and VersionTo > 0 and (name <>  '')

       --select * from Groups
       --truncate table Groups
       select G.Id, S.GroupNumber into #parent from Groups G join Groups S on G.ParentId = S.Id
       update Groups set ParentGroupNumber = IG.GroupNumber
       from Groups G join #parent IG on G.Id = IG.Id

       update Groups set CustomGroupNumberSpace = IG.CustomGroupNumberSpace
       from Groups G join IRP.GroupNumberMap IG on G.GroupNumber =  IG.GroupNumber
       where TerritoryId = @pTerritoryId

       drop table #parent

       update Territories set RootGroup_id = G.Id
       from Territories T join Groups G on T.Id = G.TerritoryId
       where ParentId is NULL and T.Id = @pTerritoryId

       --### STEP 4 : insert into OutletBrickAllocations
       print('territory type: ')
       print (@territoryType)

       print('last level final')
       print(@lastLevel)

       select DimensionID, LevelNo, Parent, Item into #tempItems from IRP.Items where DimensionID = @pTerritoryId and LevelNo = @lastLevel and VersionTo > 0
       if @territoryType = 1 
       begin
             insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type, BannerGroup, State, Panel, BrickOutletLocation, TerritoryId )
             select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address], t.Item BrickOutletCode, b.BrickName BrickOutletName, l.Name LevelName, 'Brick' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, b.BrickLocation, t.DimensionID TerritoryId 
             from #tempItems t 
             join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
             join tblBrick b on t.Item = b.Brick
             join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
             where G.TerritoryId = @pTerritoryId
       end
       else
       begin

             insert into OutletBrickAllocations (NodeCode, NodeName, [Address], BrickOutletCode, BrickOutletName, LevelName, Type,BannerGroup, State, Panel, TerritoryId, BrickOutletLocation)
             select distinct G.CustomGroupNumberSpace NodeCode, G.Name NodeName, b.Address [Address],b.outlet BrickOutletCode, b.OutletName BrickOutletName, l.Name LevelName, 'Outlet' Type, b.BannerGroup BannerGroup, b.State State, b.Panel Panel, t.DimensionID TerritoryId ,''
             from #tempItems t 
             join Groups G on t.Parent = G.Id and G.TerritoryId = @pTerritoryId
             left join [IRP].[IMSOutletMaster] x on x.OID = t.Item
             join tblOutlet b on x.EID = b.EID
             --left join tblOutlet b on t.Item = b.EID
             join Levels l on G.LevelNo = l.LevelNumber and l.TerritoryId = @pTerritoryId
             where G.TerritoryId = @pTerritoryId
       end

       --select * from OutletBrickAllocations
       delete from Groups where LevelNo = @lastLevel and TerritoryId = @pTerritoryId

       drop table #tempItems      

       ---UPDATE CUSTOM GROUP NUMBER SPACE ---
       exec [dbo].[IRPImportTerritoryCustomGroupNumber] @pTerritoryId=@pTerritoryId
    

       --Handle invalid GROUPS like UPLIFT and SHARE
       select @lastLevel = max(levelNumber) from Levels where territoryId = @pTerritoryId 
       delete from Groups where territoryId = @pTerritoryId and levelNo > 1 and (CustomGroupNumberSpace = '' or CustomGroupNumberSpace is null)
       delete from groups where territoryid = @pTerritoryId and levelno = @lastLevel 
             and customgroupnumberspace not in (select distinct nodecode from outletbrickallocations where territoryid = @pTerritoryId)
       
       --Update Standard Territory
       update territories 
       set client_id=0,name='IMS Standard Brick Structure'    where id=305
       --Update Standard Outlet
       update territories 
       set client_id=0,name='IMS Standard Outlet Structure' where id=203

       print('End: ')
       print(@pTerritoryId) 

END
