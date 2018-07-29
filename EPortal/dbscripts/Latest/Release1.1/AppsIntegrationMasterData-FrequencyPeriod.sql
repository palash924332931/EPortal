
insert into periodforfrequency values (6, 3)
insert into periodforfrequency values (6, 4)
GO

UPDATE FrequencyType SET IRPFrequencyTypeId = 0 WHERE FrequencyTypeId = 1
UPDATE FrequencyType SET IRPFrequencyTypeId = 1 WHERE FrequencyTypeId = 6
GO