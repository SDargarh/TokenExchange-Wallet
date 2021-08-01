pragma solidity >= 0.6.0;

import "../client/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../client/node_modules/@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract ReceiveToken{
    
    IERC20 public token;
    IUniswapV2Router01 public router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);         //UniSwapRouterAddress
    uint public contractTotalBalance;
    uint public userTotalBalance;
    address public contractOwner;
    address public user;
    mapping(address => uint) public userWallet;

    event totalBalanceUpdate(uint contractTotalBalance, uint userTotalBalance);
    
    constructor() public {
        contractOwner = msg.sender;
    }

    function receiveToken(address _tokenAddress, uint _amount) public {
        user = msg.sender;
        token = IERC20(_tokenAddress);
        
        token.transferFrom(user, address(this), _amount);
        contractTotalBalance = token.balanceOf(address(this));
        userTotalBalance = token.balanceOf(user);
        
        emit totalBalanceUpdate(contractTotalBalance, userTotalBalance);
        //add a check to see if received token is complaint with ERC20
        swapForEther(_tokenAddress, _amount);
    }

    function swapForEther(address _tokenAddress, uint _amount) internal {
        //generates the path to make the swap
        address[] memory path = new address[](2);
        path[0] = _tokenAddress;
        path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;     //WETH address;
        //lets the contract trade 'amount' of UNI using the UniswapV2Router01
        token.approve(address(router), _amount);
        
        // token.transferFrom(address(this), address(router), _amount);
        
        // Makes the swap 
        router.swapExactTokensForETH(
            _amount,
            0, 
            path,
            address(this),
            block.timestamp
        );  
    }

    function withdrawETH() public{
        userWallet[msg.sender] = 0;
        msg.sender.transfer(userWallet[msg.sender]);
    }

    receive() external payable {
        userWallet[user] += msg.value;
    }    
}