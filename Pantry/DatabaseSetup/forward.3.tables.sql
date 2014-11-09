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