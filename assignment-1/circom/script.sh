#!/bin/bash

# compile circuit
circom merkle.circom --r1cs --wasm --sym --c

# compute the witness
node merkle_js/generate_witness.js merkle_js/merkle.wasm input.json witness.wtns

# start Powers of Tau ceremony (Trusted Ceremony)
snarkjs powersoftau new bn128 14 pot12_0000.ptau -v

# contribute to ceremony by adding entropy
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# generate proving and verification keys
snarkjs groth16 setup merkle.r1cs pot12_final.ptau merkle_0000.zkey

# contribute to phase 2 of ceremony (circuit specific)
snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v

# export verification key
snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json

# generating a proof
snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json

# verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json


