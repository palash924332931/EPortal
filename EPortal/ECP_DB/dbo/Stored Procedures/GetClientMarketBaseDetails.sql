
CREATE PROCEDURE [dbo].[GetClientMarketBaseDetails] 
	-- Add the parameters for the stored procedure here
	@ClientId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--declare @ClientMarketBase as TABLE (Id int, ClientId int, ClientName nvarchar(max),MarketBaseId int , MarketBaseName nvarchar(max), Description nvarchar(max));

    -- Insert statements for procedure here
--insert  @ClientMarketBase
	SELECT distinct CMB.[Id]
      ,CMB.[ClientId]
	  ,C.Name ClientName
      ,CMB.[MarketBaseId]
	  ,MB.BaseType
	  ,MB.Name+' '+MB.Suffix MarketBaseName
	  ,MB.Description 
	  --,BF.[Id] BaseFilterId
   --   ,BF.[Name] BaseFilterName
   --   ,BF.[Criteria] BaseFilterCriteria
   --   ,BF.[Values] BaseFilterValues
	  --,BF.IsEnabled BaseFilterIsEnabled
	  ,MB.[DurationTo]  as DurationFrom
	  ,MB.DurationFrom as DurationTo
	  ,CASE When MBDQ.MarketbaseId =CMB.MarketbaseId Then 'Deleted' ELse 'Active' END as DeleteStatus 
  FROM [ClientMarketBases] CMB
  JOIN [Clients] C
  ON CMB.[ClientId] =C.Id
  JOIN [MarketBases] MB
  ON CMB.[MarketBaseId] = MB.Id
  JOIN [BaseFilters] BF
  ON CMB.MarketBaseId = BF.MarketBaseId
  LEFT JOIN MarketBaseDeleteQueue MBDQ ON MBDQ.MarketbaseId=CMB.[MarketBaseId] AND CompleteDeleteFlag=1
 WHERE CMB.[ClientId]=@ClientId
  order by  MarketBaseName

	
END




