pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";

function sqrt(n) {

    if (n == 0) {
        return 0;
    }

    // Test that have solution
    var res = n ** ((-1) >> 1);
//        if (res!=1) assert(false, "SQRT does not exists");
    if (res!=1) return 0;

    var m = 28;
    var c = 19103219067921713944291392827692070036145651957329286315305642004821462161904;
    var t = n ** 81540058820840996586704275553141814055101440848469862132140264610111;
    var r = n ** ((81540058820840996586704275553141814055101440848469862132140264610111+1)>>1);
    var sq;
    var i;
    var b;
    var j;

    while ((r != 0)&&(t != 1)) {
        sq = t*t;
        i = 1;
        while (sq!=1) {
            i++;
            sq = sq*sq;
        }

        // b = c ^ m-i-1
        b = c;
        for (j=0; j< m-i-1; j ++) b = b*b;

        m = i;
        c = b*b;
        t = t*c;
        r = r*b;
    }

    if (r < 0 ) {
        r = -r;
    }

    return r;
}


function calculateRoots(a, b, deltaSqrt) {

    var out[2];
    out[0] = (-b + deltaSqrt)/(2*a)
    out[1] = (-b - deltaSqrt)/(2*a)
    
    return out;

}


template SecondDegreeRoots() {
    signal input coef[3];
    signal delta;
    signal deltaSqrt;
    signal output root[2];

    coef[2] !== 0;

    delta <== coef[1]*coef[1] -4*coef[2]*coef[0];

    deltaSqrt <-- sqrt(delta)

    deltaSqrt*deltaSqrt === delta;

    var r = calculateRoots(coef[2], coef[1], deltaSqrt)


    root[0] <== r[0]
    root[1] <== r[1]

    coef[2]*root[0]*root[0] + coef[1]*root[0] + coef[0] === 0;
    coef[2]*root[1]*root[1] + coef[1]*root[1] + coef[0] === 0;

}

component main = SecondDegreeRoots();

/* INPUT = {
  "in": [6, 5, 1]
} */