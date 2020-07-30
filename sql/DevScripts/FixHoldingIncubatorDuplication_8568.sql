declare @DeliveryID int = 89

		--select *
		--into DeliveryCart_BeforeFix_20170419
		--from DeliveryCart
		--where DeliveryID = @DeliveryID

		--select min(DeliveryCartID) as DeliveryCartID, 
		--DeliveryCart, SortOrder, IsActive, CartNumber, IncubatorLocationNumber, 
		--LoadDateTime, DeliveryID, OrderID
		--into #DeliveryCart_Keepers
		--from DeliveryCart
		--where DeliveryID = @DeliveryID
		--and IsActive = 1
		--group by DeliveryCart, SortOrder, IsActive, CartNumber, IncubatorLocationNumber, 
		--LoadDateTime, DeliveryID, OrderID
		--order by IncubatorLocationNumber



		--update dc set dc.IsActive = 0
		--from DeliveryCart dc
		--where DeliveryID = @DeliveryID
		--and IsActive = 1
		--and not exists (select 1 from #DeliveryCart_Keepers where DeliveryCartID = dc.DeliveryCartID)

		--drop table #DeliveryCart_Keepers



		--select * 
		--into DeliveryCartFlock_BeforeDeletedForFix_20170419
		--from DeliveryCartFlock dcf
		--where exists 
		--(
		--select 1
		--from DeliveryCart
		--where DeliveryID = @DeliveryID
		--and IsActive = 0
		--and DeliveryCartID = dcf.DeliveryCartID
		--)

		
		delete
		from DeliveryCartFlock
		where exists 
		(
		select 1
		from DeliveryCart
		where DeliveryID = @DeliveryID
		and IsActive = 0
		and DeliveryCartID = DeliveryCartFlock.DeliveryCartID
		)


		delete 
		from DeliveryCart
		where DeliveryID = @DeliveryID
		and IsActive = 0