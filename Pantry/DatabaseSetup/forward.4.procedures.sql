if exists (select 1 from sys.procedures where object_id = object_id('Common.GetUnits'))
begin
    drop procedure Common.GetUnits
end
GO

/*

    Gets a full unit lookup.

    Selects Name, StandardConversion

*/
create procedure Common.GetUnits
as
begin
    set nocount on

    select
        Name,
        StandardConversion
    from
        Common.Unit
end
GO

print 'Procedure "Common.GetUnitNames" was created.'
GO