const Kombucha = artifacts.require('Kombucha')

module.exports = function(deployer) {
    deployer.deploy(Kombucha, "peach", 100, 100)
}
