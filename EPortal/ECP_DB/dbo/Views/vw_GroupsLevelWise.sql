


CREATE VIEW [dbo].[vw_GroupsLevelWise]
AS
			SELECT 
				 id AS GROUP_ID
				,ParentId AS PARENT_ID
				,id AS ROOT_GROUP_ID
				,Name AS GROUP_NAME
				,LEFT(GroupNumber,1) AS LEVEL_NUMBER
				,GroupNumber AS GROUP_NUMBER
				,TerritoryId AS TERRITORY_ID
				,CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups
			WHERE GroupNumber like '1%'
			UNION
			---LEVEL 2
			SELECT 
				 id AS GROUP_ID
				, ParentId AS PARENT_ID
				,ParentId AS ROOT_GROUP_ID
				,Name AS GROUP_NAME
				,LEFT(GroupNumber,1) AS LEVEL_NUMBER
				,GroupNumber AS GROUP_NUMBER
				,TerritoryId AS TERRITORY_ID
				,CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups
			WHERE GroupNumber like '2%'
			UNION
			--LEVEL 3
			SELECT 
				 lvl3.Id AS GROUP_ID
				,lvl3.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl3.Name AS GROUP_NAME
				,LEFT(lvl3.GroupNumber,1) AS LEVEL_NUMBER
				,lvl3.GroupNumber AS GROUP_NUMBER
				,lvl3.TerritoryId AS TERRITORY_ID
				,lvl3.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl3
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			on lvl2.Id=lvl3.ParentId
			WHERE lvl3.GroupNumber like '3%'
			UNION
			--LEVEL 4
			SELECT 
				 lvl4.Id AS GROUP_ID
				,lvl4.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl4.Name AS GROUP_NAME
				,LEFT(lvl4.GroupNumber,1) AS LEVEL_NUMBER
				,lvl4.GroupNumber AS GROUP_NUMBER
				,lvl4.TerritoryId AS TERRITORY_ID
				,lvl4.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl4
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl4.GroupNumber like '4%'
			UNION
			--LEVEL 5
			SELECT 
				 lvl5.Id AS GROUP_ID
				,lvl5.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl5.Name AS GROUP_NAME
				,LEFT(lvl5.GroupNumber,1) AS LEVEL_NUMBER
				,lvl5.GroupNumber AS GROUP_NUMBER
				,lvl5.TerritoryId AS TERRITORY_ID
				,lvl5.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl5
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl5.GroupNumber like '5%'
			UNION
			--LEVEL 6
			SELECT 
				 lvl6.Id AS GROUP_ID
				,lvl6.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl6.Name AS GROUP_NAME
				,LEFT(lvl6.GroupNumber,1) AS LEVEL_NUMBER
				,lvl6.GroupNumber AS GROUP_NUMBER
				,lvl6.TerritoryId AS TERRITORY_ID
				,lvl6.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl6
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl6.GroupNumber like '6%'
			UNION
			--LEVEL 7
			SELECT 
				 lvl7.Id AS GROUP_ID
				,lvl7.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl7.Name AS GROUP_NAME
				,LEFT(lvl7.GroupNumber,1) AS LEVEL_NUMBER
				,lvl7.GroupNumber AS GROUP_NUMBER
				,lvl7.TerritoryId AS TERRITORY_ID
				,lvl7.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl7
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '6%') AS lvl6
			ON lvl6.Id=lvl7.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl7.GroupNumber like '7%'
			UNION
			--LEVEL 8
			SELECT 
				 lvl8.Id AS GROUP_ID
				,lvl8.ParentId AS PARENT_ID
				,lvl2.ParentId AS ROOT_GROUP_ID
				,lvl8.Name AS GROUP_NAME
				,LEFT(lvl8.GroupNumber,1) AS LEVEL_NUMBER
				,lvl8.GroupNumber AS GROUP_NUMBER
				,lvl8.TerritoryId AS TERRITORY_ID
				,lvl8.CustomGroupNumberSpace AS CUSTOM_GROUP_NUMBER_SPACE
			FROM dbo.Groups lvl8
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '7%') AS lvl7
			ON lvl7.Id=lvl8.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '6%') AS lvl6
			ON lvl6.Id=lvl7.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '5%') AS lvl5
			ON lvl5.Id=lvl6.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '4%') AS lvl4
			ON lvl4.Id=lvl5.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '3%') AS lvl3
			ON lvl3.Id=lvl4.ParentId
			INNER JOIN (SELECT * FROM dbo.Groups WHERE GroupNumber like '2%') AS lvl2
			ON lvl2.Id=lvl3.ParentId
			WHERE lvl8.GroupNumber like '8%'
			






