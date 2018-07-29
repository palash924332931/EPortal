
CREATE PROCEDURE [dbo].[AuditMarketBaseNameReport] 
@versionFrom int,
@versionTo int,
@marketBaseId int

AS
BEGIN
	SET NOCOUNT ON;

		--select name+' ' + suffix as MarketBaseName,[Version] as VersionNumber, FirstName+ ' ' + LastName as SubmittedBy,LastSaved as [DateTime]
		--from marketbase_History a
		--join [user] b on a.userid=b.userid
		--where MBId=@marketBaseId And [version]>= @versionFrom and [version]<=@versionTo 

		---------------------------------------------------------------------------------------------------------

		declare @reportMB table(MarketBaseName varchar(50), VersionNumber int, SubmittedBy varchar(100), [DateTime] datetime )
		declare @i int
		declare @name1 varchar(50)
		declare @name2 varchar(50)
		set @i = @versionFrom
		while(@i < @versionTo)
		begin
			select @name1 = name from marketbase_History where MBId = @marketBaseId and [version]=@i 
			select @name2 = name from marketbase_History where MBId = @marketBaseId and [version]=@i + 1
			print('name1' + @name1)
			print('name2' + @name2)

			if @name1 <> @name2
			begin
				insert into @reportMB
				select name as MarketBaseName,[Version] as VersionNumber, 
				case WHEN FirstName = 'admin' then 'admin' else FirstName+ ' ' + LastName end as SubmittedBy,
				LastSaved as [DateTime]
				from marketbase_History a
				join [user] b on a.userid=b.userid
				where MBId = @marketBaseId And [version] = @i
	
				insert into @reportMB
				select name as MarketBaseName,[Version] as VersionNumber, 
				case WHEN FirstName = 'admin' then 'admin' else FirstName+ ' ' + LastName end as SubmittedBy,
				LastSaved as [DateTime]
				from marketbase_History a
				join [user] b on a.userid=b.userid
				where MBId = @marketBaseId And [version] = @i + 1
			end

			set @i = @i + 1

		end
	
		select distinct * from @reportMB order by versionnumber

END