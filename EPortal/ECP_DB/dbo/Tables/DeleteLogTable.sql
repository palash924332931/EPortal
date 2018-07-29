create table DeleteLogTable
(
	Id int identity(1,1),
	[Type] char(1) not null,
	ItemId int,
	ItemName nvarchar(100),
	dimensionId int,
	clientId int,
	UserId int,
	time_stamp datetime2
);
