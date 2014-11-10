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

if exists (select 1 from sys.procedures where object_id = object_id('Stock.CancelBatch'))
begin
    drop procedure Stock.CancelBatch
end
GO

/*

    Removes the batch with the specified ID, provided that
    the batch has not already been committed.

    Fails hard if the batch has already been committed.
*/
create procedure Stock.CancelBatch
(
    @BatchId int,
    @CancelledBy int
)
as
begin
    set nocount on
    set xact_abort on

    if exists (select 1 
        from 
            Stock.ChangeBatch
        where
            Id = @BatchId
            and CommittedToStock <> '1-1-1900') -- Default date
    begin
        declare @invalidMessage varchar(250) = 
            'Batch ' + convert(varchar, @BatchId)
            + ' was already been committed;'
            + ' it cannot be cancelled.' 

        raiserror(@invalidMessage, 16, 1)		
    end
    else
    begin
        declare @transactionCount int = @@trancount

        begin try
            if @transactionCount = 0 begin transaction

            delete Stock.Change where BatchId = @BatchId

            delete Stock.ChangeBatch where Id = @BatchId

            if @transactionCount = 0 commit transaction
        end try
        begin catch
            if @transactionCount = 0 and xact_state() <> 0
            begin
                rollback transaction
            end

            -- Now re-raise the error.
            declare @errorState int = error_state()

            declare @message varchar(max) =
                'Error ' + cast(error_number() as varchar)
                    + ' in procedure ' + error_procedure() + ' - ' + error_message()

            raiserror(@message, 16, @errorState)
        end catch
    end
end
GO

print 'Procedure "Stock.CancelBatch" was created.'
GO

if exists (select 1 from sys.procedures where object_id = object_id('Stock.CommitBatch'))
begin
    drop procedure Stock.CommitBatch
end
GO

if exists (select 1 from sys.objects where object_id = object_id('Stock.PreparedChanges'))
begin
    drop function Stock.PreparedChanges
end
GO

/*

    Gets the specified batch's changes, prepared for stock updates by
    standardizing units to either oz or ea.

*/
create function Stock.PreparedChanges
(
    @BatchId int
)
returns @result table
(
    ChangeId int,
    ProductId int,
    UnitName varchar(50),
    Quantity decimal(15,3)
)
as
begin

    insert @result
    select
        change.Id,
        change.ProductId,
        case
            -- -1 means "ea"
            when unit.StandardConversion = -1 then 'ea'
            else 'oz'
        end as UnitName,
        case
            -- Don't convert ea.
            when unit.StandardConversion = -1 then change.Quantity
            else change.Quantity / unit.StandardConversion 
        end as Quantity
    from
        Stock.Change change
        join Common.Unit unit on
            change.UnitName = unit.Name
    where
        change.BatchId = @BatchId

    return
end
GO

print 'Function "Stock.PreparedChanges" was created.'
GO

/*

    Updates the stock (Stock.Item) with the specified batch, returning the 
    date/time of the commit.

    NOTE: Metric measures are not fully supported yet, so the stock is entirely
    maintained in oz and ea.

    Fails hard if any stock quantities fall below zero.

    @CommittedToStock: the date-time when the batch was committed.

*/
create procedure Stock.CommitBatch
(
    @BatchId int,
    @CommittedToStockBy int,
    @CommittedToStock datetime out
)
as
begin
    set nocount on
    set xact_abort on

    declare @transactionCount int = @@trancount

    begin try
        if @transactionCount = 0 begin transaction

        ;with preparedChanges as
        (
            select
                ProductId,
                UnitName,
                Quantity
            from
                Stock.PreparedChanges(@BatchId)
        )
        ,summedPreparedChanges as
        (
            select
                ProductId,
                UnitName,
                sum(Quantity) as Quantity
            from
                preparedChanges
            group by
                ProductId,
                UnitName
        )
        merge Stock.Item stock
        using summedPreparedChanges source
        on (stock.ProductId = source.ProductId)
        when matched then
            update
            set
                Quantity = stock.Quantity + source.Quantity
        when not matched then
            insert (
                ProductId,
                Quantity,
                UnitName)
            values (
                source.ProductId,
                source.Quantity,
                source.UnitName);				

        -- Delete empties.
        delete Stock.Item
        where
            Quantity = 0

        -- Update the commited values.
        update Stock.ChangeBatch
        set
            CommittedToStock = isnull(@CommittedToStock, getdate()),
            CommittedToStockBy = @CommittedToStockBy
        where
            Id = @BatchId
        
        if @transactionCount = 0 commit transaction
    end try
    begin catch
        if @transactionCount = 0 and xact_state() <> 0
        begin
            rollback transaction
        end

        -- Now re-raise the error.
        declare @errorState int = error_state()

        declare @message varchar(max) =
            'Error ' + cast(error_number() as varchar)
                + ' in procedure ' + error_procedure() + ' - ' + error_message()

        raiserror(@message, 16, @errorState)
    end catch
end
GO

print 'Procedure "Stock.CommitBatch" was created.'
GO