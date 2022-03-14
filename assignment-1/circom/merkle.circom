pragma circom 2.0.0;

include "./mimcsponge.circom";

template merkle(n) {
    signal input leaves[n];
    signal output root_hash;

    component computeRoot[n];
    var counter = 0;
    for (var i = 0; i < n; i+=2) {
        computeRoot[counter] = mimc_hash(2);
        leaves[i] ==> computeRoot[counter].leaves[0];
        leaves[i+1] ==> computeRoot[counter].leaves[1];
        counter++;
    }

    component computeRootNew[2];
    var counter_new = 0;
    for (var j = 0; j < n / 2; j+=2) {
        computeRootNew[counter_new] = mimc_hash(2);
        computeRoot[j].hash ==> computeRootNew[counter_new].leaves[0];
        computeRoot[j+1].hash ==> computeRootNew[counter_new].leaves[1];
        counter_new++;
    }

    component computeRootNewNew = mimc_hash(2);
    computeRootNew[0].hash ==> computeRootNewNew.leaves[0];
    computeRootNew[1].hash ==> computeRootNewNew.leaves[1];
    root_hash <== computeRootNewNew.hash;
}

template mimc_hash(n) {
    signal input leaves[n];
    signal output hash;

    component hasher = MiMCSponge(2, 220, 1);
    leaves[0] ==> hasher.ins[0];
    leaves[1] ==> hasher.ins[1];
    hasher.k <== 0;
    hash <== hasher.outs[0];
}

component main = merkle(8);