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

function twoDimensionArrayDeclaration() {
    string[2][2] x1 = [["1", "2"], ["3", "4"]];
    string[2][2] x2 = [["1", "2"], ["3", "4"], ["4", "5"]];
    string[2][2] x3 = [["1", "2"], ["3", "4", "5"]];
    string[2][2] x4 = [["1", "2", "3"], ["3", "4"]];
}

function threeDimensionArrayDeclarationAndAccess() {
    sealed int[][][] x1 = [[[1, 2, 3], [4, 5, 6], [7, 8, 9]], [[1, 2, 3], [4, 5, 6], [7, 8, 9]]];
    int[][] x2 = x1[1];
    int[][] x3 = x1[2];
    int[] x4 = x1[1][2];
    int[] x5 = x1[1][3]; // only 1st dimension is sealed
    int x6 = x1[1][2][2];
    int x7 = x1[1][2][3]; // only 1st dimension is sealed
}

function threeDimensionArrayValueAssigning(){
    int[3][2][3] x1;
    x1[2][1][2] = 1;
    x1[3][1][2] = 1;
    x1[2][3][1] = 1;
    x1[2][1][3] = 1;
    x1[2][1] = [1, 2, 3, 4];
    x1[2] = [1, 2];
    x1[2] = [[1, 2, 3], [3, 4, 5, 6]];
}

function arrayAssignments() {
    int[] x1;
    int[2][3] x2 = [x1, x1];
    int[3] x3;
    int[2][3] x4 = [x3, x3];
    int[2][] x5 = [x1, x1];
    x5[1][4] = 12;
    x4[1][4] = 12;

}


