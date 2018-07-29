

create table Tdw_export_history

(
 Id int identity (1,1) primary key,
versionId int Not Null,
[Type] varchar(100),
 ClientId int  not null,
 ClientName varchar(255),
 Deliverable varchar(255),
 Market varchar(255),
 Territory varchar(255),
 SubmittedBy int not null,
 SubmittedDate datetime
 
 )




select * from Tdw_export_history

