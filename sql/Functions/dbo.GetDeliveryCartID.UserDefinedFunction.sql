create function GetDeliveryCartID (@DeliveryID int, @LocationNumber int, @FlockID int)
returns int
as 
begin

	declare @DeliveryCartID int = 0

	if exists 
	(
		select 1
		from DeliveryCart dc
		inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
		where DeliveryID = @DeliveryID
			and IncubatorLocationNumber = @LocationNumber
			and FlockID = @FlockID
	)
	begin
		select top 1 @DeliveryCartID = dc.DeliveryCartID
		from DeliveryCart dc
		inner join DeliveryCartFlock dcf on dc.DeliveryCartID = dcf.DeliveryCartID
		where DeliveryID = @DeliveryID
			and IncubatorLocationNumber = @LocationNumber
			and FlockID = @FlockID
	end

	return @DeliveryCartID
end


