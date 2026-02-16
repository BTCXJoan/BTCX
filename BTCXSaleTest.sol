// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BTCXSaleTest {

    IERC20 public immutable btcx;
    IERC20 public immutable usdc;

    address public immutable treasury;

    uint256 public constant PRICE_USDC = 20 * 1e6; // 20 USDC
    uint256 public constant TOKENS_PER_PURCHASE = 200 * 1e18; // 200 BTCX
    uint256 public constant MAX_FOR_SALE = 5000 * 1e18;

    uint256 public totalSold;

    event Purchased(address indexed buyer, uint256 amount);

    constructor(
        address _btcx,
        address _usdc,
        address _treasury
    ) {
        btcx = IERC20(_btcx);
        usdc = IERC20(_usdc);
        treasury = _treasury;
    }

    function buy() external {

        require(totalSold + TOKENS_PER_PURCHASE <= MAX_FOR_SALE, "Sold out");

        require(
            usdc.transferFrom(msg.sender, treasury, PRICE_USDC),
            "USDC transfer failed"
        );

        require(
            btcx.transfer(msg.sender, TOKENS_PER_PURCHASE),
            "BTCX transfer failed"
        );

        totalSold += TOKENS_PER_PURCHASE;

        emit Purchased(msg.sender, TOKENS_PER_PURCHASE);
    }
}
