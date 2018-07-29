CREATE PROCEDURE [dbo].[GetBroadcast_Emails] 
AS
BEGIN
	
	SELECT distinct  [email]
	  FROM [dbo].[User]
	  where [IsActive]=1
	
END






