const Kombucha = artifacts.require('Kombucha')
const KombuchaFactory = artifacts.require("KombuchaFactory")

module.exports = function(deployer) {
    deployer.deploy(KombuchaFactory, Kombucha.address);
}
