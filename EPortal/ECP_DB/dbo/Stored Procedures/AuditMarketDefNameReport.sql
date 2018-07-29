CREATE PROCEDURE [dbo].[AuditMarketDefNameReport] 
@versionFrom int,
@versionTo int,
@marketDefId int

AS
BEGIN
	SET NOCOUNT ON;

		--select name as MarketDefName,[Version] as VersionNumber, 
		--case WHEN FirstName = 'admin' then 'admin' else FirstName+ ' ' + LastName end as SubmittedBy,
		--LastSaved as [DateTime]
		--from marketdefinitions_History a
		--join [user] b on a.userid=b.userid
		--where marketdefid=@marketDefId And [version]>= @versionFrom and [version]<=@versionTo 

	declare @report table(MarketDefName varchar(50), VersionNumber int, SubmittedBy varchar(100), [DateTime] datetime )
	declare @i int
	declare @name1 varchar(50)
	declare @name2 varchar(50)
	set @i = @versionFrom
	while(@i < @versionTo)
	begin
		select @name1 = name from MarketDefinitions_History where marketdefid = @marketDefid and [version]=@i 
		select @name2 = name from MarketDefinitions_History where marketdefid = @marketDefid and [version]=@i + 1
		print('name1' + @name1)
		print('name2' + @name2)

		if @name1 <> @name2
		begin
			insert into @report
			select name as MarketDefName,[Version] as VersionNumber, 
			case WHEN FirstName = 'admin' then 'admin' else FirstName+ ' ' + LastName end as SubmittedBy,
			LastSaved as [DateTime]
			from marketdefinitions_History a
			join [user] b on a.userid=b.userid
			where marketdefid=@marketDefId And [version] = @i
	
			insert into @report
			select name as MarketDefName,[Version] as VersionNumber, 
			case WHEN FirstName = 'admin' then 'admin' else FirstName+ ' ' + LastName end as SubmittedBy,
			LastSaved as [DateTime]
			from marketdefinitions_History a
			join [user] b on a.userid=b.userid
			where marketdefid=@marketDefId And [version] = @i + 1
		end

		set @i = @i + 1

	end
	
	select distinct * from @report order by versionnumber

END