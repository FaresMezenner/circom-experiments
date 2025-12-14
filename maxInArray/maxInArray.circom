
include "circomlib/comparators.circom";

function findMin(arr, n) {
    var min = -1;
    for (var i = 0; i< n; i++) {
        min = arr[i] < min ? arr[i] : min;
    }

    return min;
}


template MinInArray(n) {
    signal input arr[n];
    signal output min;

    // get min
    min <-- findMin(arr, n);

    component lte[n];
    component eq[n];
    
    // accumalate is equal results, must be at last 1 at the end
    var acc = 0;

    for (var i = 0; i<n; i++) {
        lte[i] = LessEqThan(252);
        eq[i] = IsEqual();

        // constraining that calculated min is indeed smaller (or equal)
        lte[i].in[0] <== min;
        lte[i].in[1] <== arr[i];
        lte[i].out === 1;

        // calculating if this current value equals the min
        eq[i].in[0] <== min;
        eq[i].in[1] <== arr[i];
        acc += eq[i].out;


    }

    // asserting that we found at least one element equal to min
    component isZero = IsZero();
    isZero.in <== acc;
    isZero.out === 0;

    


}

component main = MinInArray(8);

/* INPUT = {
  "in": [6, 5, 1, 8, 9, 12, 12423, 5345]
} */