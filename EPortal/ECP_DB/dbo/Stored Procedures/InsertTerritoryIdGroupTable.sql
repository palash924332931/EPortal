
create procedure [dbo].[InsertTerritoryIdGroupTable]
AS
BEGIN
update G
set G.TerritoryId=T.Id
from dbo.Groups G
join [dbo].[vw_GroupsLevelWise] V
on G.id=V.GROUP_ID
join [dbo].[Territories] T
on T.RootGroup_id=V.ROOT_GROUP_ID
END



