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

-- This will essentially be a read-only lookup table.  Choosing a PK is really 
-- tough, here, because:
-- A) We'll be joining by ID.
-- B) We'll be searching primarily by the unique name.
     
-- As powerful as a name PK would be be, joining is going to ultimately be more 
-- important.  We'll add some indexes later.
if not exists (select 1 from sys.tables
    where object_id = object_id('Stock.Product'))
begin
    create table Stock.Product
    (
        Id int identity primary key,
        Name varchar(120) not null,
        StandardUnitName varchar(50) not null
            constraint fk_StockProduct_CommonUnit_StandardUnitName
            references Common.Unit (Name)
            -- It must be a standard unit.
            constraint chk_StockProduct_StandardUnitName_ea_oz_mg
            check (StandardUnitName in ('ea', 'oz', 'g')),
        PopularUnitName varchar(50) not null
            constraint fk_StockProduct_CommonUnit_PopularUnitName
            references Common.Unit (Name),
        Created datetime not null,
        CreatedBy int not null
            constraint fk_StockProduct_AccessPantryUser
            references Access.PantryUser (Id)
    )

    -- Name and unit must be unique.
    alter table Stock.Product
    add constraint uq_StockProduct_NameStandardUnitName
    unique (Name, StandardUnitName)

    print 'Table "Stock.Product" was created.'
end
else
begin
    print 'Table "Stock.Product" already exists.'
end
GO

-- Our stock change event table.
-- Note that products are not unique within batches.  This is nice,
-- because if somebody bought four cans of beans, they can enter 
-- them four times, and it'll continue to look that way in the 
-- history.
if not exists (select 1 from sys.tables where object_id = object_id('Stock.Change'))
begin
    create table Stock.Change
    (
        Id int identity primary key,
        BatchId int not null
            constraint fk_StockChange_StockChangeBatch
            references Stock.ChangeBatch (Id),
        ProductId int not null
            constraint fk_StockChange_StockProduct
            references Stock.Product (Id),
        UnitName varchar(50) not null
            constraint fk_StockChange_CommonUnit
            references Common.Unit (Name),
        Quantity decimal(15,3) not null,
        Note varchar(500) null
    )

    print 'Table "Stock.Change" was created.'
end
else
begin
    print 'Table "Stock.Change" already exists.'
end
GO

-- Stock table itself.  This will be essentially read-only, updated
-- only by commiting changes.
-- Note that units must be one of our base unit types: ea, oz, or g.
-- (The change commit process will take care of "normalizing" them
-- in this way.)  Also, quantities must always be positive.
if not exists (select 1 from sys.tables where object_id = object_id('Stock.Item'))
begin
    create table Stock.Item
    (
        ProductId int not null primary key
            references Stock.Product (Id),
        UnitName varchar(50) not null 
            references Common.Unit (Name)
            constraint chk_StockItem_UnitName_ea_oz_mg
            check (UnitName in ('ea', 'oz', 'g')),
        Quantity decimal(15,3) not null
            constraint chk_StockItem_Quantity_Positive
            check (Quantity >= 0)
    )

    print 'Table "Stock.Item" was created.'
end
else
begin
    print 'Table "Stock.Item" already exists.'
end
GO
