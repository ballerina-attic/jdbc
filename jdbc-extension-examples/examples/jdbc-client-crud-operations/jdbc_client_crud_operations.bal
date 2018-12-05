import ballerina/io;
import ballerina/sql;
import ballerinax/jdbc;

// Client for MySQL database. This client can be used with any jdbc
// supported database by providing the corresponding jdbc url.
jdbc:Client testDB = new({
        url: "jdbc:mysql://localhost:3306/testdb",
        username: "test",
        password: "test",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });

// This is the type created to represent data row.
type Student record {
    int id;
    int age;
    string name;
};

public function main() {
    // Creates a table using the update operation. If the DDL
    // statement execution is successful, the `update` operation returns 0.
    io:println("The update operation - Creating a table");
    var ret = testDB->update("CREATE TABLE student(id INT AUTO_INCREMENT,
                         age INT, name VARCHAR(255), PRIMARY KEY (id))");
    handleUpdate(ret, "Create student table");

    // Inserts data to the table using the update operation. If the DML
    // statement execution is successful, the `update` operation returns the
    // updated row count. The query parameters are given in the query
    // statement it self.
    io:println("\nThe update operation - Inserting data to a table");
    ret = testDB->update("INSERT INTO student(age, name) values
                          (23, 'john')");
    handleUpdate(ret, "Insert to student table with no parameters");

    // The query parameters are given as variables for the update operation.
    // Only int, float, boolean, and string values are supported as direct
    // variables.
    int age = 24;
    string name = "Anne";
    ret = testDB->update("INSERT INTO student(age, name) values (?, ?)",
        age, name);
    handleUpdate(ret, "Insert to student table with variable parameters");

    // The query parameters are given as sql:Parameters for the update operation.
    // Default direction is IN.
    sql:Parameter p1 = { sqlType: sql:TYPE_INTEGER, value: 25 };
    sql:Parameter p2 = { sqlType: sql:TYPE_VARCHAR, value: "James" };
    ret = testDB->update("INSERT INTO student(age, name) values (?, ?)",
        p1, p2);
    handleUpdate(ret, "Insert to student table with sql:parameter values");


    // Update data in the table using the update operation.
    io:println("\nThe Update operation - Update data in a table");
    ret = testDB->update("UPDATE student SET name = 'Jones' WHERE age = ?",
        23);
    handleUpdate(ret, "Update a row in student table");

    // Delete data in a table using the update operation.
    io:println("\nThe Update operation - Delete data from table");
    ret = testDB->update("DELETE FROM student WHERE age = ?", 24);
    handleUpdate(ret, "Delete a row from student table");

    // Column values generated during the update can be retrieved using the
    // `updateWithGeneratedKeys` operation. If the table has several auto
    // generated columns other than the auto incremented key, those column
    // names should be given as an array. The values of the auto incremented
    // column and the auto generated columns are returned as a string array.
    // Similar to the `update` operation, the inserted row count is also returned.
    io:println("\nThe updateWithGeneratedKeys operation - Inserting data");
    age = 31;
    name = "Kate";
    var retWithKey = testDB->updateWithGeneratedKeys("INSERT INTO student
                        (age, name) values (?, ?)", (), age, name);
    if (retWithKey is (int, string[])) {
        var (count, ids) = retWithKey;
        io:println("Inserted row count: " + count);
        io:println("Generated key: " + ids[0]);
    } else if (retWithKey is error) {
        io:println("Insert to table failed: " + <string>retWithKey.detail().message);
    }

    // Select data using the `select` operation. The `select` operation returns a table.
    // See the `table` ballerina example for more details on how to access data.
    io:println("\nThe select operation - Select data from a table");
    var selectRet = testDB->select("SELECT * FROM student", Student);
    table<Student> dt;
    if (selectRet is table<Student>) {
        // Conversion from type 'table' to either JSON or XML results in data streaming.
        // When a service client makes a request, the result is streamed to the service
        // client rather than building the full result in the server and returning it.
        // This allows unlimited payload sizes in the result and the response is
        // instantaneous to the client.
        // Convert a table to JSON.
        var jsonConversionRet = json.convert(selectRet);
        if (jsonConversionRet is json) {
            io:print("JSON: ");
            io:println(io:sprintf("%s", jsonConversionRet));
        } else {
            io:println("Error in table to json conversion");
        }
    } else if (selectRet is error) {
        io:println("Select data from student table failed: "
                + <string>selectRet.detail().message);
    }

    // Re-iteration of the result is possible only if `loadToMemory` named argument
    // is set to `true` in `select` operation.
    io:println("\nThe select operation - By loading table to memory");
    selectRet = testDB->select("SELECT * FROM student", Student,
        loadToMemory = true);
    if (selectRet is table<Student>) {
        // Iterating data first time.
        io:println("Iterating data first time:");
        foreach var row in selectRet {
            io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
        }
        // Iterating data second time.
        io:println("Iterating data second time:");
        foreach var row in selectRet {
            io:println("Student:" + row.id + "|" + row.name + "|" + row.age);
        }
    } else if (selectRet is error) {
        io:println("Select data from student table failed: "
                + <string>selectRet.detail().message);
    }
    //Drop the table and procedures.
    io:println("\nThe update operation - Drop the student table");
    ret = testDB->update("DROP TABLE student");
    handleUpdate(ret, "Drop table student");
}

// Function to handle return of the update operation.
function handleUpdate(int|error returned, string message) {
    if (returned is int) {
        io:println(message + " status: " + returned);
    } else if (returned is error) {
        io:println(message + " failed: " + <string>returned.detail().message);
    }
}
