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

documentation {
    Represents the properties which are used to configure DB connection pool.

    F{{connectionInitSql}} - SQL statement that will be executed after every new connection creation before adding it to the pool.
    F{{dataSourceClassName}} - Name of the DataSource class provided by the JDBC driver.
    F{{autoCommit}} - Auto-commit behavior of connections returned from the pool.
    F{{isXA}} - Whether Connections are used for a distributed transaction.
    F{{maximumPoolSize}} - Maximum size that the pool is allowed to reach, including both idle and in-use connections.
    F{{connectionTimeout}} - Maximum number of milliseconds that a client will wait for a connection from the pool.
    F{{idleTimeout}} - Maximum amount of time that a connection is allowed to sit idle in the pool.
    F{{minimumIdle}} - Minimum number of idle connections that pool tries to maintain in the pool.
    F{{maxLifetime}} - Maximum lifetime of a connection in the pool.
    F{{validationTimeout}} - Maximum amount of time that a connection will be tested for aliveness.
}
public type PoolOptions {
    string connectionInitSql,
    string dataSourceClassName,
    boolean autoCommit = true,
    boolean isXA = false,
    int maximumPoolSize = -1,
    int connectionTimeout = -1,
    int idleTimeout = -1,
    int minimumIdle = -1,
    int maxLifetime = -1,
    int validationTimeout = -1,
};

documentation {
    The SQL Datatype of the parameter.

    VARCHAR - Small, variable-length character string.
    CHAR - Small, fixed-length character string.
    LONGVARCHAR - Large, variable-length character string.
    NCHAR - Small, fixed-length character string with unicode support.
    LONGNVARCHAR - Large, variable-length character string with unicode support.

    BIT - Single bit value that can be zero or one, or nil.
    BOOLEAN - Boolean value either True or false.
    TINYINT - 8-bit integer value which may be unsigned or signed.
    SMALLINT - 16-bit signed integer value which may be unsigned or signed.
    INTEGER - 32-bit signed integer value which may be unsigned or signed.
    BIGINT - 64-bit signed integer value which may be unsigned or signed.

    NUMERIC - Fixed-precision and scaled decimal values.
    DECIMAL - Fixed-precision and scaled decimal values.
    REAL - Single precision floating point number.
    FLOAT - Double precision floating point number.
    DOUBLE - Double precision floating point number.

    BINARY - Small, fixed-length binary value.
    BLOB - Binary Large Object.
    LONGVARBINARY - Large, variable-length binary value.
    VARBINARY - Small, variable-length binary value.

    CLOB - Character Large Object.
    NCLOB - Character large objects in multibyte national character set.

    DATE - Date consisting of day, month, and year.
    TIME - Time consisting of hours, minutes, and seconds.
    DATETIME - Both DATE and TIME with additional a nanosecond field.
    TIMESTAMP - Both DATE and TIME with additional a nanosecond field.

    ARRAY - Composite data value that consists of zero or more elements of a specified data type.
    STRUCT - User defined structured type, consists of one or more attributes.
    REFCURSOR - Cursor value.
}
public type SQLType "VARCHAR"|"CHAR"|"LONGVARCHAR"|"NCHAR"|"LONGNVARCHAR"|"NVARCHAR"|"BIT"|"BOOLEAN"|
"TINYINT"|"SMALLINT"|"INTEGER"|"BIGINT"|"NUMERIC"|"DECIMAL"|"REAL"|"FLOAT"|"DOUBLE"|
"BINARY"|"BLOB"|"LONGVARBINARY"|"VARBINARY"|"CLOB"|"NCLOB"|"DATE"|"TIME"|"DATETIME"|
"TIMESTAMP"|"ARRAY"|"STRUCT"|"REFCURSOR";

@final public SQLType TYPE_VARCHAR = "VARCHAR";
@final public SQLType TYPE_CHAR = "CHAR";
@final public SQLType TYPE_LONGVARCHAR = "LONGVARCHAR";
@final public SQLType TYPE_NCHAR = "NCHAR";
@final public SQLType TYPE_LONGNVARCHAR = "LONGNVARCHAR";
@final public SQLType TYPE_NVARCHARR = "NVARCHAR";
@final public SQLType TYPE_BIT = "BIT";
@final public SQLType TYPE_BOOLEAN = "BOOLEAN";
@final public SQLType TYPE_TINYINT = "TINYINT";
@final public SQLType TYPE_SMALLINT = "SMALLINT";
@final public SQLType TYPE_INTEGER = "INTEGER";
@final public SQLType TYPE_BIGINT = "BIGINT";
@final public SQLType TYPE_NUMERIC = "NUMERIC";
@final public SQLType TYPE_DECIMAL = "DECIMAL";
@final public SQLType TYPE_REAL = "REAL";
@final public SQLType TYPE_FLOAT = "FLOAT";
@final public SQLType TYPE_DOUBLE = "DOUBLE";
@final public SQLType TYPE_BINARY = "BINARY";
@final public SQLType TYPE_BLOB = "BLOB";
@final public SQLType TYPE_LONGVARBINARY = "LONGVARBINARY";
@final public SQLType TYPE_VARBINARY = "VARBINARY";
@final public SQLType TYPE_CLOB = "CLOB";
@final public SQLType TYPE_NCLOB = "NCLOB";
@final public SQLType TYPE_DATE = "DATE";
@final public SQLType TYPE_TIME = "TIME";
@final public SQLType TYPE_DATETIME = "DATETIME";
@final public SQLType TYPE_TIMESTAMP = "TIMESTAMP";
@final public SQLType TYPE_ARRAY = "ARRAY";
@final public SQLType TYPE_STRUCT = "STRUCT";
@final public SQLType TYPE_REFCURSOR = "REFCURSOR";

documentation {
    The direction of the parameter.

    IN - IN parameters are used to send values to stored procedures.
    OUT - OUT parameters are used to get values from stored procedures.
    INOUT - INOUT parameters are used to send values and get values from stored procedures.
}

public type Direction "IN"|"OUT"|"INOUT";

@final public Direction DIRECTION_IN = "IN";
@final public Direction DIRECTION_OUT = "OUT";
@final public Direction DIRECTION_INOUT = "INOUT";

documentation {
    CallParam represents a parameter for the SQL call action where OUT or INOUT parameter is required.

    F{{sqlType}} - The data type of the corresponding SQL parameter.
    F{{value}} - Value of paramter pass into the SQL query.
    F{{direction}} - Direction of the SQL Parameter OUT, or INOUT - Default value is IN.
    F{{recordType}} - In case of OUT direction, if the sqlType is REFCURSOR, this represents the record type to map a result row.
}

public type Parameter {
    SQLType sqlType,
    any value,
    Direction direction,
    typedesc recordType,
};

//public type Param
//(SQLType, any, Direction)|
//(SQLType, any)|
//CallParam|//To used with the SQL out parameters
//any;

public type Param string|int|boolean|float|Parameter;
