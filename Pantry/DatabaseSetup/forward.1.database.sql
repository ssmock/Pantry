set nocount on
GO

-- For local databases:
alter database [C:\DEV\PANTRY\API\APP_DATA\<mdf file name>] set trustworthy on

-- For SQL Server DB:
--if not exists (select 1 from sys.databases where name = 'Pantry')
--begin
--	create database Pantry collate Latin1_General_Bin

--	alter database Pantry set trustworthy on

--	print 'Database "Pantry" was created.'
--end
--else
--begin
--	print 'Database "Pantry" already exists.'
--end
--GO

exec sp_configure @configname=clr_enabled, @configvalue=1
GO

reconfigure
GO