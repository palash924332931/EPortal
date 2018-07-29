
IF COL_LENGTH('ClientPackException','ExpiryDate') IS  NULL
 BEGIN
 ALTER TABLE [ClientPackException]
 ADD ExpiryDate datetime;
 END

 