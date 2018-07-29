Create Procedure [dbo].[DeleteSubscibedID]
@DefID as int,
@Module as nvarchar(100)

AS
BEGIN
       IF @Module='Market Definition'
       BEGIN
       Delete from DeliveryMarket Where MarketDefId=@DefID
       END

       IF @Module='Territory Definition'
       BEGIN
             Delete from DeliveryTerritory Where TerritoryId=@DefID
       END

END


