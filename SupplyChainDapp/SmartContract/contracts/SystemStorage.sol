// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ownable.sol";

contract VaccineSystemStorage is Ownable {
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

    // De-Authorized Caller
    function authorizeCaller(address _caller) public onlyOwner returns (bool) {
        authorizedCaller[_caller] = 1;
        emit AuthorizedCaller(_caller);
        return true;
    }

    // De-Authorized Caller
    function deAuthorizeCaller(
        address _caller
    ) public onlyOwner returns (bool) {
        authorizedCaller[_caller] = 0;
        emit DeAuthorizedCaller(_caller);
        return true;
    }

    struct basicDetails {
        string producerName;
        uint256 quantity;
        string optimumRangeTemp;
        string optimumRangeHum;
    }

    struct wareHouser {
        string name;
        uint256 quantity;
        uint256 storageDate;
        string optimumRangeTemp;
        string optimumRangeHum;
        string locationAddress;
    }

    // mapping
    mapping(address => basicDetails) public batchBasicDetails;
    mapping(address => wareHouser) public batchWareHouser;
    mapping(address => string) public nextAction;

    // Init Struct Pointer
    User userDetail;
    basicDetails basicDetailsData;
    wareHouser wareHouserData;

    function getNextAction(
        address _batchNumber
    ) public view returns (string memory) {
        return nextAction[_batchNumber];
    }

    // User Details
    function getUserRole(
        address _userAddress
    ) public view returns (string memory) {
        return userRole[_userAddress];
    }

    function getUserDetails(
        address _userAddress
    )
        public
        view
        returns (
            string memory _name,
            string memory _contact,
            string memory _role,
            bool _isActive,
            string memory _profileHash
        )
    {
        User memory _user = userDetails[_userAddress];
        return (
            _user.name,
            _user.contact,
            userRole[_userAddress],
            _user.isActive,
            _user.profileHash
        );
    }

    function setUserDetails(
        address _userAddress,
        string memory _name,
        string memory _contact,
        string memory _role,
        bool _isActive,
        string memory _profileHash
    ) public onlyAuthorizedCaller returns (bool) {
        userDetail.name = _name;
        userDetail.contact = _contact;
        userDetail.isActive = _isActive;
        userDetail.profileHash = _profileHash;
        userDetails[_userAddress] = userDetail;
        userRole[_userAddress] = _role;
        return true;
    }

    // Basic Details
    function getBasicDetails(
        address _batchNumber
    )
        public
        view
        returns (
            string memory producerName,
            uint256 quantity,
            string memory optimumRangeTemp,
            string memory optimumRangeHum
        )
    {
        basicDetails memory _batchBasicDetails = batchBasicDetails[
            _batchNumber
        ];
        return (
            _batchBasicDetails.producerName,
            _batchBasicDetails.quantity,
            _batchBasicDetails.optimumRangeTemp,
            _batchBasicDetails.optimumRangeHum
        );
    }

    function setBasicDetails(
        string memory _producerName,
        uint256 _quantity,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum
    ) public onlyAuthorizedCaller returns (address) {
        address _batchNumber = address(
            uint160(
                uint256(
                    keccak256(abi.encodePacked(msg.sender, block.timestamp))
                )
            )
        );

        basicDetailsData.producerName = _producerName;
        basicDetailsData.quantity = _quantity;
        basicDetailsData.optimumRangeTemp = _optimumRangeTemp;
        basicDetailsData.optimumRangeHum = _optimumRangeHum;

        batchBasicDetails[_batchNumber] = basicDetailsData;
        nextAction[_batchNumber] = "WAREHOUSER";
        return _batchNumber;
    }

    // Warehouse
    function getWareHouser(
        address _batchNumber
    )
        public
        view
        returns (
            string memory name,
            uint256 quantity,
            uint256 storageDate,
            string memory optimumRangeTemp,
            string memory optimumRangeHum,
            string memory locationAddress
        )
    {
        wareHouser memory _wareHouser = batchWareHouser[_batchNumber];
        return (
            _wareHouser.name,
            _wareHouser.quantity,
            _wareHouser.storageDate,
            _wareHouser.optimumRangeTemp,
            _wareHouser.optimumRangeHum,
            _wareHouser.locationAddress
        );
    }

    function setWareHouser(
        address _batchNumber,
        string memory _name,
        uint256 _quantity,
        uint256 _storageDate,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum,
        string memory _locationAddress
    ) public onlyAuthorizedCaller returns (bool) {
        wareHouserData.name = _name;
        wareHouserData.quantity = _quantity;
        wareHouserData.storageDate = _storageDate;
        wareHouserData.optimumRangeTemp = _optimumRangeTemp;
        wareHouserData.optimumRangeHum = _optimumRangeHum;
        wareHouserData.locationAddress = _locationAddress;

        batchWareHouser[_batchNumber] = wareHouserData;
        nextAction[_batchNumber] = "DISTRIBUTOR";
        return true;
    }
}
