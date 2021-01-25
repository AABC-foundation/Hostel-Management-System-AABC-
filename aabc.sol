pragma solidity ^0.5.2;

import "./Context.sol";
import "./ERC20.sol";
import "./ERC20Detailed.sol";

/**
 * @title SimpleToken
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract Arbitrage_analysis_beyond_commodity is Context, ERC20, ERC20Detailed {
    uint8 public constant DECIMALS = 6;
    uint256 public constant INITIAL_SUPPLY = 30000000000 * (10 ** uint256(DECIMALS));
    /**
     * @dev Constructor that gives _msgSender() all of existing tokens.
     */
    constructor () public ERC20Detailed("Arbitrage_analysis_beyond_commodity", "AABC", 6) {
        _mint(_msgSender(), INITIAL_SUPPLY);
    }
}
