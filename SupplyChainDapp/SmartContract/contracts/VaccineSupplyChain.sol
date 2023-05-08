// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./VaccineSystemStorage.sol";
import "./Ownable.sol";

contract VaccineSupplyChain is Ownable {
    event CompleteBasicDetail(address indexed user, address indexed batchCode);
    event CompleteWarehouser(address indexed user, address indexed batchCode);
    event CompleteDistributor(address indexed user, address indexed batchCode);

    modifier isValidPerformer(address batchCode, string memory role) {
        require(
            keccak256(
                abi.encodePacked(vaccineSystemStorage.getUserRole(msg.sender))
            ) == keccak256(abi.encodePacked(role))
        );
        require(
            keccak256(
                abi.encodePacked(vaccineSystemStorage.getNextAction(batchCode))
            ) == keccak256(abi.encodePacked(role))
        );
        _;
    }

    modifier onlyProducer(string memory role) {
        require(
            keccak256(
                abi.encodePacked(vaccineSystemStorage.getUserRole(msg.sender))
            ) == keccak256(abi.encodePacked(role))
        );
        _;
    }

    VaccineSystemStorage vaccineSystemStorage;

    constructor(address _vaccineSystemAddress) public {
        vaccineSystemStorage = VaccineSystemStorage(_vaccineSystemAddress);
    }

    function getBalance() public view returns (uint256) {
        return (address(this).balance);
    }


    function getNextAction(address _batchCode)
        public
        view
        returns (string memory action)
    {
        (action) = vaccineSystemStorage.getNextAction(_batchCode);
        return (action);
    }

    function getBasicDetailsData(address _batchCode)
        public
        view
        returns (
            string memory producerName,
            uint256 quantity,
            string memory optimumRangeTemp,
            string memory optimumRangeHum
        )
    {
        (
            producerName,
            quantity,
            optimumRangeTemp,
            optimumRangeHum
        ) = vaccineSystemStorage.getBasicDetails(_batchCode);
        return (
            producerName,
            quantity,
            optimumRangeTemp,
            optimumRangeHum
        );
    }

    function addBasicDetails(
        string memory _producerName,
        uint256 _quantity,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum
    ) public onlyProducer("PRODUCER") returns (address) {
        address batchCode = vaccineSystemStorage.setBasicDetails(
            _producerName,
            _quantity,
            _optimumRangeTemp,
            _optimumRangeHum
        );

        emit CompleteBasicDetail(msg.sender, batchCode);

        return batchCode;
    }

    function getWarehouserData(address _batchCode)
        public
        view
        returns (
            string memory vaccineName,
            uint256 quantity,
            uint256 storageDate,
            string memory optimumRangeTemp,
            string memory optimumRangeHum,
            bool isViolation
        )
    {
        (
            vaccineName,
            quantity,
            storageDate,
            optimumRangeTemp,
            optimumRangeHum,
            isViolation
        ) = vaccineSystemStorage.getWarehouserData(_batchCode);
        return (
            vaccineName,
            quantity,
            storageDate,
            optimumRangeTemp,
            optimumRangeHum,
            isViolation
        );
    }

    function updateWarehouser(
        address _batchCode,
        string memory _vaccineName,
        uint256 _quantity,
        uint256 _storageDate,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum,
        bool _isViolation
    ) public isValidPerformer(_batchCode, "WAREHOUSER") returns (bool) {
        bool status = vaccineSystemStorage.setWarehouser(
            _batchCode,
            _vaccineName,
            _quantity,
            _storageDate,
            _optimumRangeTemp,
            _optimumRangeHum,
            _isViolation
        );

        emit CompleteWarehouser(msg.sender, _batchCode);
        return (status);
    }

    function getDistributorData(address _batchNo)
        public
        view
        returns (
            string memory destinationAddress,
            string memory shippingName,
            uint256 quantity,
            uint256 departureDateTime,
            uint256 estimateDateTime,
            string memory optimumRangeTemp,
            string memory optimumRangeHum
        )
    {
        /* Call Storage Contract */
        (
            destinationAddress,
            shippingName,
            quantity,
            departureDateTime,
            estimateDateTime,
            optimumRangeTemp,
            optimumRangeHum
        ) = vaccineSystemStorage.getDistributorData(_batchNo);
        return (
            destinationAddress,
            shippingName,
            quantity,
            departureDateTime,
            estimateDateTime,
            optimumRangeTemp,
            optimumRangeHum
        );
    }

    function updateDistributorData(
        address _batchNo,
        string memory _destinationAddress,
        string memory _shippingName,
        uint256 _quantity,
        uint256 _departureDateTime,
        uint256 _estimateDateTime,
        string memory _optimumRangeTemp,
        string memory _optimumRangeHum
    ) public isValidPerformer(_batchNo, "DISTRIBUTOR") returns (bool) {
        bool status = vaccineSystemStorage.setDistributor(
            _batchNo,
            _destinationAddress,
            _shippingName,
            _quantity,
            _departureDateTime,
            _estimateDateTime,
            _optimumRangeTemp,
            _optimumRangeHum
        );
        emit CompleteDistributor(msg.sender, _batchNo);

        return (status);
    }
}