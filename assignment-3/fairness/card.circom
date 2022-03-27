pragma circom 2.0.0;

include "./mimcsponge.circom";
include "./circomlib/circuits/comparators.circom";

template card() {
    // 3-tuple + salt inputs correspoinding to deck of card
    signal input number;
    signal input suite;
    signal input salt;
    signal input first_card_hash;
    signal input second_card_hash;
    signal inter_hash;
    signal output calculate_hash;

    // calculate hash of card tuple {number, suit}
    component calcHash = mimc_hash(2);
    number ==> calcHash.number;
    suite ==> calcHash.suite;
    inter_hash <== calcHash.hash;

    // salt the hash
    component salting = mimc_hash(2);
    inter_hash ==> salting.number;
    salt ==> salting.suite;
    calculate_hash <== salting.hash;

    // check whether the two cards are the same
    signal equal_val;
    component equal = IsEqual();
    first_card_hash ==> equal.in[0];
    second_card_hash ==> equal.in[1];
    equal_val <== 1 - equal.out;
    equal_val === 1;

    // check whether cards have the same suite
    signal old_hash[13];
    signal new_hash[13]; 
    component check_suite_old[13];
    component check_suite_new[13];

    var temp[13] = [0,1,2,3,4,5,6,7,8,9,10,11,12];

    for (var i = 0; i < 13; i++) {
        check_suite_old[i] = mimc_hash(2);
        temp[i] ==> check_suite_old[i].number;
        suite ==> check_suite_old[i].suite;
        old_hash[i] <== check_suite_old[i].hash;

        check_suite_new[i] = mimc_hash(2);
        old_hash[i] ==> check_suite_new[i].number;
        salt ==> check_suite_new[i].suite;
        new_hash[i] <== check_suite_new[i].hash;
    }

    // if hashes match, then proof is valid
    var equal_val_new = 0;
    component new_equal[13];
    for (var i = 0; i < 13; i++) {
        new_equal[i] = IsEqual();
        calculate_hash ==> new_equal[i].in[0];
        new_hash[i] ==> new_equal[i].in[1];
        
        equal_val_new += new_equal[i].out;
    }
    equal_val_new === 1;
}

template mimc_hash(n) {
    signal input number;
    signal input suite;
    signal output hash;

    component hasher = MiMCSponge(2, 220, 1);
    number ==> hasher.ins[0];
    suite ==> hasher.ins[1];
    hasher.k <== 0;
    hash <== hasher.outs[0];
}

component main = card();