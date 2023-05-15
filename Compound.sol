// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./UniswapV2Oracle.sol";
import "./interfaces/IPriceFeed.sol";

contract CompoundOracle{
    uint256 chainlinkPrice;
    uint256 uniswapV2Price;
    uint256 public constant DELTA = 1;
    address public constant eth_usd_pricefeed = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;

    address ETH = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB; // tokenA
    address USDC = 0x2f3A40A3db8a7e3D09B0adfEfbCe4f6F81927557; // tokenB
    address factoryETH_USD = 0xf494C7e9bB3F66E7c77c3704fDfB7E21bC89620a;


    address chainlinkPriceFeed;
    address uniswapPriceFeed;
    UniswapV2Oracle uniswapPair;

    constructor(){
    }

    function getPrice() external view returns (uint256 price){
        (int relativeAssetPrice, ) = IPriceFeed(eth_usd_pricefeed).getLatestPrice();
        chainlinkPrice = uint256(relativeAssetPrice) / (10 ** uint256(8));
        uniswapPair = UniswapV2Oracle(factoryETH_USD, ETH, USDC);
        uniswapPair.update();
        uniswapV2Price = uniswapPair.consult(ETH, 1) / (10 ** uint256(8));
        if (chainlinkPrice <= uniswapV2Price + DELTA && chainlinkPrice >= uniswapV2Price - DELTA) {
            price = chainlinkPrice;
        }
        else {
            price = uniswapV2Price;
        }
    }

}