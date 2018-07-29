
CREATE FUNCTION [dbo].[GetStateFromBrick]
(
@Brick varchar(50)
)
RETURNS varchar(20)
AS
BEGIN
	DECLARE @ret varchar(20)='', @LeftChar varchar(5)

	Set @LeftChar=left(@Brick,1)
	
	if @LeftChar='2'
		Set @ret='NSW'
		
	if @LeftChar='3'
		Set @ret='VIC'
		
	if @LeftChar='4'
		Set @ret='QLD'
		
	if @LeftChar='0'
		Set @ret='NT'
		
	if @LeftChar='5'
		Set @ret='SA'
		
	if @LeftChar='6'
		Set @ret='WA'
	
	if @LeftChar='7'
		Set @ret='TAS'

	RETURN @ret

END


