// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/sql;
import ballerinax/jdbc;

sql:PoolOptions properties = { maximumPoolSize: 1,
    idleTimeout: 600000, connectionTimeout: 30000, autoCommit: true, maxLifetime: 1800000,
    minimumIdle: 1, validationTimeout: 5000,
    connectionInitSql: "SELECT 1 FROM INFORMATION_SCHEMA.SYSTEM_USERS" };

map propertiesMap = { "loginTimeout": 109 };
sql:PoolOptions properties3 = { dataSourceClassName: "org.hsqldb.jdbc.JDBCDataSource" };

map propertiesMap2 = { "loginTimeout": 109 };
sql:PoolOptions properties4 = { dataSourceClassName: "org.hsqldb.jdbc.JDBCDataSource" };

sql:PoolOptions properties5 = { dataSourceClassName: "org.hsqldb.jdbc.JDBCDataSource" };

map propertiesMap3 = { "url": "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT" };
sql:PoolOptions properties6 = { dataSourceClassName: "org.hsqldb.jdbc.JDBCDataSource" };

function testConnectionPoolProperties1() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectionPoolProperties2() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: properties
    };


    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectionPoolProperties3() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA"
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}


function testConnectorWithDefaultPropertiesForListedDB() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: {}
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectorWithWorkers() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: {}
    };

    worker w1 {
        int x = 0;
        json y;

        var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

        json j = getJsonConversionResult(dt);
        testDB.stop();
        return j;
    }
    worker w2 {
        int x = 10;
    }
}

function testConnectorWithDataSourceClass() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        poolOptions: properties3,
        dbOptions: propertiesMap
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassAndProps() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties4,
        dbOptions: propertiesMap2
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassWithoutURL() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties5
    };


    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectorWithDataSourceClassURLPriority() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: properties6,
        dbOptions: propertiesMap3
    };


    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}


function testPropertiesGetUsedOnlyIfDataSourceGiven() returns (json) {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/TEST_SQL_CONNECTOR_INIT",
        username: "SA",
        password: "",
        poolOptions: { maximumPoolSize: 1 },
        dbOptions: { "invalidProperty": 109 }
    };

    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ());

    json j = getJsonConversionResult(dt);
    testDB.stop();
    return j;
}

function testConnectionFailure() {
    endpoint jdbc:Client testDB {
        url: "jdbc:hsqldb:file:./target/tempdb/NON_EXISTING_DB",
        username: "SA",
        password: "",
        poolOptions: { maximumPoolSize: 1 },
        dbOptions: { "ifexists": true }
    };

}

function getJsonConversionResult(table|error tableOrError) returns json {
    json retVal = {};
    if (tableOrError is table) {
        var jsonConversionResult = <json>tableOrError;
        if (jsonConversionResult is json) {
            retVal = jsonConversionResult;
        } else if (jsonConversionResult is error) {
            retVal = {"Error" : <string>jsonConversionResult.detail().message};
        }
    } else if (tableOrError is error) {
        retVal = {"Error" : <string>tableOrError.detail().message};
    }
    return retVal;
}

