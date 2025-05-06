// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    OApp,
    Origin,
    MessagingFee
} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { OptionsBuilder } from "@layerzerolabs/lz-evm-protocol-v2/contracts/oapp/libs/OptionsBuilder.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract ProposalMessenger is OApp {
    constructor(address endpoint, address initialOwner)
        OApp(endpoint, initialOwner)
        Ownable(initialOwner)
    { }

    string public _data;

    function execTransaction(
        uint256 chainId,
        address target,
        uint256 value,
        bytes memory data
    ) public payable onlyOwner {
        bytes memory _payload = abi.encode(target, value,data);

        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(200000, 0);

        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
     }

    function send(
        uint32 _dstEid,
        string memory _message,
        bytes calldata _options
    ) external payable {
        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    function estimateFee(
        uint32 _dstEid,
        string memory _message,
        bytes calldata _options
    ) public view returns (uint256 nativeFee, uint256 lzTokenFee) {
        bytes memory _payload = abi.encode(_message);
        MessagingFee memory fee = _quote(_dstEid, _payload, _options, false);
        return (fee.nativeFee, fee.lzTokenFee);
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address, // Executor address as specified by the OApp.
        bytes calldata // Any extra data or options to trigger on receipt.
    ) internal override {
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        _data = abi.decode(payload, (string));
    }
}
