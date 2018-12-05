## Module overview

This module provides the functionality required to access and manipulate data stored in any type of relational database that is accessible via Java Database Connectivity (JDBC).

### Client

To access a database, you must first create a `client` object. Create a client of the JDBC Client type (i.e., `jdbc:Client`) and provide the necessary connection parameters. This will create a pool of connections to the given database. A sample for creating a JDBC client can be found below.

**NOTE**: Although the JDBC client type supports connecting to any type of relational database that is accessible via JDBC, if you are using a MySQL or H2 database, it is recommended to use clients that are created using the client types specific to them via the relevant Ballerina modules.

### Database operations

Once the client is created, database operations can be executed through that client. This module provides support for creating tables and executing stored procedures. It also supports selecting, inserting, deleting, updating, and batch updating data. Samples for these operations can be found below. Details of the SQL data types and query parameters relevant for these database operations can be found in the documentation for the SQL module.


## Samples

### Creating a client
```ballerina
jdbc:Client testDB = new({
    url: "jdbc:mysql://localhost:3306/testdb",
    username: "root",
    password: "root",
    poolOptions: { maximumPoolSize: 5 },
    dbOptions: { useSSL: false }
});
```
The full list of client properties can be found listed under the `sql:PoolOptions` type, which is located in the `types.bal` file of the SQL module directory.

### Creating tables

This sample creates a table with two columns. One column is of type `int`, and the other is of type `varchar`. The CREATE statement is executed via the `update` remote function of the client.

```ballerina
// Create the ‘Students’ table with fields ‘id’, 'name' and ‘age’.
var returned = testDB->update("CREATE TABLE student(id INT AUTO_INCREMENT, age INT, name VARCHAR(255), PRIMARY KEY (id))");
if (returned is int) {
    io:println("Students table create status in DB: " + returned);
} else if (returned is error) {
    io:println("Students table create failed: " + <string>returned.detail().message);
}
```

### Inserting data

This sample shows three examples of data insertion by executing an INSERT statement using the `update` remote function of the client.

In the first example, query parameter values are passed directly into the query statement of the `update`  remote function:

```ballerina
var returned = testDB->update("INSERT INTO student(age, name) values (23, 'john')");
if (returned is int) {
    io:println("Inserted row count to Students table: " + returned);
} else if (returned is error) {
    io:println("Insert to Students table failed: " + <string>returned.detail().message);
}
```

In the second example, the parameter values, which are in local variables, are passed directly as parameters to the `update` remote function. This direct parameter passing can be done for any primitive Ballerina type like string, int, float, or boolean. The sql type of the parameter is derived from the type of the Ballerina variable that is passed in.

```ballerina
string name = "Anne";
int age = 8;
var returned = testDB->update("INSERT INTO student(age, name) values (?, ?)", age, name);
if (returned is int) {
    io:println("Inserted row count to Students table: " + returned);
} else if (returned is error) {
    io:println("Insert to Students table failed: " + <string>returned.detail().message);
}
```

In the third example, parameter values are passed as an `sql:Parameter` to the `update` remote function. Use `sql:Parameter` when you need to provide more details such as the exact SQL type of the parameter, or the parameter direction. The default parameter direction is "IN". For more details on parameters, see the `sql` module.

```ballerina
sql:Parameter p1 = { sqlType: sql:TYPE_VARCHAR, value: "James" };
sql:Parameter p2 = { sqlType: sql:TYPE_INTEGER, value: 10 };
var returned = testDB->update("INSERT INTO student(age, name) values (?, ?)", p1, p2);
if (returned is int) {
    io:println("Inserted row count to Students table: " + returned);
} else if (returned is error) {
    io:println("Insert to Students table failed: " + <string>returned.detail().message);
}
```

### Inserting data with auto-generated keys

This example demonstrates inserting data while returning the auto-generated keys. It achieves this by using the `updateWithGeneratedKeys` remote function to execute the INSERT statement.

```ballerina
int age = 31;
string name = "Kate";
var retWithKey = testDB->updateWithGeneratedKeys("INSERT INTO student (age, name) values (?, ?)", (), age, name);
if (retWithKey is (int, string[])) {
    var (count, ids) = retWithKey;
    io:println("Inserted row count: " + count);
    io:println("Generated key: " + ids[0]);
} else if (retWithKey is error) {
    io:println("Insert to table failed: " + <string>retWithKey.detail().message);
}
```

### Selecting data

This example demonstrates selecting data. First, a type is created to represent the returned result set. Next, the SELECT query is executed via the `select` remote function of the client by passing that result set type. Once the query is executed, each data record can be retrieved by looping the result set. The table returned by the select operation holds a pointer to the actual data in the database and it loads data from the table only when it is accessed. This table can be iterated only once.

