// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.8;
pragma experimental ABIEncoderV2;

contract BesuMembership {
    address public owner;

    struct Member{
        string memberValue;
        string memberType;
        string[] memberChain;
    }
    
    struct Membership{
        string securityDomain;
        mapping(string => Member) members;
    }
    
    Membership[] public memberships;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the contract owner");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }


    event CreatedMembership(string indexed securityDomain, string indexed publicAddress);
    event UpdatedMembership(string indexed securityDomain, string indexed publicAddress);
    event DeletedMembership(string indexed securityDomain, string indexed publicAddress);
    
    
    function createMembership(bytes memory _data) external onlyOwner {
        uint256 index = memberships.length;
        memberships.push();
        Membership storage newMenborship = memberships[index];

        

        string memory decodedSecurityDomain;
        string memory decodedPublicKey;
        string memory decodedMemberValue;
        string memory decodedMemberType;
        string[] memory decodedMemberChain;

        (decodedSecurityDomain, decodedPublicKey, decodedMemberValue, decodedMemberType, decodedMemberChain) = abi.decode(_data, (string, string, string, string, string[]));

        Member memory newMember= Member({ memberValue: decodedMemberValue, memberType: decodedMemberType, memberChain: decodedMemberChain });


        newMenborship.securityDomain = decodedSecurityDomain;
        newMenborship.members[decodedPublicKey] = newMember;
        
    }

    function getMember(string memory decodedPublicKey) public view returns(Member memory member) {
        member = memberships[0].members[decodedPublicKey];
    }

    function updateMembership(
        string memory _securityDomain,
        string memory _publicKey,
        string memory _newMemberValue,
        string memory _newMemberType,
        string[] memory _newMemberChain
    ) external onlyOwner {
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(_securityDomain))) {
                Membership storage membership = memberships[i];
                return;
            }
        }
        revert("Membership not found");
    }

    function deleteMembership(
        string memory _securityDomain,
        string memory _publicKey
    ) external onlyOwner {
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(_securityDomain))) {
                return;
            }
        }
        revert("Membership not found");
    }

    /*
    function getMemberships() external view returns (Membership[] memory) {
        return memberships;
    }
    */
}