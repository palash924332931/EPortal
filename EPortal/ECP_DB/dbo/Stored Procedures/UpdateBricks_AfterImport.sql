

CREATE PROCEDURE [dbo].[UpdateBricks_AfterImport]
AS
BEGIN
--Select * into  [ECP_Archive].[dbo].[DIMOutlet_bk_on_20170712] 
--FROM  [dbo].[DIMOutlet] 
	
--Select * into  [ECP_Archive].[dbo].[DIMProduct_bk_on_20170712] 
--FROM  [dbo].[DIMProduct_Expanded]

--Select * into  [ECP_Archive].[dbo].[DIMMolecule_bk_on_20170712] 
--FROM  [dbo].[DMMolecule]

--Select * into  [ECP_Archive].[dbo].[DIMMoleculeConcat_bk_on_20170712] 
--FROM  [dbo].[DMMoleculeConcat]

select * from [dbo].[DIMProduct_Expanded]
where Study_Indicators1='' and Study_Indicators3='' and Study_Indicators5=''
and (Study_Indicators2<>'' or Study_Indicators4<>'')

update [dbo].[DIMProduct_Expanded]
set CHANGE_FLAG='D'
where Study_Indicators1='' and Study_Indicators3='' and Study_Indicators5=''
and (Study_Indicators2<>'' or Study_Indicators4<>'')
  
update  [dbo].[DIMOutlet]
  set CHANGE_FLAG='D'
  where State_Code=''
  
 Select  Retail_Sbrick,State_code, dbo.GetStateFromBrick(Retail_Sbrick)
 from  [dbo].[DIMOutlet]
 where Retail_Sbrick in
 (SELECT Retail_Sbrick
  FROM  [dbo].[DIMOutlet]
  where State_Code<>''
 group by Retail_Sbrick 
 having COUNT(distinct State_Code)>1)
 
 update  [dbo].[DIMOutlet]
 set State_code= dbo.GetStateFromBrick(Retail_Sbrick)
 where Retail_Sbrick in
 (SELECT Retail_Sbrick
  FROM  [dbo].[DIMOutlet]
  where State_Code<>''
 group by Retail_Sbrick 
 having COUNT(distinct State_Code)>1)
 
END





