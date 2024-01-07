// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract TokenLending {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public borrowedAmounts;
    address public tokenAddress;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than 0");
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        require(IERC20(tokenAddress).transfer(msg.sender, amount), "Token transfer failed");
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be greater than 0");
        require(amount <= IERC20(tokenAddress).balanceOf(address(this)), "Insufficient contract balance");
        borrowedAmounts[msg.sender] += amount;
        require(IERC20(tokenAddress).transfer(msg.sender, amount), "Token transfer failed");
    }

    function repay(uint256 amount) external {
        require(amount > 0, "Repayment amount must be greater than 0");
        require(amount <= borrowedAmounts[msg.sender], "Repayment amount exceeds borrowed amount");
        borrowedAmounts[msg.sender] -= amount;
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount), "Token transfer failed");
    }
}