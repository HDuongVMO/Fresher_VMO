// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ownable.sol";
import "./VaccineSystemStorage.sol";

contract UserAttend is Ownable {
    event userUpdate(
        address indexed user,
        string name,
        string contact,
        string role,
        bool isActive,
        string profileHash
    );
    event UserRoleUpdate(address indexed user, string role);

    VaccineSystemStorage vaccineSystemStorage;

    constructor(address _vaccineSystemAddress) {
        vaccineSystemStorage = VaccineSystemStorage(_vaccineSystemAddress);
    }

    function updateUser(
        string memory _name,
        string memory _contact,
        string memory _role,
        bool _isActive,
        string memory _profileHash
    ) public returns (bool) {
        require(msg.sender != address(0), "User Invalid");
        bool success = vaccineSystemStorage.setUserDetails(
            msg.sender,
            _name,
            _contact,
            _role,
            _isActive,
            _profileHash
        );

        emit userUpdate(
            msg.sender,
            _name,
            _contact,
            _role,
            _isActive,
            _profileHash
        );

        emit UserRoleUpdate(msg.sender, _role);
        return success;
    }

    function getUserDetails(
        address _userAddress
    )
        public
        view
        returns (
            string memory name,
            string memory contact,
            string memory role,
            bool isActive,
            string memory profileHash
        )
    {
        require(_userAddress != address(0), "User Invalid");

        (name, contact, role, isActive, profileHash) = vaccineSystemStorage
            .getUserDetails(_userAddress);
        return (name, contact, role, isActive, profileHash);
    }
}
