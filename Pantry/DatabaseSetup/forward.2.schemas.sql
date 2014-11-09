set nocount on
GO

-- "Stock" is our pantry's transactional product domain.
if not exists (select 1 from sys.schemas where name = 'Stock')
begin
	exec sp_executesql N'create schema Stock'

	print 'Schema "Stock" was created.'
end
else
begin
	print 'Schema "Stock" already exists.'
end
GO

-- "Common" is our pantry's shared reference domain.  We'll put
-- common lookups, like units of measure, here.
if not exists (select 1 from sys.schemas where name = 'Common')
begin
	exec sp_executesql N'create schema Common'

	print 'Schema "Common" was created.'
end
else
begin
	print 'Schema "Common" already exists.'
end
GO

-- "Access" is our application authorization domain.  We will
-- key to its PantryUser table frequently.
if not exists (select 1 from sys.schemas where name = 'Access')
begin
	exec sp_executesql N'create schema Access'

	print 'Schema "Access" was created.'
end
else
begin
	print 'Schema "Access" already exists.'
end
GO