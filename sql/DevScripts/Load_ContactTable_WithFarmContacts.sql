select * 
from Contact
order by Contact

--insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
--select distinct PrimaryContact, HomePhone, Cell, Fax, OtherPhone, Email, 3
--from Farm_Template
--where PrimaryContact <> ''
--and len(HomePhone) < 15
--and len(Cell) < 15
--and len(Fax) < 15
--and Len(OtherPhone) < 15

select distinct PrimaryContact, HomePhone, Cell, Fax, OtherPhone, Email, 3
from Farm_Template
where PrimaryContact <> ''
and 
(len(HomePhone) >=15
or len(Cell) >= 15
or len(Fax) >= 15
or Len(OtherPhone) >= 15
)

insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
select 'John Blatt', '(610) 488-6201', '(484) 256-1731', '(610) 488-1518', null, 'blattacresfarm@aol.com', 3 union all
select 'Chris Blatt', '(610) 488-6201', '(484) 256-1755', '(610) 488-1518', null, 'blattacresfarm@aol.com', 3

insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
select 'Wesley Keener', '(570) 672-3391', '(570) 849-0057', '(570) 672-3391', '(570) 672-8665', null, 3 union all
select 'Naomi Keener', '(570) 672-3391', '(570) 380-4537', '(570) 672-8665', '(570) 672-8665', null, 3

insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
select 'Deron Swartz', '(717) 463-4008', '(717) 363-1215', '(717) 463-4097', '(717) 463-2870', 'DAdeSwartz07@outlook.com', 3
insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
select 'Delbert Swartz', '(717) 463-3466', '(717) 363-6844',  '(717) 463-4097', '(717) 213-3016', 'dmswartz77@gmail.com', 3


insert into Contact (Contact, HomePhone, MobilePhone, FaxNumber, OfficePhone, Email, ContactTypeID)
select distinct PrimaryContact, HomePhone, Cell, Fax, replace(OtherPhone, '(chickenhouse)', ''), Email, 3
from Farm_Template
where PrimaryContact <> ''
and 
(len(HomePhone) >=15
or len(Cell) >= 15
or len(Fax) >= 15
or Len(OtherPhone) >= 15
)
and 
(PrimaryContact not like '%Swartz%')
and 
(PrimaryContact not like '%Blatt%')
and 
(PrimaryContact not like '%Keener%')

delete from Contact where ContactID = 1091

update Contact set FirstName = 'Delbert', LastName = 'Swartz', ContactTypeID = 5, IsActive = 1 where ContactID = 1116

delete from Contact where ContactID = 1109