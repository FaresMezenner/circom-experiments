include "./node_modules/circomlib/circuits/bitify.circom";

template Main(n) {
  signal input in[n];
  signal input v;

  // instantiate the Bits2Num component
  component b2n = Bits2Num(n);

  // loop over each binary value
  // and assign and constrain it to the
  // b2n input array
  for (var i = 0; i < n; i++) {
    b2n.in[i] <== in[i];
  }

  b2n.out === v;
}

component main = Main(4);

/* INPUT = {"in": [1, 0, 0, 1], "v": 9} */