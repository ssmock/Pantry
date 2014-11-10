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

if exists (select 1 from sys.procedures where object_id = object_id('Stock.CreateChangeBatch'))
begin
    drop procedure Stock.CreateChangeBatch
end
GO

/*

    Creates a new change batch, returning its ID.
    
    CommittedToStock will default to 1-1-1900.
    CommittedToStockBy will default to 0 (Nobody).

    FK error if CreatedBy is invalid.

*/
create procedure Stock.CreateChangeBatch
(
    @CreatedBy int,
    @Note varchar(max),
    @Id int out
)
as
begin
    set nocount on

    insert Stock.ChangeBatch (
        Note,
        Created,
        CreatedBy,
        CommittedToStock,
        CommittedToStockBy)
    values (
        @Note,
        getdate(),
        @CreatedBy,
        '1-1-1900', -- Invalid date
        0) -- Nobody
    
    select @Id = @@identity
end
GO

print 'Procedure "Stock.CreateBatch" was created.'
GO