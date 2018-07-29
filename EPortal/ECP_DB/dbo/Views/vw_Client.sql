CREATE VIEW dbo.[vw_Client]
AS
SELECT C.Id, C.Name, M.IRPClientId, M.IRPClientNo
FROM     dbo.Clients AS C LEFT OUTER JOIN
                  IRP.ClientMap AS M ON M.ClientId = C.Id
GO