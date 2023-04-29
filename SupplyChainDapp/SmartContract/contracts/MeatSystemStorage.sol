// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ownable.sol";

contract MeatSystemStorage is Ownable {
    mapping(address => uint) internal authorizedCaller;

    constructor() {
        authorizedCaller[msg.sender] = 1;
    }

    modifier onlyAuthorizedCaller() {
        require(authorizedCaller[msg.sender] == 1);
        _;
    }

    struct User {
        string name;
        string contact;
        bool isActive;
        string profileHash;
    }

    mapping(address => User) public userDetails;
    mapping(address => string) internal userRole;

    event AuthorizedCaller(address caller);
    event DeAuthorizedCaller(address caller);

    function authorizeCaller(address _caller) public onlyOwner returns(bool) {
        authorizedCaller[_caller] = 1;
        emit AuthorizedCaller(_caller);
        return true;
    }

    function deAuthorizeCaller(address _caller) public onlyOwner returns(bool) {
        authorizedCaller[_caller] = 0;
        emit DeAuthorizedCaller(_caller);
        return true;
    }

    User userDetail;
}