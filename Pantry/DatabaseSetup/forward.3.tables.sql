-- Units of measure.  These will be set up via script only, and names
-- will be short, so we can get away with PKing by name.
if not exists (select 1 from sys.tables where object_id = object_id('Common.Unit'))
begin
	create table Common.Unit
	(
		Name varchar(50) not null primary key,
		StandardConversion decimal(15,7) not null,
		MetricConversion decimal(15,7) not null,
		IsMetric bit not null
	)

	print 'Table "Common.Unit" was created.'
end
else
begin
	print 'Table "Common.Unit" already exists.'
end
GO

-- For now, this is just a lookup.  We can extend it to be more like an account later.
if not exists (select 1 from sys.tables where object_id = object_id('Access.PantryUser'))
begin
	create table Access.PantryUser
	(
		Id int identity primary key,
		Name varchar(120) not null unique
	)

	print 'Table "Access.PantryUser" was created.'

	-- Add "Nobody" and "System."  We will be glad to have these later.  
	set identity_insert Access.PantryUser on 

	insert Access.PantryUser (
		Id,
		Name)
	values (
		0,
		'Nobody'), (
		1,
		'System')

	set identity_insert Access.PantryUser off 

	print 'Users "Nobody" and "System" were added to Access.PantryUser.'
end
else
begin
	print 'Table "Access.PantryUser" already exists.'
end
GO

-- Batch table for stock change events.
-- We'll just be creating and committing in one go.  If we weren't, we
-- could add additional columns for Committed and CommittedBy.
if not exists (select 1 from sys.tables where object_id = object_id('Stock.ChangeBatch'))
begin
	create table Stock.ChangeBatch
	(
		Id int identity primary key,
		Note varchar(max) null,
		Created datetime,
		CreatedBy int not null
			constraint fk_StockChangeBatch_AccessPantryUser_CreatedBy
			references Access.PantryUser (Id),
		CommittedToStock datetime,
		CommittedToStockBy int not null
			constraint fk_StockChangeBatch_AccessPantryUser_CommittedBy
			references Access.PantryUser (Id),
	)

	print 'Table "Stock.ChangeBatch" was created.'
end
else
begin
	print 'Table "Stock.ChangeBatch" already exists.'
end
GO