pragma solidity ^0.4.19;

contract ProxyData {
    address internal proxied;
}

contract Proxy is ProxyData {
    function Proxy(address _proxied) public {
        proxied = _proxied;
    }

    function () public payable {
        address addr = proxied;
        assembly {
            let freememstart := mload(0x40)
            calldatacopy(freememstart, 0, calldatasize())
            let success := delegatecall(not(0), addr, freememstart, calldatasize(), freememstart, 0)
            returndatacopy(freememstart, 0, returndatasize())
            switch success
            case 0 { revert(freememstart, returndatasize()) }
            default { return(freememstart, returndatasize()) }
        }
    }
}

contract Kombucha {
    event FilledKombucha(uint amountAdded, uint newFillAmount);
    event DrankKombucha(uint amountDrank, uint newFillAmount);
    
    address private masterCopy;
    uint public fillAmount;
    uint public capacity;
    string public flavor;
    
    function Kombucha(string _flavor, uint _fillAmount, uint _capacity) public {
        init(_flavor, _fillAmount, _capacity);
    }
    
    function init(string _flavor, uint _fillAmount, uint _capacity) public {
        require(capacity == 0 && _fillAmount <= _capacity && _capacity > 0);
        flavor = _flavor;
        fillAmount = _fillAmount;
        capacity = _capacity;
    }
    
    function fill(uint amountToAdd) public {
        uint newAmount = fillAmount + amountToAdd;
        require(newAmount > fillAmount && newAmount <= capacity);
        fillAmount = newAmount;
        FilledKombucha(amountToAdd, newAmount);
    }
    
    function drink(uint amountToDrink) public returns (bytes32) {
        uint newAmount = fillAmount - amountToDrink;
        require(newAmount < fillAmount);
        fillAmount = newAmount;
        DrankKombucha(amountToDrink, newAmount);
        return keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
            keccak256(keccak256(keccak256(keccak256(keccak256(
                amountToDrink
            ))))))))))))))))))))))))))))))))))))))))))))))))));
    }
}

contract KombuchaFactory {
    event KombuchaCreation(Kombucha kombucha);

    Kombucha private masterCopy;

    function KombuchaFactory(Kombucha _masterCopy) public {
        masterCopy = _masterCopy;
    }
    
    function createKombucha(string flavor, uint fillAmount, uint capacity)
        public
        returns (Kombucha kombucha)
    {
        kombucha = Kombucha(new Proxy(masterCopy));
        kombucha.init(flavor, fillAmount, capacity);
        KombuchaCreation(kombucha);
    }
}
