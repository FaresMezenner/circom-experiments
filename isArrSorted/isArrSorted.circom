include "../node_modules/circomlib/circuits/comparators.circom";

template IsArrSorted(n) {
    signal input in[n];

    component let[n-1];

    for (var i=0; i<n-1; i++) {
        let[i] =LessThan(252);

        let[i].in[0] <== in[i+1];
        let[i].in[1] <== in[i];
        let[i].out === 0;
    }




}


component main = IsArrSorted(8);

/*
INPUT = {
    "in": [1, 5, 6, 8, 9, 12, 5345, 12423 ]
}
*/