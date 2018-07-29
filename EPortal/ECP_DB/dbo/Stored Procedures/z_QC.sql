
create PROCEDURE [dbo].[z_QC] 
	
AS
BEGIN
select c.Name Client, t.*,g.numberOfBricks from dbo.Territories t
join (
select TerritoryId ,COUNT(*) numberOfBricks
from OutletBrickAllocations
where  Type = 'brick'
group by TerritoryId) g on t.Id=g.TerritoryId
join dbo.Clients c on t.Client_id=c.Id
order by numberOfBricks 

END






