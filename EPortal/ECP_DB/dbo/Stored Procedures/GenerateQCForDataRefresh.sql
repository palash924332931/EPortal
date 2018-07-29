
CREATE PROCEDURE [dbo].[GenerateQCForDataRefresh]
AS
BEGIN
	 ----------OVERALL QC report-------------
       declare @totalCount int
       declare @addCount int
       declare @deleteCount int
       declare @modifiedCount int
	   --insert into QCDataRefresh 

	   select @addCount = count(pfc) 
       from dimproduct_expanded
       where change_flag = 'A'

	   select @deleteCount = count(pfc) 
       from dimproduct_expanded
       where change_flag = 'D'
	   
	   select @modifiedCount = count(pfc) 
       from dimproduct_expanded
       where change_flag = 'M'

	   select @totalCount = count(*)
	   from [dbo].[RAW_TDW-ECP_DIM_PRODUCT]

	   insert into LogMarketDataRefresh
	   select getdate() Time_Stamp, @totalCount as 'TotalPacks', @addCount as 'NewPacks', @deleteCount as 'DeletedPacks', @modifiedCount as 'ModifiedPacks', 'Success' as [Status], NULL 

END