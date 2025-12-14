
include "circomlib/comparators.circom";

function findMax(arr, n) {
    var max = 0;
    for (var i = 0; i< n; i++) {
        max = arr[i] > max ? arr[i] : max;
    }

    return max;
}


template MaxInArray(n) {
    signal input arr[n];
    signal output max;

    // get max
    max <-- findMax(arr, n);

    component gte[n];
    component eq[n];
    
    // accumalate is equal results, must be at last 1 at the end
    var acc = 0;

    for (var i = 0; i<n; i++) {
        gte[i] = GreaterEqThan(252);
        eq[i] = IsEqual();

        // constraining that calculated max is indeed larger
        gte[i].in[0] <== max;
        gte[i].in[1] <== arr[i];
        gte[i].out === 1;

        // calculating if this current value equals the max
        eq[i].in[0] <== max;
        eq[i].in[1] <== arr[i];
        acc += eq[i].out;


    }

    // asserting that we found at least one element equal to max
    component isZero = IsZero();
    isZero.in <== acc;
    isZero.out === 0;

    


}

component main = MaxInArray(8);

/* INPUT = {
  "in": [6, 5, 1, 8, 9, 12, 12423, 5345]
} */