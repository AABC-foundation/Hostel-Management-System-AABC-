pragma solidity ^0.4.18;

import "./AABC.sol";

contract User {
    event Deposit(address, uint256);
    event SendETH(address, uint256);
    aabc aabc;
    function User(AABC _aabc){
        aabc = _aabc;
    }

    function()
    payable
    external{

    }
    function deposit()
    payable
    public{
        Deposit(msg.sender, msg.value);
    }

    function do_Transfer(address to, uint256 amount)
    external 
    returns(bool){
        return aabc.transfer(to, amount);
    }

    function sendETHtoaabc()
    external
    returns(bool)
    {
        SendETH(address(aabc), this.balance);
        return aabc.send(this.balance);
    }
}

contract Testaabc{
    event CoinCreation(address Wallet);
    event coin(address, uint256);
    event logger(string, string);
    aabc aabc;

    address public addr_1 = 0x5539367F0D1F4Af5081368F7e04050D1d598Fb7B;
    address public addr_2 = 0xf6983cce0d5b050f7ae7d3c7a7bd913a5cedd566;
    
    address[] investorList = [addr_1, addr_2, addr_3];
    address[] nonInvestorList = [addr_4, addr_5];

    function createaabc() 
    public {
        aabc = new aabc();
        CoinCreation(address(aabc));
    }

    function test_turnOnSale()
    public{
        aabc.turnOnSale();
        bool _selling = aabc._selling();

        //selling should be true after turn on
        if(_selling == true){
            logger("selling: True", "PASS TEST");
        }
        else{
            logger("selling: False", "FAILED TEST");
        }
    }

    function test_turnOffSale()
    public {
        aabc.turnOffSale();
        bool _selling = aabc._selling();

        //selling should be FALSE after turn off
        if(_selling == false){
            logger("selling: False", "PASS TEST");
        }
        else{
            logger("selling: True", "FAILED TEST");
        }
    }

    function test_sendTransaction()
    external {
        User user1 = new User(aabc);
        User user2 = new User(aabc);

        uint256 amount = 5000000000000;
        // init aabc from owner for user 1, 5000000000000 unit
        aabc.transfer(address(user1), amount);

        user1.do_Transfer(address(user2), amount);
    }

    function test_transferWithoutTradable()
    public {
        if (aabc.tradable() == true){
            logger("tradable is true now", "try another test");
            return;
        }
        // test: transfer with amount > user1's balances
        logger("test: transfer without tradable, SHOULD NOT done", "START TEST");
        // call low level function to control revert
        // this is data for "test_sendTransaction()"
        bytes32 data = 0x30ea0352;

        // SHOULD NOT be done
        if (this.call(data)){
            logger("test: transfer success", "FAILED TEST");
        }
        else{
            logger("test: transfer failed", "PASS TEST");
        }
    }

    function test_tranferWithTradable()
    public{
        if (aabc.tradable() == false){
            logger("tradable is false now, DO TURN ON\n NOTE: you should test functions with tradable is off before this test", "PREPAIR TEST");
            aabc.turnOnTradable();
        }
        //recheck
        if (aabc.tradable() == false){
            logger("recheck: tradable is false now, check turnOnTradable function", "try another test");
            return;
        }

        User user1 = new User(aabc);
        User user2 = new User(aabc);
        // init aabc from owner for user 1, 5000000000000 unit
        logger("init amount for user 1", "PREPAIR");
        aabc.transfer(address(user1), 5000000000000);

        // test 1: transfer with amount > user1's balances
        logger("test 1: transfer with amount > user1's balances, SHOULD NOT done", "START TEST");
        if (user1.do_Transfer(address(user2), 6000000000000) == false){
            logger("test 1: transfer failed", "PASS TEST");
        }
        else{
            logger("test 1: transfer success", "FAILED TEST");
        }

        // test 2: transfer with amount <= user1's balances
        logger("test 2: transfer with amount < user1's balances, SHOULD done", "START TEST");
        if (user1.do_Transfer(address(user2), 3000000000000) == true){
            logger("test 2: transfer success", "PASS TEST");
        }
        else {
            logger("test 2: transfer ", "FAILED TEST");
        }
    }

    function test_transferFromOwner_WithoutTradable() 
    public {
        if(this != aabc.owner()){
            logger("this is not call from owner", "try another test");
            return;
        }
        if (aabc.tradable() == true){
            logger("tradable is true now, can't turn off tradable", "try another test");
            return;
        }
        // create tmp user
        User tmp = new User(aabc);
        // init amount 200,000,000,00000
        uint256 amount = 20000000000000;
        // do transfer from owner 200,000,000,00000 to user tmp
        aabc.transfer(address(tmp), amount);

        // check the balance of user tmp mapping with amount
        uint256 balanceOfUser = aabc.balanceOf(address(tmp));

        // checking test
        if (balanceOfUser == amount){
            logger("amount of new user is mapped exactly", "PASS TEST");
        }
        else {
            logger("amount of new user is not mapped", "FAILED TEST");
        }
    }

    function test_addInvestor() 
    public {
        aabc.addInvestorList(investorList);

        // test investor is in the list
        bool testInInvestorListResult = true;

        for (uint256 i = 0; i < investorList.length; i++) {
            if (aabc.isApprovedInvestor(investorList[i]) == false) {
                testInInvestorListResult = false;
                break;
            }
        }

        if (testInInvestorListResult == true) {
            logger("all added investors are in approved investors list", "PASS TEST");
        }
        else {
            logger("at least on added investor is not in approved investors list", "FAILED TEST");
        }

        // test non-investor is in the list
        bool testNotInInvestorListResult = true;

        for (i = 0; i < nonInvestorList.length; i++) {
            if (aabc.isApprovedInvestor(nonInvestorList[i]) == true) {
                testNotInInvestorListResult = false;
                break;
            }
        }

        if (testInInvestorListResult == true && testNotInInvestorListResult == true) {
            logger("add approved investors list", "PASS TEST");
        }
        else {
            logger("add approved investors list", "FAILED TEST");
        }

    }

    function test_turnOnTradable() 
    public{
        logger("test: turn on tradable", "START");
        aabc.turnOnTradable();
        bool tradable = aabc.tradable();

        // tradable should be true after turning it ON
        if(tradable == true){
            logger("tradable: true", "TEST PASSED");
        }
        else{
            logger("tradable: false", "TEST FAILED");
        }

    }

    function test_setPrice()
    public {
        aabc = new aabc();
        CoinCreation(address(aabc));

        uint256 newPrice = 45 * 10**17;

        // consider to use the value computed from external source, should not from our code
        uint256 expected_originalBuyPrice = newPrice;
        uint256 expected_maximumBuy = 10**18 * 10000000000 / newPrice;

        aabc.setBuyPrice(newPrice);

        uint256 new_originalBuyPrice = aabc._originalBuyPrice();
        uint256 new_maximumBuy = aabc._maximumBuy();

        if (new_originalBuyPrice == expected_originalBuyPrice && 
            new_maximumBuy == expected_maximumBuy) {
            logger("set new buy price", "TEST PASSED");
        }
        else {
            logger("set new buy price", "TEST FAILED");
        }
    }



    function allTest(){
        createaabc();
        test_turnOffSale();
        test_setPrice();
        test_turnOnSale();
        test_transferFromOwner_WithoutTradable();
        test_transferWithoutTradable();
        test_tranferWithTradable();
    }
} 
