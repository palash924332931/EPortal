IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE [TABLE_SCHEMA]='dbo' AND [TABLE_NAME]='Role' AND [COLUMN_NAME]='IsExternal')
BEGIN
	ALTER TABLE [dbo].[Role] ADD [IsExternal] BIT NOT NULL DEFAULT(0)	
END

EXEC('UPDATE [dbo].[Role] SET [IsExternal] = 1 WHERE [RoleID] IN (1,2)')
