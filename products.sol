// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

struct Product{
    uint setupFee;
    uint monthlyFee;
    uint duration;
}

contract Products{ 

    mapping (uint => Product) products;

    function createProduct(uint _setupFee, uint _monthlyFee, uint _duration, uint productId)public{
        products[productId].setupFee = _setupFee;
        products[productId].monthlyFee = _monthlyFee;
        products[productId].duration = _duration;
    }

    function getSetupFee(uint id)public view returns (uint){
        return products[id].setupFee;    
    }
    function getMonthly(uint id)public view returns (uint){
        return products[id].monthlyFee;
    }
    function getDuration(uint id)public view returns (uint){
        return products[id].duration;
    }

}