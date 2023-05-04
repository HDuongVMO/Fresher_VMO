// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VaccineManager is Ownable {

    address public deployerAddress;

    mapping(string => address) public vaccineSupplyChainList;
    mapping(string => address) public userExtendList;
    mapping(string => address) public vaccineSystemStorageList;

    mapping(address => string[]) public vaccineSupplyChainListVersion;
    mapping(address => string[]) public userExtendListVersion;
    mapping(address => string[]) public vaccineSystemStorageListVersion;

    string public currentVaccineSupplyChainVersion;
    string public currentUserExtendVersion;
    string public currentVaccineSystemStorageVersion;

    function addVaccineSupplyChain(address _contractAddress, string memory _version) external onlyOwner{
        vaccineSupplyChainList[_version] = _contractAddress;
        vaccineSupplyChainListVersion[owner()].push(_version);
    }

    function getVaccineSupplyChain(string memory _version) external view returns(address) {
        return getVaccineSupplyChainList[_version];
    }

    function getVaccineSupplyChainVersion() public view returns (string[] memory) {
        return vaccineSupplyChainListVersion[_ownerAddress];
    }

    function setCurrentVaccineSupplyChainVersionVersion(string memory _version) public onlyOwner {
        currentVaccineSupplyChainVersion = _version;
    }

    function getCurrentVaccineSupplyChainVersion () public view returns (string memory) {
        return currentVaccineSupplyChainVersion;
    }

    function addUserExtend(address _contractAddress, string memory _version) external onlyOwner{
        userExtendList[_version] = _contractAddress;
        userExtendListVersion[owner()].push();
    }

    function getUserExtend(string memory _version) external view returns (address) {
        return userExtendList[_version];
    }

    function getUserExtendVersion(address _ownerAddress) public view returns (string[] memory) {
        return userExtendListVersion[_ownerAddress];
    }

    function setcurrentUserExtendVersion (string memory _version) external onlyOwner {
        currentUserExtendVersion = _version;
    }

    function getcurrentUserExtendVersion() public view returns (string memory) {
        return currentUserExtendVersion;
    }

    function addVaccineSystemStorage(address _contractAddress, string memory _version) external onlyOwner {
        vaccineSystemStorageList[_version] = _contractAddress;
        vaccineSystemStorageListVersion[owner()].push(_version);
    }

    function getSystemStorageContract(string memory _version) external view returns (address) {
        return vaccineSystemStorageListVersion[_version];
    }

    function getVaccineSystemStorageVersion(address _ownerAddress) public view returns (string[] memory) {
        return vaccineSystemStorageListVersion[_ownerAddress];
    }

    function setCurrentVaccineSystemStorageVersion (string memory _version) external onlyOwner {
        currentVaccineSystemStorageVersion = _version;
    }

    function getCurrentSystemStorageVersion () public view returns (string memory) {
        return currentVaccineSystemStorageVersion;
    }

    function setDeployerAddress(address _deployerAddress) public onlyOwner {
        deployerAddress = _deployerAddress;
    }

    function getDeployerAddress() public view returns(address) {
        return deployerAddress;
    }
}