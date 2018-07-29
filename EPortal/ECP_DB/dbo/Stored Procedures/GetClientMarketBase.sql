

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetClientMarketBase] 
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
	SELECT CMB.[Id]
      ,CMB.[ClientId]
	  ,C.Name ClientName
      ,CMB.[MarketBaseId]
	  ,MB.Name +' '+MB.Suffix MarketBaseName
	  ,MB.Description 
	  ,BF.[Id] BaseFilterId
      ,BF.[Name] BaseFilterName
      ,BF.[Criteria] BaseFilterCriteria
      ,BF.[Values] BaseFilterValues
	  ,BF.IsEnabled BaseFilterIsEnabled
	  ,BF.IsRestricted IsRestricted
	  ,BF.IsBaseFilterType IsBaseFilterType
  FROM [ClientMarketBases] CMB
  JOIN [Clients] C
  ON CMB.[ClientId] =C.Id
  JOIN [MarketBases] MB
  ON CMB.[MarketBaseId] = MB.Id
  JOIN [BaseFilters] BF
  ON CMB.MarketBaseId = BF.MarketBaseId
  WHERE CMB.[ClientId]=@ClientId
  

	
END






