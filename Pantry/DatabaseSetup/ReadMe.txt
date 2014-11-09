The "forward" script files contained in this folder, when run without 
alteration* and in order designated by their names (i.e. forward.3.tables.sql
should be the third script that you run) will set up the Pantry database for 
use.  If you want to rollback the changes, just use "back.1.everything.sql."

* A lie!  The first script, forward.1.database.sql, does require a little 
alteration, depending on the location of of SQL Server database that you want 
to use:
-If you want to put in in a local "service-based" database, you will need to 
 specify the path to that MDF file.
-If your database is on an actual SQL Server instance, you will need to comment
 out the ALTER statement for the MDF, and un-comment the IF/ELSE blocks that
 follow "For SQL Server DB."