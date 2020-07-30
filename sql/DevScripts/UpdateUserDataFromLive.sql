

------ UserGroup
--SET IDENTITY_INSERT MLA_Phase2Dev.csb.UserGroup ON 
--INSERT into MLA_Phase2Dev.csb.UserGroup (UserGroupID, UserGroup)
--select UserGroupID, UserGroup
--from MLA.csb.UserGroup a
--where not exists (select 1 from MLA_Phase2Dev.csb.UserGroup where UserGroupID = a.UserGroupID) 
--SET IDENTITY_INSERT MLA_Phase2Dev.csb.UserGroup OFF
------

-------- UserTable
--SET IDENTITY_INSERT MLA_Phase2Dev.csb.UserTable ON 
--INSERT into MLA_Phase2Dev.csb.UserTable (UserTableID, UserID, EmailAddress, UserGroupID, ContactName, Inactive)
--select UserTableID, UserID, EmailAddress, UserGroupID, ContactName, Inactive
--from MLA.csb.UserTable a  
--where not exists (select 1 from MLA_Phase2Dev.csb.UserTable where UserTableID = a.UserTableID) 
--SET IDENTITY_INSERT MLA_Phase2Dev.csb.UserTable OFF
--------