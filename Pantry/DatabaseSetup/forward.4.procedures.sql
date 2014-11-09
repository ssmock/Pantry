if exists (select 1 from sys.procedures where object_id = object_id('Common.GetUnits'))
begin
    drop procedure Common.GetUnits
end
GO

/*

    Gets a full unit lookup, filtered and ordered as specified.

    Selects Name, StandardConversion, MetricConversion, IsMetric

*/
create procedure Common.GetUnits
as
begin
    set nocount on

    select
        Name,
        StandardConversion,
        MetricConversion,
        IsMetric
    from
        Common.Unit		
end
GO

print 'Procedure "Common.GetUnits" was created.'
GO