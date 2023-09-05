// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "asn1-decode/contracts/Asn1Decode.sol";

contract x509CertificateUtils {
    using Asn1Decode for bytes;
    
    struct KeyUsage {
        bool critical;
        bool present;
        uint16 bits;              // Value of KeyUsage bits. (E.g. 5 is 000000101)
    }

    struct ExtKeyUsage {
        bool critical;
        bool present;
        bytes32[] oids;
    }

    struct Certificate {
        address owner;
        bytes32 parentId;
        uint40 timestamp;
        uint160 serialNumber;
        uint40 validNotBefore;
        uint40 validNotAfter;
        bool cA;                  // Whether the certified public key may be used to verify certificate signatures.
        uint8 pathLenConstraint;  // Maximum number of non-self-issued intermediate certs that may follow this
                                  // cert in a valid certification path.
        KeyUsage keyUsage;
        ExtKeyUsage extKeyUsage;
        bool sxg;                 // canSignHttpExchanges extension is present.
        bytes32 extId;            // keccak256 of extensions field for further validation.
                                  // Equal to 0x0 unless a critical extension was found but not parsed.
                                  // This should always be checked on leaf certificates
    }
    

    function getRawTbsCert(bytes memory _cert) internal pure returns (bytes memory) {
        uint256 offset = 4;
        uint256 length = uint256(_cert[offset]);
        offset += 1;
        if (length > 0x80) {
            uint256 lengthLength = length - 0x80;
            length = 0;
            for (uint256 i = 0; i < lengthLength; i++) {
                length = length * 256 + _cert[offset];
                offset += 1;
            }
        }
        return _cert.slice(offset, length);
    }


    function getSignature(bytes memory _cert, ) internal pure returns (bytes memory) {
        bytes32 certId;
        uint node1;
        uint node2;
        uint node3;
        uint node4;

        node1 = _cert.root();
        node1 = _cert.firstChildOf(node1);
        node2 = _cert.firstChildOf(node1);
        if (_cert[NodePtr.ixs(node2)] == 0xa0) {
        node2 = _cert.nextSiblingOf(node2);
        }

        node2 = _cert.nextSiblingOf(node2);
        node2 = _cert.firstChildOf(node2);
        node3 = _cert.nextSiblingOf(node1);
        node3 = _cert.nextSiblingOf(node3);
        // signature
        return _cert.bytesAt(node3);

    }
}