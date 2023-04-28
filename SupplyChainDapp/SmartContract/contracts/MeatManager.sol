// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MeatManager is Ownable {

    address public deployerAddress;

    mapping(string => address) public meatSupplyChainList;
    mapping(string => address) public userExtendList;
    mapping(string => address) public meatSystemStorageList;

    mapping(address => string[]) public meatSupplyChainListVersion;
    mapping(address => string[]) public userExtendListVersion;
    mapping(address => string[]) public meatSystemStorageListVersion;

    string public currentMeatSupplyChainVersion;
    string public currentUserExtendVersion;
    string public currentMeatSystemStorageVersion;

    function addMeatSupplyChain(address _contractAddress, string memory _version) external onlyOwner{
        meatSupplyChainList[_version] = _contractAddress;
        meatSupplyChainListVersion[owner()].push(_version);
    }

    function getMeatSupplyChain(string memory _version) external view returns(address) {
        return getMeatSupplyChainList[_version];
    }

    function getMeatSupplyChainVersion() public view returns (string[] memory) {
        return meatSupplyChainListVersion[_ownerAddress];
    }

    function setCurrentMeatSupplyChainVersionVersion(string memory _version) public onlyOwner {
        currentMeatSupplyChainVersion = _version;
    }

    function getCurrentMeatSupplyChainVersion () public view returns (string memory) {
        return currentMeatSupplyChainVersion;
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

    function addMeatSystemStorage(address _contractAddress, string memory _version) external onlyOwner {
        meatSystemStorageList[_version] = _contractAddress;
        meatSystemStorageListVersion[owner()].push(_version);
    }

    function getSystemStorageContract(string memory _version) external view returns (address) {
        return meatSystemStorageListVersion[_version];
    }

    function getMeatSystemStorageVersion(address _ownerAddress) public view returns (string[] memory) {
        return meatSystemStorageListVersion[_ownerAddress];
    }

    function setCurrentMeatSystemStorageVersion (string memory _version) external onlyOwner {
        currentMeatSystemStorageVersion = _version;
    }

    function getCurrentSystemStorageVersion () public view returns (string memory) {
        return currentMeatSystemStorageVersion;
    }

    function setDeployerAddress(address _deployerAddress) public onlyOwner {
        deployerAddress = _deployerAddress;
    }

    function getDeployerAddress() public view returns(address) {
        return deployerAddress;
    }
}