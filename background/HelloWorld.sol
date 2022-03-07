// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract HelloWorld {
    // state variable stored in contract storage
    uint256 public sample_uint;

    // setter function for storing unsigned integer 
    function store(uint256 _uint) public {
        sample_uint = _uint;
    }
}

