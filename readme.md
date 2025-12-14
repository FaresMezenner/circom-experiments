# README — Working with .circom files (This file is AI generated)

## Prerequisites

- Node.js (>=14) and npm
- circom (install globally or use Docker)
  - npm: `npm install -g circom`
  - Docker: `docker run -it --rm -v $(pwd):/snark -w /snark circom/circom:latest`
- snarkjs (for witness/proof/verify): `npm install -g snarkjs`
- Optional: a trusted setup "ptau" file (downloadable from snarkjs demos) for Groth16/PLONK setups.

## Typical workflow

1. Compile circuit

   - `circom circuit.circom --r1cs --wasm --sym -o build`
   - Produces `build/circuit.r1cs`, `build/circuit_js/circuit.wasm`, `build/circuit_js/generate_witness.js`, `.sym`.
2. Prepare input

   - Create `input.json` with public/private input signals (keys match circuit input names).
   - Example:
     {
     "a": "3",
     "b": "11"
     }
3. Generate witness

   - `node build/circuit_js/generate_witness.js build/circuit_js/circuit.wasm input.json witness.wtns`
4. Setup (trusted setup / zkey)

   - Groth16 example:
     - `snarkjs groth16 setup build/circuit.r1cs pot12_final.ptau build/circuit_0000.zkey`
     - `snarkjs zkey contribute build/circuit_0000.zkey build/circuit_final.zkey --name="contrib"`
     - `snarkjs zkey export verificationkey build/circuit_final.zkey verification_key.json`
   - PLONK example:
     - `snarkjs plonk setup build/circuit.r1cs pot12_final.ptau build/circuit_final.zkey`
     - `snarkjs zkey export verificationkey build/circuit_final.zkey verification_key.json` (if needed)
5. Prove

   - Groth16:
     - `snarkjs groth16 prove build/circuit_final.zkey witness.wtns proof.json public.json`
   - PLONK:
     - `snarkjs plonk prove build/circuit_final.zkey witness.wtns proof.json public.json`
6. Verify

   - Groth16:
     - `snarkjs groth16 verify verification_key.json public.json proof.json`
   - PLONK:
     - `snarkjs plonk verify verification_key.json public.json proof.json`

## Common files produced

- `*.r1cs` — R1CS constraint system
- `*_js/circuit.wasm` — WASM for witness generation
- `*_js/generate_witness.js` — witness generator
- `witness.wtns` — witness file
- `*.zkey` — proving key (after setup)
- `proof.json`, `public.json`, `verification_key.json` — proof artifacts

## Tips

- Inputs must match circuit input names exactly.
- Use circomlib for common building blocks (include in .circom).
- For CI or reproducible builds, prefer Docker image.
- For debugging compile errors, add `--debug` or inspect `.sym` and the `.r1cs` info (`snarkjs r1cs info build/circuit.r1cs`).

License: adapt to project needs.
