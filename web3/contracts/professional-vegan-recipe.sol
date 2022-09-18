// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

library Base64 {
    string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
                                            hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
                                            hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
                                            hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';

        // load the table into memory
        string memory table = TABLE_ENCODE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
                // read 3 bytes
                dataPtr := add(dataPtr, 3)
                let input := mload(dataPtr)

                // write 4 characters
                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
                resultPtr := add(resultPtr, 1)
            }

            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }

        return result;
    }

    function decode(string memory _data) internal pure returns (bytes memory) {
        bytes memory data = bytes(_data);

        if (data.length == 0) return new bytes(0);
        require(data.length % 4 == 0, "invalid base64 decoder input");

        // load the table into memory
        bytes memory table = TABLE_DECODE;

        // every 4 characters represent 3 bytes
        uint256 decodedLen = (data.length / 4) * 3;

        // add some extra buffer at the end required for the writing
        bytes memory result = new bytes(decodedLen + 32);

        assembly {
            // padding with '='
            let lastBytes := mload(add(data, mload(data)))
            if eq(and(lastBytes, 0xFF), 0x3d) {
                decodedLen := sub(decodedLen, 1)
                if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
                    decodedLen := sub(decodedLen, 1)
                }
            }

            // set the actual output length
            mstore(result, decodedLen)

            // prepare the lookup table
            let tablePtr := add(table, 1)

            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))

            // result ptr, jump over length
            let resultPtr := add(result, 32)

            // run over the input, 4 characters at a time
            for {} lt(dataPtr, endPtr) {}
            {
               // read 4 characters
               dataPtr := add(dataPtr, 4)
               let input := mload(dataPtr)

               // write 3 bytes
               let output := add(
                   add(
                       shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
                       shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
                   add(
                       shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
                               and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
                    )
                )
                mstore(resultPtr, shl(232, output))
                resultPtr := add(resultPtr, 3)
            }
        }

        return result;
    }
}

