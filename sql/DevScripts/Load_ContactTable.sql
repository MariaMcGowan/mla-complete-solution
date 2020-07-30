insert into Contact (Contact, FirstName, LastName, Email, OfficePhone, MobilePhone, FaxNumber, PrimaryMethodOfContact, Notes, SortOrder, IsActive, ContactTypeID)
select FullName, FirstName, LastName, Email, OfficePhone, MobilePhone, FaxNumber, PrimaryMethodOfContact, Notes, c.SortOrder, c.IsActive, ct.ContactTypeID
from [dbo].[ContactAndContactType_Templates (1)] c
left outer join ContactTYpe ct on c.ContactType = ct.ContactTYpe

