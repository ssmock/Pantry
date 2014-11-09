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