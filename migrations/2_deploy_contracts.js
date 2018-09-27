const fs = require("fs");
const MobileDevTest = artifacts.require("./MobileDevTest.sol");

var contractAddress ={};

module.exports = function(deployer) {
    deployer.deploy(MobileDevTest)
        .then(() => MobileDevTest.deployed())
        .then(_instance =>{
            contractAddress[MobileDevTest.contractName] = _instance.address;
            fs.writeFileSync('./contractAddress.json', JSON.stringify(contractAddress));
        })
        
};