# Object Relational Mapping \(ORM\) Database<a name="EN-US_TOPIC_0000001172200433"></a>

### Introduction<a name="section103mcpsimp"></a>

This sample uses annotations and inheritance to create databases and tables, allowing for database upgrade, backup, deletion, and restoration, table adding, deletion, modification, and query, and listening for data changes.

1.  An ORM database is annotated by  **@Database**  and inherited from  **OrmDatabase**.
2.  A table in the ORM database is annotated by  **@Entity**  and inherited from  **OrmObject**.
3.  **OrmContext**  is used to upgrade, back up, delete and restore the database, add, delete, modify, and query tables, and listen for data changes.

### Usage<a name="section105mcpsimp"></a>

1.  Click  **Insert**  to insert data, click  **Update**  to update data, click  **Delete**  to delete data, and click  **Query**  to query data and view the query result.
2.  Click  **Upgrade**  to upgrade the database from version 1 to version 2 and then to version 3.
3.  Click  **Backup**  to back up the database, click  **DeleteDB**  to delete the database, and click  **Restore**  to restore the database.

### Constraints<a name="section111mcpsimp"></a>

This sample can only be run on standard-system devices.