```ballerina
// Define a type to represent the results set.
type Student record {
    int id;
    string name;
    int age;
};

// Select the data from the table.
var selectRet = testDB->select("SELECT * FROM student", Student);
if (selectRet is table<Student>) {
    // Iterating returned table.
    foreach var row in selectRet {
        io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
    }
} else if (selectRet is error) {
    io:println("Select data from student table failed: " + <string>selectRet.detail().message);
}
```

To re-iterate the same table multiple times, set the `loadToMemory` argument to true within the `select` remote function.

```ballerina
var selectRet = testDB->select("SELECT * FROM student", Student, loadToMemory = true);
if (selectRet is table<Student>) {
    // Iterating data first time.
    foreach var row in selectRet {
        io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
    }
    // Iterating data second time.
    foreach var row in selectRet {
        io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
    }
} else if (selectRet is error) {
    io:println("Select data from student table failed: " + <string>selectRet.detail().message);
}
````

### Updating data

This example demonstrates modifying data by executing an UPDATE statement via the `update` remote function of the client
```ballerina
var returned = testDB->update("UPDATE student SET name = 'Jones' WHERE age = ?", 23);
if (returned is int) {
    io:println("Updated row count in Students table: " + returned);
} else if (returned is error) {
    io:println("Update in Students table failed: " + <string>returned.detail().message);
}
```

### Batch updating data

This example demonstrates how to insert multiple records with a single INSERT statement that is executed via the `batchUpdate` remote function of the client. This is done by first creating multiple parameter arrays, each representing a single record, and then passing those arrays to the `batchUpdate` operation. Similarly, multiple UPDATE statements can also be executed via `batchUpdate`.

```ballerina
// Create the first batch of parameters.
sql:Parameter para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
sql:Parameter para2 = { sqlType: sql:TYPE_INTEGER, value: 12 };
sql:Parameter[] parameters1 = [para1, para2];

// Create the second batch of parameters.
sql:Parameter para3 = { sqlType: sql:TYPE_VARCHAR, value: "Peter" };
sql:Parameter para4 = { sqlType: sql:TYPE_INTEGER, value: 6 };
sql:Parameter[] parameters2 = [para3, para4];

// Do the batch update by passing the batches.
var retBatch = testDB->batchUpdate("INSERT INTO Students(name, age) values (?, ?)", parameters1, parameters2);
if (retBatch is int[]) {
    io:println("Batch item 1 update count: " + retBatch[0]);
    io:println("Batch item 2 update count: " + retBatch[1]);
} else if (retBatch is error) {
    io:println("Batch update operation failed: " + <string>retBatch.detail().message);
}
```

### Calling stored procedures

The following examples demonstrate executing stored procedures via the `call` remote function of the client.

The first example shows how to create and call a simple stored procedure that inserts data.
```ballerina
// Create the stored procedure.
var returned = testDB->update("CREATE PROCEDURE INSERTDATA (IN pName VARCHAR(255), IN pAge INT)
                           BEGIN
                              INSERT INTO Students(name, age) values (pName, pAge);
                           END");
if (returned is int) {
    io:println("Stored proc creation status: " + returned);
} else if (returned is error) {
    io:println("Stored procedure creation failed: " + <string>returned.detail().message);
}

// Call the stored procedure.
var retCall = testDB->call("{CALL INSERTDATA(?,?)}", (), "George", 15);
if (retCall is ()|table<record {}>[]) {
    io:println("Call operation successful");
} else if (retCall is error) {
    io:println("Stored procedure call failed: " + <string>retCall.detail().message);
}
```
This next example shows how to create and call a stored procedure that accepts `INOUT` and `OUT` parameters.

```ballerina
// Create the stored procedure.
var returned = testDB->update("CREATE PROCEDURE GETCOUNT (INOUT pID INT, OUT pCount INT)
                           BEGIN
                                SELECT COUNT(*) INTO pID FROM Students WHERE id = pID;
                                SELECT COUNT(*) INTO pCount FROM Students WHERE id = 2;
                           END");
if (returned is int) {
    io:println("Stored proc creation status: " + returned);
} else if (returned is error) {
    io:println("Stored procedure creation failed: " + <string>returned.detail().message);
}

// Call the stored procedure.
sql:Parameter param1 = { sqlType: sql:TYPE_INTEGER, value: 3, direction: sql:DIRECTION_INOUT };
sql:Parameter param2 = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT };
var retCall = testDB->call("{CALL GETCOUNT(?,?)}", (), param1, param2);
if (retCall is ()|table<record {}>[]) {
    io:println("Call operation successful");
    io:print("Student count with ID = 3: ");
    io:println(param1.value);
    io:print("Student count with ID = 2: ");
    io:println(param2.value);
} else if (retCall is error) {
    io:println("Stored procedure call failed: " + <string>retCall.detail().message);
}
```