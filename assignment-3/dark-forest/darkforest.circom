pragma circom 2.0.0;

include "./circomlib/circuits/comparators.circom";

template darkforest() {
    // private inputs correspoinding to coordinates A,B,C
    signal input Ax;
    signal input Ay;
    signal input Bx;
    signal input By;
    signal input Cx;
    signal input Cy;
    signal input energy;

    // side-lengths of AB, BC, and AC
    signal AB; 
    signal BC; 
    signal AC; 

    // area of triangle must satisfy (area > 0)
    signal area;

    // compute the area
    AB <== Ax * (By - Cy);
    BC <== Bx * (Cy - Ay);
    AC <== Cx * (Ay - By);
    area <== AB + BC + AC;

    // check whether area > 0
    component isZero = IsZero();
    isZero.in <== area;

    signal isTriangle;
    isTriangle <== 1 - isZero.out;
    isTriangle === 1;

    // calculate the side lengths AB, BC, AC using intermediary circuits
    signal diffABx;
    signal diffABy;
    signal diffBCx;
    signal diffBCy;
    signal diffACx;
    signal diffACy;

    signal ABxSquare;
    signal ABySquare;
    signal BCxSquare;
    signal BCySquare;
    signal ACxSquare;
    signal ACySquare;

    signal ABTotal;
    signal BCTotal;
    signal ACTotal;

    diffABx <== Ax - Bx;
    diffABy <== Ay - By;
    diffBCx <== Bx - Cx;
    diffBCy <== By - Cy;
    diffACx <== Ax - Cx;
    diffACy <== Ay - Cy;

    ABxSquare <== (diffABx * diffABx);
    ABySquare <== (diffABy * diffABy);
    BCxSquare <== (diffBCx * diffBCx);
    BCySquare <== (diffBCy * diffBCy);
    ACxSquare <== (diffACx * diffACx);
    ACySquare <== (diffACy * diffACy);

    ABTotal <== ABxSquare + ABySquare;
    BCTotal <== BCxSquare + BCySquare;
    ACTotal <== ACxSquare + ACySquare;

    // assign triangle lengths to arr[]
    signal arr[3];
    signal verify[3]; 
    signal output return_bool;

    arr[0] <== ABTotal;
    arr[1] <== BCTotal;
    arr[2] <== ACTotal;

    // verify whether lengths < energy
    component lessthan[3];
    for (var i = 0; i < 3; i++) {
        lessthan[i] = LessThan(64);
        lessthan[i].in[0] <== arr[i];
        lessthan[i].in[1] <== energy * energy;
        verify[i] <== 1 - lessthan[i].out;
        verify[i] === 0;
    }

    // proof is valid (statisfied all constraints), return true
    return_bool <== 1;
}

component main = darkforest();