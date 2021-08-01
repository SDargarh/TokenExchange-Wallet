var ReceiveToken = artifacts.require("./ReceiveToken.sol");

module.exports = function(deployer) {
  deployer.deploy(ReceiveToken);
};
