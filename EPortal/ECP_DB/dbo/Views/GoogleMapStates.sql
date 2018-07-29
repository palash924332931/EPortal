--select * from [dbo].[GoogleMapStates] order by id

create VIEW [dbo].[GoogleMapStates]
AS

select ItemID as id,ShortName as statecode
FROM [dbo].[z_Items]
  where DimensionID =836 and LevelNo =2




