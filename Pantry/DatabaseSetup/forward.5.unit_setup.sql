set nocount on
GO

-- We'll use this to map all of our standard conversions,
-- below.
declare @gramsPerOunce decimal (15,7) = 28.3495

;with measures as
(
	select
		'tbsp' as Name,
		2 as StandardConversion, 
		0 as MetricConversion, 
		0 as IsMetric

	union

	select 'oz', 1, 0, 0

	union

	select 'cup', .125, 0, 0

	union

	select 'pt', .0625, 0, 0

	union

	select 'qt', .03125, 0, 0

	union

	select 'gal', .0078125, 0, 0

	union

	select 'lb', .0625, 0, 0

	union

	select 'ea', -1, 0, 0
)
,conversionPrepared as
(
	select
		Name,
		StandardConversion,
		case
			-- Preserve ea's strange conversion factor.
			when StandardConversion > 0 then				
				StandardConversion 
					* @gramsPerOunce
			else -1
		end as MetricConversion,
		IsMetric
	from
		measures
)
merge Common.Unit unit
using (select
		Name,
		StandardConversion,
		MetricConversion,
		IsMetric
	from
		conversionPrepared) as source
on (unit.Name = source.Name)
when matched then
	update
	set
		StandardConversion = source.StandardConversion,
		MetricConversion = source.MetricConversion,
		IsMetric = source.IsMetric
when not matched then
	insert (
		Name,
		StandardConversion,
		MetricConversion,
		IsMetric)
	values (
		source.Name,
		source.StandardConversion,
		source.MetricConversion,
		source.IsMetric);

select * from Common.Unit