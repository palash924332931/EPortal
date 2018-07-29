

CREATE PROCEDURE [dbo].[CreateDMMoleculeConcat]

AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('dbo.DMMoleculeConcat') IS NOT NULL DROP TABLE DMMoleculeConcat
	select FCC, substring([Description], 4, 5000) [Description] 
	into DMMoleculeConcat
	from
	(
		SELECT 
			b.FCC, 
			(SELECT DISTINCT ' | ' + a.Description
			FROM DMMolecule a
			WHERE a.FCC = b.FCC --order by Description
			FOR XML PATH('')) [Description]
		FROM DMMolecule b
	GROUP BY b.FCC
	)A

END