contract ProfessionalVeganRecipe is ERC721, ERC721Enumerable, Ownable {
    mapping(string => bool) private takenNames;
    mapping(uint256 => Attr) public attributes;

    struct Attr {
        string name;
        string main_ingredient;
        string created_by;
        // The audit number will allow to see if the smart contract address is the expected one to issue this NFT.
        // Proving threfore, NFT authenticity
        string audit_id; 
    }

    constructor() ERC721("ProfessionalVeganRecipe", "PVR") {}
    
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function mint(
        address to, 
        uint256 tokenId, 
        string memory _name, 
        string memory _main_ingredient, 
        string memory _created_by, 
        string memory _audit_id
    ) 
    public onlyOwner {
        _safeMint(to, tokenId);
        attributes[tokenId] = Attr(_name, _main_ingredient, _created_by, _audit_id);
    }

    function getSvg(uint tokenId) private view returns (string memory) {
        if (tokenId == 1) {
            return "<?xml version= '1.0' encoding= 'UTF-8'?><!DOCTYPE svg  PUBLIC '-//W3C//DTD SVG 1.1//EN'  'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'><svg enable-background= 'new 0 0 249.456 249.456 ' version= '1.1 ' viewBox= '0 0 249.46 249.46 ' xml:space= 'preserve ' xmlns= 'http://www.w3.org/2000/svg '><g fill= '#1D1D1B '><path d= 'm248.2 125.37c0.817-4.207 1.259-8.547 1.259-12.99 0-37.516-30.521-68.037-68.037-68.037-2.734 0-5.489 0.165-8.189 0.489l-133.25 16.003c-9e-3 1e-3 -0.018 2e-3 -0.027 3e-3 -22.779 2.749-39.951 22.139-39.951 45.116 0 4.23 0.606 8.355 1.726 12.29-1.14 4.021-1.726 8.183-1.726 12.409 0 21.229 15.038 39.906 35.756 44.408l131.16 28.502c4.739 1.03 9.619 1.552 14.507 1.552 37.516 0 68.037-30.521 68.037-68.036 0-3.268-0.234-6.553-0.697-9.765-0.099-0.688-0.295-1.337-0.561-1.944zm-206.49-49.635 1.222-0.125c0.238-0.025 0.473-0.06 0.704-0.106l131.38-15.78c2.109-0.253 4.262-0.381 6.4-0.381 29.245 0 53.037 23.792 53.037 53.037 0 29.244-23.792 53.036-53.037 53.036-3.818 0-7.627-0.407-11.323-1.21l-131.16-28.502c-13.873-3.015-23.942-15.526-23.942-29.75 0-15.381 11.479-28.361 26.71-30.219zm139.71 114.38c-3.818 0-7.628-0.407-11.323-1.21l-131.15-28.502c-10.253-2.228-18.423-9.646-21.991-19.106 5.366 4.356 11.755 7.533 18.806 9.065l131.16 28.502c4.739 1.03 9.62 1.552 14.507 1.552 18.272 0 34.872-7.254 47.108-19.017-8.834 17.039-26.627 28.716-47.109 28.716z '/><path d= 'm180.68 138.8c-1.95 0-3.893-0.208-5.775-0.617l-18.44-4.007-3.186 14.658 18.44 4.007c2.926 0.636 5.941 0.959 8.961 0.959 23.178 0 42.035-18.857 42.035-42.035 0-4.142-3.358-7.5-7.5-7.5s-7.5 3.358-7.5 7.5c0 14.907-12.128 27.035-27.035 27.035z '/><path d= 'm32.186 119.83c4.142 0 7.5-3.358 7.5-7.5 0-8.036 6.106-14.896 14.01-15.879l0.729-0.075c0.195-0.02 0.387-0.047 0.576-0.082l81.281-9.763c4.112-0.494 7.046-4.228 6.552-8.341-0.494-4.112-4.222-7.051-8.341-6.552l-82.532 9.913-0.048 6e-3c-15.355 1.878-27.227 15.185-27.227 30.773 0 4.142 3.358 7.5 7.5 7.5z '/><path d= 'm177.44 132.74c13.657 0 24.768-11.111 24.768-24.768s-11.111-24.768-24.768-24.768-24.768 11.111-24.768 24.768 11.111 24.768 24.768 24.768zm0-34.535c5.386 0 9.768 4.382 9.768 9.768s-4.382 9.768-9.768 9.768-9.768-4.382-9.768-9.768 4.382-9.768 9.768-9.768z '/></g></svg>";
        }
        // todo use actual different svgs for different nfts
        return  "<?xml version= '1.0 ' ?><svg width= '24px ' height= '24px ' viewBox= '0 0 24 24 ' style= 'enable-background:new 0 0 24 24; ' version= '1.1 ' xml:space= 'preserve ' xmlns= 'http://www.w3.org/2000/svg ' xmlns:xlink= 'http://www.w3.org/1999/xlink '><style type= 'text/css '>.st0{opacity:0.2;fill:none;stroke:#000000;stroke-width:5.000000e-02;stroke-miterlimit:10;}</style><g id= 'Layer_Grid '/><g id= 'Layer_2 '><path d= 'M7,17c-2.2,0-4,1.8-4,4c0,0.6,0.4,1,1,1h11c0.6,0,1-0.4,1-1c0-2.2-1.8-4-4-4v-1.4c0-1.7,0.5-3.4,1.4-4.9l0.2-0.2l2.2,1.1   c0.2,0.1,0.5,0.3,0.7,0.4c0.6,0.4,1.3,0.8,2.2,0.9c0.1,0,0.1,0,0.2,0c0.4,0,0.8-0.3,1-0.7c0.2-0.6,0-1.3-0.2-1.8l0-0.2   c-0.2-0.6-0.4-1.1-0.7-1.6c-0.1-0.1-0.2-0.2-0.2-0.3l1.9-1.6C20.9,6.6,21,6.2,21,5.9c0-0.3-0.2-0.6-0.5-0.8   c-2.6-1.3-4.9-0.5-6.5,0.8c-0.5-1.4-1.5-3.2-3.6-3.9C10,1.9,9.7,2,9.4,2.2C9.2,2.4,9,2.7,9,3v2.3C8.2,5.4,7.4,5.6,6.6,5.9   C6.2,6.1,5.8,6.3,5.4,6.6c-0.1,0-0.2,0.1-0.3,0.2C5,6.9,4.9,7,4.8,7C4.4,7.1,4.1,7.5,4,7.9C3.9,8.4,4.3,8.9,4.9,9c0,0,0,0,0,0v0   c0,0,0,0,0,0C5,9,5.7,9.1,9.6,9.6C8.3,11.1,7.2,13.5,7,17L7,17z M17.9,6.4L17.2,7c-0.2-0.1-0.5-0.2-0.7-0.3   C16.9,6.5,17.4,6.4,17.9,6.4z M14.8,8.6c0.2,0,0.4-0.1,0.5-0.1c0.7,0,1.4,0.5,1.9,1.3c0.1,0.1,0.2,0.3,0.2,0.4   C17.2,10,17,9.9,16.7,9.8l-2-1L14.8,8.6z M11,4.8c0.2,0.2,0.3,0.4,0.5,0.7c-0.2-0.1-0.3-0.1-0.5-0.1V4.8z M8.4,7.4   c0.5-0.1,1-0.2,1.6-0.2c0,0,0,0,0,0c0,0,0,0,0,0c0.5,0,1.1,0.2,1.5,0.5c0,0-0.1,0.1-0.1,0.1C10.5,7.7,9.4,7.5,8.4,7.4z M11,10.9   c-0.7,1.4-1,3-1,4.6V17H9C9.2,14.1,10.1,12.2,11,10.9z M11,19h1c0.7,0,1.4,0.4,1.7,1H5.3c0.3-0.6,1-1,1.7-1h1H11z '/></g></svg>";
    }    

    function tokenURI(uint256 tokenId) override(ERC721) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "', attributes[tokenId].name, '",',
                '"svgString": "', getSvg(tokenId), '",',
                '"mainIngredient": "', attributes[tokenId].main_ingredient, '",',
                '"createdBy": "', attributes[tokenId].created_by, '",',
                '"auditId": "', attributes[tokenId].audit_id, '"'
            '}'
        );

        return string(
            abi.encodePacked(
                'data:application/json;base64,', 
                Base64.encode(dataURI)
            )
        );
    }    
}