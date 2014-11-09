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
(
    @IncludeCustomary bit = 1,
    @IncludeMetric bit = 0
)
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
    where
        -- Only get metric rows when they're
        -- requested.
        (IsMetric = 1
            and @IncludeMetric = 1)
        -- Same for customary.
        or (IsMetric = 0
            and @IncludeCustomary = 1)	
end
GO

print 'Procedure "Common.GetUnitNames" was created.'
GO