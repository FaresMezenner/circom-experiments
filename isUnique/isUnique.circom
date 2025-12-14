
include "circomlib/comparators.circom";

template ForceNotEquale() {
    signal input in[2];

    signal eq <== IsEqual()([in[0], in[1]]);
    eq === 0;

}

template IsUnique(n) {
    signal input in[n];

    assert(n>=0);
    

    component fne[n*(n-1)/2];

    var index = 0;
    for (var i = 0; i<n; i++) {
        for (var j=i+1; j<n; j++){
            fne[index] = ForceNotEquale();
            fne[index].in[0] <== in[i];
            fne[index].in[1] <== in[j];
            index++;
        }
    }

    
        
    

    



}


component main = IsUnique(8);


/* INPUT = {
  "in": [6, 5, 1, 8, 9, 12, 12423, 5345]
} */