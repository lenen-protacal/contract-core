////// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**

     ██▓       ▓█████     ███▄    █ 
    ▓██▒       ▓█   ▀     ██ ▀█   █ 
    ▒██░       ▒███      ▓██  ▀█ ██▒
    ▒██░       ▒▓█  ▄    ▓██▒  ▐▌██▒
    ░██████▒   ░▒████▒   ▒██░   ▓██░
    ░ ▒░▓  ░   ░░ ▒░ ░   ░ ▒░   ▒ ▒ 
    ░ ░ ▒  ░    ░ ░  ░   ░ ░░   ░ ▒░
      ░ ░         ░         ░   ░ ░ 
        ░  ░      ░  ░            ░ 
 */
interface ERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function transfer(address dst, uint256 amount) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );
}

contract LEN is ERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) public blackList;

    string public constant name = "LEN";
    string public constant symbol = "LEN";
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply = 100_000_000_000e18;
    address public governor;

    event GovernorTransferred(
        address indexed oldGovernor,
        address indexed newGovernor
    );

    constructor(address account) {
        _balances[account] = totalSupply;
        governor = account;
        emit Transfer(address(0), account, totalSupply);
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "LEN: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(from != address(0), "LEN: transfer from the zero address");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "LEN: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "LEN: approve from the zero address");
        require(spender != address(0), "LEN: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "LEN: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        require(!blackList[from] && !blackList[to], "Blacklist not allowed");
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal {}

    function transferGovernor(address newGovernor) external {
        if (msg.sender != governor) revert("Unauthorized");

        address oldGovernor = governor;
        governor = newGovernor;
        emit GovernorTransferred(oldGovernor, newGovernor);
    }

    function setBlacklist(address[] calldata users, bool flag) external {
        if (msg.sender != governor) revert("Unauthorized");
        for (uint256 i = 0; i < users.length; ) {
            blackList[users[i]] = flag;
            unchecked {
                i++;
            }
        }
    }

    function revokeWrongToken(address token_) external {
        if (msg.sender != governor) revert("Unauthorized");
        if (token_ == address(0x0)) {
            (bool sent, bytes memory data) = msg.sender.call{
                value: address(this).balance
            }(new bytes(0));
            require(sent, "Failed to send VS");
            return;
        }
        ERC20 token = ERC20(token_);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
