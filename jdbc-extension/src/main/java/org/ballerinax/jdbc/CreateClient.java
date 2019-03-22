/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.ballerinax.jdbc;

import org.ballerinalang.bre.Context;
import org.ballerinalang.bre.bvm.BlockingNativeCallableUnit;
import org.ballerinalang.database.sql.Constants;
import org.ballerinalang.database.sql.SQLDatasourceUtils;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BRefType;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaFunction;

import java.util.UUID;

/**
 * Returns the JDBC Client connector.
 *
 * @since 0.970
 */

@BallerinaFunction(
        orgName = "ballerinax", packageName = "jdbc:0.0.0",
        functionName = "createClient",
        args = {@Argument(name = "config", type = TypeKind.RECORD, structType = "ClientEndpointConfig"),
                @Argument(name = "globalPoolOptions", type = TypeKind.RECORD, structType = "PoolOptions")},
        isPublic = true
)
public class CreateClient extends BlockingNativeCallableUnit {

    @Override
    public void execute(Context context) {
        BMap<String, BValue> clientEndpointConfig = (BMap<String, BValue>) context.getRefArgument(0);
        BMap<String, BRefType> globalPoolOptions = (BMap<String, BRefType>) context.getRefArgument(1);
        BMap<String, BValue> sqlClient = SQLDatasourceUtils
                .createSQLDBClient(context, clientEndpointConfig, globalPoolOptions);
        sqlClient.addNativeData(Constants.CONNECTOR_ID_KEY, UUID.randomUUID().toString());
        context.setReturnValues(sqlClient);
    }
}
