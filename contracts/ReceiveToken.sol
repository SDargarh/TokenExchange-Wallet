pragma solidity >= 0.6.0;

import "../client/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

//dai - ropsten - 0x6b175474e89094c44da98b954eedeac495271d0f
//UNI - ropsten - 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984
//account1 = 0x7049d60356df2a97d9cf2fed78128b077a00308d


contract ReceiveToken{
    
    IERC20 public token;
    uint public contractTotalBalance;
    uint public userTotalBalance;
    address public contractOwner;
    mapping(address => uint) public userWallet;


    event ackReceivedTokens(address _senderAddress, uint _noOfTokens);
    event totalBalanceUpdate(uint contractTotalBalance, uint userTotalBalance);
    
    constructor() public {
        contractOwner = msg.sender;
    }

    function receiveToken(address _tokenAddress, uint _amount) public{
        address user = msg.sender;
        token = IERC20(_tokenAddress);
        userWallet[user] += _amount;

        token.transferFrom(user, address(this), _amount);

        contractTotalBalance = token.balanceOf(address(this));
        userTotalBalance = token.balanceOf(user);
        

        emit totalBalanceUpdate(contractTotalBalance, userTotalBalance);
        //add a check to see if received token is complaint with ERC20
    }

    function swapForEther() public{

    }

    function withdrawETH() public{

    }

}