package a.b;

public function Fn1() returns (function (int, int) (int)) {
    return privateFunc1;
}

public function Fn2() returns (function (int, int) (int)) {
    return function (int a, int b) returns (int) {
                return a + b;
           };
}

function privateFunc1 (int a, int b) returns (int) {
    return a + b;
}
