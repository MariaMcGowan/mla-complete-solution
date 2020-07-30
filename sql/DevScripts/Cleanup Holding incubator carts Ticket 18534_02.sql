use MLA_Test
go

declare @DeleteMe table (DeliveryCartID int)
-- 19
insert into @DeleteMe (DeliveryCartID)
select 43772
union all select 43779
union all select 43786
union all select 43793
union all select 43803
union all select 43814
union all select 43826
union all select 43837
union all select 43851
-- 18
union all select 43778
union all select 43785
union all select 43792
union all select 43802
union all select 43813
union all select 43825
union all select 43836
union all select 43850
-- 20
union all select 43768
union all select 43773
union all select 43780
union all select 43787
union all select 43794
union all select 43804
union all select 43815
union all select 43827
union all select 43838
union all select 43852
-- 17
union all select 43784
union all select 43791
union all select 43801
union all select 43812
union all select 43824
union all select 43835
union all select 43849
-- 21
union all select 43763
union all select 43769
union all select 43774
union all select 43781
union all select 43788
union all select 43795
union all select 43805
union all select 43816
union all select 43828
union all select 43839
union all select 43853
-- 16
union all select 43790
union all select 43800
union all select 43811
union all select 43823
union all select 43834
union all select 43848
-- 15
union all select 43799
union all select 43810
union all select 43822
union all select 43833
union all select 43847
-- 14
union all select 43809
union all select 43821
union all select 43832
union all select 43846
-- 11
union all select 43843
--13
union all select 43820
union all select 43831
union all select 43845
--12
union all select 43830
union all select 43844


select *
into DeliveryCartFlock_20200310
from DeliveryCartFlock
where DeliveryCartID in (select DeliveryCartID from @DeleteMe)


delete
from DeliveryCartFlock
where DeliveryCartID in (select DeliveryCartID from DeliveryCartFlock_20200310)

select *
into DeliveryCart_20200310
from DeliveryCart
where DeliveryCartID in (select DeliveryCartID from @DeleteMe)


delete
from DeliveryCart
where DeliveryCartID in (select DeliveryCartID from DeliveryCart_20200310)