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

    // ===============================================

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
        bool isViolation;
    }

    struct distributor {
        string destinationAddress;
        string shippingName;
        uint256 quantity;
        uint256 depatureDateTime;
        uint256 estimateDateTime;
        string optimumRangeTemp;
        string optimumRangeHum;
        bool isViolation;
    }

    struct vaccinationStation {
        uint256 quantity;
        uint256 arrivalDateTime;
        uint256 vaccinationStationId;
        string shippingName;
        string shippingNumber;
        string locationAddress;
    }

    mapping(address => basicDetails) public batchBasicDetails;
    mapping(address => wareHouser) public batchWareHouser;
    mapping(address => distributor) public batchDistributor;
    mapping(address => vaccinationStation) public batchVaccinationStation;
    mapping(address => string) public nextAction;

    User userDetail;
    basicDetails basicDetailsData;
    wareHouser wareHouserData;
    distributor distributorData;
    vaccinationStation vaccinationStationData;

    function getNextAction(
        address _batchCode
    ) public view returns (string memory) {
        return nextAction[_batchCode];
    }

    // USERS DETAILS
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
            string memory name,
            string memory contact,
            string memory role,
            bool isActive,
            string memory profileHash
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

    // BACSIC DETAILS
    function getBasicDetails(
        address _batchCode
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
        basicDetails memory _batchBasicDetails = batchBasicDetails[_batchCode];
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
        address _batchCode = address(
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

        batchBasicDetails[_batchCode] = basicDetailsData;
        nextAction[_batchCode] = "WAREHOUSER";
        return _batchCode;
    }

    // WAREHOUSE MANAGER
    function getWareHouser(
        address _batchCode
    )
        public
        view
        returns (
            string memory name,
            uint256 quantity,
            uint256 storageDate,
            string memory optimumRangeTemp,
            string memory optimumRangeHum,
            string memory locationAddress,
            bool isViolation
        )
    {
        wareHouser memory _wareHouser = batchWareHouser[_batchCode];
        return (
            _wareHouser.name,
            _wareHouser.quantity,
            _wareHouser.storageDate,
            _wareHouser.optimumRangeTemp,
            _wareHouser.optimumRangeHum,
            _wareHouser.locationAddress,
            _wareHouser.isViolation
        );
    }

    function setWareHouser(
        address _batchCode,
        string memory _name,
        uint256 _quantity,
        uint256 _storageDate,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum,
        string memory _locationAddress,
        bool _isViolation
    ) public onlyAuthorizedCaller returns (bool) {
        wareHouserData.name = _name;
        wareHouserData.quantity = _quantity;
        wareHouserData.storageDate = _storageDate;
        wareHouserData.optimumRangeTemp = _optimumRangeTemp;
        wareHouserData.optimumRangeHum = _optimumRangeHum;
        wareHouserData.locationAddress = _locationAddress;
        wareHouserData.isViolation = _isViolation;

        batchWareHouser[_batchCode] = wareHouserData;
        nextAction[_batchCode] = "DISTRIBUTOR";
        return true;
    }

    // DISTRIBUTOR
    function getDistributor(
        address _batchCode
    )
        public
        view
        returns (
            string memory destinationAddress,
            string memory shippingName,
            uint256 quantity,
            uint256 depatureDateTime,
            uint256 estimateDateTime,
            string memory optimumRangeTemp,
            string memory optimumRangeHum,
            bool isViolation
        )
    {
        distributor memory _distributor = batchDistributor[_batchCode];
        return (
            _distributor.destinationAddress,
            _distributor.shippingName,
            _distributor.quantity,
            _distributor.depatureDateTime,
            _distributor.estimateDateTime,
            _distributor.optimumRangeTemp,
            _distributor.optimumRangeHum,
            _distributor.isViolation
        );
    }

    function setDistributor(
        address _batchCode,
        string memory _destinationAddress,
        string memory _shippingName,
        uint256 _quantity,
        uint256 _depatureDateTime,
        uint256 _estimateDateTime,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum,
        bool _isViolation
    ) public onlyAuthorizedCaller returns (bool) {
        distributorData.destinationAddress = _destinationAddress;
        distributorData.shippingName = _shippingName;
        distributorData.quantity = _quantity;
        distributorData.depatureDateTime = _depatureDateTime;
        distributorData.estimateDateTime = _estimateDateTime;
        distributorData.optimumRangeTemp = _optimumRangeTemp;
        distributorData.optimumRangeHum = _optimumRangeHum;
        distributorData.isViolation = _isViolation;
        batchDistributor[_batchCode] = distributorData;

        nextAction[_batchCode] = "VACCINATION_STATION";
        return true;
    }

    // VACCINATION STATION
    function getVaccinationStation(
        address _batchCode
    )
        public
        view
        returns (
            uint256 quantity,
            uint256 arrivalDateTime,
            uint256 vaccinationStationId,
            string memory shippingName,
            string memory shippingNumber,
            string memory locationAddress
        )
    {
        vaccinationStation memory _vaccinationStation = batchVaccinationStation[
            _batchCode
        ];
        return (
            _vaccinationStation.quantity,
            _vaccinationStation.arrivalDateTime,
            _vaccinationStation.vaccinationStationId,
            _vaccinationStation.shippingName,
            _vaccinationStation.shippingNumber,
            _vaccinationStation.locationAddress
        );
    }

    function setVaccinationStation(
        address _batchCode,
        uint256 _quantity,
        uint256 _arrivalDateTime,
        uint256 _vaccinationStationId,
        string memory _shippingName,
        string memory _shippingNumber,
        string memory _locationAddress
    ) public onlyAuthorizedCaller returns (bool) {
        vaccinationStationData.quantity = _quantity;
        vaccinationStationData.arrivalDateTime = _arrivalDateTime;
        vaccinationStationData.vaccinationStationId = _vaccinationStationId;
        vaccinationStationData.shippingName = _shippingName;
        vaccinationStationData.shippingNumber = _shippingNumber;
        vaccinationStationData.locationAddress = _locationAddress;
        batchVaccinationStation[_batchCode] = vaccinationStationData;

        nextAction[_batchCode] = "OBJECT_INJECTION";
        return true;
    }

    // OBJECT INJECTION
}
