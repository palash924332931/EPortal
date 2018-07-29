insert into reportfieldlist values ( 127, 'irpclientno', 'Client Number', 'clients',null)
insert into [ReportFieldsByModule] values (7,127, 2)
delete  from [ReportFieldsByModule] where moduleid = 7 and fieldid = 104

insert into reportfieldlist values (216,'ExpiryDate','PROBE Pack Exception Duration','clientpackexception', 'DateString')
insert into reportfieldlist values (217,'packexception','PROBE Pack Exception','packs', NULL)
insert into reportfieldlist values (218,'probe','PROBE Mfr','manufacturer', NULL)
insert into reportfieldsbymodule values (7, 216, 2)
insert into reportfieldsbymodule values (7, 217, 2)
insert into reportfieldsbymodule values (7, 218, 2)
update reportfieldlist set fielddescription = 'PROBE Mfr Details' where fieldId = 51
update reportfieldlist set fielddescription = 'PROBE Pack Exception Details' where fieldId = 52

delete from reportfilters where moduleId = 7

--select * from reportfilters where moduleId = 7

insert into reportFilters
values
( 'Default Filter - Releases',
'Default',
'Default',
'[{"FieldID":127,"FieldDescription":"Client Number","FieldName":"irpclientno","TableName":"clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"OneKey","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":218,"FieldDescription":"PROBE Mfr","FieldName":"probe","TableName":"manufacturer","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr Details","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":217,"FieldDescription":"PROBE Pack Exception","FieldName":"packexception","TableName":"packs","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception Details","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":216,"FieldDescription":"PROBE Pack Exception Duration","FieldName":"ExpiryDate","TableName":"clientpackexception","UserTypeID":2,"FieldType":"DateString","selected":false,"include":true,"fieldValues":[]}]',
7,1,0)


insert into reportFilters
values
( 'Default Filter - Capital Chemist',
'Default',
'Default',
'[{"FieldID":127,"FieldDescription":"Client Number","FieldName":"irpclientno","TableName":"clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"OneKey","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":218,"FieldDescription":"PROBE Mfr","FieldName":"probe","TableName":"DeliverableProbe","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr Details","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":217,"FieldDescription":"PROBE Pack Exception","FieldName":"packexception","TableName":"DeliverablePackException","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception Details","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":216,"FieldDescription":"PROBE Pack Exception Duration","FieldName":"ExpiryDate","TableName":"clientpackexception",
"UserTypeID":2,"FieldType":"DateString","selected":false,"include":true,"fieldValues":[]}]',
7,1,0)

insert into reportFilters
values
( 'Default Filter - PROBE Pack Exception',
'Default',
'Default',
'[{"FieldID":127,"FieldDescription":"Client Number","FieldName":"irpclientno","TableName":"clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"OneKey","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":218,"FieldDescription":"PROBE Mfr","FieldName":"probe","TableName":"manufacturer","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr Details","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":217,"FieldDescription":"PROBE Pack Exception","FieldName":"packexception","TableName":"packs","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception Details","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":216,"FieldDescription":"PROBE Pack Exception Duration","FieldName":"ExpiryDate","TableName":"clientpackexception","UserTypeID":2,"FieldType":"DateString","selected":true,"include":true,"fieldValues":[]}]',
7,1,0)


insert into reportFilters
values
( 'Default Filter - PROBE MFR',
'Default',
'Default',
'[{"FieldID":127,"FieldDescription":"Client Number","FieldName":"irpclientno","TableName":"clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},
{"FieldID":42,"FieldDescription":"Client Name","FieldName":"Name","TableName":"Clients","UserTypeID":2,"FieldType":"","selected":true,"include":true,"fieldValues":[]},{"FieldID":53,"FieldDescription":"Capital Chemist","FieldName":"CapitalChemist","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":50,"FieldDescription":"OneKey","FieldName":"Onekey","TableName":"ClientRelease","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":218,"FieldDescription":"PROBE Mfr","FieldName":"probe","TableName":"DeliverableProbe","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":51,"FieldDescription":"PROBE Mfr Details","FieldName":"Org_Long_Name","TableName":"manufacturer","UserTypeID":2,"FieldType":"NULL","selected":true,"include":true,"fieldValues":[]},{"FieldID":217,"FieldDescription":"PROBE Pack Exception","FieldName":"packexception","TableName":"DeliverablePackException","UserTypeID":2,"FieldType":"","selected":false,"include":true,"fieldValues":[]},{"FieldID":52,"FieldDescription":"PROBE Pack Exception Details","FieldName":"Pack_Description","TableName":"packs","UserTypeID":2,"FieldType":"NULL","selected":false,"include":true,"fieldValues":[]},{"FieldID":216,"FieldDescription":"PROBE Pack Exception Duration","FieldName":"ExpiryDate","TableName":"clientpackexception","UserTypeID":2,"FieldType":"DateString","selected":false,"include":true,"fieldValues":[]}]',
7,1,0)



