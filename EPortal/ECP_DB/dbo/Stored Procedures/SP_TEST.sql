
CREATE PROCEDURE [dbo].[SP_TEST]
AS
BEGIN

insert into Test_Table
select top 2 A.*, GETDATE() as Run_Time 
from [Mirror].[dbo].[HISTORY_TDW-ECP_DIM_PRODUCT] A

END


