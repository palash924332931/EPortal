CREATE PROCEDURE [dbo].[IRPImportTerritoryCustomGroupNumber] 
	-- Add the parameters for the stored procedure here
	@pTerritoryId int 
AS
BEGIN
	SET NOCOUNT ON;
	--SET IDENTITY_INSERT [dbo].[Territories] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON;
	--SET IDENTITY_INSERT [dbo].[Levels] ON
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] ON;

declare @IDLen2 int 
declare @IDLen3 int 
declare @IDLen4 int 
declare @IDLen5 int 


-----------------update levels id length------------

	update l
	set l.levelidlength=B.length
	from levels l
	join 
	(
	select levelid,levelno, [end] - start + 1 length from
	(
		   select *, cast(substring(replace(Options, ' ',''), 7, 1) as int) start, cast(substring(replace(Options, ' ',''), 13, 1) as int) 'end' 
		   from IRP.Levels 
		   where 
		   options <> '' and 
		   dimensionid = @pTerritoryId and 
		   versionto > 0
	)A)B
	on l.id=b.levelid
	and l.levelnumber=B.levelno
	where l.levelnumber > 1
-------------------------------------------------------------------------

select @IDLen2=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=2
select @IDLen3=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=3
select @IDLen4=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=4
select @IDLen5=levelidlength from levels where territoryid=@pTerritoryId and levelnumber=5

------------------level 2-------------------------------------------------------

update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, replace(Number, '-','') cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 2)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

------------------level 3-------------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 3)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 4-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 4)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

--------------------level 5-----------------------------------------------------
update g
set g.NewCGN=a.cid
,g.CustomGroupNumber=replace(a.number,'-','')
from groups g
join(
select *, left(replace(Number, '-',''), @IDLen2) + ' '  + substring(replace(Number, '-',''), @IDLen2 + 1, @IDLen3) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + 1, @IDLen4) + ' ' + substring(replace(Number, '-',''), @IDLen2 + @IDLen3 + @IDLen4 + 1, @IDLen5) cid
from IRP.iTEMS 
where dimensionid = @pTerritoryId and versionto > 0
and levelno = 5)a
on g.id=a.itemid
and g.territoryid=a.dimensionid

-------update nodecode from Items---------
--update o
--set o.nodecode=replace(i.number,'-','')
--from outletbrickallocations o
--join IRP.Items i
--on o.territoryid=i.dimensionid
--and o.brickoutletcode=i.Item
--where o.territoryid=@pTerritoryId

--update o
--set o.nodecode=g.customgroupnumberspace
--from outletbrickallocations o
--join groups g
--on o.territoryid=g.territoryid
--and o.nodecode=g.customgroupnumber
--where o.territoryid=@pTerritoryId

update o
set o.NodeCode = g.NewCGN
from OutletBrickAllocations o join Groups g on o.TerritoryId = g.TerritoryId and o.NodeCode = g.CustomGroupNumberSpace
where o.TerritoryId = @pTerritoryId

update Groups set CustomGroupNumberSpace = NewCGN 
where TerritoryId = @pTerritoryId
	
	--SET IDENTITY_INSERT [dbo].[Territories] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF;
	--SET IDENTITY_INSERT [dbo].[Levels] OFF
	--SET IDENTITY_INSERT [dbo].[OutletBrickAllocations] OFF;

END


--exec [dbo].[IRPImportTerritoryDefinition_Groups] 3989




