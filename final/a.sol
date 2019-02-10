pragma solidity ^0.5.0;

contract PercentageToken{

    // Pay the 1% to this address
    address payable target = 0x158de12EE547EAe06Cbdb200A017aCa6B75D230D;

    // necessary variables for your token
    mapping (address => uint) public balanceOf;
    uint public totalSupply;

    // create a token with a specified supply and assign all the tokens to the creator
    constructor(uint _totalSupply) public {
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = totalSupply;
    }

    // your standard token transfer function with the addition of the share that
    // goes to your target address
    function transfer(address _to, uint amount) public {

        // calculate the share for your target address
        uint shareForX = amount/100;

        // store the previous balance of the sender for later assertion
        // (check that all works as intended)
        uint senderBalance = balanceOf[msg.sender];
        // check the sender actually has enough tokens to send
        require(senderBalance >= amount);
        // reduce sender balance first to avoid that the sender sends more than
        // he owns by submitting multiple transactions.
        balanceOf[msg.sender] -= amount;
        // store the previous balance of the receiver for later assertion
        // (check that all works as intended)
        uint receiverBalance = balanceOf[_to];

        // add the amount of tokens to the receiver but deduce the share for your
        // target address
        balanceOf[_to] += amount-shareForX;
        // add the share to your target address
        balanceOf[target] += shareForX;

        // check that everything works as intended, specifically checking that
        // the sum of tokens in all reladed accounts is the same before and after
        // the transaction. 
        assert(balanceOf[msg.sender] + balanceOf[_to] + shareForX ==
            senderBalance + receiverBalance);
    }
}
contract SmartArt is PercentageToken{
    address customer;
    constructor () public
    {
        customer = msg.sender;
    }
    struct Picture {
        uint picId;
        address author;
        uint price;
    }
    struct License {
        address customer;
        uint picId;
    }
    event Transfer(address from, address to, uint value);
    Picture[] private pictures;
    License[] private lises;
    mapping (uint => Picture)  idToPicture;
    mapping (address => uint256) balances;
    bool succes= false;
    
    function IdPicMatch() private
    {
        idToPicture[123456789] = Picture(123456789, 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 100 );
    }
    uint id = pictures.push(idToPicture[123456789]);

    function buy(uint pictureId, address customer) external payable returns(uint){
        require(msg.value == idToPicture[pictureId].price);
        uint idLicense = lises.push(License (customer, pictureId));
        return idLicense;
    }
    
    function payingTheAuthor(uint pictureId) private
    {
        address owner = idToPicture[pictureId].author ;
        //owner.transfer();
    }
    function transferFrom(address from, address to, uint value ) private  returns (bool success) {
        require( from.balance >= value );
        balances[to] += value* 95 /100  ;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    function makeSale(address sellerAddress) public payable {
        uint saleFee = 10;
        // pay seller the ETH
        // fixed point math at 2 decimal places
        uint fee = msg.value;
        uint payout = msg.value ;
        sellerAddress.transfer(payout);
}

}