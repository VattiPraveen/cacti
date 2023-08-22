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
    
    // below is the function createMembership
    function createMembership(bytes memory _data) external onlyOwner {
        

        string memory securityDomain;
        string memory memberKey;
        string memory memberValue;
        string memory memberType;
        string[] memory memberChain;

        (securityDomain, memberKey, memberValue, memberType, memberChain) = abi.decode(_data, (string, string, string, string, string[]));

        Member memory newMember= Member({ memberValue: memberValue, memberType: memberType, memberChain: memberChain });

        // check if membership already exists
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(securityDomain))) {
                revert("Membership already exists");
            }
        }
        uint256 index = memberships.length;
        memberships.push();
        Membership storage newMenborship = memberships[index];

        newMenborship.securityDomain = securityDomain;
        newMenborship.members[memberKey] = newMember;
        
    }

    // function to add new member to existing membership
    function addMember(bytes memory _data) external onlyOwner {
        string memory securityDomain;
        string memory memberKey;
        string memory memberValue;
        string memory memberType;
        string[] memory memberChain;

        (securityDomain, memberKey, memberValue, memberType, memberChain) = abi.decode(_data, (string, string, string, string, string[]));

        Member memory newMember= Member({ memberValue: memberValue, memberType: memberType, memberChain: memberChain });

        // check if membership already exists
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(securityDomain))) {
                // check if member already exists
                if (keccak256(abi.encodePacked(memberships[i].members[memberKey].memberValue)) == keccak256(abi.encodePacked(newMember.memberValue))) {
                    revert("Member already exists");
                }
                Membership storage membership = memberships[i];
                membership.members[memberKey] = newMember;
                emit UpdatedMembership(securityDomain, memberKey);
                return;
            }
        }
        revert("Membership not found");
    }

    // function to update membership
    function updateMembership(bytes memory _data) external onlyOwner {
        string memory securityDomain;
        string memory memberKey;
        string memory newMemberValue;
        string memory newMemberType;
        string[] memory newMemberChain;

        (securityDomain, memberKey, newMemberValue, newMemberType, newMemberChain) = abi.decode(_data, (string, string, string, string, string[]));

        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(securityDomain))) {
                // check if member already exists or not
                if (keccak256(abi.encodePacked(memberships[i].members[memberKey].memberValue)) == keccak256(abi.encodePacked(""))) {
                    revert("Member does not exist");
                }
                Membership storage membership = memberships[i];
                membership.members[memberKey] = Member({ memberValue: newMemberValue, memberType: newMemberType, memberChain: newMemberChain });
                emit UpdatedMembership(securityDomain, memberKey);
                return;
            }
        }
        revert("Membership not found");
    }

    function deleteMember(string memory _securityDomain, string memory _memberKey) external onlyOwner {
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(_securityDomain))) {
                // check if the member exists or not
                if (keccak256(abi.encodePacked(memberships[i].members[_memberKey].memberValue)) == keccak256(abi.encodePacked(""))) {
                    revert("Member does not exist");
                }
                delete memberships[i].members[_memberKey];
                emit DeletedMembership(_securityDomain, _memberKey);
                return;
            }
        }
        revert("Membership not found");
    }

    // function to delete membership
    function deleteMembership(string memory _securityDomain) external onlyOwner {
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(_securityDomain))) {
                delete memberships[i];
                emit DeletedMembership(_securityDomain, "");
                return;
            }
        }
        revert("Membership not found");
    }

    function getMemberships(string memory _securityDomain, string memory memberKey) external view returns (Member memory) {
        for (uint256 i = 0; i < memberships.length; i++) {
            if (keccak256(abi.encodePacked(memberships[i].securityDomain)) == keccak256(abi.encodePacked(_securityDomain))) {
                // check if member already exists or not
                if (keccak256(abi.encodePacked(memberships[i].members[memberKey].memberValue)) == keccak256(abi.encodePacked(""))) {
                    revert("Member does not exist");
                }
                return memberships[i].members[memberKey];
            }
        }
        revert("Membership not found");
    }

    // verify member certificate in security domain using x509 certificate standard or EDCSA signature



}