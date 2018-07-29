
CREATE Procedure [dbo].[prGetMarketBase] 
       @ClientId int,
       @MarketDefId varchar(10),
       @Type varchar(100)

AS
BEGIN
       IF @Type='All Market Base'
       BEGIN
             select X.[Id]
                      ,X.[ClientId]
                      ,X.ClientName
                      ,X.[MarketBaseId]   
                      ,X.UsedMarketBaseStatus
                      ,X.MarketBaseName
                      ,X.Description 
                      ,X.BaseFilterId
                      ,X.BaseFilterName
                      ,X.BaseFilterCriteria
                      ,X.BaseFilterValues
                      ,X.BaseFilterIsEnabled
                      ,X.IsRestricted
                      ,X.IsBaseFilterType
					  ,X.DeleteStatus
                    from(
                           SELECT CMB.[MarketBaseId] as [Id]
                             ,CMB.[ClientId]
                             ,C.Name ClientName
                             ,CMB.[MarketBaseId]
                             ,'false' UsedMarketBaseStatus
                             ,MB.Name +' '+MB.Suffix MarketBaseName
                             ,MB.Description 
                             ,BF.[Id] BaseFilterId
                             ,BF.[Name] BaseFilterName
                             ,BF.[Criteria] BaseFilterCriteria
                             ,BF.[Values] BaseFilterValues
                             ,BF.IsEnabled BaseFilterIsEnabled
                             ,BF.IsRestricted IsRestricted
                             ,BF.IsBaseFilterType IsBaseFilterType
							 ,CASE When MBDQ.MarketbaseId =CMB.MarketbaseId Then 'Deleted' ELse 'Active' END as DeleteStatus 
                      FROM [ClientMarketBases] CMB
                      JOIN [Clients] C
                      ON CMB.[ClientId] =C.Id
                      JOIN [MarketBases] MB
                      ON CMB.[MarketBaseId] = MB.Id
                      JOIN [BaseFilters] BF
                      ON CMB.MarketBaseId = BF.MarketBaseId
					  JOIN Subscription S
					  ON CMB.[ClientId] =S.ClientId
					  JOIN SubscriptionMarket SM
					  ON SM.SubscriptionId = S.SubscriptionId and SM.MarketbaseId = CMB.[MarketBaseId]
					  LEFT JOIN MarketBaseDeleteQueue MBDQ ON MBDQ.MarketbaseId=CMB.[MarketBaseId]
                      WHERE CMB.[ClientId]=@ClientId
                    )X

       END
       IF @Type='According to MarketDef'
       BEGIN
             select X.[Id]
                      ,X.[ClientId]
                      ,X.ClientName
                      ,X.[MarketBaseId]   
                      ,X.UsedMarketBaseStatus
                      ,X.MarketBaseName
                      ,X.Description 
                      ,X.BaseFilterId
                      ,X.BaseFilterName
                      ,X.BaseFilterCriteria
                      ,X.BaseFilterValues
                      ,X.BaseFilterIsEnabled
                      ,X.IsRestricted
                      ,X.IsBaseFilterType
					  ,X.DeleteStatus
                    from(
                           SELECT CMB.[MarketBaseId] as [Id]
                             ,CMB.[ClientId]
                             ,C.Name ClientName
                             ,CMB.[MarketBaseId], A.MarketBaseId AS UsedMarketBaseId
                             ,case when CMB.[MarketBaseId] = A.MarketBaseId then 'true' else 'false' end UsedMarketBaseStatus
                             ,MB.Name +' '+MB.Suffix MarketBaseName
                             ,MB.Description 
                             ,BF.[Id] BaseFilterId
                             ,BF.[Name] BaseFilterName
                             ,BF.[Criteria] BaseFilterCriteria
                             ,BF.[Values] BaseFilterValues
                             ,BF.IsEnabled BaseFilterIsEnabled
                             ,BF.IsRestricted IsRestricted
                             ,BF.IsBaseFilterType IsBaseFilterType
							 ,CASE When MBDQ.MarketbaseId =CMB.MarketbaseId Then 'Deleted' ELse 'Active' END as DeleteStatus 
                      FROM [ClientMarketBases] CMB
                      JOIN [Clients] C
                      ON CMB.[ClientId] =C.Id
                      JOIN [MarketBases] MB
                      ON CMB.[MarketBaseId] = MB.Id
                      JOIN [BaseFilters] BF
                      ON CMB.MarketBaseId = BF.MarketBaseId
					  JOIN Subscription S
					  ON CMB.[ClientId] =S.ClientId
					  JOIN SubscriptionMarket SM
					  ON SM.SubscriptionId = S.SubscriptionId and SM.MarketbaseId = CMB.[MarketBaseId]
                      left join 
                           (select distinct MarketBaseId from MarketDefinitionBaseMaps where MarketDefinitionId in (@MarketDefId))A on A.MarketBaseId = CMB.[MarketBaseId]
					  LEFT JOIN MarketBaseDeleteQueue MBDQ ON MBDQ.MarketbaseId=CMB.[MarketBaseId]
                      WHERE CMB.[ClientId]=@ClientId
                    )X
       END
END



