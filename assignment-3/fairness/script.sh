#!/bin/bash

# compile circuit
circom card.circom --r1cs --wasm --sym --c

# compute the witness
node card_js/generate_witness.js card_js/card.wasm input.json witness.wtns

# start Powers of Tau ceremony (Trusted Ceremony)
snarkjs powersoftau new bn128 15 pot12_0000.ptau -v

# contribute to ceremony by adding entropy
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

# generate proving and verification keys
snarkjs groth16 setup card.r1cs pot12_final.ptau card_0000.zkey

# contribute to phase 2 of ceremony (circuit specific)
snarkjs zkey contribute card_0000.zkey card_0001.zkey --name="1st Contributor Name" -v

# export verification key
snarkjs zkey export verificationkey card_0001.zkey verification_key.json

# generating a proof
snarkjs groth16 prove card_0001.zkey witness.wtns proof.json public.json

# verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json


