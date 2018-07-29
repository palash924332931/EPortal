CREATE procedure [dbo].[GetMIPMKTPxrForMarketbase]
 @pClientId int 
as
begin

	select distinct 0 as Id, 0 as MarketbaseId, mkt_code as MarketCode ,mkt_name as MarketName from MIP.vw_Everest_PXR_FeedOUT 
	where client_no_MIP IN (select MIPClientNo from MIP.ClientMap  where clientId = @pClientId)
	and pxr_exclude_flag ='N'

end
GO