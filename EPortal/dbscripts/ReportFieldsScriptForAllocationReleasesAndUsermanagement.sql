
--insert into ReportFieldList values (42,'Name','Client Name','Clients',null)
--insert into ReportFieldList values (43,'FirstName','First Name','User',null)
--insert into ReportFieldList values (44,'LastName','Last Name','User',null)

--insert into ReportModules values (2,'Subscription/Deliverables','Subscription/Deliverables')
--insert into ReportModules values (3,'Territories','Territories')
--insert into ReportModules values (4,'Market Base','Market Base')
--insert into ReportModules values (5,'Pack Request','Pack Request')
--insert into ReportModules values (6,'Allocation','Allocation')
--insert into ReportModules values (7,'Releases','Releases')
--insert into ReportModules values (8,'User Management','User Management')


--insert into [ReportFieldsByModule] values (6,	42,	2)
--insert into [ReportFieldsByModule] values (6,	43,	2)
--insert into [ReportFieldsByModule] values (6,	44,	2)

--insert into ReportFilters values ('Default','Default','allocation default filter',
--'[{"FieldDescription":"Client Name","FieldID":42,"FieldName":"Name","TableName":"Clients","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"First Name","FieldID":43,"FieldName":"FirstName","TableName":"User","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Last Name","FieldID":44,"FieldName":"LastName","TableName":"User","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]}]'
--,6,0,0)

----user management fields
--insert into ReportFieldList values (45,'Username','Username','User',null)
--insert into ReportFieldList values (46,'RoleName','Role','Role',null)
--insert into ReportFieldList values (47,'isActive','Active','User',null)
--insert into ReportFieldList values (48,'MaintenancePeriodEmail','Email Remainder','User',null)
--insert into ReportFieldList values (49,'NewsAlertEmail','Email News Alert','User',null)
--insert into ReportFieldList values (103,'LoginDate','Last Login Time','UserLogin_History','DateString',null)

--insert into [ReportFieldsByModule] values (8,	42,	2)
--insert into [ReportFieldsByModule] values (8,	43,	2)
--insert into [ReportFieldsByModule] values (8,	44,	2)
--insert into [ReportFieldsByModule] values (8,	45,	2)
--insert into [ReportFieldsByModule] values (8,	46,	2)
--insert into [ReportFieldsByModule] values (8,	47,	2)
--insert into [ReportFieldsByModule] values (8,	48,	2)
--insert into [ReportFieldsByModule] values (8,	49,	2)
--insert into [ReportFieldsByModule] values (8,	103,2)

--insert into ReportFilters values ('Default','Default','user management default filter',
--'[{"FieldDescription":"Client Name","FieldID":42,"FieldName":"Name","TableName":"Clients","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"First Name","FieldID":43,"FieldName":"FirstName","TableName":"User","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Last Name","FieldID":44,"FieldName":"LastName","TableName":"User","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Username","FieldID":45,"FieldName":"Username","TableName":"User","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Role","FieldID":46,"FieldName":"Role","TableName":"Role","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Active","FieldID":47,"FieldName":"Active","TableName":"Boolean","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Email Remainder","FieldID":48,"FieldName":"EmailRemainder","TableName":"Boolean","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]},{"FieldDescription":"Email News Alert","FieldID":49,"FieldName":"EmailNewsAlert","TableName":"Boolean","UserTypeID":2,"selected":true,"include":true,"fieldValues":[]}]'
--,8,0,0)


--Releases fields
--insert into ReportFieldList values (50,'Onekey','One key','ClientRelease',null)
--insert into ReportFieldList values (51,'Org_Long_Name','PROBE Mfr','manufacturer',null)
--insert into ReportFieldList values (52,'Pack_Description','PROBE Pack Exception','packs',null)
--insert into ReportFieldList values (53,'CapitalChemist','Capital Chemist','ClientRelease',null)
--insert into ReportFieldList values (104,'Id','Client Number ','Clients',null)

--insert into [ReportFieldsByModule] values (7, 104, 2)
--insert into [ReportFieldsByModule] values (7, 42, 2)
--insert into [ReportFieldsByModule] values (7,	50,	2)
--insert into [ReportFieldsByModule] values (7,	51,	2)
--insert into [ReportFieldsByModule] values (7,	52,	2)
--insert into [ReportFieldsByModule] values (7,	53,	2)

--insert into ReportFilters values ('Default','Default','Releases default filter',
--'[{"FieldID":104,"FieldDescription":"Client Number ","FieldName":"Id","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[],"selectedValues":"166 ALL DIVISION STATE                     "},{"FieldID":50,"FieldDescription":"One key","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[],"selectedValues":"True"},{"FieldID":51,"FieldDescription":"PROBE Mfr","FieldName":"Org_Long_Name","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception","FieldName":"Pack_Description","TableName":"DIMProduct_Expanded","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]}]'
--,7,0,0)






