// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {TokenLending} from "../src/TokenLending.sol";

contract TokenLendingScript is Script {
    function run() external returns (TokenLending) {
       vm.startBroadcast();

       TokenLending tokenLending = new TokenLending();

       vm.stopBroadcast();
       return tokenLending;
   }
}