pragma solidity ^0.4.24;


import "../crowdsale/validation/CappedCrowdsale.sol";

import "../crowdsale/distribution/RefundableCrowdsale.sol";

import "../crowdsale/emission/MintedCrowdsale.sol";

import "../token/ERC20/ERC20Mintable.sol";


contract SimpleToken is ERC20 {


  string public constant name = "SimpleToken";

  string public constant symbol = "SIM";

  uint8 public constant decimals = 18;


  uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  constructor() public {

    _mint(msg.sender, INITIAL_SUPPLY);

  }


}



contract SampleCrowdsaleToken is ERC20Mintable {


  string public constant name = "Sample Crowdsale Token";

  string public constant symbol = "SCT";

  uint8 public constant decimals = 18;


contract SampleCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {


  constructor(

    uint256 openingTime,

    uint256 closingTime,

    uint256 rate,

    address wallet,

    uint256 cap,

    ERC20Mintable token,

    uint256 goal

  )

    public

    Crowdsale(rate, wallet, token)

    CappedCrowdsale(cap)

    TimedCrowdsale(openingTime, closingTime)

    RefundableCrowdsale(goal)

  {
    require(goal <= cap);

  }

}


/// Добавление ролей к эвент контрактам


library Roles {

  struct Role {

    mapping (address => bool) bearer;

  }


  /**

* @dev give an account access to this role

*/

  function add(Role storage role, address account) internal {

    require(account != address(0));

    role.bearer[account] = true;

  }


  /**

* @dev remove an account's access to this role

*/

  function remove(Role storage role, address account) internal {

    require(account != address(0));

    role.bearer[account] = false;

  }

  function has(Role storage role, address account)

    internal

    view

    returns (bool)

  {

    require(account != address(0));

    return role.bearer[account];

  }

}

/// Роли


import "../Roles.sol";



contract CapperRole {

  using Roles for Roles.Role;


  event CapperAdded(address indexed account);

  event CapperRemoved(address indexed account);


  Roles.Role private cappers;


  constructor() public {

    cappers.add(msg.sender);

  }


  modifier onlyCapper() {

    require(isCapper(msg.sender));

    _;

  }


  function isCapper(address account) public view returns (bool) {

    return cappers.has(account);

  }


  function addCapper(address account) public onlyCapper {

    cappers.add(account);

    emit CapperAdded(account);

  }


  function renounceCapper() public {

    cappers.remove(msg.sender);

  }


  function _removeCapper(address account) internal {

    cappers.remove(account);

    emit CapperRemoved(account);

  }

}


contract CapperRole {

  using Roles for Roles.Role;


  event CapperAdded(address indexed account);

  event CapperRemoved(address indexed account);


  Roles.Role private cappers;


  constructor() public {

    cappers.add(msg.sender);

  }


  modifier onlyCapper() {

    require(isCapper(msg.sender));

    _;

  }


  function isCapper(address account) public view returns (bool) {

    return cappers.has(account);

  }


  function addCapper(address account) public onlyCapper {

    cappers.add(account);

    emit CapperAdded(account);

  }


  function renounceCapper() public {

    cappers.remove(msg.sender);

  }


  function _removeCapper(address account) internal {

    cappers.remove(account);

    emit CapperRemoved(account);

  }

}


