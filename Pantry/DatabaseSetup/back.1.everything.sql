set nocount on
GO

if not exists (select 1 from sys.schemas where name = 'Stock')
begin
    print 'Schema "Stock" does not exist to drop.'
end
else
begin
    drop schema Stock

    print 'Schema "Stock" was dropped.'
end
GO

if not exists (select 1 from sys.schemas where name = 'Common')
begin
    print 'Schema "Common" does not exist to drop.'
end
else
begin
    drop schema Common

    print 'Schema "Common" was dropped.'
end
GO

if not exists (select 1 from sys.schemas where name = 'Access')
begin

    print 'Schema "Access" does not exist to drop.'
end
else
begin
    drop schema Access

    print 'Schema "Access" already exists.'
end
GO

use master

if exists (select 1 from sys.databases where name = 'Pantry')
begin
    drop database Pantry

    print 'Database "Pantry" was dropped.'
end
else
begin
    print 'Database "Pantry" does not exist to drop.'
end

if not exists (select 1 from sys.tables where object_id = object_id('Common.Unit'))
begin	
    print 'Table "Common.Unit" does not exist to drop.'
end
else
begin
    drop table Common.Unit

    print 'Table "Common.Unit" was dropped.'
end
GO

if exists (select 1 from sys.procedures where object_id = object_id('Common.GetUnits'))
begin
    drop procedure Common.GetUnits

    print 'Procedure "Common.GetUnits" was dropped.'
end
else
begin
    print 'Procedure "Common.GetUnits" does not exist to drop.'
end

if not exists (select 1 from sys.tables where object_id = object_id('Stock.ChangeBatch'))
begin	
    print 'Table "Stock.ChangeBatch" does not exist to drop.'
end
else
begin
    drop table Stock.ChangeBatch

    print 'Table "Stock.ChangeBatch" was dropped.'
end
GO

if exists (select 1 from sys.procedures where object_id = object_id('Stock.CreateChangeBatch'))
begin
    drop procedure Stock.CreateChangeBatch

    print 'Procedure "Stock.CreateChangeBatch" was dropped.'
end
else
begin
    print 'Procedure "Stock.CreateChangeBatch" does not exist to drop.'
end
